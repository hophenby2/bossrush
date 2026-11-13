--祈华梦六面道中部分
s6_road = {}
-------------------------------------
local path = "EISlib/stage/stage6/"
Include(path .. "s6_boss_defined.lua")
--资源加载
path = "res/stage/stage6/s6title/"
local function load_res()
    LoadImageFromFile("s6_t1", path .. "s6_t1.png")
    LoadImageFromFile("s6_t2", path .. "s6_t2.png")
    LoadImageFromFile("s6_t3", path .. "s6_t3.png")
end
load_res()
----------------------------------标题
local function s6_mid_dialog()
    -- 总时长360F
    New(tasker, function(self)
        player.dialog = true
        local subscene = dialog.reader.matchScene("LastStage_mid")
        if subscene then
            task.New(self, function()
                for _, t in ipairs(subscene.action) do
                    if t.type == dialog.actype.sentence then
                        local dlg = dialog.player.box.create(0, 140, "rect", "normal", "left", { 230,221,215 }, t.dialog_text, {}, 0, 0)
                        dlg.scrmode = false -- 在world里面绘制
                        dlg.scale = 1.2
                        task.Wait(120)
                        dlg.clear = true
                    end
                end
            end)
        end
        task.Wait(300)
        PlaySound("enep01")
        misc.ShakeScreen(60, 4)
        task.Wait(60)
        player.dialog = false
        task.Wait(10) -- wait
    end)
end

local s6_title
do
    local size, t0, t1, t2 = 0.8, 90, 60, 60
    local s6_t1 = Class(object)
    function s6_t1:init(x, y)
        self.x, self.y = x, y
        self.img = "s6_t1"
        self.hscale, self.vscale = size, size
        _object.set_color(self, "", 0, 0, 0, 0)
        task.New(self, function()
            local d_a = 255/t0
            for _ = 1, t0 do
                self._a = self._a + d_a
                self._r, self._g, self._b = self._r + d_a, self._g + d_a, self._b + d_a
                task.Wait(1)
            end
            task.Wait(t1)
            d_a = -255/t2
            for _ = 1, t2 do
                self._a = self._a + d_a
                task.Wait(1)
            end
            Del(self)
        end)
    end
    function s6_t1:frame()
        task.Do(self)
    end
    function s6_t1:render()
        SetImgState(self, "", self._a, self._r, self._g, self._b)
        Render(self.img, self.x, self.y, 0, self.hscale, self.vscale)
    end
    local s6_t2 = Class(object)
    function s6_t2:init(x, y)
        self.x, self.y = x, y
        self.img = "s6_t2"
        self.hscale, self.vscale = size, size
        _object.set_color(self, "", 0, 255, 255, 255)
        task.New(self, function()
            local d_a = 255/t0
            for _ = 1, t0 do
                self._a = self._a + d_a
                task.Wait(1)
            end
            task.Wait(t1)
            d_a = -255/t2
            for _ = 1, t2 do
                self._a = self._a + d_a
                task.Wait(1)
            end
            Del(self)
        end)
    end
    function s6_t2:frame()
        task.Do(self)
    end
    function s6_t2:render()
        SetImgState(self, "", self._a, self._r, self._g, self._b)
        Render(self.img, self.x, self.y, 0, self.hscale, self.vscale)
    end
    local s6_t3 = Class(object)
    function s6_t3:init(x, y)
        self.x, self.y = x, y
        self.img = "s6_t3"
        self.hscale, self.vscale = size, size
        _object.set_color(self, "", 0, 255, 255, 255)
        task.New(self, function()
            local d_a = 255/t0
            for _ = 1, t0 do
                self._a = self._a + d_a
                task.Wait(1)
            end
            task.Wait(t1)
            d_a = -255/t2
            for _ = 1, t2 do
                self._a = self._a + d_a
                task.Wait(1)
            end
            Del(self)
        end)
    end
    function s6_t3:frame()
        task.Do(self)
    end
    function s6_t3:render()
        SetImgState(self, "", self._a, self._r, self._g, self._b)
        Render(self.img, self.x, self.y, 0, self.hscale, self.vscale)
    end
    function s6_title()
        local x, y = 0, 100
        New(s6_t3, x, y)
        New(s6_t1, x + 50*size, y + size)
        New(s6_t2, x + 130*size, y - 60*size)
    end
end

----------------------------------不能访问的函数的定义-------------------------------------
--设置线性减伤
local function decDmg(self, t1, t2, d0, d1)
    --设置线性减伤时间
    d0 = d0 or self.dmgrate
    d1 = d1 or 1
    self.dmgrate = d0
    t1 = t1 or 180
    t2 = t2 or 60
    task.New(self, function()
        task.Wait(t1)
        local d = (d1 - d0) / t2
        for _ = 1, t2 do
            self.dmgrate = self.dmgrate + d
            task.Wait(1)
        end
        self.dmgrate = d1 --强制设置一下，以防浮点数的极小误差
    end)
end
--增加染色圈范围
local function addDyeRange(self, dr, t)
    dr = dr/t
    task.New(self, function()
        for _ = 1, t do
            self.dye_range = self.dye_range + dr
            task.Wait(1)
        end
    end)
end
----------------------------------移动定义-------------------------------------

----------------------------------特殊的弹幕定义-------------------------------------
--藏妖精的大花
local b1, b2
do
    --藏着小妖精的樱花弹幕
    local ex = Class(bullet)
    function ex:init(x, y, a, mst, da, t)
        t = t or 120
        straight.init(self, arrow_big,4,true,x,y,0,a,2)
        self.group = GROUP_INDES
        self.bound = false
        self.layer = LAYER_ENEMY_BULLET-1
        self.hscale, self.vscale = 1, 1
        self._a = 255
        self.timer = 11
        task.New(self, function ()
            while IsValid(mst) and not mst.spawn do
                self.x, self.y = mst.x + 12.5*cos(self.rot), mst.y + 10*sin(self.rot)
                task.Wait(1)
            end
            if not IsValid(mst) then
                Del(self)
            end
            if self.y < -224 then Del(self) end
            self.omiga = 0
            self.bound = true
            self.navi = true
            self.group = GROUP_ENEMY_BULLET
            --散开之后变化
            egg.AddSimStrChV(self, 0, 0.5, self.rot, t)
            task.Wait(t)
            egg.AddSimStrChV(self, 0, 1.5, self.rot, 150)
            task.Wait(30)
            egg.AddSimStrChV(self, 0, -1, self.rot + da or 0, 120)
        end)
    end
    function ex:render()
        SetImgState(self, "", self._a, 255, 255, 255)
        Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
    end
    b1 = Class(bullet)
    function b1:init(x, y, mst, dt)
        straight.init(self, star_small, 3, true, mst.x + x, mst.y + y, 0, 0)
        self.omiga = 1
        self.group = GROUP_INDES
        self.hscale, self.vscale = 1.5, 1.5
        self.a, self.b = 6, 6
        self._a = 255
        self.timer = 11
        self.spawn = false
        do--创建绑定的花瓣对象
            local diff = difficulty
            if diff == 4 then
                local a = 36
                local da = -15
                for _ = 1, 5 do
                    da = -60
                    for _ = 1, 2 do
                        for i = 1, 4 do
                            New(ex, self.x, self.y, a, self, da, 30*i)
                        end
                        da = da + 120
                    end
                    a = a + 72
                end
            elseif  diff == 3 then
                local a = 0
                for _ = 1, 6 do
                    for i = 2, 4 do
                        New(ex, self.x, self.y, a, self, 0, 30*i)
                    end
                    a = a + 60
                end
            elseif  diff == 2 then
                local a = 36
                for _ = 1, 5 do
                    for i = 3, 4 do
                        New(ex, self.x, self.y, a, self, 0, 30*i)
                    end
                    a = a + 72
                end
            else
                local a = 0
                for _ = 1, 4 do
                    New(ex, self.x, self.y, a, self, 0, 120)
                    a = a + 90
                end
            end
        end
        task.New(self, function ()
            while IsValid(mst) and not mst.release do
                self.x, self.y = mst.x + x, mst.y + y
                task.Wait(1)
            end
            egg.AddSimStrChV(self, 0, 2, -90, 60)
            --[[while Dist(self, player) > 80 do
                task.Wait(1)
            end]]
            task.Wait(60 + dt)
            self.spawn = true
            b1.spawnFairy(self)
            self.group = GROUP_ENEMY_BULLET
            egg.AddSimStrChV(self, 0, 2, 90, 60)
            task.Wait(20)
            egg.AddSimStrChV(self, 0, 1.5, Angle(self, player), 30)
        end)
    end
    function b1:render()
        SetImgState(self, "", self._a, 255, 255, 255)
        Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
    end
    b2 = Class(bullet)
    function b2:init(x, y)
        straight.init(self, star_small, 3, true, x, y, 0, 0)
        self.omiga = 0
        self.group = GROUP_ENEMY_BULLET
        self.hscale, self.vscale = 1.5, 1.5
        self.a, self.b = 4, 4
        self._a = 255
        self.timer = 11
        self.spawn = false
        do--创建绑定的花瓣对象
            local diff = difficulty
            if diff == 4 then
                local a = 36
                local da = -15
                for _ = 1, 5 do
                    da = -60
                    for _ = 1, 2 do
                        New(ex, self.x, self.y, a, self, da).group = GROUP_ENEMY_BULLET
                        da = da + 120
                    end
                    a = a + 72
                end
            elseif  diff == 3 then
                local a = 0
                for _ = 1, 6 do
                    New(ex, self.x, self.y, a, self, 0).group = GROUP_ENEMY_BULLET
                    a = a + 60
                end
            elseif  diff == 2 then
                local a = 36
                for _ = 1, 5 do
                    New(ex, self.x, self.y, a, self, 0).group = GROUP_ENEMY_BULLET
                    a = a + 72
                end
            else
                local a = 0
                for _ = 1, 4 do
                    New(ex, self.x, self.y, a, self, 0).group = GROUP_ENEMY_BULLET
                    a = a + 90
                end
            end
        end
        task.New(self, function ()
            self.layer = LAYER_ENEMY_BULLET-1
            local vx, vy = ran:Float(-1, 1), ran:Float(1.75, 2.25)
            egg.AddSimStrChV(self, 0, vy, -90, 60)
            egg.AddSimStrChV(self, 0, vx, 0, 60, 60)
            --[[while Dist(self, player) > 30 do
                task.Wait(1)
            end
            egg.AddSimStrChV(self, 0, -vy, -90, 30)
            egg.AddSimStrChV(self, 0, -vx, 0, 30)
            self.spawn = true
            egg.AddAccDecChV(self, 2, 90, 10, 10, 10)
            task.Wait(30)
            egg.AddSimStrChO(self, 0, 1, 30)
            egg.AddSimStrChV(self, 0, 1.5, Angle(self, player), 30)]]
        end)
    end
    function b2:render()
        SetImgState(self, "", self._a, 255, 255, 255)
        Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
    end
