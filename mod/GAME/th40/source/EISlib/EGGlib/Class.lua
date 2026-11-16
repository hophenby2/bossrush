----------------------------------------
---s7p类定义
----------------------------------------
local M = {}
EGGlib.Class = M

---@class s7p.class
---@return s7p.class
function M.newSimpleClass()
    local cls = {}
    --构造方法，默认为缺省的，即什么也不做，需要在外面override
    function cls.constructor(instance) end
    function cls.new(...)
        local instance = {}
        --调用构造方法
        cls.constructor(instance, ...)
        --绑定类为元表
        setmetatable(instance, {__index = cls})
        return instance
    end
    --对某个实例使用，使之拥有该类的所有方法
    function cls.implement(instance, ...)
        --调用构造方法
        cls.constructor(instance, ...)
        --绑定类为元表
        setmetatable(instance, {__index = cls})
    end
    return cls
end

--创建一个简单的接口
function M.newSimpleInterface()
    return M.newSimpleClass()
end

--继承
function M.extend(child, father)
    for key, func in pairs(father) do --copy
        child[key] = func
    end
end

--region some frequently-used SimpleClass 常用的类和接口
local U = {}
M.Frequently = U

--基础运动接口
U.Basic_movement = M.newSimpleInterface()
do
    local this = U.Basic_movement
    function this.constructor(self, x, y)
        self.x, self.y = x, y
        self.vx, self.vy = 0, 0
        self.ax, self.ay = 0, 0
    end
    function this.update(self)
        self.vx, self.vy = self.vx + self.ax, self.vy + self.ay
        self.x, self.y = self.x + self.vx, self.y + self.vy
    end
end

--支持多内部对象事件 的 核心接口
U.Multi_ObjectEvent_Core = M.newSimpleInterface()
do
    local this = U.Multi_ObjectEvent_Core
    function this.constructor(self)
        self.object_event_list = {}
    end
    function this.update(self)
        for k, object_event in pairs(self.object_event_list) do
            object_event:update()
        end
    end
    function this.addObjectEvent(self, object_event)
        table.insert(self.object_event_list, object_event)
    end
end

--追踪逻辑类（前置接口：基础运动接口Basic_movement）
U.TrackEvent = M.newSimpleClass()
do
    local this = U.TrackEvent
    function this.constructor(self, mst, target, v, tight)
        self.mst = mst
        self.v = v
        self.dv = 0
        self.target = nil
        self.tight = tight --跟踪的紧密度，0为完全不跟，1为每帧角度持续更新为自身与目标方向的角度
        self.maxv = 20
        self.max_tight = 1
    end
    function this.update(self)
        local target = self.target
        local mst = self.mst --不需要判断mst的存在，因为本实例本身就要依附于mst而存在的
        local a = Angle(0, 0, mst.vx, mst.vy)
        if self:isValidTarget() then
            local da = (Angle(mst.x, mst.y, target.x, target.y) - a) % 360
            if da > 180 then
                da = da -360
            end
            a = a + da * self.tight
        end
        self.v = self.v + self.dv
        EGGlib.ObjectEvent.setV(mst, self.v, a) --这段是影响mst的运动参数

    end
    function this.setAcceleration(self, acc)
        self.dv = acc
    end
    function this.setV(self, v)
        self.v = v
    end
    function this.getTight(self)
        return  self.tight
    end
    function this.setTight(self, tight)
        self.tight = max(0, min(self.max_tight, tight))
    end
    function this.addTight(self, dtight)
        self.tight = max(0, min(self.max_tight, self.tight + dtight))
    end
    function this.getTarget(self)
        return self.target
    end
    function this.setTarget(self, target)
        self.target = target
    end
    function this.isValidTarget(self)
        local target = self.target
        return lstg.IsValid(target) --只支持lstg.object
    end
end

U.Updater = M.newSimpleClass() --用于BOSS战对其他类的产生的实例的更新器，updater由这张符卡实例，并且控制其他所有实例的更新逻辑，符卡击破后失效
do
    local this = U.Updater
    function this.constructor(self)
        self.inst_list = {}
        self.timer = 0
    end
    function this.update(self)
        self.timer = self.timer + 1
        for k, inst in pairs(self.inst_list) do
            if inst:isValid() then
                inst:update()
            else
               table.remove(self.inst_list, k)
                SystemLog("对象失效，已回收，回收时间："..self.timer)
            end
        end
    end
    function this.add(self, inst)
        table.insert(self.inst_list, inst)
    end
end

--endregion