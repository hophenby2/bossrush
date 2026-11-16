-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
--todo 使用任意机体，不主动击破任何鬼火的情况下收取这张符卡
local curpath = EISlib.stage.path.."stage6/spellcard/spell_4.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local no_func = function() end
local velch = EGGlib.ObjectEvent.velocityChange
local changeVelocity = EGGlib.ObjectEvent.changeVelocity
local alpAndSizeCh = EGGlib.ObjectEvent.alphaAndSizeChange
local disapear = EGGlib.ObjectEvent.disappear
local alphaAndSizeChangeTask = EGGlib.ObjectEvent.alphaAndSizeChangeTask
local spSizeAndColliChange = EGGlib.ObjectEvent.spSizeAndColliChange
local spSizeAndColliChangeTask = EGGlib.ObjectEvent.spSizeAndColliChangeTask
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local sty = EISlib.Enemy.Style
local alphaChangeTask = EGGlib.ObjectEvent.alphaChangeTask
local warning_laser = EISlib.Bullet.Laser.warning_laser2
local lead_laser = EISlib.Bullet.Laser.lead_laser
local laser = EISlib.Bullet.Laser.laser
local cancelBoundProtect = EGGlib.ObjectEvent.cancelBoundProtect
local circle_normal1 = EGGlib.BulletGroup.Circle.normal1
local tranRot = EGGlib.Math.TranRot
local isInLaser2 = EGGlib.ObjectEvent.isInLaser2
local newSimpleClass = EGGlib.Class.newSimpleClass
local alphaChange = EGGlib.ObjectEvent.alphaChange
local LS = EISlib.Bullet.Laser.laser
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1

local achi = true

local laser_eff

--初始文字提示
local tips = Class(object)
function tips:init()
    self.x, self.y = 0, 174
    self.group = GROUP_GHOST
    self.layer = LAYER_TOP
    self.a, self.b = 0, 0
    robject.set_color(self, "", 0, 255, 255, 255)
    self.hscale, self.vscale = 1, 1
    task.New(self, function()
        alphaChange(self, 0, 255, 30)
        task.Wait(360)
        alphaChange(self, 255, 0, 30)
        Del(self)
    end)
end
function tips:frame()
    task.Do(self)
end
function tips:render()
    local x, y = self.x, self.y
    local str1 = "触碰连接线或拆除连接点"
    RenderStrokeTTF("Serif48", str1,
            x, x, y, y,
            1.25, lstg.Color(self._a, self._r, self._g, self._b),
            1.25, lstg.Color(self._a, 0, 0, 0),
            "centerpoint")
    --RenderTTF('Mono24', str1, x, y, x, y, self.hscale*2, Color(self._a, self._r, self._g, self._b), 'center')
    local str2 = "Touch Connection Lines\n or Destroy Nodes"
    --RenderTTF('Mono24', str2, x, y - 25, x, y - 25, self.hscale*2, Color(self._a, self._r, self._g, self._b), 'center')
    RenderStrokeTTF("Serif48", str2,
            x, x, y - 30, y - 30,
            1, lstg.Color(self._a, self._r, self._g, self._b),
            1, lstg.Color(self._a, 0, 0, 0),
            "centerpoint")
end


--倒计时
local countdown = Class(object)
function countdown:init(x, y, t)
    self.x, self.y = x, y
    self.group = GROUP_GHOST
    self.layer = LAYER_PLAYER - 1
    self.left_time = t
    self.a, self.b = 0, 0
    robject.set_color(self, "", 150, 255, 255, 255)
    self.hscale, self.vscale = 1, 1
    --spSizeAndColliChangeTask(self, 0.9, 30, 135)
    self.start = false --开始记时的标记