end
---------------------------------攻击方式定义-------------------------------------

----------------------------------状态改变定义-------------------------------------
--设置染色圈范围线性变化
local function dyeRangeCh(self, r1, t)
    local dr = (r1 - self.dye_range)/t
    task.New(self, function()
        for _ = 1, t do
            self.dye_range = self.dye_range + dr
            task.Wait(1)
        end
    end)
end
--生成常用加速弹
local function accbullet(st, co, x, y, v, a, t)
    local obj = stg.newBulletStraight(st, co, true, x, y, 0, a)
    egg.AddSimStrChV(obj, 0, v, a, t)
    return obj
end
--设置出屏等待
local function boundWait(self, t)
    self.bound = false
    t = t or 90
    --出屏
    task.New(self, function()
        task.Wait(t)
        self.bound = true
    end)
end
--清除弹幕和小怪
local function clearEnemyAndBullet()
    New(tasker, function()
        for _ = 1, 10 do
            for _, unit in ObjList(GROUP_NONTJT) do
                Del(unit)
            end
            for _, unit in ObjList(GROUP_ENEMY_BULLET) do
                _del(unit, true)
            end
            task.Wait(1)
        end
    end)
end
----------------------------------死尸弹定义-------------------------------------

----------------------------------obj定义--------------------------------------------
--中间爆菊大怪的危险警告
local danger_eff = Class(object)
function danger_eff:init(x, y)
    self.x, self.y = x, y
    self.group = GROUP_GHOST
    self.img = "danger_eff"
    self.hscale, self.vscale = 3, 3
    self.rot = 0
    _object.set_color(self, "", 0, 255, 255, 255)
    egg.SimAlpCh(self, 0, 255, 30)
    egg.SimSizeCh(self, 3, 1, 45)
    task.New(self, function()
        for x = 0, 90, 2 do
            self.rot = 180*cos(x)
            task.Wait(1)
        end
        task.Wait(30)
        egg.SimAlpCh(self, 255, 0, 45)
        egg.SimSizeCh(self, 1, 0, 45)
        task.Wait(45)
        Del(self)
    end)
end
function danger_eff:frame()
    task.Do(self)
end
function danger_eff:render()
    SetImgState(self, "", self._a, 255, 255, 255)
    Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end
----------------------------------小怪、衍生定义-------------------------------------

