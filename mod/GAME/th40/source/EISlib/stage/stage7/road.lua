-----------------------------------------
---东方栖霞园道中 Stage7
-----------------------------------------
---@class  EISlib.stage.stage7.road

local disarm = false --测试选项：缴械所有敌人

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
    local res_name = "s7_road_"
    local path = "res/stage/stage7/"
    --关卡标题
    LoadImageFromFile(res_name.."title1", path.."title1.png")
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
local LS = EISlib.Bullet.Laser.laser
local lead_laser = EISlib.Bullet.Laser.lead_laser
local sect_layer1 = EGGlib.BulletGroup.Sector.layer1
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local sect_normal1 = EGGlib.BulletGroup.Sector.normal1
local sect_normal2 = EGGlib.BulletGroup.Sector.normal2
local circle_normal1 = EGGlib.BulletGroup.Circle.normal1
local alphaChangeTask = EGGlib.ObjectEvent.alphaChangeTask
local omigaChangeTask = EGGlib.ObjectEvent.omigaChangeTask
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local newSimpleClass = EGGlib.Class.newSimpleClass
local EnemyGroup = EGGlib.Road.EnemyGroup
local accDecMoveToPoint = EGGlib.ObjectEvent.accDecMoveToPoint
local Basic_movement = EGGlib.Class.Frequently.Basic_movement
local setV = EGGlib.ObjectEvent.setV
local moveWithTask = EGGlib.ObjectEvent.moveWithTask
local curve_normal1 = EGGlib.BulletGroup.Curve.normal1
local setProtectTime = EGGlib.ObjectEvent.setProtectTime
local sin = EGGlib.Math.phaseToSin --采用已存储好的sin数组，减少直接sin运算，优化性能
local cos = EGGlib.Math.phaseToCos
local rotateMoveWith2Task = EGGlib.ObjectEvent.rotateMoveWith2Task
local tri_circle3 = EGGlib.BulletGroup.TriAngleStroke.circle3
local tri_normal1 = EGGlib.BulletGroup.TriAngleStroke.normal1
local tranRot = EGGlib.Math.TranRot
local simPar = EGGlib.ObjectEvent.simPar
local accDecVelocityChange =  EGGlib.ObjectEvent.accDecVelocityChange
local clearEnemyAndBullet = EGGlib.ObjectEvent.clearEnemyAndBullet


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
local s7_enemy_manager = EnemyGroup.new()
do
    s7_enemy_manager:initEnemyListByTable({
        --region part1 enemy
        {
            --蓝色小妖精
            ["small_blue"] = function(x, y)
                local obj = E.enemy1.create(
                        x, y,
                        1, 20, COLOR_BLUE --hp, dt, co
                )
                --固定向下移动
                task.New(obj, function()
                    --从屏幕上方下来
                    accDecMoveToPoint(obj, x, y - 250, 1, 29, 60)
                    --[[又向上溜了
                    velch(obj, 0, 3, 90, 30)]]
                    --去追自机
                    velch(obj, 0, 4, Angle(obj, player), 120)
                end)
                return obj
            end,
            --在一条线上运动的妖精
            ["line"] = function(x, y, a)
                local obj = E.enemy2.create(
                        x, y, --x, y
                        5, 0, COLOR_BLUE --hp, dt, co
                )
                setV(obj, 0.75, a)
                return obj
            end,
            --送血灵碎片的中妖精
            ["mid"] = function(x, y)
                local obj = E.mid1.create(
                        x, y,
                        40, 40, COLOR_BLUE --hp, dt, co
                )
                setProtectTime(obj, 60) --有1秒的无敌
                task.New(obj, function()
                    --从屏幕上方下来
                    accDecMoveToPoint(obj, x, y - 100, 1, 29, 60)
                    --缓慢向下走
                    velch(obj, 0.5, 2, -90, 120, 300)
                end)
                return obj
            end,
        },
        --endregion
        --region part2 enemy
        {
            --摇摆不定的鬼火
            ["ghost"] = function(x, y, phase, u)
                local obj = E.ghost1.create(x, y,
                        1, ran:Int(0, 20), COLOR_BLUE --hp, dt, co
                )
                local x0 = obj.x --中心x坐标
                --纵向动作
                task.New(obj, function()
                    velchTask(obj, 4, 0, -90, 30, 60)
                    task.Wait(45)
                    --横向移动
                    task.New(obj, function()
                        local t = 30
                        local v, dv = 0, 4/t*u
                        for _ = 1, t do
                            v = v + dv
                            x0 = x0 + v
                            task.Wait(1)
                        end
                        dv = -dv
                        for _ = 1, t do
                            v = v + dv
                            x0 = x0 + v
                            task.Wait(1)
                        end
                    end)
                    task.Wait(45)
                    velchTask(obj, 0, 4, 45, 30)
                end)
                --横向动作
                task.New(obj, function()
                    while true do
                        obj.x = x0 + 30*sin(phase)
                        task.Wait(1)
                        phase = phase + 6*u
                    end
                end)
            end,
            --简单的开花弹中妖精
            ["mid"] = function(x, y)
                local obj = E.mid2.create(
                        x, y,
                        40, 45, COLOR_BLUE --hp, dt, co
                )
                setProtectTime(obj, 30) --有1秒的无敌
                task.New(obj, function()
                    --从屏幕上方下来
                    accDecMoveToPoint(obj, x, y - 100, 1, 29, 60)
                    --缓慢向下走
                    velch(obj, 0.5, 2, -90, 120, 300)
                end)
                return obj
            end,
            --第一种大型妖精
            ["big"] = function(x, y)
                local u = sign(x)
                local obj = E.big1.create(x, y,
                        300, 120, u, COLOR_BLUE --hp, dt, u, co
                )
                setProtectTime(obj, 120) --有2秒的无敌
                task.New(obj, function()
                    --从屏幕上方斜入
                    velch(obj, 4, 0, -90 - 45*u, 30, 45)
                    --斜向移动离开
                    local a = -90 + 120*u
                    velch(obj, 0, 0.75, -90 + 90*u, 60)
                    velch(obj, 0, 2.5, a, 120, 300)
                end)
                return obj
            end,
        },
        --endregion
        --region part3 enemy
        {
            --快速摆动+移动的一队列鬼火（控制器对象，只是直接生成对象会不执行任务，需要一个总控制器控制更新模块）
            ["ghost"] = function(x, y, a, u)
                local obj = GhostMovement.new(
                        E.ghost1.create(x, y,
                                1, ran:Int(0, 20), COLOR_BLUE --hp, dt, co
                        ),
                        x, y)
                simPar(obj, 2, a, 0.033, a + 90*u)
                return obj
            end,
            --简单的连弹中妖精
            ["mid1"] = function(x, y)
                local u = sign(x)
                local obj = E.mid1.create(
                        x, y,
                        40, 60, COLOR_BLUE --hp, dt, co
                )
                setProtectTime(obj, 60) --有1秒的无敌
                task.New(obj, function()
                    --从侧翼插入
                    accDecMoveToPoint(obj, x - 150*u, y - 100, 1, 29, 30)
                    --缓慢向下走
                    velch(obj, 0, 0.5, -90, 120)
                    task.Wait(240)
                    velch(obj, 0, 0.5, -90, 120)
                end)
                return obj
            end,
            --简单的开花中妖精
            ["mid2"] = function(x, y)
                local u = sign(x)
                local obj = E.mid2.create(
                        x, y,
                        40, 60, COLOR_BLUE --hp, dt, co
                )
                setProtectTime(obj, 60) --有1秒的无敌
                task.New(obj, function()
                    --从侧翼插入
                    accDecMoveToPoint(obj, x - 150*u, y - 100, 1, 29, 30)
                    --缓慢向下走
                    velch(obj, 0, 0.5, -90, 120)
                    task.Wait(240)
                    velch(obj, 0, 0.5, -90, 120)
                end)
                return obj
            end,
        },
        --endregion
        --region part4 enemy
        {
            --摇摆不定的鬼火
            ["ghost"] = function(x, y, phase, u)
                local obj = E.ghost1.create(x, y,
                        1, ran:Int(0, 20), COLOR_RED --hp, dt, co
                )
                local x0 = obj.x --中心x坐标
                --纵向动作
                task.New(obj, function()
                    velchTask(obj, 4, 0, -90, 30, 60)
                    task.Wait(45)
                    --横向移动
                    task.New(obj, function()
                        local t = 30
                        local v, dv = 0, 4/t*u
                        for _ = 1, t do
                            v = v + dv
                            x0 = x0 + v
                            task.Wait(1)
                        end
                        dv = -dv
                        for _ = 1, t do
                            v = v + dv
                            x0 = x0 + v
                            task.Wait(1)
                        end
                    end)
                    task.Wait(45)
                    velchTask(obj, 0, 4, 45, 30)
                end)
                --横向动作
                task.New(obj, function()
                    while true do
                        obj.x = x0 + 30*sin(phase)
                        task.Wait(1)
                        phase = phase + 6*u
                    end
                end)
            end,
            --在一条线上运动的妖精
            ["line"] = function(x, y, a)
                local obj = E.enemy2.create(
                        x, y, --x, y
                        5, 0, COLOR_RED --hp, dt, co
                )
                setV(obj, 0.75, a)
                return obj
            end,
        },
        --endregion
        --region part5 enemy
        {
            --第一种大型妖精
            ["big"] = function(x, y)
                local u = sign(x)
                local obj = E.big1.create(x, y,
                        150, 180, u, COLOR_RED --hp, dt, u, co
                )
                setProtectTime(obj, 120) --有2秒的无敌
                task.New(obj, function()
                    --从屏幕上方斜入
                    velchTask(obj, 4, 0, -90 - 25*u, 30, 60)
                    task.Wait(45)
                    --斜向移动离开
                    local a = -90 + 120*u
                    accDecVelocityChange(obj, 3, a, 30, 60, 30)
                    a = -90 - 45*u
                    velch(obj, 0, 1, a, 120)
                    task.Wait(240)
                    velchTask(obj, 0, -1, a, 120)
                    task.Wait(60)
                    velch(obj, 0, 2, 90, 300)
                end)
                return obj
            end,
            --快速摆动+移动的一队列鬼火（控制器对象，只是直接生成对象会不执行任务，需要一个总控制器控制更新模块）
            ["ghost"] = function(x, y, a, u)
                local obj = GhostMovement.new(
                        E.ghost1.create(x, y,
                                1, ran:Int(0, 20), COLOR_RED --hp, dt, co
                        ),
                        x, y)
                simPar(obj, 2, a, 0.033, a + 90*u)
                return obj
            end,
            --送血灵碎片的中妖精
            ["mid1"] = function(x, y)
                local obj = E.mid1.create(
                        x, y,
                        40, 40, COLOR_RED --hp, dt, co
                )
                setProtectTime(obj, 60) --有1秒的无敌
                task.New(obj, function()
                    --从屏幕上方下来
                    accDecMoveToPoint(obj, x, y - 100, 1, 29, 60)
                    --缓慢向下走
                    velch(obj, 0.5, 2, -90, 120, 300)
                end)
                return obj
            end,
            --简单的开花弹中妖精
            ["mid2"] = function(x, y)
                local obj = E.mid2.create(
                        x, y,
                        40, 45, COLOR_RED --hp, dt, co
                )
                setProtectTime(obj, 30) --有1秒的无敌
                task.New(obj, function()
                    --从屏幕上方下来
                    accDecMoveToPoint(obj, x, y - 100, 1, 29, 60)
                    --缓慢向下走
                    velch(obj, 0.5, 2, -90, 120, 300)
                end)
                return obj
            end,
            --红色小妖精
            ["small_red"] = function(x, y)
                local obj = E.enemy1.create(
                        x, y,
                        1, 20, COLOR_RED --hp, dt, co
                )
                --固定向下移动
                task.New(obj, function()
                    --从屏幕上方下来
                    accDecMoveToPoint(obj, x, y - 250, 1, 29, 90)
                    --去追自机
                    velch(obj, 0, 2, Angle(obj, player), 120)
                end)
                return obj
            end,
            --从侧翼突袭的红色小妖精
            ["small_red2"] = function(x, y)
                local obj = E.enemy1.create(
                        x, y,
                        1, 20, COLOR_RED --hp, dt, co
                )
                local u = sign(x)
                --固定向下移动
                task.New(obj, function()
                    --斜着出来
                    accDecVelocityChange(obj, 5, -90 - 60*u, 1, 59, 30)
                    velchTask(obj, 0, 0.75, -90 - 90*u, 30)
                    --往上飞
                    velch(obj, 0, 4, 90, 120)
                end)
                return obj
            end,
        },
        --endregion
    })
    s7_enemy_manager:initGroupListByTable({
        --region part1 group
        {
            --一组7只呈三角形排布的蓝色小妖精（参数x，y为最中间那只初始生成坐标）
            ["small_blue*7"] = function(x, y)
                local wait = 6
                local ce = s7_enemy_manager:getCreateEnemyFunc(1, "small_blue")
                tasker(function()
                    ce(x, y)
                    task.Wait(wait)
                    for i = 1, 3 do
                        for u = -1, 1, 2 do
                            ce(x + 25*i*u, y + 25*i)
                        end
                        task.Wait(wait)
                    end
                end)
            end,
            --一组7只呈三角形排布的蓝色小妖精 外加 中间一只中妖精
            ["small_blue*7+mid"] = function(x, y)
                local wait = 6
                local ce = s7_enemy_manager:getCreateEnemyFunc(1, "small_blue")
                local ce3 = s7_enemy_manager:getCreateEnemyFunc(1, "mid")
                tasker(function()
                    ce(x, y)
                    task.Wait(wait)
                    for i = 1, 3 do
                        for u = -1, 1, 2 do
                            ce(x + 25*i*u, y + 25*i)
                        end
                        if i == 2 then
                            ce(x, y + 25*i)
                        elseif i == 3 then
                            for u = -1, 1, 2 do
                                ce(x + 25*u, y + 25*i)
                            end
                        end
                        task.Wait(wait)
                    end
                    ce3(x, y)
                end)
            end,
            --在一条线上运动的妖精
            ["line"] = function(x, y, n)
                n = n or 8
                local wait = 30
                local u = sign(x)
                local ce = s7_enemy_manager:getCreateEnemyFunc(1, "line")
                local line = EnemyLine.new(x, y)
                local isFinish = false --本组敌人生成完毕的flag
                --设置整体向下的速度
                setV(line, 1, -90)
                --敌人生成逻辑
                tasker(function()
                    for _ = 0, n - 1 do
                        line:addEnemy(ce(line.x, line.y, 90 + 60*u)) --斜向上走
                        task.Wait(wait)
                    end
                    isFinish = true
                end)
                --以下tasker作为线对象本身帧逻辑的更新器，在敌人产生完毕并且全部被消灭时结束更新
                tasker(function()
                    local t = 0
                    while not (isFinish and line:isNoEnemy()) do
                        line:update()
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
            --一组成群的鬼火
            ["ghost"] = function(x, y, u)
                local ce = s7_enemy_manager:getCreateEnemyFunc(2, "ghost")
                local n = 10 --组10只
                local wait = 10
                --敌人生成逻辑
                tasker(function()
                    for i = 0, n - 1 do
                        ce(x, y, -30*i*u, -u)
                        task.Wait(wait)
                    end
                end)
            end
        },
        --endregion
        --region part3 group
        {
            --在一条线上运动的鬼火
            ["ghost_line"] = function(x, y, a, u)
                local n = 16
                local wait = 10
                local ce = s7_enemy_manager:getCreateEnemyFunc(3, "ghost")
                local line = EnemyLine.new(x, y)
                local isFinish = false --本组敌人生成完毕的flag
                --设置整体向下的速度
                setV(line, 1, -90)
                --敌人生成逻辑
                tasker(function()
                    for _ = 0, n - 1 do
                        line:addEnemy(ce(line.x, line.y, a, u)) --斜向上走
                        task.Wait(wait)
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
                    SystemLog("当前组敌人已被消灭，用时："..t)
                end)
            end,
            --从侧翼插入的连弹中型敌人(y代表两个敌人起始生成的y坐标之和的一半，yrange表示两者间y坐标之差）
            ["mid1"] = function(y, yrange)
                local ce = s7_enemy_manager:getCreateEnemyFunc(3, "mid1")
                ce(-245, y + 0.5*yrange)
                ce(245, y - 0.5*yrange)
            end,
            --从侧翼插入的开花中型敌人(y代表两个敌人起始生成的y坐标之和的一半，yrange表示两者间y坐标之差）
            ["mid2"] = function(y, yrange)
                local ce = s7_enemy_manager:getCreateEnemyFunc(3, "mid2")
                ce(-245, y + 0.5*yrange)
                ce(245, y - 0.5*yrange)
            end
        },
        --endregion
        --region part4 group
        {
            --一组成群的鬼火
            ["ghost"] = function(x, y, u, boss)
                local ce = s7_enemy_manager:getCreateEnemyFunc(4, "ghost")
                local n = 10 --组10只
                local wait = 10
                --敌人生成逻辑
                tasker(function()
                    for i = 0, n - 1 do
                        if not IsValid(boss) then
                            ce(x, y, -30*i*u, -u)
                        end
                        task.Wait(wait)
                    end
                end)
            end,
            --在一条线上运动的妖精
            ["line"] = function(x, y, n, boss)
                n = n or 8
                local wait = 30
                local u = sign(x)
                local ce = s7_enemy_manager:getCreateEnemyFunc(4, "line")
                local line = EnemyLine.new(x, y)
                local isFinish = false --本组敌人生成完毕的flag
                --设置整体向下的速度
                setV(line, 1, -90)
                --敌人生成逻辑
                tasker(function()
                    for _ = 0, n - 1 do
                        if not IsValid(boss) then
                            line:addEnemy(ce(line.x, line.y, 90 + 60*u)) --斜向上走
                        end
                        task.Wait(wait)
                    end
                    isFinish = true
                end)
                --以下tasker作为线对象本身帧逻辑的更新器，在敌人产生完毕并且全部被消灭时结束更新
                tasker(function()
                    local t = 0
                    while not (isFinish and line:isNoEnemy()) do
                        line:update()
                        t = t + 1
                        task.Wait(1)
                    end
                    --SystemLog("当前组敌人已被消灭，用时："..t)
                end)
            end,
        },
        --endregion
        --region part5 group
        {            --在一条线上运动的鬼火
            ["ghost_line"] = function(x, y, a, u)
                local n = 20
                local wait = 10
                local ce = s7_enemy_manager:getCreateEnemyFunc(5, "ghost")
                local line = EnemyLine.new(x, y)
                local isFinish = false --本组敌人生成完毕的flag
                --设置整体向下的速度
                setV(line, 1, -90)
                --敌人生成逻辑
                tasker(function()
                    for _ = 0, n - 1 do
                        line:addEnemy(ce(line.x, line.y, a, u)) --斜向上走
                        task.Wait(wait)
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
                    SystemLog("当前组敌人已被消灭，用时："..t)
                end)
            end,
            --一组7只呈三角形排布的蓝色小妖精 外加 中间一只中妖精
            ["small_red*7+mid1"] = function(x, y)
                local wait = 6
                local ce = s7_enemy_manager:getCreateEnemyFunc(5, "small_red")
                local ce3 = s7_enemy_manager:getCreateEnemyFunc(5, "mid1")
                tasker(function()
                    ce(x, y)
                    task.Wait(wait)
                    for i = 1, 3 do
                        for u = -1, 1, 2 do
                            ce(x + 25*i*u, y + 25*i)
                        end
                        task.Wait(wait)
                    end
                    ce3(x, y)
                end)
            end,
            --一组7只呈三角形排布的蓝色小妖精 外加 中间一只中妖精
            ["small_red*7+mid2"] = function(x, y)
                local wait = 6
                local ce = s7_enemy_manager:getCreateEnemyFunc(5, "small_red")
                local ce3 = s7_enemy_manager:getCreateEnemyFunc(5, "mid2")
                tasker(function()
                    ce(x, y)
                    task.Wait(wait)
                    for i = 1, 3 do
                        for u = -1, 1, 2 do
                            ce(x + 25*i*u, y + 25*i)
                        end
                        task.Wait(wait)
                    end
                    ce3(x, y)
                end)
            end,
            --从侧翼突袭的红色小妖精
            ["small_red2"] = function(x, y, yrange)
                local n = 3
                local wait = 5
                local ce = s7_enemy_manager:getCreateEnemyFunc(5, "small_red2")
                tasker(function()
                    y = y - 0.5*yrange
                    local dy = yrange/(n - 1)
                    for i = 0, n - 1 do
                        ce(x, y + dy*i)
                        task.Wait(wait)
                    end
                end)
            end
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


--region Bullet Defined
--endregion
B.bullet_demo = EISlib.Bullet.Shooter.createBulletClass(
        function(diff, rank)
            local function create(x, y)
                local obj = stg.newBullet(x, y, stg.arrow_big, COLOR_RED)
            end
            return create
        end
)

--基础道中自机狙发射点
P.pointer_demo = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                0, 0, 0, 0, 0
            })
            local da = switch1(diff, {
                0, 0, 0, 0, 0
            }) --每way间的间隔
            --case：层数
            local layer = switch1(diff, {
                0, 0, 0, 0, 0
            })
            --case：初始弹速
            local v0 = switch1(diff, {
                0, 0, 0, 0, 0
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv = switch1(diff, {
                0, 0, 0, 0, 0
            })
            local style, color = stg.grain_b, COLOR_BLUE
            local function bullet_func(x, y, v, a)
                stg.newSimpleStraight(x, y, v, a, style, color)
            end
            local function attack(x, y, a)
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

--模版
S.shooter_demo = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                50, 45, 40, 30, 30
            })
            --case：持续攻击时间
            local total_time = 360
            local function shooter(e, dt)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                        end
                )
            end
            return shooter
        end
)


--region Enemy Defined
--region 最普通的自机狙杂鱼
E.enemy1 = BS.createEnemy(
        function(diff, rank)
            local style_list = {}
            style_list[COLOR_BLUE] = sty.FAIRY_SMALL_BLUE
            style_list[COLOR_RED] = sty.FAIRY_SMALL_3_RED
            local function create(x, y, hp, dt, co)
                co = co or COLOR_BLUE
                local obj = New(enemy, x, y, style_list[co], --style
                        hp, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                if not disarm then
                    S.shooter1.main(obj, dt, co) --给这个小怪装上发射器
                end
                return obj
            end
            return create
        end
)

--3way连续发射自机狙
S.shooter1 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = 0
            --case：持续攻击时间
            local total_time = 90
            local wait = switch(rank, {
                30, 30, 30, 30, 15
            })
            local shooter_list = {
                [COLOR_BLUE] = function(e, dt)
                    enemy.createShooter(e,
                            start_time_left + dt, total_time + dt, --start_time_left total_time
                            function()
                                while true do
                                    P.pointer1.attack(e.x, e.y, Angle(e, player), COLOR_BLUE)
                                    task.Wait(wait)
                                end
                            end
                    )
                end,
                [COLOR_RED] = function(e, dt)
                    enemy.createShooter(e,
                            start_time_left + dt, total_time + dt, --start_time_left total_time
                            function()
                                while true do
                                    if e.y > -50 then
                                        P.pointer1.attack(e.x, e.y, Angle(e, player) + ran:Float(-2.5, 2.5), COLOR_RED)
                                    end
                                    task.Wait(2*wait)
                                end
                            end
                    )
                end
            }
            local function shooter(e, dt, co)
                shooter_list[co](e, dt)
            end
            return shooter
        end
)

--3way基础自机狙
P.pointer1 = BS.createPointer(
        function(diff, rank)
            local attack_list = {}
            --blue
            do
                --每way间的间隔
                local da = switch(rank, {
                    1, 1, 1, 1, 15
                })
                --case：初始弹速
                local v = 2.5*defaultSwitchVelocityByRank(rank)
                --
                local dv = 0.1*defaultSwitchVelocityByRank(rank)
                local style, color = stg.grain_a, COLOR_BLUE

                attack_list[color] = function(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                for i = -0.5, 0.5, 1 do
                                    stg.newSimpleStraight(x, y, v, a + da*i, style, color)
                                end
                                stg.newSimpleStraight(x, y, v + dv, a, style, color - 1)
                            end)
                end
            end

            --red
            do
                --每way间的间隔
                local da = switch(rank, {
                    1, 1, 1, 1, 15
                })
                --case：初始弹速
                local v = 3.5*defaultSwitchVelocityByRank(rank)
                --
                local dv = 0.125*defaultSwitchVelocityByRank(rank)
                local style, color = stg.grain_a, COLOR_RED

                attack_list[color] = function(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                for i = -0.5, 0.5, 1 do
                                    stg.newSimpleStraight(x, y, v, a + da*i, style, color)
                                end
                                stg.newSimpleStraight(x, y, v + dv, a, style, color - 1)
                            end)
                end
            end
            local function attack(x, y, a, co)
                attack_list[co](x, y, a)
            end
            return attack
        end
)
--endregion

--region 斜向下阵列基本妖精

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
                return  IsValid(self)
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



E.enemy2 = BS.createEnemy(
        function(diff, rank)
            local style_list = {}
            style_list[COLOR_BLUE] = sty.FAIRY_SMALL_4_BLUE
            style_list[COLOR_RED] = sty.FAIRY_SMALL_4_RED
            local function create(x, y, hp, dt, co)
                co = co or COLOR_BLUE
                local obj = New(enemy, x, y, style_list[co], --style
                        hp, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                --这种妖精弹幕攻击方向与移动方向相同
                if not disarm then
                    S.shooter2.main(obj, dt, co) --给这个小怪装上发射器
                end
                return obj
            end
            return create
        end
)


--斜向下阵列妖精连续发射4way固定角度弹幕
S.shooter2 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = 1
            --case：持续攻击时间
            local total_time = 360
            local wait = switch(rank, {
                30, 30, 30, 30, 20
            })
            local function shooter(e, dt, co)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            while true do
                                P.pointer2.attack(e.x, e.y, Angle(e.dx, e.dy, 0, 0), co)
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)

--4way开花弹，用作斜向下的飞行矩阵
P.pointer2 = BS.createPointer(
        function(diff, rank)
            local attack_list = {}
            --blue
            do
                --define
                local way = 3
                local da = switch(rank, {
                    0.5, 0.5, 0.5, 0.5, 1
                })
                local dv_w = -0.025*defaultSwitchVelocityByRank(rank)*2
                local layer = 1
                local v = 2*defaultSwitchVelocityByRank(rank)
                local dv = 0.5*defaultSwitchVelocityByRank(rank)
                local style, color = stg.arrow_big, COLOR_BLUE
                local function bullet_func(x, y, v, a)
                    local w = (way - 1)/2
                    for i = -w, w do
                        if i ~= 0 then
                            stg.newSimpleStraight(x, y, v + dv_w*abs(i), a + da*i, style, color)
                        end
                    end
                    stg.newSimpleStraight(x, y, v, a, style, color)
                end
                --func
                attack_list[color] = function(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                for i = 1, 2 do
                                    for j = 0, layer - 1 do
                                        bullet_func(x, y, v + dv*j, a + 180*i)
                                        bullet_func(x, y, v + dv*j, -a + 180*i)
                                    end
                                end
                            end)
                end
            end

            --red
            do
                --define
                local way = 3
                local da = 4.5
                local dv_w = -0.1*defaultSwitchVelocityByRank(rank)*2
                local layer = 1
                local v = 2*defaultSwitchVelocityByRank(rank)
                local dv = 0.5*defaultSwitchVelocityByRank(rank)
                local style, color = stg.arrow_big, COLOR_RED
                local function bullet_func(x, y, v, a)
                    local w = (way - 1)/2
                    for i = -w, w do
                        if i ~= 0 then
                            stg.newSimpleStraight(x, y, v + dv_w*abs(i), a + da*i, style, color)
                        end
                    end
                    stg.newSimpleStraight(x, y, v, a, style, color)
                end
                --func
                attack_list[color] = function(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                for i = 1, 2 do
                                    for j = 0, layer - 1 do
                                        bullet_func(x, y, v + dv*j, a + 180*i)
                                        bullet_func(x, y, v + dv*j, -a + 180*i)
                                    end
                                end
                            end)
                end
            end
            local function attack(x, y, a, co)
                attack_list[co](x, y, a)
            end
            return attack
        end
)
--endregion

--region 送血灵碎片的中妖精
E.mid1 = BS.createEnemy(
        function(diff, rank)
            local style_list = {}
            style_list[COLOR_BLUE] = sty.FAIRY_MIDDLE_BLUE
            style_list[COLOR_RED] = sty.FAIRY_MIDDLE_RED
            local function create(x, y, hp, dt, co)
                co = co or COLOR_BLUE
                local obj = New(enemy, x, y, style_list[co], --style
                        hp, --hp
                        true,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                enemy.changeAura(obj, COLOR_RED, "middle") --激光颜色与法阵颜色要一致
                --召唤小弟
                for u = -1, 1, 2 do
                    E.mid1_1.create(obj, 50*u, 0, dt, co)
                end
                if not disarm then
                    S.mid1.main(obj, dt + 90, co) --给这个小怪装上发射器
                end
                return obj
            end
            return create
        end
)

E.mid1_1 = BS.createEnemy(
        function(diff, rank)
            local style_list = {}
            style_list[COLOR_BLUE] = sty.FIRE_BLUE
            style_list[COLOR_RED] = sty.FIRE_RED
            local function create(mst, dx, dy, dt, co)
                co = co or COLOR_BLUE
                local obj = New(enemy, mst.x + dx, mst.y + dy, style_list[co], --style
                        9999, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                enemy.setTauntRank(obj, enemy.SERVANT_TAUNT)
                obj.show_aura = true
                _connect(mst, obj, 1, true)
                moveWithTask(obj, mst, dx, dy, _infinite)
                if not disarm then
                    S.mid1_1.main(obj, dt, sign(dx), co)
                end
                return obj
            end
            return create
        end
)

--鬼火使魔发的弹幕
S.mid1_1 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = 1
            --case：持续攻击时间
            local total_time = 360

            local wait = switch(rank, {
                120, 120, 120, 120, 90
            })
            local count = 8 --攻击次数
            local shooter_list = {
                [COLOR_BLUE] = function(e, dt, u)
                    enemy.createShooter(e,
                            start_time_left + dt, total_time + dt, --start_time_left total_time
                            function(obj)
                                while true do
                                    task.New(obj, function()
                                        local a = Angle(e, player)
                                        for i = 0, count - 1 do
                                            P.mid1_1.attack(e.x, e.y, i, a, u, COLOR_BLUE)
                                            task.Wait(4)
                                        end
                                    end)
                                    task.Wait(wait)
                                end
                            end
                    )
                end,
                [COLOR_RED] = function(e, dt, u)
                    enemy.createShooter(e,
                            start_time_left + dt, total_time + dt, --start_time_left total_time
                            function(obj)
                                while true do
                                    task.New(obj, function()
                                        for i = 0, count - 1 do
                                            P.mid1_1.attack(e.x, e.y, i, Angle(e, player), u, COLOR_RED)
                                            task.Wait(4)
                                        end
                                    end)
                                    task.Wait(wait)
                                end
                            end
                    )
                end,
            }
            local function shooter(e, dt, u, co)
                shooter_list[co](e, dt, u)
            end
            return shooter
        end
)

P.mid1_1 = BS.createPointer(
        function(diff, rank)
            local attack_list = {}
            --blue
            do
                local bunch = switch(rank, {
                    3, 3, 3, 3, 5
                })
                local da = switch(rank, {
                    45, 45, 45, 45, 22.5
                })
                local v = 2.5*defaultSwitchVelocityByRank(rank)
                local dv = 0.25*defaultSwitchVelocityByRank(rank)
                local style, color = stg.grain_b, COLOR_BLUE
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStraight(x, y, v, a, style, color)
                end
                attack_list[color] = function(x, y, i, a, u)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                curve_normal1(x, y, v + dv*i, a, bunch, da*u, bullet_func)
                            end)
                end
            end
            --red
            do
                local bunch = switch(rank, {
                    3, 3, 3, 3, 5
                })
                local da = switch(rank, {
                    45, 45, 45, 45, 22.5
                })
                local v = 2.5*defaultSwitchVelocityByRank(rank)
                local dv = 0.25*defaultSwitchVelocityByRank(rank)
                local style, color = stg.ball_mid, COLOR_RED
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStraight(x, y, v, a, style, color)
                end
                attack_list[color] = function(x, y, i, a, u)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                curve_normal1(x, y, v + dv*i, a, bunch, da*u, bullet_func)
                            end)
                end
            end
            local function attack(x, y, i, a, u, co)
                attack_list[co](x, y, i, a, u)
            end
            return attack
        end
)

--本体发弹
S.mid1 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = 1
            --case：持续攻击时间
            local total_time = 360

            local wait = switch(rank, {
                120, 120, 120, 120, 90
            })
            local count = switch(rank, {
                1, 1, 1, 1, 2
            })
            local function shooter(e, dt, co)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            while true do
                                task.New(e, function()
                                    for _ = 0, count - 1 do
                                        P.mid1.attack(e.x, e.y, Angle(e, player), co)
                                        task.Wait(30)
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

--基础道中自机狙发射点
P.mid1 = BS.createPointer(
        function(diff, rank)
            local attack_list = {}
            --blue
            do
                --case：way数
                local way = switch(rank, {
                    6, 6, 6, 6, 8
                })
                local da = 105/(way - 1)
                --case：初始弹速
                local v = 2.5*defaultSwitchVelocityByRank(rank)
                --case：每层弹速差
                local dv = 0.5*defaultSwitchVelocityByRank(rank)
                local style, color = stg.grain_b, COLOR_BLUE
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, v + 3, v, a, 20, 0, stg.ball_mid_c, color - 1)
                end
                local function bullet_func1(x, y, v, a)
                    stg.newSimpleStrChV(x, y, v + 3, v, a, 20, 0, stg.ball_mid, color)
                end

                attack_list[color] = function(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                sect_normal1(x, y, v, a, way, da, bullet_func)
                                sect_normal1(x, y, v + dv, a, way + 1, da, bullet_func1)
                            end)
                end
            end

            --red
            do
                --case：way数
                local way = switch(rank, {
                    6, 6, 6, 6, 8
                })
                local da = 105/(way - 1)
                --case：初始弹速
                local v = 2.5*defaultSwitchVelocityByRank(rank)
                --case：每层弹速差
                local dv = 0.5*defaultSwitchVelocityByRank(rank)
                local dv_l = 0.1*defaultSwitchVelocityByRank(rank)
                local style, color = stg.grain_b, COLOR_RED
                local function bullet_func(x, y, v, a)
                    for i = 0, 1 do
                        stg.newSimpleStrChV(x, y, 0, v + dv_l*i, a, 60, 0, style, color - 1)
                    end
                end
                local function bullet_func1(x, y, v, a)
                    for i = 0, 1 do
                        stg.newSimpleStrChV(x, y, 0, v + dv_l*i, a, 60, 0, style, color)
                    end
                end

                attack_list[color] = function(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                sect_normal1(x, y, v, a, way, da, bullet_func)
                                sect_normal1(x, y, v + dv, a, way + 1, da, bullet_func1)
                            end)
                end
            end
            local function attack(x, y, a, co)
                attack_list[co](x, y, a)
            end
            return attack
        end
)
--endregion

--region 开花中妖精
E.mid2 = BS.createEnemy(
        function(diff, rank)
            local style_list = {}
            style_list[COLOR_BLUE] = sty.FAIRY_MIDDLE_2_BLUE
            style_list[COLOR_RED] = sty.FAIRY_MIDDLE_2_RED
            local function create(x, y, hp, dt, co)
                co = co or COLOR_BLUE
                local obj = New(enemy, x, y, style_list[co], --style
                        hp, --hp
                        true,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                if not disarm then
                    S.mid2.main(obj, dt, co) --给这个小怪装上发射器
                end
                return obj
            end
            return create
        end
)

S.mid2 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = 1
            --case：持续攻击时间
            local total_time = 360
            local wait = switch(rank, {
                90, 90, 90, 90, 60
            })
            local function shooter(e, dt, co)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            while true do
                                P.mid2.attack(e.x, e.y, Angle(e, player), co)
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)

P.mid2 = BS.createPointer(
        function(diff, rank)
            local attack_list = {}
            --blue
            do
                --case：way数
                local way = switch(rank, {
                    7, 7, 7, 7, 9
                })
                --case：初始弹速
                local v = 2.5*defaultSwitchVelocityByRank(rank)
                --case：每层弹速差
                local dv_l = 1*defaultSwitchVelocityByRank(rank)
                local dv_w = 0.075*defaultSwitchVelocityByRank(rank)*2
                local style, color = stg.ball_big, COLOR_BLUE
                local function bullet_func1(x, y, v, a)
                    for i = -0.5, 0.5 do
                        stg.newSimpleStraight(x, y, v - dv_w*abs(i), a + 4*i, style, color)
                    end
                    stg.newSimpleStraight(x, y, v, a, style, color)
                end
                local function bullet_func2(x, y, v, a)
                    stg.newSimpleStraight(x, y, v, a, style, color)
                end

                attack_list[color] = function(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_normal1(x, y, v + dv_l, a, way, --base
                                        bullet_func1
                                )
                                circle_normal1(x, y, v, a + 180/(way + 1), way + 1, --base
                                        bullet_func2
                                )
                            end)
                end
            end

            --red
            do
                --case：way数
                local way = switch(rank, {
                    7, 7, 7, 7, 11
                })
                local bunch = switch(rank, {
                    3, 3, 3, 3, 4
                })
                local da_b = 1.5
                --case：初始弹速
                local v = 2.5*defaultSwitchVelocityByRank(rank)
                --case：每层弹速差
                local dv_l = 1*defaultSwitchVelocityByRank(rank)
                local dv_b = -0.075*defaultSwitchVelocityByRank(rank)*2
                local style, color = stg.ball_big, COLOR_RED
                local function bf0(x, y, v, a)
                    stg.newSimpleStraight(x, y, v, a, stg.ball_mid, color)
                end
                local function bf1(x, y, v, a)
                    stg.newSimpleStraight(x, y, v, a, stg.ball_mid_c, color - 1)
                end
                local function bullet_func1(x, y, v, a)
                    tri_normal1(x, y, v, dv_b, a,
                            da_b, bunch, --da0, bunch
                            bf0)
                    tri_normal1(x, y, v - 2*dv_b, dv_b, a,
                            da_b, bunch + 1, --da0, bunch
                            bf1)
                end
                local function bullet_func2(x, y, v, a)
                    tri_normal1(x, y, v, dv_b, a,
                            da_b, bunch, --da0, bunch
                            bf1)
                end

                attack_list[color] = function(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_normal1(x, y, v + dv_l, a, way, --base
                                        bullet_func1
                                )
                                circle_normal1(x, y, v, a + 180/(way + 1), way + 1, --base
                                        bullet_func2
                                )
                            end)
                end
            end
            local function attack(x, y, a, co)
                attack_list[co](x, y, a)
            end
            return attack
        end
)
--endregion

--region 鬼火群
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
            local style_list = {}
            style_list[COLOR_BLUE] = sty.FIRE_CYAN
            style_list[COLOR_RED] = sty.FIRE_PINK
            local function create(x, y, hp, dt, co)
                co = co or COLOR_BLUE
                local obj = New(enemy, x, y, style_list[co], --style
                        hp, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                if not disarm then
                    S.ghost1.main(obj, dt, co)
                end
                obj.show_aura = true
                return obj
            end
            return create
        end
)

--4层连弹
S.ghost1 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = 1
            --case：持续攻击时间
            local total_time = 120
            local wait = switch(rank, {
                60, 60, 60, 60, 40
            })
            local count = switch(rank, {
                2, 2, 2, 2, 4
            })
            local function shooter(e, dt, co)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            while true do
                                if e.y > 0 then --只有y大于0才会攻击
                                    task.New(e, function()
                                        local x, y, a = e.x, e.y, Angle(e, player)
                                        for i = 0, count - 1 do
                                            P.ghost1.attack(x, y + 10*i, a, co)
                                            task.Wait(2)
                                        end
                                    end)
                                end
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
            --case：way数
            local way = 3
            local da = switch(rank, {
                75, 75, 75, 75, 60
            }) --每way间的间隔
            --case：初始弹速
            local v = 3*defaultSwitchVelocityByRank(rank)
            local style, color = stg.grain_a, COLOR_CYAN
            local function attack(x, y, a, co)
                PlaySound("tan00")
                co = co or color
                co = co - 1
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, 0, v, a, 60, 0, style, co)
                end
                stg.newFadeEffect(x, y, style, co, false,
                        function()
                            sect_normal1(x, y, v, a, way, da, bullet_func)
                        end)
            end
            return attack
        end
)