end
function countdown:frame()
    task.Do(self)
    if self.start then
        if self.left_time > 0 then
            self.left_time = self.left_time - 1
        elseif not self.isDel then
            countdown.kill(self)
        end
        if self.left_time <= 90 then --时间快停止了就闪
            if self.left_time % 6 == 0 then
                self._r, self._g, self._b = 255, 0, 0
            elseif self.left_time % 3 == 0 then
                self._r, self._g, self._b = 255, 255, 255
            end
        end
    end
end
function countdown:render()
    local x, y = self.x, self.y
    local t0, t1 = math.floor(self.left_time/60), self.left_time%60
    t1 = math.floor(t1/60*100)
    local t2 = t1%10 --取小数点右边第二位
    t1 = math.floor(t1/10) --取小数点右边第一位
    --RenderTTF('Mono24', string.format("%d.%d%ds", t0, t1, t2), x, y, x, y, self.hscale*5, Color(self._a, self._r, self._g, self._b), 'center', 'noclip')
    ui:RenderText('title',string.format("%d.%d%d",t0,t1,t2),x,y,.75,
        Color(self._a,self._r,self._g,self._b),'center')
end
function countdown:kill()
    PreserveObject(self)
    self.isDel = true
    task.New(self, function()
        alphaAndSizeChange(self, -self._a, -1, 20)
        self.status = "del"
    end)
end
--开始记时
function countdown:start()
    self.start = true
end

local function infectEffect(x, y)
    local obj = stg.newSimpleBullet(x, y, stg.ball_light, COLOR_RED)
    obj.colli = false
    robject.set_color(obj, "mul+add", 255, 255, 1, 255)
    setSizeAndColli(obj, 0.01, 0.01)
    task.New(obj, function()
        alphaAndSizeChange(obj, -255, 2.99, 30)
        Del(obj)
    end)
end

