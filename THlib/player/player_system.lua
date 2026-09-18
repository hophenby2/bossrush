local player_lib = player_lib

local ObjList = ObjList
local Dist = Dist
local Forbid = Forbid
local cos, sin = cos, sin

local defaultKeys = {
    "up", "down", "left", "right",
    "slow", "shoot", "spell", "special",
}
player_lib.defaultKeys = defaultKeys

local moveKeyEvent = {
    { "up", "down", "key.up.down", 0, function(self)
        self.__up_flag = true
        self.__up_counting = self.__up_counting + 1
    end },
    { "up", "up", "key.up.up", 0, function(self)
        self.__up_flag = false
        self.__up_counting = 0
    end },
    { "down", "down", "key.down.down", 0, function(self)
        self.__down_flag = true
        self.__down_counting = self.__down_counting + 1
    end },
    { "down", "up", "key.down.up", 0, function(self)
        self.__down_flag = false
        self.__down_counting = 0
    end },
    { "left", "down", "key.left.down", 0, function(self)
        self.__left_flag = true
        self.__left_counting = self.__left_counting + 1

    end },
    { "left", "up", "key.left.up", 0, function(self)
        self.__left_flag = false
        self.__left_counting = 0
    end },
    { "right", "down", "key.right.down", 0, function(self)
        self.__right_flag = true
        self.__right_counting = self.__right_counting + 1
    end },
    { "right", "up", "key.right.up", 0, function(self)
        self.__right_flag = false
        self.__right_counting = 0
    end },
}

local defaultKeyEvent = {
    { "up", "down", "key.up.down", 0, function(self)
        self.__up_flag = true
        self.__up_counting = self.__up_counting + 1
    end },
    { "up", "up", "key.up.up", 0, function(self)
        self.__up_flag = false
        self.__up_counting = 0
    end },
    { "down", "down", "key.down.down", 0, function(self)
        self.__down_flag = true
        self.__down_counting = self.__down_counting + 1
    end },
    { "down", "up", "key.down.up", 0, function(self)
        self.__down_flag = false
        self.__down_counting = 0
    end },
    { "left", "down", "key.left.down", 0, function(self)
        self.__left_flag = true
        self.__left_counting = self.__left_counting + 1

    end },
    { "left", "up", "key.left.up", 0, function(self)
        self.__left_flag = false
        self.__left_counting = 0
    end },
    { "right", "down", "key.right.down", 0, function(self)
        self.__right_flag = true
        self.__right_counting = self.__right_counting + 1
    end },
    { "right", "up", "key.right.up", 0, function(self)
        self.__right_flag = false
        self.__right_counting = 0
    end },
    { "slow", "down", "key.slow.down", 0, function(self)
        self.__slow_flag = true
    end },
    { "slow", "up", "key.slow.up", 0, function(self)
        self.__slow_flag = false
    end },
    { "shoot", "down", "key.shoot.down", 0, function(self)
        self.__shoot_flag = true
        self.__aya_shoot = true--给文文用的
        self.__shoot_count = 15
    end },
    { "shoot", "up", "key.shoot.up", 0, function(self)
        if self.__shoot_count <= 0 then
            self.__shoot_flag = false
        end
        self.__aya_shoot = false--给文文用的
    end },
    { "spell", "down", "key.spell.down", 0, function(self)
        self.__spell_flag = true
    end },
    { "spell", "up", "key.spell.up", 0, function(self)
        self.__spell_flag = false
    end },
    { "special", "down", "key.special.down", 0, function(self)
        self.__special_flag = true
    end },
    { "special", "up", "key.special.up", 0, function(self)
        self.__special_flag = false
    end },
}
player_lib.defaultKeyEvent = defaultKeyEvent