--endregion

--region 风车大蝴蝶
E.big1 = EISlib.Bullet.Shooter.createEnemy(
        function(diff, rank)
            local style_list = {}
            style_list[COLOR_BLUE] = sty.FAIRY_LARGE_BLUE
            style_list[COLOR_RED] = sty.FAIRY_LARGE_RED
            local function create(x, y, hp, dt, u, co)
                co = co or COLOR_BLUE
                local obj = New(enemy, x, y, style_list[co], --style
                        hp, --hp
                        true,  --show_hpbar
                        system.DROP_MID_ENEMY, --drop
                        false, --no_count
                        nil, --death_func
                        true --type
                )
                enemy.changeAura(obj, COLOR_ORANGE, "big") --激光颜色与法阵颜色要一致
                --生成小弟
                for i = 0, 3 do
                    E.big1_1.create(obj, 90*i, u, dt, co)
                end
                if not disarm then
                    S.big1.main(obj, dt, co)
                end
                return obj
            end
            return create
        end
)

E.big1_1 = EISlib.Bullet.Shooter.createEnemy(
        function(diff, rank)
            local style_list = {}
            style_list[COLOR_BLUE] = sty.FIRE_BLUE
            style_list[COLOR_RED] = sty.FIRE_RED
            local function create(mst, a, u, dt, co)
                co = co or COLOR_BLUE
                local obj = New(enemy, mst.x, mst.y, style_list[co], --style
                        99999, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                setSizeAndColli(obj, 1.25, 1.25)
                obj.show_aura = true
                enemy.setTauntRank(obj, enemy.SERVANT_TAUNT)
                enemy.cancelClashColli(obj) --取消撞击判定
                _connect(mst, obj, 1, true)
                rotateMoveWith2Task(obj, mst,
                        90, a, --rmax, a
                        4*u, --omiga
                        60, _infinite, --t0, t1
                        false --IsRotChange
                )
                obj.mst = mst
                if not disarm then
                    S.big1_1.main(obj, dt, u, co)
                end
                obj.show_aura = true
            end
            return create
        end
)

--三角型描边弹幕发射器
S.big1_1 = EISlib.Bullet.Shooter.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = 1
            --case：持续攻击时间
            local total_time = 360
            --case：攻击间隔
            local wait = switch(rank, {
                10, 10, 10, 10, 5
            })
            --红色模式下每次攻击的角度差
            local da = -wait*0
            local shooter_list = {
                [COLOR_BLUE] = function(e, dt, u)
                    enemy.createShooter(e,
                            start_time_left + dt, total_time + dt, --start_time_left total_time
                            function()
                                local mst = e.mst
                                while IsValid(mst) do
                                    P.big1_1.attack(e.x, e.y, Angle(mst, e) + 135*u, COLOR_BLUE)
                                    task.Wait(wait)
                                end
                            end
                    )
                end,
                [COLOR_RED] = function(e, dt, u)
                    enemy.createShooter(e,
                            start_time_left + dt, total_time + dt, --start_time_left total_time
                            function()
                                local mst = e.mst
                                local i = 0
                                while IsValid(mst) do
                                    P.big1_1.attack(e.x, e.y, Angle(mst, e) + (135 + da*i)*u, COLOR_RED)
                                    task.Wait(wait)
                                    i = i + 1
                                end
                            end
                    )
                end
            }
            local function shooter(e, dt, u, co)
                shooter_list[co](e, dt, u)
            end
            return shooter
        end
)