local ceil = Class(enemy)
do
    local ceil_tb = {} --存放当前所有细胞的表
    local warning_laser_table = {} --细胞间是否有激光的二维关系矩阵
    local index = 1
    function ceil:init(x, y, d, a, counter, t, wt)
        enemy.init(self,
                x, y, sty.FIRE_CYAN, --style
                20, --hp
                false,  --show_hpbar
                system.DROP_NONE, --drop
                true, --no_count
                nil, --death_func
                false --type
        )
        enemy.setBoundTime(self, _infinite)
        self.t = t or 10 --套娃一次需要的时间
        self.show_aura = true
        cancelBoundProtect(self) --取消出屏保护
        robject.set_color(self, "", 100, 255, 255, 255)
        self.dist = d
        self.angle = a
        self.index = index
        warning_laser_table[self.index] = {} --开辟矩阵
        index = index + 1
        self.other_ceil = {} --另外三个变量 {obj, isLaser}
        self.counter = counter
        table.insert(ceil_tb, self)
        enemy.setClashRate(self, 0.25)
        setSizeAndColli(self, 0.1, 0.1)
        self.colli = false
        self.hide = true
        task.New(self, function()
            self.hide = false
            spSizeAndColliChange(self, 0.9, 30, 135)
            --self.colli = true
        end)
        task.New(self, function()
            task.Wait(self.t)
            ceil.summonOtherCeil(self, wt - self.t)
        end)
    end
    function ceil:frame()
        enemy.frame(self)
        if player_class.isInBomb(player) then
            self.colli = false
        elseif self._a >= 255 then
            self.colli = true
        end
    end
    function ceil:render()
        enemy.render(self)
    end
    --检测有没有被连通； 连通：只要还有一条线连着就算连通
    function ceil:checkConnected(ignore_ls)
        --一定有更好的写法，但因为是后来加的需求，再加上时间不太够了，所以直接暴力遍历了，也影响不了多大性能开销
        local flag = false
        for k, v in pairs(warning_laser_table[self.index]) do
            if v and IsValid(v) and ignore_ls ~= v then
                flag = true
                break
            end
        end
        if not flag then
            for k, v in pairs(warning_laser_table) do
                if v[self.index] and IsValid(v[self.index]) and ignore_ls ~= v[self.index] then
                    flag = true
                    break
                end
            end
        end
        return flag
    end
    function ceil:summonOtherCeil(wt)
        if self.counter > 0 then
            local x0, y0, d, a0 = self.x, self.y, self.dist, self.angle
            local x, y, a
            for i = 0, 2 do
                a = a0 - 60 + 120*i
                x, y = x0 + d*cos(a), y0 + d*sin(a)
                sp.UnitListUpdate(ceil_tb)
                --检查有没有重复生成
                local flag = true
                for _, obj in pairs(ceil_tb) do
                    if x - obj.x < 1 and x - obj.x > -1 and y - obj.y < 1 and y - obj.y > -1 then
                        flag = false
                        if not ceil.isLinkByWarningLaser(self, obj) then
                            local ls = ceil.createWarningLaser(self, self.x, self.y, a, self, obj, wt)
                            warning_laser_table[self.index][obj.index] = ls
                            warning_laser_table[obj.index][self.index] = ls
                            table.insert(self.other_ceil, obj)
                            table.insert(obj.other_ceil, self)
                        end
                        break
                    end
                end
                --没有重复则生成
                if flag then
                    local obj = New(ceil, x, y, d, a, self.counter - 1, self.t, wt)
                    local ls = ceil.createWarningLaser(self, self.x, self.y, a, self, obj, wt)
                    warning_laser_table[self.index][obj.index] = ls
                    warning_laser_table[obj.index][self.index] = ls
                    table.insert(self.other_ceil, obj)
                    table.insert(obj.other_ceil, self)
                end
            end
        end
    end
    --开始新的一轮生成
    function ceil.reFresh()
        warning_laser_table = {}
        ceil_tb = {}
        index = 1
    end
    --生成预警激光
    function ceil:createWarningLaser(x, y, a, ceil1, ceil2, wt)
        local d = self.dist - 10
        local obj = New(lead_laser,
                1, COLOR_BLUE, --type, co
                x, y, 1*d/5, a, --x, y, v, a
                d, 7, 7, 1, --len, w0, w1, t
                true, false, _infinite --islock, isshoot, last_time
        )
        LS.setMaxLength(obj, 1, 5)
        LS.setMaxLength(obj, 2, d)
        LS.setMaxLength(obj, 3, 5)
        obj.real_laser = nil
        obj.colli = false
        obj._a = 0
        --被自机切断的逻辑
        task.New(obj, function()
            --至少要等到线长到最长才可以碰的
            local tt = 0
            while not laser.isMaxLength(obj) do
                task.Wait(1)
                tt = tt + 1
            end
            alphaChangeTask(obj, 0, 60, 30)
            task.Wait(wt - tt)
            laser_eff.create(obj.x, obj.y, d, 7, a)
            obj._a = 120
            while not isInLaser2(player, obj.x, obj.y, obj.rot, laser.getTotalLength(obj), 2*laser.getWide(obj, 2, 0.5)) and not obj.isTimeOut do --isTimeOut代表对应红激光已经出了，此时不再接受自机断线逻辑
                task.Wait(1)
            end
            if not obj.isTimeOut then
                --去检查链接的两个细胞是否已连通，如果没变红且没被连通，则直接自爆
                if IsValid(ceil1) and not (ceil1.infected or ceil1.will_infected) and not ceil.checkConnected(ceil1, obj) then
                    _del(ceil1)
                end
                if IsValid(ceil2) and not (ceil2.infected or ceil2.will_infected) and not ceil.checkConnected(ceil2, obj) then
                    _del(ceil2)
                end
                _del(obj, true)
            end
        end)
        return obj
    end
    --被感染
    function ceil:infected()
        if not self.infected and not self.killing_flag then
            infectEffect(self.x, self.y)
            enemy.change_style(self, sty.FIRE_RED)
            self.infected = true
            self.maxhp = 10000
            self.hp = self.maxhp
            local tb = self.other_ceil
            for i = 1, #tb do
                local obj = tb[i]
                if IsValid(obj) then
                    local ls = warning_laser_table[self.index][obj.index]
                    if IsValid(ls) and not IsValid(ls.real_laser) then
                        local d = self.dist - 10
                        ls.real_laser = New(lead_laser,
                                1, COLOR_RED, --type, co
                                self.x, self.y, d/10, Angle(self, obj), --x, y, v, a
                                d, 7, 7, 1, --len, w0, w1, t
                                true, false, _infinite --islock, isshoot, last_time
                        )
                        LS.setMaxLength(ls, 1, 5)
                        LS.setMaxLength(ls, 2, d)
                        LS.setMaxLength(ls, 3, 5)
                        local real_ls = ls.real_laser
                        task.New(real_ls, function()
                            while IsValid(ls) do
                                task.Wait(1)
                            end
                            _del(real_ls, true)
                        end)
                        task.New(ls, function()
                            while not laser.isMaxLength(ls.real_laser) do
                                task.Wait(1)
                            end
                            ls.isTimeOut = true --不再接受自机断线的flag
                            if IsValid(obj) then
                                ceil.infected(obj)
                            end
                        end)
                    end
                end
            end
        end
    end
    function ceil:isLinkByWarningLaser(other)
        return IsValid(warning_laser_table[self.index][other.index])
    end
    function ceil.infectedByIndex(index, isInfectOther, isEffect, t)
        local obj = ceil_tb[index]
        if IsValid(obj) and not obj.infected then
            if isEffect then
                obj.will_infected = true
                obj.maxhp = 10000
                obj.hp = obj.maxhp
                tasker(function()
                    local count = math.floor(t/60)
                    for i = 0, count - 1 do
                        for _ = 1, 3 do
                            if IsValid(obj) then
                                infectEffect(obj.x, obj.y)
                            end
                            task.Wait(10)
                        end
                        if i == 0 then
                            --样式变成红的
                            enemy.change_style(obj, sty.FIRE_RED)
                        end
                        task.Wait(30)
                    end
                    task.Wait(t - 60*count)
                    if IsValid(obj) then
                        ceil.infected(obj)
                    end
                end)
            else
                ceil.infected(obj)
            end
        elseif isInfectOther then --要是这个已经被击破了， 就影响其周围的细胞
            --检测还存在的连接细胞实例，并筛选出它们的下标
            local valid_list = {1, 2, 3}
            local i, index = 1
            while i <= #valid_list do
                index = valid_list[i]
                if IsValid(obj.other_ceil[index]) then
                    i = i + 1
                else
                    table.remove(valid_list, i)
                end
            end
            if #valid_list > 0 then
                --随机感染
                i = ran:Int(1, #valid_list)
                ceil.infectedByIndex(obj.other_ceil[i].index, isInfectOther)
            end
        end
    end
    --随机感染n个
    function ceil.infectedRandom(n)
        if n == 0 then
            local i = 3
            tasker(function()
                local obj = ceil_tb[i]
                for _ = 1, 3 do
                    infectEffect(obj.x, obj.y)
                    task.Wait(10)
                end
                task.Wait(30)
                ceil.infectedByIndex(i, true)
            end)
        else
            local random_index = {7, 8, 17, 14, 18, 30, 13, 22}
            --local random_index = {1}
            local c
            while n > 0 do
                c = ran:Int(1, #random_index)
                local i = random_index[c]
                tasker(function()
                    local obj = ceil_tb[i]
                    for _ = 1, 3 do
                        infectEffect(obj.x, obj.y)
                        task.Wait(10)
                    end
                    task.Wait(60)
                    ceil.infectedByIndex(i, true)
                end)
                table.remove(random_index, c)
                n = n - 1
            end
        end
    end
    function ceil.delByIndex(index)
        local obj = ceil_tb[index]
        if IsValid(obj) then
            ceil.del(obj)
            obj.status = "del"
        end
    end
    function ceil:del()
        enemy.del(self)
        local tb = self.other_ceil
        local obj, ls
        for i = 1, #tb do
            obj = tb[i]
            ls = warning_laser_table[self.index][obj.index]
            if IsValid(ls) then
                if IsValid(ls.real_laser) then
                    Del(ls.real_laser)
                end
                Del(ls)
            end
        end
        self.killing_flag = true
    end
    function ceil:kill()
        achi = false --这样爆掉的话成就就没了
        enemy.kill(self)
        local tb = self.other_ceil
        local obj, ls
        for i = 1, #tb do
            obj = tb[i]
            ls = warning_laser_table[self.index][obj.index]
            if IsValid(ls) then
                if IsValid(ls.real_laser) then
                    Kill(ls.real_laser)
                end
                Del(ls)
            end
        end
        self.killing_flag = true
    end
    --遍历
    function ceil.allCeilDo(func)
        --sp.UnitListUpdate(ceil_tb)
        for _, obj in pairs(ceil_tb) do
            if IsValid(obj) then
                func(obj)
            end
        end
    end
end



local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    local deathManager_inst
    --region Bullet 自定义子弹
    --激光线一闪而过的特效
    B.laser_colli_effect = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, l, w, a)
                    local obj = New(lead_laser,
                            1, COLOR_BLUE, --type, co
                            x, y, l, a, --x, y, v, a
                            l, w, w, 1, --len, w0, w1, t
                            true, false, _infinite --islock, isshoot, last_time
                    )
                    obj.colli = false
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    obj.bound = false
                    --闪出逻辑
                    task.New(obj, function()
                        local t = 30
                        local d_a = -obj._a/t
                        for _ = 1, t do
                            obj._a = obj._a + d_a
                            task.Wait(1)
                        end
                        _del(obj, false)
                    end)
                    return obj
                end
                return create
            end
    )
    laser_eff = B.laser_colli_effect

    B.bullet1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, vx, vy, t, color)
                    local obj = stg.newSimpleBullet(x, y, stg.arrow_small_b, color, true)
                    obj.rot = Angle(0, 0, vx, vy)
                    task.New(obj, function()
                        obj.ax, obj.ay = vx/t, vy/t
                        task.Wait(t)
                        obj.ax, obj.ay = 0, 0
                    end)
                end
                return create
            end
    )

    --鬼火出现判定时一闪的特效
    B.ghost_colli_effect = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local color_list = {}
                color_list[COLOR_BLUE] = sty.FIRE_BLUE
                color_list[COLOR_RED] = sty.FIRE_RED
                local function create(x, y, co)
                    local obj = New(enemy,
                            x, y, color_list[co], --style
                            999, false, --hp, show_hp
                            system.DROP_NONE, --drop
                            true, --no_count
                            nil --death_func
                    )
                    obj.show_aura = true
                    obj.hscale, obj.vscale = 1, 1
                    obj.colli = false
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    obj.bound = false
                    --闪出逻辑
                    task.New(obj, function()
                        alphaAndSizeChange(obj, -255, 0.25, 30)
                        _del(obj, false)
                    end)
                end
                return create
            end
    )
    --endregion
    --region 子弹发射点定义
    P.ceil_boom1 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local n = switch1(diff, {
                    0, 2, 4, 6, 6
                })
                local style, color = stg.arrow_small_b, COLOR_ROYAL_BLUE
                local way = 3
                local v = switch1(diff, {
                    1, 1, 1, 1, 1
                })*switch(rank, {
                    1.05, 1.05, 1.05, 1.05, 1.15
                })
                local t = 90
                local function attack(x, y, a, l)
                    local dl = l/(n - 1)
                    local function bullet_func(x, y, v, a)
                        local h, vx, vy
                        local n = (n - 1)/2
                        for i = -n, n do
                            h = dl*i
                            vx, vy = v, 2*v*h*tan(60)/l
                            vx, vy = tranRot(vx, vy, a)
                            B.bullet1.create(x, y, vx, vy, t, color)
                        end
                    end
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_normal1(x, y, v, a, way, bullet_func)
                            end)
                end
                return attack
            end
    )

    --一个紫细胞被引爆后产生的弹幕
    P.ceil_boom2 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local n = switch1(diff, {
                    4, 6, 8, 10, 10
                }) +  switch(rank, {
                    0, 0, 0, 0, 2
                })
                local style, color = stg.arrow_small_b, COLOR_DEEP_RED
                local way = 3
                local v = switch1(diff, {
                    1, 1, 1, 1, 1
                })*switch(rank, {
                    1.05, 1.05, 1.05, 1.05, 1.15
                })
                local t = 90
                local function attack(x, y, a, l)
                    local dl = l/(n - 1)
                    local function bullet_func(x, y, v, a)
                        local h, vx, vy
                        local n = (n - 1)/2
                        for i = -n, n do
                            h = dl*i
                            vx, vy = v, 2*v*h*tan(60)/l
                            vx, vy = tranRot(vx, vy, a)
                            B.bullet1.create(x, y, vx, vy, t, color)
                        end
                    end
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_normal1(x, y, v, a, way, bullet_func)
                            end)
                end
                return attack
            end
    )
    --endregion
    --region 死尸弹
    --管理死尸弹情况的类
    local deathManager = newSimpleClass()
    do
        local this = deathManager
        function this.constructor(self)
            self.n = switch1(difficulty, {
                1, 2, 3, 4, 5
            })
        end
        function this.getN(self)
            return self.n
        end
        function this.addN(self)
            self.n = self.n + 1
        end
    end
    --死尸弹
    D.death = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local style = stg.arrow_small_b
                local way = 3
                local v = switch1(diff, {
                    1, 1, 1, 1, 1
                })*switch(rank, {
                    1.05, 1.05, 1.05, 1.05, 1.15
                })
                local t = 90
                local function main(e)
                    local x, y, a = e.x, e.y, e.angle
                    local l = 30
                    local n = deathManager_inst:getN()
                    deathManager_inst:addN() --死尸弹强度+1
                    local co
                    if e.infected then
                        co = COLOR_DEEP_RED
                        n = n*2 --强度翻倍
                    else
                        co = COLOR_ROYAL_BLUE
                    end
                    enemy.createDeath(
                            50, --total_time,
                            function(obj)
                                local dl = l/(n - 1)
                                local function bullet_func(x, y, v, a)
                                    local h, vx, vy
                                    local n = (n - 1)/2
                                    for i = -n, n do
                                        h = dl*i
                                        vx, vy = v, 2*v*h*tan(60)/l
                                        vx, vy = tranRot(vx, vy, a)
                                        B.bullet1.create(x, y, vx, vy, t, co)
                                    end
                                end
                                PlaySound("tan00")
                                --if e.infected  then
                                    stg.newFadeEffect(x, y, style, co, false,
                                            function()
                                                circle_normal1(x, y, v, a, way, bullet_func)
                                            end)
                                --end
                                Del(obj)
                            end)
                end
                return main
            end)
    --endregion
    --region 自定义敌人
    --endregion
    --region Tasker 任务执行器
    --endregion
    --region 组合攻击
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local t = 30
                local d_a = 155/t
                local alpha_func = function(obj)
                    obj._a = obj._a + d_a
                    obj.colli = false
                end
                local function main(n, l, left_time, next_time, infected_index_list, remove_index_list)
                    deathManager_inst = deathManager.new()
                    local boom = function(obj)
                        if IsValid(obj) then
                            if obj.infected then
                                P.ceil_boom2.attack(obj.x, obj.y, obj.angle, l)
                            else
                                P.ceil_boom1.attack(obj.x, obj.y, obj.angle, l)
                            end
                            Del(obj)
                        end
                    end
                    ceil.reFresh()
                    New(ceil, 0, l, l, 30, n, math.floor(60/n), 130) --x, y, d, a, counter, t
                    task.Wait(70)
                    local c = New(countdown, 0, 0, left_time)
                    ceil.allCeilDo(function(obj)
                        enemy.changeDeathFunc(obj, D.death.main)
                    end)
                    for _, index in pairs(remove_index_list) do
                        ceil.delByIndex(index)
                    end
                    --标记红色细胞
                    for _, index in pairs(infected_index_list) do
                        ceil.infectedByIndex(index, false, true, left_time + 90)
                    end

                    task.Wait(60)

                    ceil.allCeilDo(function(obj)
                        if obj.infected then
                            B.ghost_colli_effect.create(obj.x, obj.y, COLOR_RED)
                        else
                            B.ghost_colli_effect.create(obj.x, obj.y, COLOR_BLUE)
                        end
                        obj.colli = true
                        enemy.changeDeathFunc(obj, D.death.main)
                    end)

                    --开始计时
                    countdown.start(c)
                    for _ = 1, t do
                        ceil.allCeilDo(alpha_func)
                        task.Wait(1)
                    end
                    ceil.allCeilDo(
                            function(obj)
                                obj._a = 255
                            end
                    )
                    task.Wait(left_time)
                    task.Wait(60 - t)
                    ceil.allCeilDo(boom) --引爆所有
                    task.Wait(next_time)
                end
                return main
            end)
    --endregion

    --若rank有变化，则必须更新一次
    local rank = -1
    local function reFresh()
        local new_rank = system.PowerRank.getRank()
        if rank ~= new_rank then --以下两个会受rank影响，需要更新
            for _, v in pairs(B) do
                v.update(difficulty, new_rank)
            end
            for _, v in pairs(P) do
                v.update(difficulty, new_rank)
            end
            for _, v in pairs(T) do
                v.update(difficulty, new_rank)
            end
            for _, v in pairs(C) do
                v.update(difficulty, new_rank)
            end
            for _, v in pairs(E) do
                v.update(difficulty, new_rank)
            end
            for _, v in pairs(S) do
                v.update(difficulty, new_rank)
            end
            for _, v in pairs(D) do
                v.update(difficulty, new_rank)
            end
            rank = new_rank
        end
    end

    local function bossAction(b)
        task.MoveTo(b, 0, 144, 60, MOVE_NORMAL)
    end

    local function spAchievement(b)
        if b.sc_bonus > 0 and achi then
            --[[local achi_func = switch1(difficulty, {
                function()
                    AchievementReminder.unlock("s6_sc4", "纯粹的自由:Easy", "在不击破任何一个鬼火的前提下，收取 病毒「死神的赠礼」")
                end,
                function()
                    AchievementReminder.unlock("s6_sc4", "纯粹的自由:Easy", "在不击破任何一个鬼火的前提下，收取 病毒「死神的赠礼」")
                    AchievementReminder.unlock("s6_sc4", "纯粹的自由:Normal", "在不击破任何一个鬼火的前提下，收取 病毒「死神的赠礼」")
                end,
                function()
                    AchievementReminder.unlock("s6_sc4", "纯粹的自由:Easy", "在不击破任何一个鬼火的前提下，收取 病毒「死神的赠礼」")
                    AchievementReminder.unlock("s6_sc4", "纯粹的自由:Normal", "在不击破任何一个鬼火的前提下，收取 病毒「死神的赠礼」")
                    AchievementReminder.unlock("s6_sc4", "纯粹的自由:Hard", "在不击破任何一个鬼火的前提下，收取 瘟疫「黑死病传说」")
                end,
                function()
                    AchievementReminder.unlock("s6_sc4", "纯粹的自由:Easy", "在不击破任何一个鬼火的前提下，收取 病毒「死神的赠礼」")
                    AchievementReminder.unlock("s6_sc4", "纯粹的自由:Normal", "在不击破任何一个鬼火的前提下，收取 病毒「死神的赠礼」")
                    AchievementReminder.unlock("s6_sc4", "纯粹的自由:Hard", "在不击破任何一个鬼火的前提下，收取 瘟疫「黑死病传说」")
                    AchievementReminder.unlock("s6_sc4", "纯粹的自由:Lunatic", "在不击破任何一个鬼火的前提下，收取「致潘多拉」")
                end,
            })
            if achi_func then
                achi_func()
            end]]
            achievement.unlock("s6_sc4", true, true)
        end
    end
    
    local names = {
        "name-boss8-card4-E",
        "name-boss8-card4-N",
        "name-boss8-card4-H",
        "name-boss8-card4-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "timespell", --类型
            {55, 55, 55}, --时间
            3200, --耐久
            {50, 50}, --掉落
            function(b) --普通模式攻击前动作
                task.wait(60)
                bossAction(b)
            end,
            function(b) --练习模式攻击前动作
                b.x, b.y = 0, 144
                boss.show_aura(b, true)
            end,
            function(b) --main
                achi = true
                b.colli = false
                boss.show_aura(b, false)
                task.New(b, function()
                    alphaChange(b, 255, 0, 60)
                    b.hide = true
                    b.y = 384
                    New(tips)
                end)
                reFresh()
                --local l = 100
                local len_list = {100, 80, 65, 50} --每波六边形的半径定义
                local left_time_list = {360, 360, 360, 360} --每波六边形的准备时间
                local next_time_list = {240, 300, 285, _infinite} --下一波生成的等待时间
                --会被染成红色的鬼火表
                local infected_index_list_list = {
                    {2, 4, 11, 3, 31, 21},
                    {31, 17, 14, 1, 5, 10, 21},
                    {17, 18, 4, 11, 32, 33, 2, 13, 14},
                    {59, 42, 27, 54, 43, 17, 8, 7, 14, 25, 38, 29, 17, 18, 14, 37, 23, 45, 30, 31, 13, 22, 35, 63, 64, 32, 33, 21, 50, 85, 65, 64, 67, 66, 68, 26, 49}
                }
                --为了优化性能，作特殊处理，这些序号的鬼火在生成后就要被消除（都在屏幕外边）
                local remove_index_list_list = {
                    {44, 45, 29, 43, 25, 46, 28, 42, 27, 41, 16, 26, 40, 15, 25, 39, 38, 24, 37, 23, 36, 35, 34},
                    {44, 45, 29, 43, 25, 42, 27, 41, 26, 40, 25, 39, 38, 37, 23, 36, 35, 60, 59, 58, 57, 56, 55, 54, 53, 52, 51, 50, 49, 64, 63, 62, 61},
                    {44, 25, 27, 41, 26, 40, 25, 39, 36, 60, 59, 58, 57, 56, 55, 54, 53, 52, 51, 62, 61},
                    {104, 82, 106, 103, 81, 61, 83, 107, 105, 102, 57, 56, 55, 96, 78, 77, 76, 75, 101, 100, 99, 98, 97, 95, 72, 52, 70, 91, 94, 71, 92, 93},
                }
                --套娃次数
                local n_list = {5, 6, 6, 8}
                for i = 1, 4 do
                    reFresh()
                    C.FIRST.main(n_list[i], len_list[i], left_time_list[i], next_time_list[i], infected_index_list_list[i], remove_index_list_list[i])
                end
            end,
            function(b) --finish
                spAchievement(b)
                b.y = 144
                b.hide = false
                b._a = 255
                b.colli = false
                boss.show_aura(b, false)
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard
