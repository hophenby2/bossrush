---=====================================
---东方栖霞园弹幕发射器
---author:S7P
---=====================================
---@class EISlib.Bullet.Shooter
local M = {}
EISlib.Bullet.Shooter = M

--工具人对象（与tasker用法类似，不过要手写)
M.shooter = Class(object)
function M.shooter:init(master, start_time_left, total_time, func)
    self.master = master
    if not master then
        self.no_master = true
    end
    self.bound = false
    M.setTimeLeft(self, start_time_left, total_time - start_time_left)
    M.changeAtkFunc(self, func)
end
function M.shooter:frame()
    M.upadteTimeLeft(self)
end
function M.shooter:render() end
function M.shooter:kill() end
function M.shooter.del() end

--目标对象发射器攻击提前或者延迟一段时间
function M.addAttackWait(obj, dt)
    obj.start_time_left = max(obj.start_time_left, obj.start_time_left + dt)
end
--目标对象发射器攻击提早或者延后结束一段时间
function M.addAttackEnd(obj, dt)
    obj.last_time_left = obj.last_time_left + dt
end
--目标对象发射器攻击停止一段时间(rank变化或者自机miss）
function M.stopAttack(obj, stop_time)
    local dt = stop_time - obj.start_time_left
    dt = max(0, dt)
    M.addAttackWait(obj, dt)
    M.addAttackEnd(obj, -dt)
end
--设置发射时间和持续时间
function M.setTimeLeft(obj, start_time_left, last_time_left)
    obj.start_time_left = start_time_left
    obj.last_time_left = last_time_left
end
--更新发射时间和持续时间
function M.upadteTimeLeft(obj)
    if obj.start_time_left > 0 then
        obj.start_time_left = obj.start_time_left - 1
    elseif obj.last_time_left > 0 then
        if obj.no_master or IsValid(obj.master) then
            if obj.status == "normal" then
                task.Do(obj)
            end
        else
            Del(obj)
        end
        obj.last_time_left = obj.last_time_left - 1
    else
        Del(obj)
    end
end
--改变攻击方式
function M.changeAtkFunc(obj, func)
    task.clear(obj)
    task.New(obj, function()
        func(obj)
    end)
end


------------------------------------------
--自定义子弹生成器
function M.createBulletClass(createBulletFunc)
    local bullet = {}
    local t = {}
    for diff = 1, 5 do
        t[diff] = {}
        for rank = 0, 4 do
            t[diff][rank + 1] = createBulletFunc(diff, rank)
        end
    end
    bullet.create_t = t
    function bullet.update(diff, rank)
        diff = diff or difficulty
        rank = rank or system.PowerRank.getRank()
        bullet.create =  bullet.create_t[diff][rank + 1]
    end
    --初始化（默认e难度0rank）
    bullet.update(1, 0)
    return bullet
end

--发弹点生成器
function M.createPointer(createPointerFunc)
    local pointer = {}
    local t = {}
    for diff = 1, 5 do
        t[diff] = {}
        for rank = 0, 4 do
            t[diff][rank + 1] = createPointerFunc(diff, rank)
        end
    end
    pointer.attack_t = t
    function pointer.update(diff, rank)
        diff = diff or difficulty
        rank = rank or system.PowerRank.getRank()
        pointer.attack =  pointer.attack_t[diff][rank + 1]
    end
    --初始化（默认e难度0rank）
    pointer.update(1, 0)
    return pointer
end


--道中敌人发弹工具对象生成器
function M.createShooter(createShooterFunc)
    local shooter = {}
    local t = {}
    for diff = 1, 5 do
        t[diff] = {}
        for rank = 0, 4 do
            t[diff][rank + 1] = createShooterFunc(diff, rank)
        end
    end
    shooter.main_t = t
    function shooter.update(diff, rank)
        diff = diff or difficulty
        rank = rank or system.PowerRank.getRank()
        shooter.main =  shooter.main_t[diff][rank + 1]
    end
    --初始化（默认e难度0rank）
    shooter.update(1, 0)
    return shooter
end

--道中敌人动作工具对象生成器
function M.createAction(createActionFunc)
    local action = {}
    local t = {}
    for diff = 1, 5 do
        t[diff] = {}
        for rank = 0, 4 do
            t[diff][rank + 1] = createActionFunc(diff, rank)
        end
    end
    action.main_t = t
    function action.update(diff, rank)
        diff = diff or difficulty
        rank = rank or system.PowerRank.getRank()
        action.main =  action.main_t[diff][rank + 1]
    end
    --初始化（默认e难度0rank）
    action.update(1, 0)
    return action
end

--boss发弹工具对象生成器
function M.createTasker(createTaskerFunc)
    local tasker_class = {}
    local t = {}
    for diff = 1, 5 do
        t[diff] = {}
        for rank = 0, 4 do
            t[diff][rank + 1] = createTaskerFunc(diff, rank)
        end
    end
    tasker_class.main_t = t
    function tasker_class.update(diff, rank)
        diff = diff or difficulty
        rank = rank or system.PowerRank.getRank()
        tasker_class.main =  tasker_class.main_t[diff][rank + 1]
    end
    --初始化（默认e难度0rank）
    tasker_class.update(1, 0)
    return tasker_class
end

--步骤生成器
function M.createStep(createStepFunc)
    local step = {}
    local t = {}
    for diff = 1, 5 do
        t[diff] = {}
        for rank = 0, 4 do
            t[diff][rank + 1] = createStepFunc(diff, rank)
        end
    end
    step.main_t = t
    function step.update(diff, rank)
        diff = diff or difficulty
        rank = rank or system.PowerRank.getRank()
        step.main =  step.main_t[diff][rank + 1]
    end
    --初始化（默认e难度0rank）
    step.update(1, 0)
    return step
end

--敌机对象生成器
function M.createEnemy(createEnemyFunc)
    local enemy = {}
    local t = {}
    for diff = 1, 5 do
        t[diff] = {}
        for rank = 0, 4 do
            t[diff][rank + 1] = createEnemyFunc(diff, rank)
        end
    end
    enemy.create_t = t
    function enemy.update(diff, rank)
        diff = diff or difficulty
        rank = rank or system.PowerRank.getRank()
        enemy.create =  enemy.create_t[diff][rank + 1]
    end
    --初始化（默认e难度0rank）
    enemy.update(1, 0)
    return enemy
end