P.big1_1 = EISlib.Bullet.Shooter.createPointer(
        function(diff, rank)
            local attack_list = {}
            --blue
            do
                --case：一侧边有多少个
                local bunch = 2
                --case：每way之间角度差
                local da = switch(rank, {
                    0.8, 0.8, 0.8, 0.8, 1
                })
                --case：初始弹速
                local v = 2*defaultSwitchVelocityByRank(rank)
                --case：相邻弹幕速度差
                local dv = -0.025*defaultSwitchVelocityByRank(rank)
                local style, color = stg.arrow_big, COLOR_BLUE
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStraight(x, y, v, a, style, color)
                end

                attack_list[color] = function(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                stg.newSimpleStraight(x, y, v + 2*dv, a, stg.ball_mid, color)
                                tri_normal1(x, y, v, dv, a,
                                        da, bunch, --da0, bunch
                                        bullet_func)
                            end)
                end
            end

            --red
            do
                --case：一侧边有多少个
                local bunch = 2
                --case：每way之间角度差
                local da = switch(rank, {
                    0.8, 0.8, 0.8, 0.8, 1
                })
                --case：初始弹速
                local v = 2*defaultSwitchVelocityByRank(rank)
                --case：相邻弹幕速度差
                local dv = -0.025*defaultSwitchVelocityByRank(rank)
                local style, color = stg.arrow_big, COLOR_RED
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStraight(x, y, v, a, style, color)
                end

                attack_list[color] = function(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                stg.newSimpleStraight(x, y, v + 6*dv, a, stg.ball_mid, color)
                                tri_normal1(x, y, v, dv, a,
                                        da, bunch, --da0, bunch
                                        bullet_func)
                            end)
                end
            end

            local function attack(x, y, a, co)
                attack_list[co](x, y, a)
            end
            return attack
        end
)