local defaultFrameEvent = {
    ["frame.updateDeathState"] = { 100, function(self)
        if (self.death == 0 or self.death > 90) and (not self.lock) and not (self.time_stop) then
            self.__death_state = 0
        elseif self.death == 90 then
            self.__death_state = 1
        elseif self.death == 84 then
            self.__death_state = 2
        elseif self.death == 50 then
            self.__death_state = 3
        elseif self.death < 50 and not (self.lock) and not (self.time_stop) then
            self.__death_state = 4
        else
            self.__death_state = -1
        end
    end },
    ["frame.updateSlow"] = { 99, function(self)
        if self.__slow_flag then
            self.slow = 1
        else
            self.slow = 0
        end
    end },
    ["frame.control"] = { 98, function(self, system)
        if not self.dialog then
            if self.__shoot_flag and self.nextshoot <= 0 then
                system:shoot()
            end
        else
            self.nextshoot = 15
            self.nextspell = 30
        end
    end },
    ["frame.move"] = { 97, function(self)
        local dx, dy, v = 0, 0, self.hspeed
        local left, right, up, down
        local lc, rc, uc, dc = self.__left_counting, self.__right_counting, self.__up_counting, self.__down_counting
        if not self.lock then
            if self.slowlock then
                self.slow = 1
            end
            if self.slow == 1 then
                v = self.lspeed
            end
            up = self.__up_flag
            down = self.__down_flag
            left = self.__left_flag
            right = self.__right_flag
            if uc > dc and dc > 0 then
                down = true
                up = false
            end
            if dc > uc and uc > 0 then
                up = true
                down = false
            end
            if lc > rc and rc > 0 then
                right = true
                left = false
            end
            if rc > lc and lc > 0 then
                left = true
                right = false
            end
            dx = dx - (left and 1 or 0)
            dx = dx + (right and 1 or 0)
            dy = dy + (up and 1 or 0)
            dy = dy - (down and 1 or 0)
            if dx * dy ~= 0 then
                v = v * SQRT2_2
            end
            dx = v * dx
            dy = v * dy
            local w = lstg.world
            self.x = Forbid(self.x + dx, w.pl + 8, w.pr - 8)
            self.y = Forbid(self.y + dy, w.pb + 16, w.pt - 32)
        end
        self.__move_dx = dx
        self.__move_dy = dy
    end },
    ["frame.fire"] = { 96, function(self)
        if self.__shoot_flag and not self.dialog then
            self.fire = self.fire + 0.16
        else
            self.fire = self.fire - 0.16
        end
        if self.fire < 0 then
            self.fire = 0
        end
        if self.fire > 1 then
            self.fire = 1
        end
    end },
    ["frame.itemCollect"] = { 95, function(self)
        if self.y > self.collect_line then
            for _, o in ObjList(6) do
                local flag = false
                if o.attract < 8 then
                    flag = true
                elseif o.attract == 8 and o.target ~= self then
                    if (not o.target) or o.target.y < self.y then
                        flag = true
                    end
                end
                if flag then
                    o.attract = 8
                    o.num = self.item
                    o.target = self
                end
            end
        else
            local C = self.__slow_flag and 48 or 24
            for _, o in ObjList(6) do
                if o.attract < 3 and Dist(self, o) < C then
                    o.attract = 3
                    o.target = self
                end
            end
        end
    end },
    ["frame.updateVar"] = { 94, function(self)
        self.lh = self.lh + (self.slow - 0.5) * 0.3
        if self.lh < 0 then
            self.lh = 0
        end
        if self.lh > 1 then
            self.lh = 1
        end
        if self.nextshoot > 0 then
            self.nextshoot = self.nextshoot - 1
        end
        if self.nextspell > 0 then
            self.nextspell = self.nextspell - 1
        end
        if self.nextsp > 0 then
            self.nextsp = self.nextsp - 1
        end
        if self.__shoot_count > 0 then
            self.__shoot_count = self.__shoot_count - 1
        end
        self.supportx = self.x + (self.supportx - self.x) * 0.6875
        self.supporty = self.y + (self.supporty - self.y) * 0.6875
        if self.protect > 0 then
            self.protect = self.protect - 1
        end
        if self.death > 0 then
            self.death = self.death - 1
        end
    end },
    ["frame.updateSupport"] = { 94, function(self)
        if self.splock then
            self._support_radius = self._support_radius - self._support_radius * 0.1
        else
            self._support_radius = self.max_support_radius + (self.min_support_radius - self.max_support_radius) * task.SetMode[3](self.lh)
        end
        local t = self.timer * 3 * self.support_sign
        for i = 1, 4 do
            self.sp[i][1] = self.supportx + self._support_radius * cos(i * 90 + t)
            self.sp[i][2] = self.supporty + self._support_radius * sin(i * 90 + t)
        end
    end },
}
player_lib.defaultFrameEvent = defaultFrameEvent

