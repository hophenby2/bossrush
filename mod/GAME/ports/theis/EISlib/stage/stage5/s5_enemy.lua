--祈华梦五面道中部分
s5_road = {}
local path = "EISlib/stage/stage5/"
Include(path .. "s5_boss_defined.lua")
-------------------------------------
local path = "res/stage/stage5/s5title/"
--资源加载
local function load_res()
    LoadImageFromFile("s5_t1", path .. "s5_t1.png")
    LoadImageFromFile("s5_t2", path .. "s5_t2.png")
    LoadImageFromFile("s5_t3", path .. "s5_t3.png")
    LoadImageFromFile("s5_t4", path .. "s5_t4.png")
end
load_res()
----------------------------------标题
local s5_title
do
    local size, t0, t1, t2 = 0.8, 90, 60, 60
    local s5_t1 = Class(object)
    function s5_t1:init(x, y)
        self.x, self.y = x, y
        self.img = "s5_t1"
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
    function s5_t1:frame()
        task.Do(self)
    end
    function s5_t1:render()
        SetImgState(self, "", self._a, self._r, self._g, self._b)
        Render(self.img, self.x, self.y, 0, self.hscale, self.vscale)
    end
    local s5_t2 = Class(object)
    function s5_t2:init(x, y)
        self.x, self.y = x, y
        self.img = "s5_t2"
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
    function s5_t2:frame()
        task.Do(self)
    end
    function s5_t2:render()
        SetImgState(self, "", self._a, self._r, self._g, self._b)
        Render(self.img, self.x, self.y, 0, self.hscale, self.vscale)
    end
    local s5_t3 = Class(object)
    function s5_t3:init(x, y)
        self.x, self.y = x, y
        self.img = "s5_t3"
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
    function s5_t3:frame()
        task.Do(self)
    end
    function s5_t3:render()
        SetImgState(self, "", self._a, self._r, self._g, self._b)
        Render(self.img, self.x, self.y, 0, self.hscale, self.vscale)
    end
    local s5_t4 = Class(object)
    function s5_t4:init(x, y)
        self.x, self.y = x, y
        self.img = "s5_t4"
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
    function s5_t4:frame()
        task.Do(self)
    end
    function s5_t4:render()
        SetImgState(self, "", self._a, self._r, self._g, self._b)
        Render(self.img, self.x, self.y, 0, self.hscale, self.vscale)
    end
    function s5_title()
        local x, y = 0, 100
        New(s5_t1, x - 130*size, y + 0)
        New(s5_t4, x + 80*size, y - 5*size)
        New(s5_t2, x + 160*size, y - 36*size)
        New(s5_t3, x + 60*size, y + 20*size)
    end
end

--也要被清除的对象
local clearer = {}

----------------------------------函数的定义-------------------------------------
--清除弹幕和小怪
local function clearEnemyAndBullet()
    for _, unit in ObjList(GROUP_NONTJT) do
        Del(unit)
    end
    for _, unit in ObjList(GROUP_ENEMY_BULLET) do
        _del(unit, true)
    end
    local obj
    for i = #clearer, 1, -1 do
        obj = clearer[i]
        if IsValid(obj) then
            Del(obj)
        end
        table.remove(clearer)
    end
end
----------------------------------移动定义-------------------------------------

----------------------------------特殊的弹幕定义-------------------------------------
--生成常用加速弹
local function accbullet(st, co, x, y, v, a, t)
    local obj = stg.newBulletStraight(st, co, true, x, y, 0, a)
    egg.AddSimStrChV(obj, 0, v, a, t)
    return obj
end
---------------------------------攻击方式定义-------------------------------------

----------------------------------状态改变定义-------------------------------------
local dec_dmg = function (self, t1, t2, r0) --设置线性减伤时间
    self.dmgrate = r0 or 0.1
    t1 = t1 or 180
    t2 = t2 or 60
    task.New(self, function ()
        task.Wait(t1)
        local d = (1-self.dmgrate)/t2
        for _ = 1, t2 do
            self.dmgrate = self.dmgrate + d
            task.Wait(1)
        end
    end)
end
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
----------------------------------死尸弹定义-------------------------------------

----------------------------------obj定义--------------------------------------------
--大妖精泡泡
local function bubble(mst, size)
    local obj = s4_boss.bubble_dark2(mst.x, mst.y, size or 0.75) --是四面的黑泡泡
    obj.group = GROUP_GHOST
    boundWait(obj, 300)
    task.New(obj, function()
        while IsValid(mst) do
            obj.x, obj.y = mst.x, mst.y
            task.Wait(1)
        end
        Del(obj)
    end)