S.big1 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = 0
            --case：持续攻击时间
            local total_time = 360
            local wait = switch(rank, {
                60, 60, 60, 60, 45
            })
            local function shooter(e, dt, co)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            while true do
                                task.New(e, function()
                                    local count = switch(system.PowerRank.getRank(), {
                                        1, 1, 1, 1, 3
                                    })
                                    local x, y = e.x, e.y
                                    for i = 0, count - 1 do
                                        P.big1.attack(x, y, i, -90, 10*(2 - i), co)
                                        task.Wait(10)
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

--⑨的甜甜圈弹
P.big1 = BS.createPointer(
        function(diff, rank)
            local attack_list = {}
            --blue
            do
                --case：way数
                local way = 24
                local style, color = stg.ball_mid_c, COLOR_BLUE
                attack_list[color] = function(x, y, i, a, wt)
                    PlaySound("tan00")
                    local function bullet_func(x, y, i, a)
                        B.big1.create(x, y, i, a, wt, color)
                    end
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_normal1(x, y, i, a, way, bullet_func)
                            end)
                end
            end

            --red
            do
                --case：way数
                local way = 24
                local style, color = stg.ball_mid_c, COLOR_RED
                attack_list[color] = function(x, y, i, a, wt)
                    PlaySound("tan00")
                    local b_list = {}
                    local function bullet_func(x, y, i, a)
                        table.insert(b_list, B.big1.create(x, y, i, a, wt, color))
                    end
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_normal1(x, y, i, a, way, bullet_func)
                                tasker(function()
                                    task.Wait(wt - 1)
                                    for _, b in pairs(b_list) do
                                        if IsValid(b) then
                                            b.angle = Angle(x, y, player.x, player.y)
                                        end
                                    end
                                end)
                            end)
                end
            end

            local function attack(x, y, i, a, wt, co)
                attack_list[co](x, y, i, a, wt)
            end
            return attack
        end
)