---@class player.system
local system = plus.Class()
player_lib.system = system
function system:init(p, slot)
    self.player = p

    p.hspeed = p.hspeed or 4
    p.lspeed = p.lspeed or 2
    p.collect_line = p.collect_line or 96
    p.slow = p.slow or 0
    p.A = p.A or 0
    p.B = p.B or 0
    p.lh = p.lh or 0
    p.fire = p.fire or 0
    p.lock = p.lock or false
    p.dialog = p.dialog or false
    p.nextshoot = p.nextshoot or 0
    p.nextspell = p.nextspell or 0
    p.nextsp = p.nextsp or 0
    p.item = p.item or 1
    p.death = p.death or 0
    p.protect = p.protect or 120
    p.grazer = p.grazer or New(grazer, p)

    p.time_stop = p.time_stop or false
    p.slot = slot
    p.__death_state = 0 --自机状态

    p.__move_dx = 0 --本帧操作移动x距离
    p.__move_dy = 0 --本帧操作移动y距离
    p.__up_counting, p.__down_counting, p.__left_counting, p.__right_counting = 0, 0, 0, 0
    p.__shoot_count = 0

    p.supportx = p.supportx or p.x
    p.supporty = p.supporty or p.y
    p.max_support_radius = 45
    p.min_support_radius = 20
    p._support_radius = 45
    p.support_sign = p.support_sign or 1
    p.sp = { { }, {  }, {  }, {  } }
    for i = 1, 4 do
        p.sp[i][1] = p.supportx + p._support_radius * cos(i * 90)
        p.sp[i][2] = p.supporty + p._support_radius * sin(i * 90)
    end

    self.listener = eventListener()
    self._keys = {}
    self._keys_remove = {}
    self.keyState = {}
    self.keyStatePre = {}
    for _, key in ipairs(defaultKeys) do
        self:regKeys(key)
    end
    for _, event in ipairs(defaultKeyEvent) do
        self:addKeyEvent(unpack(event))
    end
    for name, event in pairs(defaultFrameEvent) do
        self:addFrameEvent(name, unpack(event))
    end
end
function system:lock()
    local p = self.player
    p.colli = false
    p.splock = true
    self.listener = eventListener()
    self._keys = {}
    self._keys_remove = {}
    self.keyState = {}
    self.keyStatePre = {}
    for _, key in ipairs(defaultKeys) do
        self:regKeys(key)
    end
    for _, event in ipairs(moveKeyEvent) do
        self:addKeyEvent(unpack(event))
    end
    for name, event in pairs(defaultFrameEvent) do
        self:addFrameEvent(name, unpack(event))
    end
end

---帧逻辑事件
function system:frame()
    local p = self.player
    if not IsValid(p.grazer) then
        p.grazer = New(grazer, p)
    end
    p.grazer.world = p.world
    if p.lock then
        p.timer = p.timer - 1
    else
        self:updateKeyState() --更新自机按键状态（之后应改为外部调用）
        self:findTarget() --更新target目标
        self:doFrameEvent() --执行帧逻辑事件
    end
    if not p._wisys then
        p._wisys = PlayerWalkImageSystem(p)
    end
    p._wisys:frame(p.__move_dx)
end

---渲染事件
function system:render()
    local p = self.player
    p._wisys:render()--by OLC，自机行走图系统
end

---Shoot事件
function system:shoot()
    local p = self.player
    if p.class.shoot then
        p.class.shoot(p)
    end
end

---碰撞回调事件
function system:colli(other)
    local p = self.player
    if p.death == 0 and not p.dialog and not cheat and not lstg.var.ON_astral then
        if p.protect == 0 then
            if other.IsBoss and not other.is_combat then
                --在没有战斗的时候不判定体术
                return
            end
            if other.IsBoss and other.WALKIMGID == "Seiran" then
                ext.achievement:get(45)
            end--清兰现制草莓酱
            if lstg.var.ON_sakura then
                lstg.var.sakura = 0
                lstg.var.sakura_bonus = false
            else
                PlaySound("pldead00", 0.5)
                p.death = 90--无决死的10帧
                item.PlayerMiss(p)
                New(player_death_ef, p.x, p.y)
            end
            return true
        end
        if other.group == 10 and not other.IsBentLaser then
            laser.CutOnUnit(other, p)
        end
        if other.group == 1 then
            object.Del(other)
        end
    end
    self:doColliAfterEvent(other)