local e1, e1_1, ls, ls_mst
do
    local function IsBound(self)
        if self.x > -192 and self.x < 192 and self.y < 224 and self.y > -224 then
            return true
        else
            return false
        end
    end
    local function IsBound2(self)
        if self.x > -224 and self.x < 224 and self.y < 224 then
            return true
        else
            return false
        end
    end

    local x0, y0 = 0, 30
    local r0, dr0, ddr0 = 350, -2*100/180, 200/360/180
    local da0 = -0.6
    local rate = {0.9, 0.5, 0.3, -0.8, -1}

    --六开幕激光
    ls = Class(laser)
    function ls:init(mst1, mst2)
        laser.init(self, COLOR_BLUE, 400, 400, 0, 6, 0, 6, 6, 6, 0)
        self.bound = false
        self.mst1, self.mst2 = mst1, mst2
        self.layer = LAYER_ENEMY-1
        laser.ChangeImage(self, 1, orginal)
        task.New(self, function()
            laser._TurnOn(self, 30, false, true)
            while IsValid(mst1) and IsValid(mst2) do
                task.Wait(1)
            end
            PlaySound("kira00", 0.5, 0, false)
            local n = int(self.l2 / 8)
            local sp = 360
            local dsp = sp/(n-1)
            local a0, d, dx, dy, _x, _y, obj = self.rot + 90 - sp*0.5*(n-1), 0, cos(self.rot), sin(self.rot)
            for _ = 1, n do
                _x, _y = self.x + d * dx, self.y + d * dy
                a0 = Angle(_x, _y, player.x, player.y)
                if Dist(self, player) > 50 then
                    for i = -1, 1, 2 do
                        obj = stg.newBulletStraight(stg.arrow_small, 6, true, _x, _y, 0, a0 + 90*i)
                        egg.AddSimStrChV(obj, 3, 2, a0 + 90*i, 60)
                        --obj.omiga = 3
                        _object.set_color(obj, "", 255, 255, 255, 255)
                    end
                end
                d = d + 8
                a0 = a0 + dsp
            end
            Del(self)
        end)
    end
    function ls:frame()
        self.class.base.frame(self)
        --_object.set_color(self, "", 255, 255, 255 - 100 * self.killing / 30, 255 - 100 * self.killing / 30)
        if IsValid(self.mst1) and IsValid(self.mst2) then
            self.x, self.y = self.mst1.x, self.mst1.y
            self.rot = Angle(self.mst1, self.mst2)
            self.l2 = max(0, Dist(self.mst1, self.mst2) - 12)
        end
    end
    --六开幕激光主人
    ls_mst = Class(object)
    function ls_mst:init(a, u, IsAtk)
        self.x, self.y = 400, 400
        self.bound = false
        self.group = GROUP_INDES
        self.colli = false
        --创建绑定阴阳玉
        self.child = New(e1, a, u, self, IsAtk)
        --简单移动
        task.New(self, function()
            local r, dr, ddr = r0, dr0, ddr0
            local da = da0*u
            for _ = 1, 180 do
                a = a + da
                self.x, self.y = x0 + r*cos(a), y0 + r*sin(a)
                task.Wait(1)
            end
            for i = 1, 5 do
                dr, ddr = rate[i]*dr0, rate[i]*ddr0
                for _ = 1, 180 do
                    dr = dr + ddr
                    r = r + dr
                    a = a + da
                    self.x, self.y = x0 + r*cos(a), y0 + r*sin(a)
                    task.Wait(1)
                end
                for _ = 1, 180 do
                    a = a + da
                    self.x, self.y = x0 + r*cos(a), y0 + r*sin(a)
                    task.Wait(1)
                end
            end
            self.bound = true
        end)
    end
    function ls_mst:frame()
        task.Do(self)
    end


    --旋转阴阳玉
    e1 = Class(enemy)
    function e1:init(a, u, mst, IsAtk)
        self.x, self.y = 400, 400
        enemy.init(self, 33, 15,false,false,true, true, 2, 32, 1)
        --跟随
        task.New(self, function()
            while true do
                if IsValid(mst) then
                    self.x, self.y = mst.x, mst.y
                else
                    Del(self)
                end
                task.Wait(1)
            end
        end)
        --攻击
        task.New(self, function()
            local diff = difficulty
            if diff == 4 then
                if IsAtk then
                    task.Wait(240)
                    local a0, da, a1 = 90*u, (-2 + da0)*u
                    while true do
                        for _ = 1, 4 do
                            for i = -1, 1 do
                                a1 = a + a0 + 15*i
                                if Dist(self, player) > 32 then
                                    stg.newBulletStraight(stg.arrow_big, 6, true, self.x + 16*cos(a1), self.y + 16*sin(a1), 1.5, a1)
                                end
                            end
                            task.Wait(8)
                            a0 = a0 + da
                        end
                        --[[for _ = 1, 3 do
                            task.Wait(5)
                            a0 = a0 + da
                        end]]
                        --PlaySound("tan00")
                    end
                end
            elseif  diff == 3 then
                task.Wait(240)
                local a0, da = 180, (-3 + da0)*u
                while true do
                    for _ = 1, 4 do
                        if Dist(self, player) > 32 then
                            stg.newBulletStraight(stg.arrow_big, 6, true, self.x, self.y, 1, a + a0)
                        end
                        task.Wait(5)
                        a0 = a0 + da
                    end
                    for _ = 1, 2 do
                        task.Wait(5)
                        a0 = a0 + da
                    end
                    --PlaySound("tan00")
                end
            elseif  diff == 2 then
                if IsAtk then
                    task.Wait(240)
                    local a0, da = 180, (-3 + da0)*u
                    while true do
                        for _ = 1, 4 do
                            if Dist(self, player) > 32 then
                                stg.newBulletStraight(stg.arrow_big, 6, true, self.x, self.y, 0.75, a + a0)
                            end
                            task.Wait(5)
                            a0 = a0 + da
                        end
                        for _ = 1, 3 do
                            task.Wait(5)
                            a0 = a0 + da
                        end
                        --PlaySound("tan00")
                    end
                end
            end
        end)
    end
    function e1:frame()
        enemy.frame(self)
        --放雷时高防
        if player.nextspell > 10 then
            self.dmgrate = 0.005
        else
            self.dmgrate = 1
        end
    end
    --重置旋转中心
    function e1.reFreshCenter()
        x0, y0 = 0, 0
    end
    --改变旋转中心
    function e1.updateCenter(dy)
        y0 = y0 + dy
    end

    --鬼火死尸弹惩罚
    local function death(x, y)
        local diff = difficulty
        if diff == 4 then
            New(tasker, function()
                local dx, dy, a, obj
                for _ = 1, 10 do
                    dx, dy = x + ran:Float(-5, 5), y + ran:Float(-5, 5)
                    a = Angle(dx, dy, player.x, player.y) + ran:Float(-10, 10)
                    if Dist(dx, dy, player.x, player.y) > 30 then
                        obj = stg.newBulletStraight(stg.arrow_small, 1, true, dx, dy, 0, a)
                        egg.AddSimStrChV(obj, 0, 3, a, 20)
                        PlaySound("tan00")
                    end
                    task.Wait(5)
                end
            end)
        elseif  diff == 3 then
            New(tasker, function()
                local dx, dy, a, obj
                for _ = 1, 6 do
                    dx, dy = x + ran:Float(-5, 5), y + ran:Float(-5, 5)
                    a = Angle(dx, dy, player.x, player.y)
                    if Dist(dx, dy, player.x, player.y) > 30 then
                        obj = stg.newBulletStraight(stg.arrow_small, 1, true, dx, dy, 0, a)
                        egg.AddSimStrChV(obj, 0, 2.5, a, 60)
                        PlaySound("tan00")
                    end
                    task.Wait(5)
                end
            end)
        elseif  diff == 2 then
            --[[New(tasker, function()
                local dx, dy, a, obj
                for _ = 1, 4 do
                    dx, dy = x + ran:Float(-5, 5), y + ran:Float(-5, 5)
                    a = Angle(dx, dy, player.x, player.y)
                    if Dist(dx, dy, player.x, player.y) > 30 then
                        obj = stg.newBulletStraight(stg.arrow_small, 1, true, dx, dy, 0, a)
                        egg.AddSimStrChV(obj, 0, 1.5, a, 60)
                        PlaySound("tan00")
                    end
                    task.Wait(5)
                end
            end)]]
        end
    end
    --旋转鬼火
    e1_1 = Class(enemy)
    function e1_1:init(a, x, a1, u, mst, way)
        enemy.init(self,20, 10,false,false,true, nil, 3, 0, 1)
        task.New(self, function()
            local r, dr, ddr = r0, dr0, ddr0
            local da = -da0*u
            --三个为一组的小圆
            local r1, da1 = 10, -1*u
            local dx = way*da0*u
            x = x*u
            --超过时间了就离场，mst为关卡组本身
            task.New(self, function()
                --先检测是否入场
                while not IsBound(self) do
                    task.Wait(1)
                end
                local t = 0
                while mst.timer < 3120 do
                    --在离场时间到之前就离场就会发射死尸弹
                    if t > 300 and not IsBound2(self) and difficulty > 2 then
                        death(self.x, self.y)
                        Del(self)
                    end
                    task.Wait(1)
                    t = t + 1
                end
                while true do
                    dr = dr + 0.005
                    r = r + dr
                    task.Wait(1)
                end
            end)
            for _ = 1, 180 do
                a = a + da
                a1 = a1 + da1
                x = x + dx
                self.x, self.y = x0 + r*cos(a) + sin(x)*r1*cos(a1), y0 + r*sin(a) + sin(x)*r1*sin(a1)
                task.Wait(1)
            end
            for i = 1, 5 do
                dr, ddr = rate[i]*dr0, rate[i]*ddr0
                for _ = 1, 180 do
                    dr = dr + ddr
                    r = r + dr
                    a = a + da
                    a1 = a1 + da1
                    x = x + dx
                    self.x, self.y = x0 + r*cos(a) + sin(x)*r1*cos(a1), y0 + r*sin(a) + sin(x)*r1*sin(a1)
                    task.Wait(1)
                end
                for _ = 1, 180 do
                    a = a + da
                    a1 = a1 + da1
                    x = x + dx
                    self.x, self.y = x0 + r*cos(a) + sin(x)*r1*cos(a1), y0 + r*sin(a) + sin(x)*r1*sin(a1)
                    task.Wait(1)
                end
            end
        end)
    end
    function e1_1:frame()
        enemy.frame(self)
        --放雷时高防
        if player.nextspell > 10 then
            self.dmgrate = 0.005
        else
            self.dmgrate = 1
        end
    end
    function e1_1:kill()
        enemy.kill(self)
        if not (self.sys_co==1 or self.sys_co==2) and Dist(self, player) > 30 then
            death(self.x, self.y)
        end
    end
end
local e2, e2_1
do
    --迎接客人的小花
    local f1, f1_1, f2
    do
        --扔出去弹幕的统一运动方式
        local function move(obj, a)
            obj.bound = false
            task.New(obj, function()
                egg.AddSimStrChV(obj, ran:Float(2, 7.5), 1, a, 150)
                egg.AddSimStrChV(obj, 0, 4, -90, 240)
                task.Wait(180)
                obj.bound = true
            end)
        end
        function f1(x, y, a)
            local obj = stg.newBulletStraight(stg.ball_small, 3, true, x, y, 0, 0)
            for i = 1, 6 do
                f1_1(obj, 60*i)
            end
            move(obj, a)
        end
        function f1_1(mst, a)
            local dx, dy = 6*cos(a), 6*sin(a)
            local obj = stg.newBulletStraight(stg.grain_a, 3, true, mst.x + dx, mst.y + dy, 0, a)
            obj.hscale, obj.vscale = 0.75, 0.9
            obj.bound = false
            task.New(obj, function()
                while IsValid(mst) do
                    obj.x, obj.y = mst.x + dx, mst.y + dy
                    task.Wait(1)
                end
                Del(obj)
            end)
        end
        --简单子弹
        function f2(x, y, a, st)
            local obj = stg.newBulletStraight(st, 3, true, x, y, 0, 0)
            move(obj, a)
        end
    end
    --撒花啦~
    local function atk(self, a)
        task.New(self, function()
            local diff = difficulty
            if diff == 4 then
                task.Wait(75)
                local x, y = self.x, self.y
                local a0
                for _ = 1, 8 do
                    a0 = a + ran:Float(-30, 30)
                    f1(x, y, a0)
                    for _ = 1, 3 do
                        a0 = a + ran:Float(-30, 30)
                        f2(x, y, a0, stg.ball_mid)
                        a0 = a + ran:Float(-30, 30)
                        f2(x, y, a0, stg.ball_mid_c)
                    end
                end
            elseif  diff == 3 then
                task.Wait(85)
                local x, y = self.x, self.y
                local a0
                for _ = 1, 5 do
                    a0 = a + ran:Float(-30, 30)
                    f1(x, y, a0)
                    for _ = 1, 2 do
                        a0 = a + ran:Float(-30, 30)
                        f2(x, y, a0, stg.ball_mid)
                        a0 = a + ran:Float(-30, 30)
                        f2(x, y, a0, stg.ball_mid_c)
                    end
                end
            elseif  diff == 2 then
                task.Wait(95)
                local x, y = self.x, self.y
                local a0
                for _ = 1, 3 do
                    a0 = a + ran:Float(-30, 30)
                    f1(x, y, a0)
                    for _ = 1, 2 do
                        a0 = a + ran:Float(-30, 30)
                        f2(x, y, a0, stg.ball_mid)
                        a0 = a + ran:Float(-30, 30)
                        f2(x, y, a0, stg.ball_mid_c)
                    end
                end
            else
                task.Wait(105)
                local x, y = self.x, self.y
                local a0
                for _ = 1, 2 do
                    a0 = a + ran:Float(-30, 30)
                    f1(x, y, a0)
                    a0 = a + ran:Float(-30, 30)
                    f2(x, y, a0, stg.ball_mid)
                    a0 = a + ran:Float(-30, 30)
                    f2(x, y, a0, stg.ball_mid_c)
                end
            end
        end)
    end
    --鬼火攻击
    local function atk2(self)
        task.New(self, function()
            task.Wait(75)
            local diff = difficulty
            if diff == 4 then
                task.Wait(30)
                local a
                for _ = 1, 4 do
                    a = Angle(self, player)
                    for i = -2, 2 do
                        for j = 0, 1 do
                            accbullet(stg.arrow_big, 10, self.x, self.y, 1 + 0.5*j, a + 45*i, 60)
                        end
                    end
                    task.Wait(30)
                    PlaySound("tan00")
                end
            elseif diff == 3 then
                task.Wait(40)
                local a
                for _ = 1, 4 do
                    a = Angle(self, player)
                    for i = -2, 2 do
                        for j = 0, 0 do
                            accbullet(stg.arrow_big, 10, self.x, self.y, 1 + 0.5*j, a + 45*i, 60)
                        end
                    end
                    task.Wait(30)
                    PlaySound("tan00")
                end
            elseif diff == 2 then
                task.Wait(50)
                local a
                for _ = 1, 4 do
                    a = Angle(self, player)
                    for i = -1, 1 do
                        for j = 0, 0 do
                            accbullet(stg.arrow_big, 10, self.x, self.y, 1 + 0.5*j, a + 45*i, 60)
                        end
                    end
                    task.Wait(30)
                    PlaySound("tan00")
                end
            else
                task.Wait(60)
                local a
                for _ = 1, 2 do
                    a = Angle(self, player)
                    for i = 0, 0 do
                        for j = 0, 0 do
                            accbullet(stg.arrow_big, 10, self.x, self.y, 1 + 0.5*j, a + 45*i, 60)
                        end
                    end
                    task.Wait(30)
                    PlaySound("tan00")
                end
            end
        end)
    end
    --迎客大蝴蝶
    e2 = Class(enemy)
    function e2:init(x, y, co, u)
        self.x, self.y = x, y
        enemy.init(self,28 + (co or 4), 30,false,false,true, true, co, 25, 1)
        decDmg(self, 60, 60, 0.1, 1)
        for i = 1, 3 do
            atk2(New(e2_1, self, 120*i, u))
        end
        --移动
        task.New(self, function()
            egg.AddAccDecChV(self, 2, 90 - 90*u, 30, 15, 30)
            task.Wait(75)
            egg.AddSimStrChV(self, 0, 2, -90 + 90*u, 30)
            dyeRangeCh(self, 80, 60)
        end)
        atk(self, 90 - 35*u)
        boundWait(self, 300)
    end
    --工具人鬼火
    e2_1 = Class(enemy)
    function e2_1:init(mst, a, u)
        enemy.init(self, 20, 10,false,false,true, nil, 3, 0, 1)
        --self.hscale, self.vscale = 0.75, 0.75
        self.a, self.b = self.a*self.hscale, self.b*self.vscale
        self.x, self.y = mst.x, mst.y
        task.New(self, function()
            local r, dr, da = 0, 40/30, 2*u
            for _ = 1, 30 do
                r = r + dr
                a = a + da
                if IsValid(mst) then
                    self.x, self.y = mst.x + r*cos(a), mst.y + r*sin(a)
                else
                    Del(self)
                end
                task.Wait(1)
            end
            while IsValid(mst) do
                a = a + da
                self.x, self.y = mst.x + r*cos(a), mst.y + r*sin(a)
                task.Wait(1)
            end
            Del(self)
        end)
        --攻击
    end