--单个甜甜圈子弹定义
B.big1 = EISlib.Bullet.Shooter.createBulletClass(
        function(diff, rank)
            local create_list = {}
            --blue
            do
                local v0 = 4
                local dv = 1.5
                local v1 = 4*defaultSwitchVelocityByRank(rank)
                local style, color = stg.ball_mid, COLOR_BLUE
                create_list[color] = function(x, y, i, a, wt)
                    local obj = stg.newSimpleBullet(x, y, style, color)
                    task.New(obj, function()
                        velch(obj, v0 + dv*i, 0, a, 45)
                        task.Wait(wt)
                        PlaySound("kira00")
                        obj.angle = obj.angle or Angle(obj, player)
                        velch(obj, 0, v1, obj.angle, 20)
                    end)
                    return obj
                end
            end

            --red
            do
                local v0 = 3
                local dv = 1
                local v1 = 4*defaultSwitchVelocityByRank(rank)
                local style, color = stg.ball_mid, COLOR_RED
                create_list[color] = function(x, y, i, a, wt)
                    local obj = stg.newSimpleBullet(x, y, style, color)
                    task.New(obj, function()
                        velch(obj, v0 + dv*i, 0, a, 45)
                        task.Wait(wt)
                        PlaySound("kira00")
                        obj.angle = obj.angle or Angle(obj, player)
                        velch(obj, 0, v1, obj.angle, 20)
                    end)
                    return obj
                end
            end
            local function create(x, y, i, a, wt, co)
                return create_list[co](x, y, i, a, wt)
            end
            return create
        end
)
--endregion

--endregion


--region 标题定义
local title, white
title = Class(object)
function title:init(x, y)
    self.x, self.y = x, y
    self.img = "s7_road_title1"
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
    system.PowerRank.resumeHyper() --从这里计时
    local self = New(R) --创建自己
    self.sence = sence or 0
    New(stage7_background, self.sence)
    loadRes()
    LoadMusicRecord("s7")
    R.updateByRankChange() --初始化一次
    task.Wait(60)
    self.timer = 0 --计时清零
end

--道中片段1
local createMidBoss = lstg.DoFile(EISlib.stage.path.."stage7/mid_boss.lua")
local mid_bosses = {}
for diff = 5, 5 do
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
        EISlib.stage.playMusic("s7", t / 60, true) -- 要解锁音乐室
        if self.timer == t then
            self.sence = 1
            --region 获取敌机组合
            local g1 = s7_enemy_manager:getCreateGroupFunc(1, "small_blue*7+mid")
            local g2 = s7_enemy_manager:getCreateGroupFunc(1, "line")
            local e3 = s7_enemy_manager:getCreateEnemyFunc(1, "mid")
            --endregion

            --region 开始设计版面
            g1(-100, 245) --7只一组妖精
            task.Wait(90)
            g1(100, 245)
            task.Wait(90)

            g1(-100, 245)
            task.Wait(90)
            g1(100, 245)
            g2(-224, 100) --开始出现连线妖精
            task.Wait(90)

            g1(-100, 245)
            task.Wait(90)
            g1(100, 245)
            g2(224, 100) --开始出现连线妖精
            task.Wait(90)

            g1(-100, 245)
            task.Wait(90)
            g1(100, 245)

            task.Wait(90)
            e3(-80, 245)
            e3(80, 245)
            task.Wait(180)
            createTitle(0, 100)
            --endregion
            --task.Wait(99999)
        end
    end
end

--道中片段2
function R.SECOND(pratice)
    local self = lstg.tmpvar.current_road
    --1020f
    local t = 1020
    if IsValid(self) then
        if pratice then
            self.timer = t
            audio.playMusic("s7", 1.0, t/60)
        else
            --等到tf
            while self.timer < t do
                task.Wait(1)
            end
        end
        if self.timer == t then
            self.sence = 2
            --region 获取敌机组合
            local g1 = s7_enemy_manager:getCreateGroupFunc(2, "ghost")
            local e2 = s7_enemy_manager:getCreateEnemyFunc(2, "mid")
            local e3 = s7_enemy_manager:getCreateEnemyFunc(2, "big")
            local g4 = s7_enemy_manager:getCreateGroupFunc(1, "small_blue*7")
            --endregion

            --region 开始设计版面
            for u = -1, 1, 2 do
                e2(80*u, 245)
            end
            task.Wait(30)
            for i = 0.5, 3.5 do
                for u = -1, 1, 2 do
                    g1(45*i*u, 245, u)
                end
                task.Wait(30)
            end
            for u = -1, 1, 2 do
                e2(80*u, 245)
            end
            task.Wait(90)
            for i = 0.5, 3.5 do
                for u = -1, 1, 2 do
                    g1(40*i*u, 245, u)
                end
                task.Wait(30)
            end
            for u = -1, 1, 2 do
                e2(80*u, 245)
            end
            task.Wait(90)
            for i = 0.5, 3.5 do
                for u = -1, 1, 2 do
                    g1(45*i*u, 245, u)
                end
                task.Wait(30)
            end
            task.Wait(120)
            --出现大型机
            for u = -1, 1, 2 do
                e3(-120*u, 245)
                task.Wait(60)
                g1(75*u, 245, u)
                task.Wait(120)
                g1(-100*u, 245, -u)
                task.Wait(60)
                g4(-50*u, 245)
                task.Wait(45)
                g4(-12.5, 245)
                task.Wait(45)
                g4(25*u, 245)
                task.Wait(60)
            end
            --先来两只中妖精
            for u = -1, 1, 2 do
                e2(80*u, 245)
            end
            task.Wait(30)
            --大量鬼火
            for i = 0.5, 2.5 do
                for u = -1, 1, 2 do
                    g1(45*i*u, 245, u)
                end
                task.Wait(30)
            end
            --再来两只中妖精
            for u = -1, 1, 2 do
                e2(80*u, 245)
            end
            task.Wait(60)
            --两只大怪同时出
            for u = -1, 1, 2 do
                e3(-40*u, 285)
            end
            task.Wait(120)
            --中间出一对鬼火
            for u = -1, 1, 2 do
                g1(0*u, 245, u)
            end
            task.Wait(180)
            --小妖精从中间向两侧出现
            for i = 0, 2 do
                if i == 0 then
                    g4(0, 245)
                else
                    for u = -1, 1, 2 do
                        g4(30*u*i, 245)
                    end
                end
                task.Wait(45)
            end
            SystemLog("第二段最后一只妖精生成时间："..self.timer)
            --endregion
        end
    end
end