end

---更新target目标
function system:findTarget()
    local p = self.player
    if not IsValid(p.target) or not p.target.colli then
        player_class.findtarget(p)
    end
    if not self:keyIsDown("shoot") then
        p.target = nil
    end
end

---注册一个按键
---@param key string @目标按键标识名
function system:regKeys(key)
    self._keys[key] = true
    self._keys_remove[key] = nil
end

---解除注册一个按键
---@param key string @目标按键标识名
function system:unregKeys(key)
    if self._keys[key] then
        self._keys_remove[key] = true
        self._keys[key] = nil
    end
end

---更新自机按键状态
function system:updateKeyState()
    local p = self.player
    local keyState = p.key or KeyState
    local Do = self.doKeyEvent
    for key in pairs(self._keys) do
        --更新已注册按键状态并执行事件组
        self.keyStatePre[key] = self.keyState[key]
        self.keyState[key] = keyState[key] or false
        if self.keyState[key] then
            if self.keyStatePre[key] then
                Do(self, key, "hold") --保持按住
            else
                Do(self, key, "press") --按下
            end
            Do(self, key, "down") --按住（包括按下）
        else
            if self.keyStatePre[key] then
                Do(self, key, "release") --抬起
            else
                Do(self, key, "none") --保持抬起
            end
            Do(self, key, "up") --保持抬起（包括抬起）
        end
    end
    for key in pairs(self._keys_remove) do
        --移除解除注册的按键并执行应有的事件组
        if self.keyState[key] then
            Do(self, key, "release") --抬起
            Do(self, key, "up") --保持抬起（包括抬起）
        end
        self.keyStatePre[key] = nil
        self.keyState[key] = nil
        self._keys_remove[key] = nil
    end
end

---获取自身注册按键是否按下
---@param key string @目标按键标识名
---@return boolean
function system:keyIsDown(key)
    if self._keys[key] or self._keys_remove[key] then
        return self.keyState[key]
    end
end

---获取自身注册按键是否在当前帧按下
---@param key string @目标按键标识名
---@return boolean
function system:keyIsPressed(key)
    if self._keys[key] then
        return self.keyState[key] and not self.keyStatePre[key]
    end
end

---添加按键事件
---@param key string @目标按键标识名
---@param state string @目标按键事件
---@param eventName string @按键事件名
---@param eventLevel number @按键事件优先度
---@param eventFunc function @按键事件函数
---@return boolean @是否发生覆盖
function system:addKeyEvent(key, state, eventName, eventLevel, eventFunc)
    return self.listener:addEvent(string.format("keyEvent@%s@%s", key, state),
            eventName, eventLevel, eventFunc)
end

---移除按键事件
---@param key string @目标按键标识名
---@param state string @目标按键事件
---@param eventName string @按键事件名
function system:removeKeyEvent(key, state, eventName)
    self.listener:remove(string.format("keyEvent@%s@%s", key, state), eventName)
end

---执行按键事件
---@param key string @目标按键标识名
---@param state string @目标按键事件
function system:doKeyEvent(key, state)
    self.listener:Do(string.format("keyEvent@%s@%s", key, state), self.player, self)
end

---添加帧逻辑事件（前）
---@param eventName string @事件名
---@param eventLevel number @事件优先度
---@param eventFunc function @事件函数
---@return boolean @是否发生覆盖
function system:addFrameBeforeEvent(eventName, eventLevel, eventFunc)
    return self.listener:addEvent("frameEvent@before", eventName, eventLevel, eventFunc)
end

---移除帧逻辑事件（前）
---@param eventName string @事件名
function system:removeFrameBeforeEvent(eventName)
    self.listener:remove("frameEvent@before", eventName)
end

---执行帧逻辑事件（前）
function system:doFrameBeforeEvent()
    self.listener:Do("frameEvent@before", self.player, self)
end

---添加帧逻辑事件
---@param eventName string @事件名
---@param eventLevel number @事件优先度
---@param eventFunc function @事件函数
---@return boolean @是否发生覆盖
function system:addFrameEvent(eventName, eventLevel, eventFunc)
    return self.listener:addEvent("frameEvent@frame", eventName, eventLevel, eventFunc)
end

---移除帧逻辑事件
---@param eventName string @事件名
function system:removeFrameEvent(eventName)
    self.listener:remove("frameEvent@frame", eventName)
end

---执行帧逻辑事件
function system:doFrameEvent()
    self.listener:Do("frameEvent@frame", self.player, self)
end

---添加帧逻辑事件（后）
---@param eventName string @事件名
---@param eventLevel number @事件优先度
---@param eventFunc function @事件函数
---@return boolean @是否发生覆盖
function system:addFrameAfterEvent(eventName, eventLevel, eventFunc)
    return self.listener:addEvent("frameEvent@after", eventName, eventLevel, eventFunc)
end

---移除帧逻辑事件（后）
---@param eventName string @事件名
function system:removeFrameAfterEvent(eventName)
    self.listener:remove("frameEvent@after", eventName)
end

---执行帧逻辑事件（后）
function system:doFrameAfterEvent()
    self.listener:Do("frameEvent@after", self.player, self)
end

---添加渲染逻辑事件（前）
---@param eventName string @事件名
---@param eventLevel number @事件优先度
---@param eventFunc function @事件函数
---@return boolean @是否发生覆盖
function system:addRenderBeforeEvent(eventName, eventLevel, eventFunc)
    return self.listener:addEvent("renderEvent@before", eventName, eventLevel, eventFunc)
end

---移除渲染逻辑事件（前）
---@param eventName string @事件名
function system:removeRenderBeforeEvent(eventName)
    self.listener:remove("renderEvent@before", eventName)
end

---执行渲染逻辑事件（前）
function system:doRenderBeforeEvent()
    self.listener:Do("renderEvent@before", self.player, self)
end

---添加渲染逻辑事件（后）
---@param eventName string @事件名
---@param eventLevel number @事件优先度
---@param eventFunc function @事件函数
---@return boolean @是否发生覆盖
function system:addRenderAfterEvent(eventName, eventLevel, eventFunc)
    return self.listener:addEvent("renderEvent@after", eventName, eventLevel, eventFunc)
end

---移除渲染逻辑事件（后）
---@param eventName string @事件名
function system:removeRenderAfterEvent(eventName)
    self.listener:remove("renderEvent@after", eventName)
end

---执行渲染逻辑事件（后）
function system:doRenderAfterEvent()
    self.listener:Do("renderEvent@after", self.player, self)
end

---添加碰撞逻辑事件（前）
---@param eventName string @事件名
---@param eventLevel number @事件优先度
---@param eventFunc function @事件函数
---@return boolean @是否发生覆盖
function system:addColliBeforeEvent(eventName, eventLevel, eventFunc)
    return self.listener:addEvent("colliEvent@before", eventName, eventLevel, eventFunc)
end

---移除碰撞逻辑事件（前）
---@param eventName string @事件名
function system:removeColliBeforeEvent(eventName)
    self.listener:remove("colliEvent@before", eventName)
end

---执行碰撞逻辑事件（前）
function system:doColliBeforeEvent(other)
    self.listener:Do("colliEvent@before", self.player, self, other)
end

---添加碰撞逻辑事件（后）
---@param eventName string @事件名
---@param eventLevel number @事件优先度
---@param eventFunc function @事件函数
---@return boolean @是否发生覆盖
function system:addColliAfterEvent(eventName, eventLevel, eventFunc)
    return self.listener:addEvent("colliEvent@after", eventName, eventLevel, eventFunc)
end

---移除碰撞逻辑事件（后）
---@param eventName string @事件名
function system:removeColliAfterEvent(eventName)
    self.listener:remove("colliEvent@after", eventName)
end

---执行碰撞逻辑事件（后）
function system:doColliAfterEvent(other)
    self.listener:Do("colliEvent@after", self.player, self, other)
end