end
local e3, e3_1
do
    --暴鸽鬼火攻击
    local function atk(self)
        task.New(self, function()
            task.Wait(75)
            local diff = difficulty
            if diff == 4 then
                task.Wait(45)
                local a
                for _ = 1, 2 do
                    a = Angle(self, player)
                    for i = 0, 23 do
                        for j = 0, 2 do
                            accbullet(stg.ball_mid_c, 9, self.x, self.y, 1 + 0.25*j, a + 15*i + 5*j, 120)
                        end
                    end
                    task.Wait(90)
                    PlaySound("tan00")
                end
            elseif diff == 3 then
                task.Wait(55)
                local a
                for _ = 1, 2 do
                    a = Angle(self, player)
                    for i = 0, 17 do
                        for j = 0, 1 do
                            accbullet(stg.ball_mid_c, 9, self.x, self.y, 1 + 0.25*j, a + 20*i + 10*j, 120)
                        end
                    end
                    task.Wait(90)
                    PlaySound("tan00")
                end
            elseif diff == 2 then
                task.Wait(65)
                local a
                for _ = 1, 2 do
                    a = Angle(self, player)
                    for i = 0, 11 do
                        for j = 0, 0 do
                            accbullet(stg.ball_mid_c, 9, self.x, self.y, 1 + 0.25*j, a + 30*i + 0*j, 120)
                        end
                    end
                    task.Wait(90)
                    PlaySound("tan00")
                end
            else
                task.Wait(75)
                local a
                for _ = 1, 1 do
                    a = Angle(self, player)
                    for i = 0, 7 do
                        for j = 0, 0 do
                            accbullet(stg.ball_mid_c, 9, self.x, self.y, 1 + 0.25*j, a + 45*i + 0*j, 120)
                        end
                    end
                    task.Wait(90)
                    PlaySound("tan00")
                end
            end
        end)
    end
    --暴鸽大蝴蝶（x
    e3 = Class(enemy)
    function e3:init(x, y, co, u, dx)
        self.x, self.y = x, y
        self.release = false
        enemy.init(self,28 + (co or 4), 30,false,false,true, true, 2, 25, 1)
        self.dmgrate = 0.1
        for i = 1, 3 do --2-1的工具凑数鬼火
            atk(New(e2_1, self, 120*i, u))
        end
        for i = 1, 4 do
            New(b1, 0, -10-20*i, self, 40 - 10*i)
        end
        egg.AddSimStrChV(self, 0, 1.25, 90 - 90*u, 30)
        task.New(self, function()
            --[[while abs(self.x - player.x) > 15 do
                task.Wait(1)
            end]]
            if u == 1 then
                while self.x < dx do
                    task.Wait(1)
                end
            else
                while self.x > dx do
                    task.Wait(1)
                end
            end
            decDmg(self, 60, 60, 0.1, 1)
            --减速(投放炸弹
            egg.AddSimStrChV(self, 0, -1.25, 90 - 90*u, 30)
            self.release = true
            task.Wait(30)
            --[[task.New(self, function()
                for _ = 1, 60 do
                    self.dye_range = self.dye_range + 0.5
                    task.Wait(1)
                end
            end)]]
            dyeRangeCh(self, 90, 60)
            --task.Wait(60)
            --然后加速溜
            egg.AddSimStrChV(self, 0, 1, -90, 30)
            self.bound = true
        end)
    end
    --花后面衍生的小妖精
    e3_1 = Class(enemy)
    function e3_1:init(x, y)
        self.x, self.y = x, y
        enemy.init(self,24 + 3, 10,false,true,true, nil, 3, 0, 1)
        self.hscale, self.vscale = 0, 0
        task.New(self, function()
            local ds = 1/10
            for _ = 1, 10 do
                self.hscale, self.vscale = self.hscale + ds, self.vscale + ds
                task.Wait(1)
            end
            egg.AddSimStrChV(self, 0, 0.75, 90, 60)
        end)
    end
    --花弹幕生成小妖精函数
    function b1:spawnFairy()
        New(e3_1, self.x, self.y)
    end
end
local e4, e4_1, e6, e7, e7_1
do
    local f1, f2, f3, f4
    do
        function f1(x, y, v0, v1, a)
            local obj = stg.newBulletStraight(stg.arrow_big, 10, true, x, y, 0, a, false)
            egg.AddSimStrChV(obj, v0, v1, a, 30)
        end
        function f2(x, y, v, a)
            local obj = stg.newBulletStraight(stg.ball_mid_c, 3, true, x, y, 0, a, false)
            egg.AddAccDecChV(obj, -2, a, 15, 15, 15)
            task.New(obj, function()
                task.Wait(30)
                PlaySound("kira00")
                egg.AddSimStrChV(obj, 0, v, a, 30)
            end)
        end
        --⑨的狙
        function f3(x, y, v, a)
            local obj = stg.newBulletStraight(stg.ball_mid, 5, true, x, y, 0, 0)
            egg.AddSimStrChV(obj, v, 0, a, 60)
            task.New(obj, function()
                task.Wait(60)
                PlaySound("kira00")
                egg.AddSimStrChV(obj, 0, v, Angle(obj, player), 60)
            end)
        end
        --简单的匀加速弹幕
        function f4(x, y, v, a)
            local obj = stg.newBulletStraight(stg.arrow_big, 6, true, x, y, 0, a)
            egg.AddSimStrChV(obj, 0, v, a, 60)
        end
    end
    local function atk(self, a)
        local diff = difficulty
        if diff == 4 then
            for i = 1, 6 do
                for j = -3, 3 do
                    f2(self.x, self.y, 2 + 0.2*abs(j), a + 60*i + 10*j)
                end
            end
        elseif diff == 3 then
            for i = 1, 6 do
                for j = -2, 2 do
                    f2(self.x, self.y, 1.75 + 0.2*abs(j), a + 60*i + 15*j)
                end
            end
        elseif diff == 2 then
            for i = 1, 5 do
                for j = -2, 2 do
                    f2(self.x, self.y, 1.5 + 0.2*abs(j), a + 72*i + 18*j)
                end
            end
        else
            for i = 1, 4 do
                for j = -2, 2 do
                    f2(self.x, self.y, 1.25 + 0.15*abs(j), a + 90*i + 22.5*j)
                end
            end
        end

    end
    --到处乱飞的大蝴蝶
    e4 = Class(enemy)
    function e4:init(x, y, co, u)
        self.x, self.y = x, y
        enemy.init(self,28 + (co or 4), 30, false,false,true, true, co, 0, 1)
        decDmg(self, 60, 90, 0.1, 1)
        dyeRangeCh(self, 60, 90)
        for i = 1, 3 do
            New(e4_1, self, 120*i, u)
        end
        egg.AddSimStrChV(self, 0, 2, -90, 30)
        --移动
        task.New(self, function()
            task.Wait(30)
            egg.AddSimStrChV(self, 0, max(3, min(8, 0.05*abs(player.x - self.x))), 90 - 90*sign(player.x - self.x), 240) --往自机方向飞
            self.bound = true
        end)
        --攻击
        task.New(self, function()
            local diff = difficulty
            if diff == 4 then
                task.Wait(30)
                for _ = 1, 3 do
                    atk(self, Angle(self, player))
                    task.Wait(30)
                end
            elseif diff == 3 then
                task.Wait(40)
                for _ = 1, 3 do
                    atk(self, Angle(self, player))
                    task.Wait(30)
                end
            elseif diff == 2 then
                task.Wait(50)
                for _ = 1, 2 do
                    atk(self, Angle(self, player))
                    task.Wait(30)
                end
            else
                task.Wait(60)
                for _ = 1, 1 do
                    atk(self, Angle(self, player))
                    task.Wait(30)
                end
            end
        end)
    end
    --鬼火
    e4_1 = Class(enemy)
    function e4_1:init(mst, a, u)
        enemy.init(self, 20, 10,false,false,true, nil, 3, 0, 1)
        --self.hscale, self.vscale = 0.75, 0.75
        --self.a, self.b = self.a*self.hscale, self.b*self.vscale
        self.x, self.y = mst.x, mst.y
        task.New(self, function()
            local r, dr, da = 0, 40/30, 2*u
            for _ = 1, 30 do
                if IsValid(mst) then
                    self.x, self.y = mst.x + r*cos(a), mst.y + r*sin(a)
                else
                    Del(self)
                end
                r = r + dr
                a = a + da

                task.Wait(1)
            end
            while IsValid(mst) do
                a = a + da
                self.x, self.y = mst.x + r*cos(a), mst.y + r*sin(a)
                task.Wait(1)
            end
            Del(self)
        end)
        --攻击
        task.New(self, function()
            local diff = difficulty
            if diff == 4 then
                task.Wait(30)
                for _ = 1, 6 do
                    for i = 0, 4 do
                        --f1(self.x, self.y, 3, 1.5, a)
                        for j = 0, 1 do
                            accbullet(stg.arrow_big, 10, self.x, self.y, 0.8 + 0.1*i + 0.5*j, a, 60)
                        end
                        task.Wait(2)
                    end
                    task.Wait(30)
                end
            elseif  diff == 3 then
                task.Wait(40)
                for _ = 1, 6 do
                    for i = 0, 3 do
                        for j = 0, 1 do
                            accbullet(stg.arrow_big, 10, self.x, self.y, 0.8 + 0.1*i + 0.1*j, a, 60)
                        end
                        task.Wait(2)
                    end
                    task.Wait(30)
                end
            elseif  diff == 2 then
                task.Wait(50)
                for _ = 1, 6 do
                    for i = 0, 3 do
                        for j = 0, 0 do
                            accbullet(stg.arrow_big, 10, self.x, self.y, 0.8 + 0.1*i + 0.1*j, a, 60)
                        end
                        task.Wait(3)
                    end
                    task.Wait(30)
                end
            else
                task.Wait(60)
                for _ = 1, 3 do
                    for i = 0, 2 do
                        for j = 0, 0 do
                            accbullet(stg.arrow_big, 10, self.x, self.y, 0.8 + 0.1*i + 0.1*j, a, 60)
                        end
                        task.Wait(5)
                    end
                    task.Wait(30)
                end
            end
        end)
    end


    --从下面上来的妖精
    e6 = Class(enemy)
    function e6:init(x, y)
        self.x, self.y = x, y
        enemy.init(self, 29, 20,false,false,true, true, 2, 0, 1)
        decDmg(self, 60, 60, 0.05, 1)
        dyeRangeCh(self, 60, 120) --染色圈扩大
        egg.AddSimStrChV(self, 0, 0.75, 90, 60)
        --攻击（上升到一定高度前往下攻击，达到时发射星形弹幕
        task.New(self, function()
            local diff = difficulty
            if diff == 4 then
                local k = 5
                while self.y < -50 do
                    for _ = 1, 3 do
                        for u = -1, 1, 2 do
                            f4(self.x, self.y, 2, -90 + k*u)
                        end
                        PlaySound("tan00")
                        task.Wait(3)
                        k = k + 2
                    end
                    task.Wait(15)
                    k = k + 12
                end
                for _ = 1, 3 do
                    atk(self, 0)
                    task.Wait(60)
                end
            elseif diff == 3 then
                local k = 5
                while self.y < 0 do
                    for _ = 1, 3 do
                        for u = -1, 1, 2 do
                            f4(self.x, self.y, 1.5, -90 + k*u)
                        end
                        PlaySound("tan00")
                        task.Wait(3)
                        k = k + 1
                    end
                    task.Wait(20)
                    k = k + 20
                end
                for _ = 1, 3 do
                    atk(self, 0)
                    task.Wait(60)
                end
            elseif diff == 2 then
                while self.y < 80 do
                    for _ = 1, 3 do
                        for u = -1, 1, 2 do
                            f4(self.x + 10*u, self.y, 1.5, -90)
                        end
                        PlaySound("tan00")
                        task.Wait(8)
                    end
                end
                for _ = 1, 3 do
                    atk(self, 0)
                    task.Wait(60)
                end
            end
        end)
    end
    --带鬼火的妖精
    --星型弹幕
    local function atk(self, a)
        local diff = difficulty
        if diff == 4 then
            for i = 1, 6 do
                for j = -3, 3 do
                    for k = 0, 2 do
                        f2(self.x, self.y, 1 + 0.5*k + 0.2*abs(j), a + 60*i + 10*j)
                    end
                end
            end
        elseif diff == 3 then
            for i = 1, 6 do
                for j = -2, 2 do
                    for k = 0, 1 do
                        f2(self.x, self.y, 1.25 + 0.5*k + 0.2*abs(j), a + 60*i + 15*j)
                    end
                end
            end
        elseif diff == 2 then
            for i = 1, 5 do
                for j = -2, 2 do
                    for k = 0, 1 do
                        f2(self.x, self.y, 1 + 0.5*k + 0.2*abs(j), a + 72*i + 18*j)
                    end
                end
            end
        else
            for i = 1, 4 do
                for j = -2, 2 do
                    f2(self.x, self.y, 1.25 + 0.15*abs(j), a + 90*i + 22.5*j)
                end
            end
        end

    end
    e7 = Class(enemy)
    function e7:init(x, y)
        self.x, self.y = x, y
        enemy.init(self,29, 30,false,false,true, true, 1, 70, 1)
        decDmg(self, 30, 60, 0.05, 1)
        egg.AddSimStrChV(self, 0, 0.75, -90, 60)
        --生成鬼火
        for i = 1, 9 do
            New(e7_1, self, 40*i)
        end
        --攻击（发射狙
        task.New(self, function()
            local diff = difficulty
            if diff == 4 then
                task.Wait(60)
                local a
                while self.y > 0 do
                    a = Angle(self, player)
                    atk(self, a)
                    task.Wait(30)
                end
            elseif diff == 3 then
                task.Wait(70)
                local a
                while self.y > 20 do
                    a = Angle(self, player)
                    atk(self, a)
                    task.Wait(40)
                end
            elseif diff == 2 then
                task.Wait(80)
                local a
                while self.y > 40 do
                    a = Angle(self, player)
                    atk(self, a)
                    task.Wait(50)
                end
            else
                task.Wait(90)
                local a
                while self.y > 75 do
                    a = Angle(self, player)
                    atk(self, a)
                    task.Wait(60)
                end
            end
        end)
    end
    --一团鬼火
    e7_1 = Class(enemy)
    function e7_1:init(mst, a)
        enemy.init(self,20, 10,false,false,true, nil, nil, 0, 1)
        self.bound = false
        self.x, self.y = mst.x, mst.y
        --移动
        task.New(self, function()
            local r, dr, dx, dy = 0, 60/60, cos(a), sin(a)
            for _ = 1, 60 do
                if IsValid(mst) then
                    r = r + dr
                    self.x, self.y = mst.x + r*dx, mst.y + r*dy
                else
                    break
                end
                task.Wait(1)
            end
            dx, dy = r*dx, r*dy
            --主人爆了就不跟随了，先内缩后散开
            while true do
                if IsValid(mst) then
                    self.x, self.y = mst.x + dx, mst.y + dy
                else
                    break
                end
                task.Wait(1)
            end
            --攻击
            task.New(self, function()
                local diff = difficulty
                if diff == 4 then
                    task.Wait(60)
                    while self.y > 0 do
                        if Dist(self, player) > 50 then
                            for i = 0, 2 do
                                f3(self.x, self.y, 1.25 + 0.25*i, 90)
                            end
                        end
                        task.Wait(10)
                    end
                elseif  diff == 3 then
                    task.Wait(70)
                    while self.y > 50 do
                        if Dist(self, player) > 50 then
                            for i = 0, 1 do
                                f3(self.x, self.y, 1.25 + 0.25*i, 90)
                            end
                        end
                        task.Wait(20)
                    end
                elseif  diff == 2 then
                    task.Wait(80)
                    while self.y > 50 do
                        if Dist(self, player) > 50 then
                            for i = 0, 0 do
                                f3(self.x, self.y, 1.25 + 0.25*i, 90)
                            end
                        end
                        task.Wait(30)
                    end
                else
                    task.Wait(90)
                    while self.y > 50 do
                        if Dist(self, player) > 50 then
                            f3(self.x, self.y, 1, a)
                        end
                        task.Wait(60)
                    end
                end
            end)
            egg.AddSimStrChV(self, 0, 1.5, a + 180, 240)
            egg.AddSimStrChV(self, 0, 1.5, -90, 60)
        end)
    end
    function e7_1:kill()
        enemy.kill(self)
        local diff = difficulty
        if diff == 4 then
            local x, y = self.x, self.y
            New(tasker, function()
                for _ = 1, 4 do
                    stg.newBulletStraight(stg.arrow_small, 10, true, x, y, 2.5, Angle(x, y, player.x, player.y))
                    task.Wait(10)
                end
            end)
        elseif  diff == 3 then
            local x, y = self.x, self.y
            New(tasker, function()
                for _ = 1, 3 do
                    stg.newBulletStraight(stg.arrow_small, 10, true, x, y, 2, Angle(x, y, player.x, player.y))
                    task.Wait(10)
                end
            end)
        elseif  diff == 2 then
            local x, y = self.x, self.y
            New(tasker, function()
                for _ = 1, 2 do
                    stg.newBulletStraight(stg.arrow_small, 10, true, x, y, 1.75, Angle(x, y, player.x, player.y))
                    task.Wait(10)
                end
            end)
        end
    end
    function e7_1:dyeKill()
        enemy.kill(self)
        _del(self, false)
    end
end
local e5, e5_1, e5_2
do
    local da = 3.5
    local f1, f2
    do
        function f1(x, y, v, a)
            local obj = stg.newBulletStraight(stg.arrow_big, 4, true, x, y, 0, a, false)
            egg.AddSimStrChV(obj, 0, v, a, 60)
        end
        function f2(x, y, v, a)
            local obj = stg.newBulletStraight(stg.ball_mid_c, 3, true, x, y, 0, a, false)
            egg.AddAccDecChV(obj, -2, a, 15, 15, 15)
            egg.AddSimStrChV(obj, 0, v, a, 30, 30)
        end
    end
    --若最中间的大怪被击破，就都溜了
    local function flee(self, a)
        egg.AddSimStrChV(self, 0, 2, a, 120)
    end
    --星型弹幕
    local function atk1(self, a)
        task.New(self, function()
            a = a or 0
            local diff = difficulty
            if diff == 4 then
                task.Wait(90)
                for _ = 1, 3 do
                    for i = 1, 6 do
                        for j = -6, 6 do
                            f2(self.x, self.y, 2 + 0.1*abs(j), a + 60*i + 5*j)
                        end
                    end
                    task.Wait(60)
                end
            elseif diff == 3 then
                task.Wait(110)
                for _ = 1, 2 do
                    for i = 1, 6 do
                        for j = -4, 4 do
                            f2(self.x, self.y, 1.75 + 0.2*abs(j), a + 60*i + 7.5*j)
                        end
                    end
                    task.Wait(75)
                end
            elseif diff == 2 then
                task.Wait(130)
                for _ = 1, 2 do
                    for i = 1, 5 do
                        for j = -3, 3 do
                            f2(self.x, self.y, 1.5 + 0.2*abs(j), a + 72*i + 12*j)
                        end
                    end
                    task.Wait(90)
                end
            else
                task.Wait(150)
                for i = 1, 4 do
                    for j = -2, 2 do
                        f2(self.x, self.y, 1.25 + 0.15*abs(j), a + 90*i + 22.5*j)
                    end
                end
            end
        end)
    end
    --超级巨大的蝴蝶
    e5 = Class(enemy)
    function e5:init(x, y, co, u)
        self.x, self.y = x, y
        enemy.init(self, 80, 60, false,false,true, true, co, 51, 1)
        --生成小怪
        do
            if co == 1 then
                co = 2
            elseif co == 2 then
                co = 1
            end
            local a
            for i = 1, 4 do
                a = 90*i
                New(e5_1, self, a, 80, u, co)
                for j = -2, 2 do
                    New(e5_2, self, a + 10*j, 50, u)
                end
            end
        end
        --移动
        task.New(self, function()
            egg.AddAccDecChV(self, 3, 90 - 80*u, 30, 50, 30)
            task.Wait(90)
            egg.AddSimStrChV(self, 0, 2, 90 - 90*u, 180)
            task.Wait(360)
            self.bound = true
        end)
    end
    --中阴阳玉
    e5_1 = Class(enemy)
    function e5_1:init(mst, a, r, u, co)
        self.x, self.y = mst.x + r*cos(a), mst.y + r*sin(a)
        self.mst = mst
        enemy.init(self,32 + (co or 4), 30,false,false,true, true, co, 60, 1)
        task.New(self, function()
            local da = da*u
            while IsValid(mst) do
                a = a + da
                self.x, self.y = mst.x + r*cos(a), mst.y + r*sin(a)
                task.Wait(1)
            end
            flee(self, a)
            self.bound = true
        end)
        atk1(self, a)
    end
    function e5_1:kill()
        enemy.kill(self)
        if IsValid(self.mst) then
            addDyeRange(self.mst, 17.5, 20)
        end
    end
    --鬼火
    e5_2 = Class(enemy)
    function e5_2:init(mst, a, r, u)
        self.x, self.y = mst.x + r*cos(a), mst.y + r*sin(a)
        enemy.init(self, 20, 10,false, false, true, nil, nil, 0, 1)
        --self.hscale, self.vscale = 0.75, 0.75
        --self.a, self.b = self.a*self.hscale, self.b*self.vscale
        --移动
        task.New(self, function()
            local da = da*u
            while IsValid(mst) do
                a = a + da
                self.x, self.y = mst.x + r*cos(a), mst.y + r*sin(a)
                task.Wait(1)
            end
            flee(self, a)
            self.bound = true
        end)
        --攻击
        task.New(self, function()
            local diff = difficulty
            if diff == 4 then
                task.Wait(30)
                while true do
                    f1(self.x, self.y, 2.5, a)
                    task.Wait(5)
                end
            elseif  diff == 3 then
                task.Wait(45)
                while true do
                    f1(self.x, self.y, 2.25, a)
                    task.Wait(8)
                end
            elseif  diff == 2 then
                task.Wait(60)
                while true do
                    f1(self.x, self.y, 2, a)
                    task.Wait(10)
                end
            else
                task.Wait(75)
                while true do
                    f1(self.x, self.y, 1.5, a)
                    task.Wait(15)
                end
            end
        end)
    end

end

----------------------------------道中本体-------------------------
local function road(self)
    --New(egg.updateFileObject, "EISlib/stage/stage6/s6_enemy.lua") --
    do
        New(stage6_background)
        system.setTargetChain(5201314) -- 999
        LoadMusicRecord("s6")
        LoadMusicRecord("s6_boss")
        dialog.cacheResource("LastStage")
    end
    EISlib.stage.playMusic("s6", 0, true)
    do
        e1.reFreshCenter()
        task.New(self, function()
            for _ = 1, 180 do
                e1.updateCenter(-0.2)
                task.Wait(1)
            end
        end)
        local a, da, u, num, IsAtk = 0, 60, -1, 5
        for k = 1, 6 do
            da = 360/int(num)
            if k % 2 == 1 then
                IsAtk = true
            else
                IsAtk = false
            end
            local ls_tb = {}
            for j = 1, int(num) do
                table.insert(ls_tb, New(ls_mst, a, u, IsAtk))
                --New(e1, a, j%2+1, u, self, IsAtk)
                a = a + da
                for i = 1, 3 do
                    New(e1_1, a + 0.5*da, 90, a + 120*i, u, self, int(num))
                end
            end
            --L难度奇数波生成激光
            if difficulty == 4 and not IsAtk then
                for i = 1, int(num) do
                    New(ls, ls_tb[(i)%int(num) + 1], ls_tb[(i+1)%int(num) + 1])
                end
            end
            --生成阴阳玉判断器
            New(tasker, function()
                local isAllClear = true
                while isAllClear do
                    isAllClear = false
                    for i = 1, #ls_tb do
                        if IsValid(ls_tb[i]) and IsValid(ls_tb[i].child) then
                            isAllClear = true
                            break
                        end
                    end
                    task.Wait(1)
                end
                --所有阴阳玉都不存在了，消除绑定者（同时消除激光）
                for i = 1, #ls_tb do
                    if IsValid(ls_tb[i]) then
                        Del(ls_tb[i])
                    end
                end
            end)
            task.Wait(390)
            u = -u
            num = num + 0.5
        end
    end
    while self.timer < 3120 - 390 do
        task.Wait(1)
    end
    local T = self.timer
    --到了游戏时间3120f
    do
        task.Wait(360)
        clearEnemyAndBullet()
        s6_mid_dialog()
        task.Wait(360) --这里是补充第一波阴阳玉的移除的时间
        --标题出现时间
        s6_title()
        task.Wait(240)
        --开始出怪
        local u = 1
        for i = 1, 8 do
            New(e2, -245*u, -50 + 30*i, i%2+1, u)
            task.Wait(40)
            u = -u
        end
        task.Wait(240)
        u = -u
        for _ = 1, 5 do
            New(e4, 150*u, 270, 1, u)
            task.Wait(45)
        end
        u = -u
        for _ = 1, 5 do
            New(e4, 150*u, 270, 2, u)
            task.Wait(45)
        end
        for i = 1, 5 do
            New(e4, 150*u, 270, i%2+1, u)
            task.Wait(30)
            u = -u
        end
    end

    do
        task.Wait(90)
        local u = 1
        for i = 0, 2 do
            New(e3, -224*u, 150, 2, u, -135 + 80*i)
            task.Wait(75)
        end
        task.Wait(90)
        u = -u
        for i = 0, 2 do
            New(e3, -224*u, 150, 2, u, 135 - 80*i)
            task.Wait(75)
        end
        task.Wait(30)
    end
    local T = self.timer --记得改完后删掉！！
    do
        --2600开始樱花雨
        local f1, f1_2, f1_1, f2, f2_1, f3
        local isnKill, obj
        do
            --单只增援计时器
            function isnKill(t)
                for _ = 1, t do
                    if not IsValid(obj) then
                        break
                    end
                    task.Wait(1)
                end
            end
            local function move(self)
                egg.AddSimStrChV(self, 0, ran:Float(1.75, 2.25), -90, 60)
                egg.AddSimStrChV(self, 0, ran:Float(-1, 1), 0, 60, 60)
            end
            --hl
            function f1(x, y)
                local obj = stg.newBulletStraight(stg.ball_small, 3, true, x, y, 0, 0)
                obj.layer = LAYER_ENEMY_BULLET + 1
                for i = 1, 6 do
                    f1_1(obj, 60*i)
                end
                move(obj)
            end
            --en
            function f1_2(x, y)
                local obj = stg.newBulletStraight(stg.ball_small, 3, true, x, y, 0, 0)
                obj.layer = LAYER_ENEMY_BULLET + 1
                for i = 1, 6 do
                    f1_1(obj, 60*i)
                end
                egg.AddSimStrChV(obj, 0, ran:Float(1, 2), -90 + ran:Float(-10, 10), 60)
            end
            function f1_1(mst, a)
                local dx, dy = 6*cos(a), 6*sin(a)
                local obj = stg.newBulletStraight(stg.grain_a, 3, true, mst.x + dx, mst.y + dy, 0, a)
                obj.hscale, obj.vscale = 0.75, 0.9
                obj.bound = false
                task.New(obj, function()
                    while IsValid(mst) do
                        obj.x, obj.y = mst.x + dx, mst.y + dy
                        task.Wait(1)
                    end
                    egg.AddV2(obj, obj.dx, obj.dy)
                    obj.bound = true
                end)
            end
            --简单子弹(hl
            function f2(x, y, st)
                local obj = stg.newBulletStraight(st, 3, true, x, y, 0, 0)
                move(obj)
            end
            --en
            function f2_1(x, y, st)
                local obj = stg.newBulletStraight(st, 3, true, x, y, 0, 0)
                egg.AddSimStrChV(obj, 0, ran:Float(1, 2), -90 + ran:Float(-10, 10), 60)
            end
            --三吴克
            function f3(x)
                New(tasker, function()
                    --New(danger_eff, x, -192)
                    New(e7, x, 245)
                    task.Wait(60)
                    local obj = New(e6, x, -245)
                    obj.dye_range = 50
                end)
            end
        end

        do
            --2600环玉
            task.New(self, function()
                local diff = difficulty
                if diff == 4 then
                    while self.timer < T + 350 do
                        f2(ran:Float(-192, 192), 224, stg.ball_mid_c)
                        task.Wait(5)
                    end
                elseif  diff == 3 then
                    while self.timer < T + 350 do
                        f2(ran:Float(-192, 192), 224, stg.ball_mid_c)
                        task.Wait(10)
                    end
                elseif  diff == 2 then
                    while self.timer < T + 350 do
                        f2_1(ran:Float(-192, 192), 224, stg.ball_mid_c)
                        task.Wait(10)
                    end
                else
                    while self.timer < T + 350 do
                        f2_1(ran:Float(-192, 192), 224, stg.ball_mid_c)
                        task.Wait(20)
                    end
                end
            end)
            task.Wait(100)
            --2700小玉
            task.New(self, function()
                local diff = difficulty
                if diff == 4 then
                    while self.timer < T + 300 do
                        f2(ran:Float(-192, 192), 224, stg.ball_mid)
                        task.Wait(5)
                    end
                elseif  diff == 3 then
                    while self.timer < T + 300 do
                        f2(ran:Float(-192, 192), 224, stg.ball_mid)
                        task.Wait(10)
                    end
                elseif  diff == 2 then
                    while self.timer < T + 300 do
                        f2_1(ran:Float(-192, 192), 224, stg.ball_mid)
                        task.Wait(10)
                    end
                else
                    while self.timer < T + 300 do
                        f2_1(ran:Float(-192, 192), 224, stg.ball_mid)
                        task.Wait(20)
                    end
                end
            end)
            --2800花
            task.New(self, function()
                local diff = difficulty
                if diff == 4 then
                    while self.timer < T + 350 do
                        f1(ran:Float(-192, 192), 224)
                        task.Wait(10)
                    end
                    while self.timer < T + 1100 do
                        f1(ran:Float(-192, 192), 224)
                        task.Wait(60)
                    end
                elseif  diff == 3 then
                    while self.timer < T + 350 do
                        f1(ran:Float(-192, 192), 224)
                        task.Wait(15)
                    end
                    while self.timer < T + 1100 do
                        f1(ran:Float(-192, 192), 224)
                        task.Wait(90)
                    end
                elseif  diff == 2 then
                    while self.timer < T + 350 do
                        f1_2(ran:Float(-192, 192), 224)
                        task.Wait(18)
                    end
                    while self.timer < T + 1100 do
                        f1_2(ran:Float(-192, 192), 224)
                        task.Wait(90)
                    end
                else
                    while self.timer < T + 350 do
                        f1_2(ran:Float(-192, 192), 224)
                        task.Wait(20)
                    end
                    while self.timer < T + 1100 do
                        f1_2(ran:Float(-192, 192), 224)
                        task.Wait(120)
                    end
                end
            end)
            --2900爆米花
            task.New(self, function()
                local diff = difficulty
                if diff == 4 then
                    while self.timer < T + 350 do
                        New(b2, ran:Float(-192, 192), 224)
                        task.Wait(15)
                    end
                    while self.timer < T + 1200 do
                        New(b2, ran:Float(-192, 192), 224)
                        task.Wait(90)
                    end
                elseif  diff == 3 then
                    while self.timer < T + 350 do
                        New(b2, ran:Float(-192, 192), 224)
                        task.Wait(25)
                    end
                    while self.timer < T + 1200 do
                        New(b2, ran:Float(-192, 192), 224)
                        task.Wait(120)
                    end
                elseif  diff == 2 then
                    while self.timer < T + 350 do
                        New(b2, ran:Float(-192, 192), 224)
                        task.Wait(30)
                    end
                    while self.timer < T + 1200 do
                        New(b2, ran:Float(-192, 192), 224)
                        task.Wait(150)
                    end
                else
                    while self.timer < T + 350 do
                        New(b2, ran:Float(-192, 192), 224)
                        task.Wait(40)
                    end
                    while self.timer < T + 1200 do
                        New(b2, ran:Float(-192, 192), 224)
                        task.Wait(180)
                    end
                end
            end)
            task.Wait(280)
            --3100
            f3(0) --三吴克
            task.Wait(210)
            f3(-60)
            task.Wait(210)
            f3(60)
            task.Wait(180)
            while self.timer < T + 1350 do
                task.Wait(1)
            end
            --控制时间
            for i = 0, 2 do
                for u = -1, 1, 2 do
                    New(e2, -245*u, 50 + 50*i, i%2+1, u)
                end
                task.Wait(70)
            end
            task.Wait(210)
        end
    end
    do
        local f1, IsClear
        local u, obj = 1
        local isnKill
        do
            function IsClear(t)
                --判断t时间内是否还存在敌人，若不存在则跳过剩余时间
                local flag
                for _ = 1, t do
                    flag = true
                    for _, _ in ObjList(GROUP_NONTJT) do
                        flag = false
                        break
                    end
                    for _, _ in ObjList(GROUP_ENEMY) do
                        flag = false
                        break
                    end
                    if flag then
                        break
                    end
                    task.Wait(1)
                end
            end
            --单只增援计时器
            function isnKill(t)
                for _ = 1, t do
                    if not IsValid(obj) then
                        break
                    end
                    task.Wait(1)
                end
            end
            --三吴克
            function f1(x)
                New(tasker, function()
                    --New(danger_eff, x, -192)
                    New(e7, x, 245)
                    task.Wait(60)
                    local obj = New(e6, x, -245)
                    obj.dye_range = 40
                end)
            end
        end
        f1(-90)
        f1(90)
        f1(0)
        task.Wait(120)
        IsClear(360)
        while self.timer < T + 3000 do
            obj = New(e5, -280*u, 100, 1 + 0.5*(-u + 1), u)
            isnKill(300)
            task.Wait(60)
            u = -u
        end
        task.Wait(240)
    end
    while self.timer < T + 3240 do
        task.Wait(1)
    end
    clearEnemyAndBullet()
    task.Wait(300)
    s6_boss.main()
    task.Wait(120)
    --region 成就和EX面解锁
    --成就 不续关通关L难度及其下级成就 (id:11 12 13 14)
    if (lstg.var.coun_num or 0) <= 0 then
        local diff = difficulty
        if diff == 4 then
            achievement.unlock("14")
            achievement.unlock("13")
            achievement.unlock("12")
            achievement.unlock("11")
        elseif  diff == 3 then
            achievement.unlock("13")
            achievement.unlock("12")
            achievement.unlock("11")
        elseif diff == 2 then
            achievement.unlock("12")
            achievement.unlock("11")
        elseif diff == 1 then
            achievement.unlock("11")
        end
        system.record.markPlayerClearGroup()
        if system.record.isAllPlayerClearGroup() then
            if diff == 4 then
                achievement.unlock("24")
                achievement.unlock("23")
                achievement.unlock("22")
                achievement.unlock("21")
            elseif  diff == 3 then
                achievement.unlock("23")
                achievement.unlock("22")
                achievement.unlock("21")
            elseif diff == 2 then
                achievement.unlock("22")
                achievement.unlock("21")
            elseif diff == 1 then
                achievement.unlock("21")
            end
        end
    end
    --成就 NM
    if system.isNoMiss() then
        achievement.unlock("51")
    end
    --成就 NB
    if system.isNoBomb() then
        achievement.unlock("52")
    end
    --成就 获取特定数目 红 蓝 绿 点数 (id:41 42 43)
    local dyeitem = lstg.var.dyeitem or {red=0, blue=0, green=0}
    if dyeitem.red >= 2400 then
        achievement.unlock("41")
    end
    if dyeitem.blue >= 3000 then
        achievement.unlock("42")
    end
    if dyeitem.green >= 800 then
        achievement.unlock("43")
    end
    --成就 染色数分别达到2500, 3000, 3500 (id:61 62 63
    if system.getTotalChain() >= 3500 then
        achievement.unlock("63")
        achievement.unlock("62")
        achievement.unlock("61")
    elseif system.getTotalChain() >= 3000 then
        achievement.unlock("62")
        achievement.unlock("61")
    elseif system.getTotalChain() >= 2500 then
        achievement.unlock("61")
    end
    --EX面解锁
    if difficulty >= 2 then
        system.record.unlocExtra() -- NHL难度解锁
    end
    --L难度解锁
    if difficulty >= 3 then
        system.record.unlockLunatic() -- HL难度解锁
    end
    --endregion
    system.makeSettlement(6, true)
    --region 高分和高分成就
    --成就 通关分数达到xx亿 (id:71)(数值还未定下来？我先默认给个150亿
    if system.getScore() >= 150*100000000 then
        achievement.unlock("71")
    end
    --标记新的高分，一会回主菜单要保存
    system.record.markHighScore()
    --endregion
    task.Wait(120)
end
s6_road.mid_dialog = s6_mid_dialog
s6_road.main = road