end
----------------------------------小怪、衍生定义-------------------------------------
local e1, e1_1, e1_2, e1_3, spawnGhostFires
do
    local x0, y0 = 0, 30
    local r0, dr0, ddr0 = 300, -2*100/240, 200/240/240
    local da0, dda0 = 0.3, -1.05/240
    --旋转阴阳玉
    e1 = Class(enemy)
    function e1:init(a, co, dt)
        self.x, self.y = 400, 400
        enemy.init(self,32 + (co or 4), 15,false,false,true, true, co, 20, 1)
        dec_dmg(self, 150, 90, 0)
        boundWait(self, 720 + dt)
        --dyeRangeCh(self, r1, t)
        self.colli = false
        self.group = GROUP_GHOST
        task.New(self, function()
            if dt == 0 then
                _object.set_color(self, "", 0, 255, 255, 255)
                task.Wait(60)
            else
                _object.set_color(self, "", 100, 255, 255, 255)
                task.Wait(300)
            end
            egg.SimAlpCh(self, self._a, 255, 120)
            dyeRangeCh(self, 50, 60)
            task.Wait(120)
            self.colli = true
            self.group = GROUP_NONTJT
        end)
        task.New(self, function()
            local r, dr, ddr = r0, dr0, ddr0
            local da, dda = da0, dda0
            for _ = 1, dt do
                a = a + da
                self.x, self.y = x0 + 1.2*r*cos(a), y0 + r*sin(a)
                task.Wait(1)
            end
            for _ = 1, 240 do
                dr = dr + ddr
                r = r + dr
                da = da + dda
                a = a + da
                self.x, self.y = x0 + 1.2*r*cos(a), y0 + r*sin(a)
                task.Wait(1)
            end
            for _ = 1, 240 do
                a = a + da
                self.x, self.y = x0 + 1.2*r*cos(a), y0 + r*sin(a)
                task.Wait(1)
            end
            --self.bound = true
            for _ = 1, _infinite do
                a = a + da
                self.x, self.y = x0 + 1.2*r*cos(a), y0 + r*sin(a)
                task.Wait(1)
            end
        end)
        --攻击
        task.New(self, function()
            --阴阳玉颜色决定子弹颜色
            if co == 1 then
                co = 2
            elseif co == 2 then
                co = 6
            end
            local diff = difficulty
            if diff == 4 then
                task.Wait(dt + 170)
                local a0
                if dt == 0 then
                    a0 = 75
                else
                    a0 = 60
                end
                for _ = 1, _infinite do
                    for j = -2, 2 do
                        for i = 0, 1 do
                            boundWait(stg.newBulletStraight(stg.ball_mid, co, true, self.x, self.y, 2 + 0.5*i, a + 90 + 10*j + a0), 30)
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(20)
                    a0 = a0 - 5
                end
            elseif  diff == 3 then
                task.Wait(dt + 170)
                local a0
                if dt == 0 then
                    a0 = 75
                else
                    a0 = 55
                end
                for _ = 1, _infinite do
                    for j = -2, 2 do
                        for i = 0, 0 do
                            boundWait(stg.newBulletStraight(stg.ball_mid, co, true, self.x, self.y, 2 + 0.5*i, a + 90 + 10*j + a0), 30)
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(20)
                    a0 = a0 - 5
                end
            elseif  diff == 2 then
                task.Wait(dt + 170)
                local a0
                if dt == 0 then
                    a0 = 75
                else
                    a0 = 50
                end
                for _ = 1, _infinite do
                    for j = -2, 2 do
                        for i = 0, 0 do
                            boundWait(stg.newBulletStraight(stg.ball_mid, co, true, self.x, self.y, 1.75 + 0.5*i, a + 90 + 7.5*j + a0), 30)
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(20)
                    a0 = a0 - 5
                end
            else
                task.Wait(dt + 170)
                local a0
                if dt == 0 then
                    a0 = 75
                else
                    a0 = 50
                end
                for _ = 1, _infinite do
                    for j = -1, 1 do
                        for i = 0, 0 do
                            boundWait(stg.newBulletStraight(stg.ball_mid, co, true, self.x, self.y, 1.5 + 0.5*i, a + 90 + 10*j + a0), 30)
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(20)
                    a0 = a0 - 5
                end
            end
        end)
    end
    --改变旋转中心
    function e1.updateCenter(dy)
        y0 = y0 + dy
    end
    function e1.reFreshCenter()
        x0, y0 = 0, -30
    end
    --鬼火团(6个
    function spawnGhostFires(a, u)
        local obj = stg.newBulletStraight(stg.ball_mid, 1, true, 270, 384, 0, 0)
        obj.group = GROUP_GHOST
        obj.hide = true
        obj.angle = 0
        boundWait(obj, 120)
        --鬼火召唤术
        for i = 1, 6 do
            New(e1_1, obj, 30*i)
        end
        --移动
        local dr = -20
        task.New(obj, function()
            local r, dr, ddr = r0 + dr, dr0, ddr0
            local da, dda = 0.1, 0.4/240
            for _ = 1, 240 do
                dr = dr + ddr
                r = r + dr
                da = da + dda
                a = a + da
                obj.angle = obj.angle + u
                obj.x, obj.y = x0 + 1.2*r*cos(a), y0 + r*sin(a)
                task.Wait(1)
            end
            for _ = 1, 105 do
                --[[if obj.x < -195 then
                    obj.x = -300
                    Del(obj)
                end]]
                a = a + da
                obj.x, obj.y = x0 + 1.2*r*cos(a), y0 + r*sin(a)
                obj.angle = obj.angle + u
                task.Wait(1)
            end
            Del(obj)
        end)
    end
    --旋转鬼火
    e1_1 = Class(enemy)
    function e1_1:init(mst, a)
        enemy.init(self,20, 10,false,false,true, nil, nil, 0, 1)
        self.bound = false
        --移动
        task.New(self, function()
            local a0
            for _ = 1, 345 do
                if IsValid(mst) then
                    a0 = a + mst.angle
                    self.x, self.y = mst.x + 20*cos(a0)*sin(a0), mst.y + 20*sin(a0)*sin(a0)
                end
                task.Wait(1)
            end
            SetV(self, 1, 180)
            task.Wait(30)
            Del(self)
        end)
        --攻击
        task.New(self, function()
            local diff = difficulty
            if diff == 4 then
                task.Wait(180)
                for _ = 1, 1 do
                    for i = 1, 8 do
                        for j = 0, 1 do
                            accbullet(stg.arrow_big, 4, self.x, self.y, 1.25 + 0.25*j, a + 45*i + 22.5*j, 240)
                        end
                    end
                    PlaySound("kira00")
                    task.Wait(120)
                end
            elseif  diff == 3 then
                task.Wait(180)
                for _ = 1, 1 do
                    for i = 1, 8 do
                        for j = 0, 0 do
                            accbullet(stg.arrow_big, 4, self.x, self.y, 1.25 + 0.25*j, a + 45*i + 22.5*j, 240)
                        end
                    end
                    PlaySound("kira00")
                    task.Wait(120)
                end
            elseif  diff == 2 then
                task.Wait(180)
                for _ = 1, 1 do
                    for i = 1, 4 do
                        for j = 0, 0 do
                            accbullet(stg.arrow_big, 4, self.x, self.y, 1.25 + 0.25*j, a + 90*i + 45*j, 240)
                        end
                    end
                    PlaySound("kira00")
                    task.Wait(120)
                end
            else
                task.Wait(180)
                for _ = 1, 1 do
                    for i = 1, 2 do
                        for j = 0, 0 do
                            accbullet(stg.arrow_big, 4, self.x, self.y, 1.25 + 0.25*j, a + 180*i + 90*j, 240)
                        end
                    end
                    PlaySound("kira00")
                    task.Wait(120)
                end
            end
        end)
    end
    function e1_1:kill()
        enemy.kill(self)
        local diff = difficulty
        local a = Angle(self, player)
        if not (self.sys_co == 1 or self.sys_co == 2) and Dist(self, player) > 20 then
            if diff == 4 then
                for i = 1, 8 do
                    for j = 0, 1 do
                        accbullet(stg.arrow_small, 1, self.x, self.y, 2.5 + 0.5*j, a + 45*i + 22.5*j, 10)
                    end
                end
                PlaySound("kira00")
            elseif diff == 3 then
                for i = 1, 8 do
                    for j = 0, 0 do
                        accbullet(stg.arrow_small, 1, self.x, self.y, 2.5 + 0.5*j, a + 45*i + 22.5*j, 10)
                    end
                end
                PlaySound("kira00")
            elseif diff == 2 then
                for i = 1, 4 do
                    for j = 0, 0 do
                        accbullet(stg.arrow_small, 1, self.x, self.y, 2.5 + 0.5*j, a + 90*i + 45*j, 10)
                    end
                end
                PlaySound("kira00")
            end
        end
    end
    --出场演出用的阴阳玉
    e1_2 = Class(enemy)
    function e1_2:init(a, co)
        self.x, self.y = 400, 400
        self.hscale, self.vscale = 0.25, 0.25
        enemy.init(self,32 + (co or 4), 5,false,true,true, false, nil, 60, 1, true)
        _object.set_color(self, "", 0, 0, 0, 0)
        self.colli = false
        self.group = GROUP_GHOST
        task.New(self, function()
            local r, dr, ddr = 0, 0, 8/240
            local da, dda = 0.5, 0.5/240
            local d_a, d_r, ds = 200/255, 200/255, 0.75/255
            for _ = 1, 240 do
                dr = dr + ddr
                r = r + dr
                da = da + dda
                a = a + da
                self.x, self.y = x0 + 1.2*r*cos(a), y0 + r*sin(a)
                self._a = self._a + d_a
                self._r, self._g, self._b = self._r + d_r, self._g + d_r, self._b + d_r
                self.hscale, self.vscale = self.hscale + ds, self.vscale + ds
                task.Wait(1)
            end
        end)
    end
    --出场演出用的鬼火
    e1_3 = Class(enemy)
    function e1_3:init(a)
        self.x, self.y = 400, 400
        self.hscale, self.vscale = 0.25, 0.25
        enemy.init(self,20, 10,false,true,true, false, nil, 0, 1, true)
        _object.set_color(self, "", 0, 0, 0, 0)
        self.colli = false
        self.group = GROUP_GHOST
        task.New(self, function()
            local r, dr, ddr = 0, 0, 8/240
            local da, dda = 0.5, 0.5/240
            local d_a, d_r, ds = 200/255, 200/255, 0.75/255
            for _ = 1, 240 do
                dr = dr + ddr
                r = r + dr
                da = da + dda
                a = a + da
                self.x, self.y = x0 + 1.2*r*cos(a), y0 + r*sin(a)
                self._a = self._a + d_a
                self._r, self._g, self._b = self._r + d_r, self._g + d_r, self._b + d_r
                self.hscale, self.vscale = self.hscale + ds, self.vscale + ds
                task.Wait(1)
            end
        end)
    end
end
local e2, e2_1, e2_2
local atk2_1, atk2_2
--部分攻击方式定义
do
    function atk2_1(self, t)
        local a, obj
        task.New(self, function()
            local diff = difficulty
            if diff == 4 then
                task.Wait(70 + t)
                for _ = 1, 4 do
                    a = Angle(self, player)
                    for i = 0, 5 do
                        for j = -2, 2 do
                            obj = stg.newBulletStraight(stg.arrow_big, 6, true, self.x, self.y, 0, a + 30*j)
                            egg.AddSimStrChV(obj, 0, 2 + 0.2*i, a + 30*j, 60)
                        end
                        PlaySound("tan00")
                        task.Wait(3)
                    end
                    task.Wait(90)
                end
            elseif  diff == 3 then
                task.Wait(75 + t)
                for _ = 1, 3 do
                    a = Angle(self, player)
                    for i = 0, 4 do
                        for j = -1, 1 do
                            obj = stg.newBulletStraight(stg.arrow_big, 6, true, self.x, self.y, 0, a + 30*j)
                            egg.AddSimStrChV(obj, 0, 1.8 + 0.2*i, a + 50*j, 60)
                        end
                        PlaySound("tan00")
                        task.Wait(3)
                    end
                    task.Wait(100)
                end
            elseif  diff == 2 then
                task.Wait(80 + t)
                for _ = 1, 2 do
                    a = Angle(self, player)
                    for i = 0, 4 do
                        for j = -1, 1 do
                            obj = stg.newBulletStraight(stg.arrow_big, 6, true, self.x, self.y, 0, a + 30*j)
                            egg.AddSimStrChV(obj, 0, 1.6 + 0.2*i, a + 120*j, 60)
                        end
                        PlaySound("tan00")
                        task.Wait(3)
                    end
                    task.Wait(120)
                end
            else
                task.Wait(85 + t)
                for _ = 1, 2 do
                    a = Angle(self, player)
                    for i = 0, 3 do
                        for j = 0, 0 do
                            obj = stg.newBulletStraight(stg.arrow_big, 6, true, self.x, self.y, 0, a + 30*j)
                            egg.AddSimStrChV(obj, 0, 1.4 + 0.2*i, a + 120*j, 60)
                        end
                        PlaySound("tan00")
                        task.Wait(3)
                    end
                    task.Wait(120)
                end
            end
        end)
    end
    function atk2_2(self, i, t)
        local a, obj
        task.New(self, function()
            local diff = difficulty
            if diff == 4 then
                task.Wait(90 + 30*i + t)
                for _ = 1, _infinite do
                    if Dist(self, player) > 50 and self.y > -120 then
                        a = Angle(self, player)
                        for j = -2, 2 do
                            obj = stg.newBulletStraight(stg.ball_mid_c, 3, true, self.x + 5*cos(a + 120*j), self.y + 5*sin(a + 120*j), 0, a + 45*j)
                            egg.AddSimStrChV(obj, 0, 1, a + 45*j, 90, 10)
                            --a = a + 45
                        end
                    end
                    task.Wait(30)
                end
            elseif  diff == 3 then
                task.Wait(90 + 45*i + t)
                for _ = 1, _infinite do
                    if Dist(self, player) > 50 and self.y > -80 then
                        a = Angle(self, player)
                        for j = -1, 1 do
                            obj = stg.newBulletStraight(stg.ball_mid_c, 3, true, self.x + 5*cos(a + 120*j), self.y + 5*sin(a + 120*j), 0, a + 45*j)
                            egg.AddSimStrChV(obj, 0, 1, a + 67.5*j, 90, 10)
                        end
                    end
                    task.Wait(45)
                end
            elseif  diff == 2 then
                task.Wait(90 + 60*i + t)
                for _ = 1, _infinite do
                    if Dist(self, player) > 50 and self.y > -40 then
                        a = Angle(self, player)
                        for j = -1, 1 do
                            obj = stg.newBulletStraight(stg.ball_mid_c, 3, true, self.x + 5*cos(a + 120*j), self.y + 5*sin(a + 120*j), 0, a + 45*j)
                            egg.AddSimStrChV(obj, 0, 1, a + 120*j, 90, 10)
                        end
                    end
                    task.Wait(60)
                end
            else
                task.Wait(90 + 60*i + t)
                for _ = 1, _infinite do
                    if Dist(self, player) > 50 and self.y > -40 then
                        a = Angle(self, player)
                        for j = -1, 1, 2 do
                            obj = stg.newBulletStraight(stg.ball_mid_c, 3, true, self.x + 5*cos(a + 120*j), self.y + 5*sin(a + 120*j), 0, a + 45*j)
                            egg.AddSimStrChV(obj, 0, 1, a + 120*j, 90, 10)
                        end
                    end
                    task.Wait(60)
                end
            end
        end)
    end
end
do
    --第二种大妖精
    e2 = Class(enemy)
    function e2:init(x, y, co, t, min)
        t = t or 0
        self.x, self.y = x, y
        enemy.init(self,28 + (co or 4), 30,false,false,true, true, co, 41, 1)
        self.min = min
        self.layer = LAYER_ENEMY+1
        self.group = GROUP_NONTJT
        --生成子鬼火
        do
            local count, obj = 1
            for i = -3, 3, 2 do
                obj = New(e2_1, nil, 16*i)
                atk2_2(obj, count, t)
                count = count + 1
                _connect(self, obj, 0, false)
            end
            for u = -1, 1 do
                obj = New(e2_1, 3, 90*u)
                atk2_1(obj, t)
                _connect(self, obj, 0, false)
            end
        end
    end
    function e2:kill()
        New(e2_2, self.x, self.y, self.min)
        enemy.kill(self)
    end
    --鬼火使魔
    e2_1 = Class(enemy)
    function e2_1:init(co, sp)
        enemy.init(self,20, 50,false,false,true, nil, co, 0, 1)
        self.group = GROUP_NONTJT
        --移动
        task.New(self, function()
            local dx, dy = 40*cos(90 + sp), 40*sin(90 + sp)
            while IsValid(self._master) do
                self.x, self.y = self._master.x + dx, self._master.y + dy
                task.Wait(1)
            end
            --主人死了就放飞了
            egg.AddSimStrChV(self, 0, 1, -90 + 0.15*sp, 120)
        end)
    end
    function e2_1:kill()
        local diff = difficulty
        if diff == 4 then
            local x, y = self.x, self.y
            New(tasker, function()
                local a0, a = ran:Float(-5, 5)
                for i = 0, 6 do
                    a = Angle(x, y, player.x, player.y) + a0
                    for j = -2, 2 do
                        stg.newBulletStraight(stg.arrow_small, 1, true, x, y, 1 + 0.2*i, a + 15*j)
                    end
                    PlaySound("tan00")
                    task.Wait(3)
                end
            end)
        elseif diff == 3 then
            local x, y = self.x, self.y
            New(tasker, function()
                local a0, a = ran:Float(-5, 5)
                for i = 0, 4 do
                    a = Angle(x, y, player.x, player.y) + a0
                    for j = -1, 1 do
                        stg.newBulletStraight(stg.arrow_small, 1, true, x, y, 1 + 0.2*i, a + 30*j)
                    end
                    PlaySound("tan00")
                    task.Wait(3)
                end
            end)
        elseif diff == 2 then
            local x, y = self.x, self.y
            New(tasker, function()
                local a0, a = ran:Float(-5, 5)
                for i = 0, 2 do
                    a = Angle(x, y, player.x, player.y) + a0
                    for j = -1, 1 do
                        stg.newBulletStraight(stg.arrow_small, 1, true, x, y, 1 + 0.2*i, a + 45*j)
                    end
                    PlaySound("tan00")
                    task.Wait(3)
                end
            end)
        end
        enemy.kill(self)
    end
    function e2_1:dyeKill()
        enemy.kill(self)
        Del(self)
    end
    --衍生出的额外大妖精

    --裹在泡泡里的大妖精
    e2_2 = Class(enemy)
    function e2_2:init(x, y, ymin)
        self.x, self.y = x, y
        --self.dmgrate = 0.1
        enemy.init(self, 29, 20,false,false,true, true, 2, 20, 1)
        self.group = GROUP_GHOST
        self.colli = false
        table.insert(clearer, self)
        --移动
        local vy = 1.5
        ymin = ymin or -50
        local t = min((self.y - ymin)/vy, 90)
        SetV(self, vy, 90)
        egg.AddAccDecChV(self, 2*vy, -90, 1, t, 60)  --先下沉然后上浮
        --状态变化
        _object.set_color(self, "", 150, 50, 50, 50)
        local drot = 6
        self.rot = -t*drot
        self.hscale, self.vscale = 0.5, 0.5
        task.New(self, function()
            --旋转
            for _ = 1, t do
                self.rot = self.rot + drot
                task.Wait(1)
            end
            PlaySound("cancel00") --吹泡泡的声音
            self.colli = true
            self.group = GROUP_NONTJT
            bubble(self)
            egg.SimAlpRGBChTo255(self, 60)
            egg.SimSizeCh(self, 0.5, 1, 60)
            dyeRangeCh(self, 50, 60)
            task.Wait(30)
            --减伤
            --dec_dmg(self, 0, 30, 0.1)
        end)
        --攻击
        task.New(self, function()
            task.Wait(t + 30) --至少也要等大妖精有判定了
            local diff = difficulty
            if diff == 4 then
                local a
                while true do
                    a = -90 + ran:Float(-15, 15)
                    for i = 1, 5 do
                        accbullet(stg.ball_mid_c, 5, self.x, self.y, 1, a + 72*i, 60)
                    end
                    PlaySound("kira00")
                    task.Wait(12)
                end
            elseif diff == 3 then
                local a
                while true do
                    a = -90 + ran:Float(-15, 15)
                    for i = 1, 4 do
                        accbullet(stg.ball_mid_c, 5, self.x, self.y, 1, a + 90*i, 60)
                    end
                    PlaySound("kira00")
                    task.Wait(18)
                end
            elseif diff == 2 then
                local a
                while true do
                    a = -90 + ran:Float(-15, 15) + 60
                    for i = 1, 3 do
                        accbullet(stg.ball_mid_c, 5, self.x, self.y, 1, a + 120*i, 60)
                    end
                    PlaySound("kira00")
                    task.Wait(24)
                end
            else
                local a
                while true do
                    a = 90 + ran:Float(-15, 15) + 60
                    for i = 1, 1 do
                        accbullet(stg.ball_mid_c, 5, self.x, self.y, 1, a + 120*i, 60)
                    end
                    PlaySound("kira00")
                    task.Wait(24)
                end
            end
        end)
    end
    function e2_2:kill()
        enemy.kill(self)
        local a, diff, a0, dx, dy, r, x, y = Angle(self, player), difficulty
        if diff == 4 then
            for j = 1, 18 do
                a0 = a + 20*j
                dx, dy = cos(a0), sin(a0)
                for i = 0, 2 do
                    r = 30 - 10*i
                    x, y = self.x + r*dx, self.y + r*dy
                    if Dist(x, y, player.x, player.y) > 40 then
                        accbullet(stg.arrow_small, 3, x, y, 1 + 0.125*i, a0, 60)
                    end
                end
            end
            PlaySound("kira00")
        elseif diff == 3 then
            for j = 1, 12 do
                a0 = a + 30*j
                dx, dy = cos(a0), sin(a0)
                for i = 0, 1 do
                    r = 30 - 10*i
                    x, y = self.x + r*dx, self.y + r*dy
                    if Dist(x, y, player.x, player.y) > 40 then
                        accbullet(stg.arrow_small, 3, x, y, 1 + 0.125*i, a0, 60)
                    end
                end
            end
            PlaySound("kira00")
        elseif diff == 2 then
            for j = 1, 8 do
                a0 = a + 45*j
                dx, dy = cos(a0), sin(a0)
                for i = 0, 0 do
                    r = 30 - 10*i
                    x, y = self.x + r*dx, self.y + r*dy
                    if Dist(x, y, player.x, player.y) > 40 then
                        accbullet(stg.arrow_small, 3, x, y, 1 + 0.125*i, a0, 60)
                    end
                end
            end
            PlaySound("kira00")
        end
    end
end
local e3, e3_1, e3_2
local atk3_1, atk3_1_1
--部分攻击方式定义
do
    function atk3_1(self, u, t)
        local a, obj, v
        task.New(self, function()
            local diff = difficulty
            if diff == 4 then
                task.Wait(70 + t)
                for _ = 1, 3 do
                    v = 2
                    for _ = 1, 9 do
                        for i = -1, 3 do
                            a = -90 + (10 + 15*i)*u
                            obj = stg.newBulletStraight(stg.arrow_big, 6, true, self.x, self.y, 0, a)
                            egg.AddSimStrChV(obj, 0, v, a, 60)
                        end
                        v = v + 0.25
                        task.Wait(3)
                    end
                    task.Wait(90)
                end
            elseif  diff == 3 then
                task.Wait(75 + t)
                for _ = 1, 3 do
                    v = 1.75
                    for _ = 1, 7 do
                        for i = -1, 2 do
                            a = -90 + (19 + 20*i)*u
                            obj = stg.newBulletStraight(stg.arrow_big, 6, true, self.x, self.y, 0, a)
                            egg.AddSimStrChV(obj, 0, v, a, 60)
                        end
                        v = v + 0.25
                        task.Wait(3)
                    end
                    task.Wait(90)
                end
            elseif  diff == 2 then
                task.Wait(80 + t)
                for _ = 1, 2 do
                    v = 1.5
                    for _ = 1, 5 do
                        for i = -1, 2 do
                            a = -90 + (25 + 20*i)*u
                            obj = stg.newBulletStraight(stg.arrow_big, 6, true, self.x, self.y, 0, a)
                            egg.AddSimStrChV(obj, 0, v, a, 60)
                        end
                        v = v + 0.175
                        task.Wait(3)
                    end
                    task.Wait(100)
                end
            else
                task.Wait(85 + t)
                for _ = 1, 2 do
                    v = 1.5
                    for _ = 1, 4 do
                        for i = 0, 2 do
                            a = -90 + (10 + 25*i)*u
                            obj = stg.newBulletStraight(stg.arrow_big, 6, true, self.x, self.y, 0, a)
                            egg.AddSimStrChV(obj, 0, v, a, 60)
                        end
                        v = v + 0.175
                        task.Wait(3)
                    end
                    task.Wait(110)
                end
            end

        end)
    end
    function atk3_1_1(self, u, t)
        local a, obj
        task.New(self, function()
            local diff = difficulty
            if diff == 4 then
                task.Wait(30 + t)
                for _ = 1, 4 do
                    --7
                    for i = -3, 3 do
                        a = -90 + 15*i + 60*u
                        obj = stg.newBulletStraight(stg.ball_mid, 2, true, self.x, self.y, 3, a)
                        --obj.vscale, obj.b = 0.75, 0.75*obj.b
                    end
                    --6
                    for i = -2, 3 do
                        a = -90 + 15*i + (60 - 7.5*u)*u
                        obj = stg.newBulletStraight(stg.ball_mid, 2, true, self.x, self.y, 2.5, a)
                        --obj.vscale, obj.b = 0.75, 0.75*obj.b
                    end
                    --5
                    for i = -2, 2 do
                        a = -90 + 15*i + 60*u
                        obj = stg.newBulletStraight(stg.ball_mid, 2, true, self.x, self.y, 2, a)
                        --obj.vscale, obj.b = 0.75, 0.75*obj.b
                    end
                    --4
                    for i = -1, 2 do
                        a = -90 + 15*i + (60 - 7.5*u)*u
                        obj = stg.newBulletStraight(stg.ball_mid, 2, true, self.x, self.y, 1.5, a)
                        --obj.vscale, obj.b = 0.75, 0.75*obj.b
                    end
                    PlaySound("tan00")
                    task.Wait(90)
                end
            elseif  diff == 3 then
                task.Wait(35 + t)
                for _ = 1, 3 do
                    --6
                    for i = -2, 3 do
                        a = -90 + 15*i + (60 - 7.5*u)*u
                        obj = stg.newBulletStraight(stg.ball_mid, 2, true, self.x, self.y, 2.5, a)
                        --obj.vscale, obj.b = 0.75, 0.75*obj.b
                    end
                    --5
                    for i = -2, 2 do
                        a = -90 + 15*i + 60*u
                        obj = stg.newBulletStraight(stg.ball_mid, 2, true, self.x, self.y, 2, a)
                        --obj.vscale, obj.b = 0.75, 0.75*obj.b
                    end
                    --4
                    for i = -1, 2 do
                        a = -90 + 15*i + (60 - 7.5*u)*u
                        obj = stg.newBulletStraight(stg.ball_mid, 2, true, self.x, self.y, 1.5, a)
                        --obj.vscale, obj.b = 0.75, 0.75*obj.b
                    end
                    PlaySound("tan00")
                    task.Wait(90)
                end
            elseif  diff == 2 then
                task.Wait(40 + t)
                for _ = 1, 2 do
                    --5
                    for i = -2, 2 do
                        a = -90 + 15*i + 60*u
                        obj = stg.newBulletStraight(stg.ball_mid, 2, true, self.x, self.y, 2, a)
                        --obj.vscale, obj.b = 0.75, 0.75*obj.b
                    end
                    --4
                    for i = -1, 2 do
                        a = -90 + 15*i + (60 - 7.5*u)*u
                        obj = stg.newBulletStraight(stg.ball_mid, 2, true, self.x, self.y, 1.5, a)
                        --obj.vscale, obj.b = 0.75, 0.75*obj.b
                    end
                    PlaySound("tan00")
                    task.Wait(90)
                end
            else
                task.Wait(45 + t)
                for _ = 1, 2 do
                    --4
                    for i = -1, 2 do
                        a = -90 + 15*i + (60 - 7.5*u)*u
                        obj = stg.newBulletStraight(stg.ball_mid, 2, true, self.x, self.y, 1.5, a)
                        --obj.vscale, obj.b = 0.75, 0.75*obj.b
                    end
                    PlaySound("tan00")
                    task.Wait(90)
                end
            end

        end)
    end
end
do
    --主妖精
    e3 = Class(enemy)
    function e3:init(x, y, co, t, ymin)
        t = t or 0
        self.x, self.y = x, y
        enemy.init(self,28 + (co or 4), 30,false,false,true, true, co, 50, 1)
        self.layer = LAYER_ENEMY+1
        --生成子鬼火
        do
            local obj
            for u = -1, 1, 2 do
                _connect(self, New(e3_1, nil, 45*u, -10, 0.1*u, ymin), 0, false)
                obj = New(e3_1, 3, 15*u, -10)
                atk3_1_1(obj, u, t)
                _connect(self, obj, 0.5, false)
                obj = New(e3_1, 3, 30*u, 10)
                atk3_1(obj, u, t)
                _connect(self, obj, 0, false)
            end
            _connect(self, New(e3_1, nil, 0, 0, 0, ymin), 0, false)
        end
    end
    --鬼火使魔
    e3_1 = Class(enemy)
    function e3_1:init(co, dx, dy, vx, ymin)
        local st
        if co then
            st = 20
        else
            st = 20 --无色毛玉，脱落后会生成小妖精的
        end
        enemy.init(self, st, 25,false,false,true, nil, co, 0, 1)
        --移动
        task.New(self, function()
            while IsValid(self._master) do
                self.x, self.y = self._master.x + dx, self._master.y + dy
                task.Wait(1)
            end
            --移动
            if self.y > -192 then
                local vy = 1.1
                ymin = ymin or -150
                local t = min((self.y - ymin)/vy, 120)
                SetV(self, vy, 90)
                self.vx = vx or 0
                egg.AddAccDecChV(self, 2*vy, -90, 1, t, 60)  --先下沉然后上浮
                --状态变化
                self.group = GROUP_GHOST
                enemy.change_style(self, 25) --变形
                _object.set_color(self, "", 150, 50, 50, 50)
                local drot = 6
                self.rot = -t*drot
                self.hscale, self.vscale = 0.5, 0.5
                task.New(self, function()
                    --旋转
                    for _ = 1, t do
                        self.rot = self.rot + drot
                        task.Wait(1)
                    end
                    PlaySound("cancel00") --吹泡泡的声音
                    self.colli = true
                    self.group = GROUP_NONTJT
                    bubble(self, 0.5)
                    egg.SimAlpRGBChTo255(self, 60)
                    egg.SimSizeCh(self, 0.5, 1, 60)
                    dyeRangeCh(self, 50, 60)
                    task.Wait(30)
                end)
            else
                self.ay = -0.05
            end
        end)
    end
    function e3_1:kill()
        e2_2.kill(self)
    end
    function e3_1:dyeKill()
        enemy.kill(self)
        Del(self)
    end

    --染色工具阴阳玉
    e3_2 = Class(enemy)
    function e3_2:init(co, x, y, u)
        enemy.init(self,32 + (co or 4), 15, false,false,true, true, 2, 20, 1)
        _object.set_color(self, "", 100, 255, 255, 255)
        self.group = GROUP_GHOST
        dec_dmg(self, 120, 60, 0.1)
        self.x, self.y = x, y
        --移动
        task.New(self, function()
            egg.AddAccDecChV(self, 2.75, 90 - 90*u, 1, 120, 60)
            task.Wait(120)
            egg.SimAlpCh(self, 100, 255, 30)
            self.group = GROUP_NONTJT
            dyeRangeCh(self, 50, 60)
            egg.AddAccDecChV(self, 2, -90, 30, 0, 30)
            task.Wait(60)
            egg.AddAccDecChV(self, 2, 90 + 90*u, 60, 999, 60)
        end)
        --攻击
        task.New(self, function()
            local diff = difficulty
            if diff == 4 then
                task.Wait(30)
                local a
                for _ = 1, 3 do
                    a = Angle(self, player)
                    for i = -3, 3 do
                        for j = 0, 3 do
                            stg.newBulletStraight(stg.ball_mid, 6, true, self.x, self.y, 1.3 + 0.2*j, a + 3*i)
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(60)
                end
            elseif diff == 3 then
                task.Wait(35)
                local a
                for _ = 1, 3 do
                    a = Angle(self, player)
                    for i = -3, 3 do
                        for j = 0, 2 do
                            stg.newBulletStraight(stg.ball_mid, 6, true, self.x, self.y, 1.3 + 0.2*j, a + 2*i)
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(60)
                end
            elseif diff == 2 then
                task.Wait(40)
                local a
                for _ = 1, 2 do
                    a = Angle(self, player)
                    for i = -2, 2 do
                        for j = 0, 1 do
                            stg.newBulletStraight(stg.ball_mid, 6, true, self.x, self.y, 1.3 + 0.2*j, a + 2*i)
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(60)
                end
            else
                task.Wait(45)
                local a
                for _ = 1, 2 do
                    a = Angle(self, player)
                    for i = -2, 2 do
                        for j = 0, 0 do
                            stg.newBulletStraight(stg.ball_mid, 6, true, self.x, self.y, 1.3 + 0.2*j, a + 1*i)
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(60)
                end
            end
        end)
    end
end
--[[local e4_1, e4_2, e4_3, e4_4, e4_5, e4_6
local atk5_1, atk5_2
--部分攻击方式定义
do
    function atk5_1(self)
        local a, obj
        task.New(self, function()
            local diff = difficulty
            if diff == 4 then
                task.Wait(90)
                for _ = 1, 3 do
                    a = Angle(self, player)
                    for _ = 1, 6 do
                        obj = stg.newBulletStraight(stg.arrow_small, 5, true, self.x, self.y, 0, a)
                        egg.AddSimStrChV(obj, 0, 2, a, 60)
                        task.Wait(3)
                    end
                    task.Wait(120)
                end
            elseif  diff == 3 then
                task.Wait(110)
                for _ = 1, 2 do
                    a = Angle(self, player)
                    for _ = 1, 4 do
                        obj = stg.newBulletStraight(stg.arrow_small, 5, true, self.x, self.y, 0, a)
                        egg.AddSimStrChV(obj, 0, 1.75, a, 60)
                        task.Wait(5)
                    end
                    task.Wait(150)
                end
            elseif  diff == 2 then
                task.Wait(130)
                for _ = 1, 2 do
                    a = Angle(self, player)
                    for _ = 1, 3 do
                        obj = stg.newBulletStraight(stg.arrow_small, 5, true, self.x, self.y, 0, a)
                        egg.AddSimStrChV(obj, 0, 1.5, a, 60)
                        task.Wait(6)
                    end
                    task.Wait(150)
                end
            else
                task.Wait(150)
                a = Angle(self, player)
                for _ = 1, 3 do
                    obj = stg.newBulletStraight(stg.arrow_small, 5, true, self.x, self.y, 0, a)
                    egg.AddSimStrChV(obj, 0, 1.5, a, 60)
                    task.Wait(6)
                end
            end
        end)
    end
    function atk5_2(self, i)
        task.New(self, function()
            local diff = difficulty
            if diff == 4 then
                local a, obj
                task.Wait(90 + 15*i)
                for _ = 1, _infinite do
                    if Dist(self, player) > 50 and self.y > -130 then
                        a = Angle(self, player)
                        for i = -1, 1 do
                            obj = stg.newBulletStraight(stg.ball_mid_c, 3, true, self.x, self.y, 0, a + 20*i)
                            egg.AddSimStrChV(obj, 0, 2, a + 20*i, 120)
                        end
                    end
                    task.Wait(60)
                end
            elseif  diff == 3 then
                local a, obj
                task.Wait(110 + 15*i)
                for _ = 1, _infinite do
                    if Dist(self, player) > 50 and self.y > -75 then
                        a = Angle(self, player)
                        obj = stg.newBulletStraight(stg.ball_mid_c, 3, true, self.x, self.y, 0, a)
                        egg.AddSimStrChV(obj, 0, 1.75, a, 120)
                    end
                    task.Wait(70)
                end
            elseif  diff == 2 then
                local a, obj
                task.Wait(130 + 15*i)
                for _ = 1, _infinite do
                    if Dist(self, player) > 50 and self.y > -50 then
                        a = Angle(self, player)
                        obj = stg.newBulletStraight(stg.ball_mid_c, 3, true, self.x, self.y, 0, a)
                        egg.AddSimStrChV(obj, 0, 1.5, a, 120)
                    end
                    task.Wait(120)
                end
            else
                local a, obj
                task.Wait(150 + 15*i)
                for _ = 1, _infinite do
                    if Dist(self, player) > 50 and self.y > 0 then
                        a = Angle(self, player)
                        obj = stg.newBulletStraight(stg.ball_mid_c, 3, true, self.x, self.y, 0, a)
                        egg.AddSimStrChV(obj, 0, 1, a, 120)
                    end
                    task.Wait(180)
                end
            end
        end)
    end
end
do
    --第一组怪(鬼火和阴阳玉)
    do
        local t0, t1, t2 = 30, 55, 30
        local t3, t4, t5 = 30, 0, 30
        local v0, v1 = 2, 2
        --阴阳玉
        e4_1 = Class(enemy)
        function e4_1:init(x, y, co, u1)
            u1 = u1 or 1
            self.x, self.y = x, y
            enemy.init(self,32 + (co or 4), 7.5,false,false,true, true, 1, 60, 1)
            dec_dmg(self, 0, 120)
            --self.a, self.b = 24, 24
            task.New(self, function()
                local u = 1
                egg.AddAccDecChV(self, 2, 90 - 90*u, 30, 20, 30) --从板外出来，要凑够距离的
                task.Wait(60)
                --开始循环了
                for _ = 1, 4 do
                    for _ = 1, 2 do
                        egg.AddAccDecChV(self, v0, 90 - 90*u, t0, t1, t2)
                        task.Wait(t0+t1)
                        --到达中间，往下移
                        egg.AddAccDecChV(self, v1, 0-90*u1, t3, t4, t5)
                        task.Wait(60)
                    end
                    u = -u
                end
            end)
        end
        function e4_1:kill()
            e2_3.kill(self)
        end
        --鬼火
        e4_2 = Class(enemy)
        function e4_2:init(x, y, u1)
            self.x, self.y = x, y
            u1 = u1 or 1
            enemy.init(self,20 + 4, 25,false,false,true, nil, nil, 0, 1)
            task.New(self, function()
                local u = -1
                egg.AddAccDecChV(self, 2, 90 - 90*u, 30, 20, 30) --从板外出来，要凑够距离的
                task.Wait(60)
                --开始循环了
                for _ = 1, 4 do
                    for _ = 1, 2 do
                        egg.AddAccDecChV(self, v0, 90 - 90*u, t0, t1, t2)
                        task.Wait(t0+t1)
                        --到达中间，往下移
                        egg.AddAccDecChV(self, v1, 0-90*u1, t3, t4, t5)
                        task.Wait(60)
                    end
                    u = -u
                end
            end)
        end
    end
    --岩壁战斗机妖精
    do
        --主妖精
        e4_3 = Class(enemy)
        function e4_3:init(x, y, co, a, u)
            self.x, self.y = x, y
            enemy.init(self,28 + (co or 4), 15,false,false,true, true, 1, 60, 1)
            dec_dmg(self, 0, 60)
            --生成子鬼火
            do
                local obj
                for u = -1, 1, 2 do
                    _connect(self, New(e4_4, nil, 45*u, -10, u), 0.5, false)
                    obj = New(e4_4, 3, 15*u, -10)
                    atk2_1_1(obj, u)
                    _connect(self, obj, 0.5, false)
                    obj = New(e4_4, 3, 30*u, 10)
                    atk2_1(obj, u)
                    _connect(self, obj, 0.5, false)
                end
                _connect(self, New(e4_4, nil, 0, -30), 0.5, false)
            end
            --移动
            task.New(self, function()
                egg.AddSimStrChV(self, 3, 0.75, a, 90)
                task.Wait(90)
                egg.AddEllMove(self, a, 0, 0.15*u, 0, 200, 0.75, 120, 120, 120)
            end)
        end
        --鬼火使魔
        e4_4 = Class(enemy)
        function e4_4:init(co, dx, dy, u)
            enemy.init(self,20 + (co or 4), 25,false,false,true, nil, co, 0, 1)
            --移动
            task.New(self, function()
                while IsValid(self._master) do
                    self.x, self.y = self._master.x + dx, self._master.y + dy
                    task.Wait(1)
                end
                --主人死了就掉下去了
                u = u or 0
                egg.AddAccDecChV(self, 1, -90 + 15*u, 120, 60, 60)
                egg.AddSimStrChV(self, 0, 0.25, -90, 60, 180)
            end)
        end
    end
    --六鬼火妖精
    do
        e4_5 = Class(enemy)
        function e4_5:init(x, y, co, a)
            self.x, self.y = x, y
            enemy.init(self,28 + (co or 4), 15,false,false,true, true, 1, 41, 1)
            dec_dmg(self, 0, 60)
            --生成子鬼火
            do
                local obj
                local count = 0
                for i = -3, 3, 2 do
                    obj = New(e4_6, nil, 16*i)
                    atk5_2(obj, count)
                    _connect(self, obj, 0.5, false)
                    count = count + 1
                end
                for u = -1, 1, 2 do
                    obj = New(e4_6, 3, 90*u)
                    atk5_1(obj)
                    _connect(self, obj, 0.5, false)
                end
            end
            --移动
            task.New(self, function()
                egg.AddSimStrChV(self, 6, 0, a, 120)
                task.Wait(120)
                egg.AddSimStrChV(self, 0, 2, Angle(self, player), 150)
            end)
        end
        --鬼火使魔
        e4_6 = Class(enemy)
        function e4_6:init(co, sp)
            enemy.init(self,20 + (co or 4), 25,false,false,true, nil, co, 0, 1)
            --移动
            task.New(self, function()
                local dx, dy = 40*cos(90 + sp), 40*sin(90 + sp)
                while IsValid(self._master) do
                    self.x, self.y = self._master.x + dx, self._master.y + dy
                    task.Wait(1)
                end
                --主人死了就放掉了
                egg.AddSimStrChV(self, 0, 2, -90 + 0.15*sp, 180)
            end)
        end
    end
end]]
--增援段落
----------------------------------道中本体-------------------------
local function p4(self)
    do
        self.timer = 8780
        local f1, f2, f3, f4
        do
            --从左右来的妖精
            function f1(x, y, co, a, t)
                local obj = New(e3, x, y, co, 30)
                dec_dmg(obj, 135, 30, 0.1)
                task.New(obj, function()
                    egg.AddSimStrChV(obj, 5, 0, a, 120)
                    task.Wait(120 + t)
                    egg.AddSimStrChV(obj, 0, 2, -90, 150)
                end)
            end
            --从上边下来的妖精
            function f2(x, y, co, a, u)
                local obj = New(e2, x, y, co, -30)
                dec_dmg(obj, 40, 20, 0.1)
                dyeRangeCh(obj, 50, 60)
                task.New(obj, function()
                    egg.AddSimStrChV(obj, 3, 0.75, a, 90)
                    task.Wait(90)
                    egg.AddEllMove(obj, a, 0, 0.15*u, 0, 200, 0.75, 120, 120, 120)
                end)
            end
            --最后一波一排妖精1
            function f3(x, y, co, a, t)
                local obj = New(e3, x, y, co, nil, -600)
                dec_dmg(obj, 60, 10, 0.1)
                task.New(obj, function()
                    egg.AddSimStrChV(obj, 5.8, 0, a, 90)
                    task.Wait(90 + t)
                    egg.AddSimStrChV(obj, 0, 2, -90, 150)
                end)
            end
            --最后一波从上边下来的妖精
            function f4(x, y, co, a, u)
                local obj = New(e2, x, y, co, nil, -600)
                dec_dmg(obj, 30, 20, 0.1)
                dyeRangeCh(obj, 50, 60)
                task.New(obj, function()
                    egg.AddSimStrChV(obj, 3, 0.75, a, 90)
                    task.Wait(90)
                    egg.AddEllMove(obj, a, 0, 0.15*u, 0, 200, 0.75, 120, 120, 120)
                end)
            end
        end

        do
            for u = -1, 1, 2 do
                for i = 2, 0, -1 do
                    f1(300*u, 80, 2, 90 + 80*u + 8.5*i*u, -10*i)
                    task.Wait(20)
                end
                task.Wait(150)
                for i = 0, 2 do
                    f2((-65 + 30*i)*u, 280 + 0*i, 1, -90 + (20*i)*u, u)
                    task.Wait(30)
                end
                task.Wait(180)
            end
            task.Wait(60)
            for u = 1, -1, -2 do
                for i = -2, 2 do
                    f3(45*i*u, 300 + 30*(i + 2), 2, -90, -10*i)
                    task.Wait(15)
                end
                task.Wait(200)
                for i = -2, 2 do
                    f4(70*i*u, 320 + 17.5*i, 1, -90, u)
                    task.Wait(15)
                end
                task.Wait(320)
            end
            task.Wait(360)
        end
        clearEnemyAndBullet()
    end
end

local function road(self)
    --p1
    do
        system.setTargetChain(620)
        LoadMusicRecord("s5")
        LoadMusicRecord("s5_boss1")
        LoadMusicRecord("s5_boss2")
        dialog.cacheResource("Stage5_mid")
        dialog.cacheResource("Stage5")
        dialog.cacheResource("Stage5_Bossmid")
        dialog.cacheResource("Stage5_after")
        New(stage5_background)
        EISlib.stage.playMusic("s5", 0, true)
    end
    task.Wait(120)
    s5_title()
    do
        --刷新一下中心
        e1.reFreshCenter()
        --生成演出阴阳玉和鬼火
        task.New(self, function()
            local a, da = 0, -15
            for i = 1, 9 do
                New(e1_2, a, i%2+1)
                a = a + da
                task.Wait(10)
            end
            task.Wait(180)
            a, da = -90, -1.5
            for i = 1, 12 do
                for _ = 1, 2 do
                    for j = -1, 1 do
                        New(e1_3, a - 4.5*j)
                        a = a + da
                    end
                    task.Wait(4)
                end
                task.Wait(20)
            end
        end)
        task.Wait(180)
        task.New(self, function()
            task.Wait(240)
            for _ = 1, 180 do
                e1.updateCenter(-0.2)
                task.Wait(1)
            end
        end)
        --生成阴阳玉大怪
        task.New(self, function()
            local a, da, u, dt = 45, -30, 1, 135
            for j = 1, 7 do
                New(e1, a, j%2+1, dt)
                a = a + da
                u = -u
                dt = dt - 10
                task.Wait(20)
            end
            task.Wait(260 + 32*3)
            a = a
            for j = 0, 17 do
                New(e1, a, j%2+1, 0)
                u = -u
                task.Wait(32)
            end
        end)
        task.Wait(450)
        local a, da = 45, 0
        --生成鬼火小怪
        for i = 1, 12 do
            spawnGhostFires(a, -1)
            task.Wait(60)
        end
    end
    --p2(1860
    while(self.timer<1700)do
        task.Wait(1)
    end
    clearEnemyAndBullet()
    task.Wait(160)
    do
        local f1, f2
        do
            --从左上右上来的
            function f1(x, y, co, u)
                local obj = New(e2, x, y, co)
                dec_dmg(obj, 0, 90, 0.05)
                task.New(obj, function()
                    egg.AddSimStrChV(obj, 2, 1, -90, 60)
                    --task.Wait(15)
                    egg.AddSimStrChV(obj, 0, 1.5, 90*(1-u), 150)
                end)
            end
            --从正上方下来
            function f2(x, y, co)
                local obj = New(e2, x, y, co)
                dec_dmg(obj, 0, 90, 0.05)
                task.New(obj, function()
                    egg.AddSimStrChV(obj, 2, 0.25, -90, 60)
                    task.Wait(180)
                    egg.AddSimStrChV(obj, 0, 1.5, -90, 150)
                end)
            end
        end

        self.timer = 1860
        --左右轮流来
        for _ = 1, 3 do
            for u = -1, 1, 2 do
                f1(-120*u, 245, 1, u)
                task.Wait(60)
            end
            task.Wait(135)
        end
        task.Wait(60)
        --正上方下来
        local u0 = 1
        for i = 0, 2 do
            for u = -1, 1, 2 do
                f2((30 + 30*i)*u*u0, 245, 1)
                --task.Wait(30)
            end
            task.Wait(180)
            u0 = -u0
        end

        local t = 1
        while(self.timer < 3530)do
            task.Wait(1)
        end
        clearEnemyAndBullet()
    end
    --p3(3530
    do
        local f1
        do
            function f1(x, y, co, u)
                local obj = New(e3, x, y, co)
                dec_dmg(obj, 0, 60, 0.05)
                task.New(obj, function()
                    egg.AddSimStrChV(obj, 4, 0, 90*(1-u), 60)
                    task.Wait(150)
                    egg.AddSimStrChV(obj, 0, 1, 90*(1-u), 90)
                    egg.AddSimStrChV(obj, 0, 2, 90, 300)
                end)
            end
        end

        self.timer = 3530

        for u0 = 1, -1, -2 do
            for u = -u0, u0, 2*u0 do
                for i = 0, 2 do
                    f1(224*u, 0 + 60*i, 1, -u)
                    task.Wait(60)
                end
                New(tasker, function()
                    task.Wait(30)
                    for i = 0, 2 do
                        New(e3_2, 1, -224*u, 150 + 20*i, u)
                        task.Wait(60)
                    end
                end)
            end
            if u0 == 1 then
                task.Wait(480)
            end
        end
        while self.timer < 5160 do
            task.Wait(1)
        end
        clearEnemyAndBullet()
    end
    --道中boss与增援
    do
        self.timer = 5160
        local boss = s5_mid_boss.main() --创建五道中boss
        while IsValid(boss) do
            task.Wait(1)
        end
    end
    --p4
    p4(self)
    s5_boss.main()
    task.Wait(120)
    system.makeSettlement(5)
    task.Wait(120)
end
s5_road.main = road
--五后半道中单独练习
local function lastRoad(self)
    do
        New(stage5_background, true)
        LoadMusicRecord("s5")
        EISlib.stage.playMusic("s5", 8780/60, true)
    end
    p4(self)
    task.Wait(120)
end
s5_road.lastRoad = lastRoad