function R.THIRD(pratice)
    local self = lstg.tmpvar.current_road
    --3120f
    local t = 3120
    if IsValid(self) then
        if pratice then
            self.timer = t
            audio.playMusic("s7", 1.0, t/60)
        else
            --等到3120f
            while self.timer < t do
                task.Wait(1)
            end
        end
        if self.timer == t then
            self.sence = 3

            --region 获取敌机组合
            local g1 = s7_enemy_manager:getCreateGroupFunc(3, "ghost_line")
            local e2 = s7_enemy_manager:getCreateEnemyFunc(1, "mid")
            local g3 = s7_enemy_manager:getCreateGroupFunc(1, "line")
            local g4 = s7_enemy_manager:getCreateGroupFunc(3, "mid1")
            local g5 = s7_enemy_manager:getCreateGroupFunc(3, "mid2")
            local g6 = s7_enemy_manager:getCreateGroupFunc(1, "small_blue*7")
            local e7 = s7_enemy_manager:getCreateEnemyFunc(2, "big")
            local e8 = s7_enemy_manager:getCreateEnemyFunc(2, "mid")
            --endregion

            --region 开始设计版面
            task.Wait(60)
            --开始到处出怪
            for u = -1, 1, 2 do
                g1(-224*u, 245, -90 + 45*u, u)
                task.Wait(40)
                g1(224*u, 100, -90 - 90*u, -u)
                task.Wait(40)
                e2(-80*u, 245)
                g1(-100*u, 365, -90 - 30*u, u)
                task.Wait(40)
                g1(100*u, 365, -90 + 15*u, -u)
                task.Wait(40)
                e2(80*u, 245)
                g1(-224*u, 100, -90 + 135*u, -u)
                task.Wait(40)
                g1(224*u, 0, -90 - 90*u, -u)
                task.Wait(40)
            end
            task.Wait(150)
            for u = -1, 1, 2 do
                g4(150, 100) --y, yrange 两侧袭击的连弹妖精
                task.Wait(60)
                g6(-50*u, 245) --六只一组的小妖精
                g3(-224*u, 150, 10) --开始出现连线鳞弹妖精
                task.Wait(60)
                g6(50*u, 245) --六只一组的小妖精
                task.Wait(60)
                g5(200, -100) --y, yrange 两侧袭击的开花妖精
                task.Wait(60)
                g6(-50*u, 245) --六只一组的小妖精
                task.Wait(60)
            end
            for i = -1.5, 1.5 do
                g6(-50*i, 245) --六只一组的小妖精
                task.Wait(30)
            end
            --一大波妖精正在接近！（？
            e7(-120, 245) --大型机掩护鳞弹妖精
            task.Wait(60)
            --task.Wait(40)
            g4(180, 100) --y, yrange 两侧袭击的连弹妖精
            task.Wait(30)
            g5(160, -100) --y, yrange 两侧袭击的开花妖精
            task.Wait(60)
            g1(-224, 245, -90, 1)
            task.Wait(30)
            g1(-224, 245, -90, -1)
            task.Wait(30)
            --靠边两侧出连弹中怪
            for u = -1, 1, 2 do
                e2(120*u, 245)
            end
            task.New(self, function()
                task.Wait(30)
                for u = -1, 1, 2 do
                    g3(-224*u, 150, 10) --出现连线鳞弹妖精
                end
            end)
            --小妖精从中间向两侧出现
            for i = 0, 2 do
                if i == 0 then
                    g6(0, 245)
                else
                    for u = -1, 1, 2 do
                        g6(30*u*i, 245)
                    end
                end
                task.Wait(30)
            end
            --靠边两侧出开花中怪
            for u = -1, 1, 2 do
                e8(120*u, 245)
            end
            task.Wait(60)
            --小妖精从中间向两侧出现
            for i = 0, 2 do
                if i == 0 then
                    g6(0, 245)
                else
                    for u = -1, 1, 2 do
                        g6(30*u*i, 245)
                    end
                end
                task.Wait(45)
            end
            SystemLog("第二段最后一只妖精生成时间："..self.timer)
            --endregion
        end
    end
end

--道中boss
function R.FOURTH(pratice)
    local self = lstg.tmpvar.current_road
    --5220f
    local t = 5220
    if IsValid(self) then
        if pratice then
            self.timer = t
            audio.playMusic("s7", 1.0, t/60)
        else
            --等到3550f
            while self.timer < t do
                task.Wait(1)
            end
        end
        if self.timer == t then
            self.sence = 4
            --region 获取敌机组合（增援部分）
            local g1 = s7_enemy_manager:getCreateGroupFunc(4, "ghost")
            local g2 = s7_enemy_manager:getCreateGroupFunc(4, "line")
            --endregion

            --region 开始设计版面
            clearEnemyAndBullet()
            local boss = New(mid_bosses[5])
            while self.timer < 9120 do
                task.Wait(1)
            end
            --增援什么的可以考虑在9120到10000出
            for u = -1, 1, 2 do
                g2(224*u, 150, 12, boss) --连线增援妖精
                for i = 0, 5 do
                    g1((-180 + 60*i)*u, 245, -u, boss)
                    task.Wait(30)
                end
                task.Wait(210)
            end
            --如果这时道中boss还存活，就卡着不让后面的道中前进
            while IsValid(boss) do
                task.Wait(1)
            end
            --endregion
        end
    end
end

function R.FIFTH(pratice)
    local self = lstg.tmpvar.current_road
    --10120f ——> 12215f
    local t = 10120
    if IsValid(self) then
        if pratice then
            self.timer = t
            audio.playMusic("s7", 1.0, t/60)
        else
            --等待到7740f
            while self.timer < t do
                task.Wait(1)
            end
        end
        if self.timer >= t then
            self.sence = 5
            --region 获取敌机组合
            local e1 = s7_enemy_manager:getCreateEnemyFunc(5, "big")
            local g2 = s7_enemy_manager:getCreateGroupFunc(5, "ghost_line")
            local g3 = s7_enemy_manager:getCreateGroupFunc(5, "small_red*7+mid1")
            local g4 = s7_enemy_manager:getCreateGroupFunc(5, "small_red*7+mid2")
            local e5 = s7_enemy_manager:getCreateEnemyFunc(5, "mid1")
            local e6 = s7_enemy_manager:getCreateEnemyFunc(5, "mid2")
            local g7 = s7_enemy_manager:getCreateGroupFunc(5, "small_red2")
            --endregion

            --region 开始设计版面
            for u = -1, 1, 2 do
                e1(-1*u, 245)
                task.Wait(60)
                for i = 0, 1 do
                    e6((75 - 150*i)*u, 245)
                    task.Wait(20)
                end
                task.Wait(30)
                g2(-224*u, 0, 90 - 100*u, u)
                task.Wait(30)
                g2(224*u, 144, 90 + 100*u, u)
                task.Wait(30)
                task.Wait(60)
                for i = 0, 1 do
                    g3(-(50 - 100*i)*u, 245)
                    task.Wait(20)
                end
                task.Wait(60)
                for i = 0, 2 do
                    g4((100 - 100*i)*u, 245)
                    task.Wait(20)
                end
                task.Wait(30)
                g2(224*u, 120, 90 + 90*u, -u)
                task.Wait(30)
                g2(-224*u, 120, 90 - 90*u, u)
                task.Wait(30)
                for i = 0, 1 do
                    e5(-(75 - 150*i)*u, 245)
                    task.Wait(20)
                end
                task.Wait(120)
            end

            for u = -1, 1, 2 do
                e1(-u, 245)
                --小怪海
                for i = 0, 5 do
                    for j = 0, 2 do
                        g7((224 + 20*j + 10*i)*u, 200 - 25*j - 10*i, 180)
                        task.Wait(10)
                    end
                end
                --小怪海
                for i = 0, 5 do
                    for j = 0, 2 do
                        g7((224 + 20*j + 10*i)*u, 200 - 25*j - 10*i, 180)
                        task.Wait(10)
                    end
                end
            end
            task.Wait(300)
            clearEnemyAndBullet()
            --endregion
        end
    end
end

return R
