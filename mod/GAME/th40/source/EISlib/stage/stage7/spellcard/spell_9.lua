-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage7/spellcard/spell_9.lua" --当前存放目录
local newSimpleClass = EGGlib.Class.newSimpleClass
--声明类
local Route = newSimpleClass()
local snake_mouth_unit = newSimpleClass()
local snake_mouth_info = newSimpleClass()
local snake_head = newSimpleClass()
local snake_body_danmuku = newSimpleClass()
local snake_body = newSimpleClass()
local snake = newSimpleClass()
local Size_Controller = newSimpleClass()
--引用方法
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local no_func = function() end
local velch = EGGlib.ObjectEvent.velocityChange
local changeVelocity = EGGlib.ObjectEvent.changeVelocity
local alpAndSizeCh = EGGlib.ObjectEvent.alphaAndSizeChange
local disapear = EGGlib.ObjectEvent.disappear
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local move = EGGlib.ObjectEvent.moveToPlayerDefault
local tranRot = EGGlib.Math.TranRot
local setSize = EGGlib.ObjectEvent.setSize
local aimToTarget = EGGlib.ObjectEvent.aimToTarget
local setV = EGGlib.ObjectEvent.setV
local alphaChange = EGGlib.ObjectEvent.alphaChange
local alphaChangeTask = EGGlib.ObjectEvent.alphaChangeTask
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local aimToPoint = EGGlib.ObjectEvent.aimToPoint
local defaultRenderImg = EGGlib.RenderEffect.defaultRenderImg
local defaultRenderAni = EGGlib.RenderEffect.defaultRenderAni
local setNextCardNoScOpenEffect = EGGlib.BossCard.setNextCardNoScOpenEffect
local Bclass = EISlib.BossDefinition.Gluttony
local movePointWithPar = EGGlib.ObjectEvent.movePointWithPar
local stop = EGGlib.ObjectEvent.stop
local warning_laser = EISlib.Bullet.Laser.warning_laser
local sect_layer1 = EGGlib.BulletGroup.Sector.layer1

--黑洞
local cave = Class(object)
function cave:init(x, y)
    self.x, self.y = x, y
    self.layer = LAYER_BG+1
    self.img = Bclass.cave_ani
    self.hscale, self.vscale = 1, 1
    robject.set_color(self, "", 255, 255, 255, 255)
end
function cave:frame()
    task.Do(self)
end
function cave:render()
    defaultRenderAni(self)
end


local mask = Class(object)
function mask:init()
    self.x, self.y = 0, 0
    self.layer = LAYER_BG+1
    self.img = "white"
    self.hscale, self.vscale = 60, 70
    robject.set_color(self, "", 0, 50, 0, 0)
    task.New(self, function()
        local t = 60
        local d_a = 200/t
        for _ = 1, t do
            self._a = self._a + d_a
            task.Wait(1)
        end
    end)
end
function mask:frame()
    task.Do(self)
end
function mask:render()
    defaultRenderImg(self)
end
function mask:close()
    task.New(self, function()
        local t = 60
        local d_a = -self._a/t
        for _ = 1, t do
            self._a = self._a + d_a
            task.Wait(1)
        end
        Del(self)
    end)
end

--大小控制器
do
    local this = Size_Controller
    this.dphase = 5
    this.SIN_list = {} --事先把要用到的正弦值算好，不必在游戏内实行计算，提高运行效率
    do
        local n = math.ceil(360/this.dphase)
        for i = 0, n do
            this.SIN_list[i + 1] = sin(i*this.dphase) --注意，lua数组是从1开始的，所以这里推荐使用get方法正确访问数组，而不是直接访问，get方法在下面定义
        end
    end
    function this.constructor(self, obj, s, s_range, phase0, t)
        self.s_range = s_range
        self.phase = phase0
        self.size, self.dsize = 0, s/t
        self.size_t = t
        self.timer = 0
        task.New(obj, function()
            local SIN
            while true do
                if self.timer < self.size_t then
                    self.size = self.size + self.dsize
                end
                self.phase = self.phase + this.dphase
                if self.phase >= 360 then
                    self.phase = self.phase - 360
                end
                SIN = this.getSinPhase(self.phase)
                obj.hscale, obj.vscale = self.size*(1 + self.s_range*SIN), self.size*(1 + self.s_range*SIN)
                task.Wait(1)
                self.timer = self.timer + 1
            end
        end)
    end
    function this.sizeChange(self, ds, t)
        self.dsize = ds/t
        self.size_t = t
        self.timer = 0
    end
    --获取相位对应的sin值
    function this.getSinPhase(phase)
        return this.SIN_list[math.floor(phase/this.dphase) + 1]
    end
end



--路径信息
do
    local this = Route
    function this.constructor(self, x, y, rot)
        self.x, self.y, self.rot = x, y, rot
        if rot then
            self.dx, self.dy = cos(rot), sin(rot)
        end
    end

    function this.reset(self, x, y, rot)
        self.x, self.y, self.rot = x, y, rot
        if rot then
            self.dx, self.dy = cos(rot), sin(rot)
        end
    end
end

--构成蛇嘴的弹幕单位
do
    local this = snake_mouth_unit
    --override
    function this.constructor(self, u)
        self.x, self.y, self.rot = -384, 384, 0
        self.u = u
        --嘴唇
        self.main = stg.newSimpleBullet(self.x, self.y, stg.ball_mid, COLOR_RED, true, -2)
        self.main.bound = false
        --牙齿
        self.tooth = stg.newSimpleBullet(self.x, self.y, stg.grain_b, COLOR_DEEP_RED, true, -2.1)
        setSize(self.tooth, 1.5, 0.25)
        self.tooth.bound = false
        self.tooth.rot = self.rot - 90*u
    end
    function this.update(self)
        local main = self.main
        main.x, main.y, main.rot = self.x, self.y, self.rot
        --调整牙齿的位置和朝向
        local rot = self.rot - 90*self.u
        local tooth = self.tooth
        tooth.x, tooth.y, tooth.rot = self.x + 5*cos(rot), self.y + 5*sin(rot), rot
    end
    --通过信息表实例来设置自身位置信息
    function this.setByRoute(self, route)
        self.x, self.y, self.rot = route.x, route.y, route.rot
    end
end

--构成蛇嘴的信息表
do
    local this = snake_mouth_info
    --override
    function this.constructor(self, n, route)
        self.n = n --弹幕数量
        self.route = route --起始坐标
    end
    function this.getN(self)
        return self.n
    end
    function this.getRoute(self)
        return self.route
    end
end

--蛇头
do
    local this = snake_head
    --常规时候嘴巴的排布
    this.normal_mouth_route_list = {
        snake_mouth_info.new(6, Route.new(0, 0)),
        snake_mouth_info.new(6, Route.new(30*cos(80), 30*sin(80))),
        snake_mouth_info.new(1, Route.new(45*cos(60), 45*sin(60), 0)),
        snake_mouth_info.new(6, Route.new(0, 0)),
        snake_mouth_info.new(6, Route.new(30*cos(-80), 30*sin(-80))),
        snake_mouth_info.new(1, Route.new(45*cos(-60), 45*sin(-60), 0)),
    }

    --张口血盆大口
    this.expand_mouth_route_list = {

    }

    --咬下去
    this.bite_mouth_route_list = {

    }

    --override
    function this.constructor(self, x, y)
        self.x, self.y = x, y
        self.rot = 0
        --作为头部的主弹幕
        self.main = stg.newSimpleBullet(x, y, stg.ball_big, COLOR_RED, true, -1)
        self.main.bound = false
        --生成蛇嘴部分
        self.mouth_list = {}
        for i, info in pairs(this.normal_mouth_route_list) do
            for _ = 0, info:getN() - 1 do
                local mouth = snake_mouth_unit.new(-sign(i - 0.5*(#this.normal_mouth_route_list + 1))) --接入嘴巴的接口
                table.insert(self.mouth_list, mouth)
            end
        end
    end
    function this.update(self)
        local main = self.main
        main.x, main.y, main.rot = self.x, self.y, self.rot
        --更新所有嘴单位的位置和方向
        local index, mouth = 1
        local current_route, next_route, rot, dx, dy
        for k, info in pairs(this.normal_mouth_route_list) do
            current_route = info:getRoute()
            if this.normal_mouth_route_list[k+1] then
                next_route = this.normal_mouth_route_list[k+1]:getRoute()
                rot = current_route.rot or Angle(current_route.x, current_route.y, next_route.x, next_route.y)
            else
                next_route = nil
                rot = current_route.rot
            end
            for i = 0, info:getN() - 1 do
                mouth = self.mouth_list[index]
                if next_route then
                    dx, dy = tranRot(
                            current_route.x + i/info:getN()*(next_route.x - current_route.x),
                            current_route.y + i/info:getN()*(next_route.y - current_route.y),
                            self.rot
                    )
                    mouth.x = self.x + dx
                    mouth.y = self.y + dy
                    mouth.rot = rot + self.rot
                else
                    dx, dy = tranRot(
                            current_route.x,
                            current_route.y,
                            self.rot
                    )
                    mouth.x = self.x + dx
                    mouth.y = self.y + dy
                    mouth.rot = rot + self.rot
                end
                mouth:update()
                index = index + 1
            end
        end
    end
    --通过路径实例来设置自身位置信息
    function this.setByRoute(self, route)
        self.x, self.y, self.rot = route.x, route.y, route.rot
    end
    --获取有效的obj对象
    function this.getMain(self)
        return self.main
    end
    --删除
    function this.del(self)
        local obj = self.main
        if IsValid(obj) then
            _del(obj, false)
        end
        for _, obj in pairs(self.mouth_list) do
            if IsValid(obj) then
                _del(obj, true)
            end
        end
        self = nil
    end
end

--用来包裹一节蛇身的单个弹幕
do
    local this = snake_body_danmuku
    --override
    function this.constructor(self, index, master, phase)
        self.x, self.y, self.rot = -384, 384, 0
        self.main = stg.newSimpleBullet(self.x, self.y, stg.ball_mid_c, COLOR_DEEP_RED, true, -2.1)
        self.main.colli = false
        robject.set_color(self.main, "", 0, 255, 255, 255)
        setSize(self.main, 0, 0)
        task.New(self.main, function()
            alphaAndSizeChange(self.main, 255, 1, 30)
            self.main.colli = true
        end)
        self.main.bound = false
        --生成时在屏幕外生成且设为不可见，其帧逻辑由对应体节实例控制
        self.x, self.y = -384, 448
        self.bound = false
        self.index = index --这个不是索引，是该实例在体节的第几位，用于处理横坐标更新
        self.dphase = phase
        self.master = master
        self.phase = master.phase + phase
        self.sin_phase = sin(self.phase)
    end
    function this.update(self)
        self.phase = self.dphase + self.master.phase
        if self.phase >= 360 then
            self.phase = self.phase - 360
        end
        local main = self.main
        main.x, main.y, main.rot = self.x, self.y, self.rot
    end
    function this.getIndex(self)
        return self.index
    end
    function this.getPhase(self)
        return self.phase
    end
    function this.getSinPhase(self)
        return snake.getSinPhase(self:getPhase()) --直接通过相位来访问表查找对应的sin值，不用实时计算
    end
end

--蛇身
do
    local this = snake_body
    this.n = 10 --蛇的一节有 n*2 个弹幕
    --override
    function this.constructor(self, index, master)
        --初始化
        self.master = master
        self.x, self.y = 384, 384
        self.index = index --本体节在蛇的位置（顺序表索引）
        self.length = 100 --本节长度，初始默认为100，之后每帧随相邻节距离更新
        self.width = 15 --本节宽度，对应的是正弦函数的振幅A
        self.rot = 0 --本节朝向，初始默认为0，之后每帧随相邻节角度更新
        self.bullet_list = {}
        local dphase = 180/this.n
        for i = 0, this.n - 1 do
            --上下双螺旋处理
            for j = 0, 1 do
                local obj = snake_body_danmuku.new(i, master, i*dphase + 180*j) --使用组成蛇一个体节的弹幕接口
                table.insert(self.bullet_list, obj)
            end
        end
    end
    function this.update(self)
        local route_list = self.master.route_list
        local index = 1 + (self.index - 1)*self.master.length_time
        local dindex = math.floor(self.master.length_time/this.n)
        local route
        --以下控制每个弹幕行为
        local rate, sin_phase
        local w = self.width
        local dx1, dy1
        local dx2, dy2
        for _, obj in pairs(self.bullet_list) do
            rate = (obj.phase%180)/180*0
            sin_phase = obj:getSinPhase()
            route = route_list[index + (obj.index - 1)*dindex]
            if route then --如果越界了route是不存在的，不作任何操作
                dx1, dy1 = self.length*route.dx, self.length*route.dy --与自身朝向平行的方向
                dx2, dy2 = -route.dy, route.dx --与自身朝向垂直的方向(逆时针转90度 self.rot + 90）
                obj.x, obj.y = route.x + rate*dx1 + w*sin_phase*dx2, route.y + rate*dy1 + w*sin_phase*dy2
            end
            obj:update()
        end
    end
    --使用路径对象来设置位置状态
    function this.setByRoute(self, route0, route1)
        self.x, self.y, self.rot = route0.x, route0.y, route0.rot
        self.length = Dist(route0.x, route0.y, route1.x, route1.y)
    end
    --删除本节体节
    function this.del(self)
        for _, obj in pairs(self.bullet_list) do
            if IsValid(obj) then
                _del(obj, true)
            end
        end
        self = nil
    end
end

--整条蛇
do
    local this = snake
    this.default_length_time = 20 --每个体节间隔的路径数（帧）
    this.dphase = 5 --正弦运动每帧角度增加量
    this.SIN_list = {} --事先把要用到的正弦值算好，不必在游戏内实行计算，提高运行效率
    do
        local n = math.ceil(720/this.dphase)
        for i = 0, n do
            this.SIN_list[i + 1] = sin(i*this.dphase) --注意，lua数组是从1开始的，所以这里推荐使用get方法正确访问数组，而不是直接访问，get方法在下面定义
        end
    end
    function this.constructor(self, x, y, n, body_length_time)
        self.x, self.y = x, y
        self.phase = 0
        self.vx, self.vy = 0, 0
        self.ax, self.ay = 0, 0
        self.rot = 0
        self.head = snake_head.new(x, y) --创建蛇头
        self.body_list = {} --创建蛇身
        --走过的路径表,记录三个变量 横坐标 纵坐标 朝向，越靠前的记录越新
        self.route_list = {}
        table.insert(self.route_list, 1, Route.new(self.x, self.y, self.rot)) --至少初始化一条记录，不然初始时蛇如果不动会报错
        self.last_x, self.last_y = x, y --记录上一帧的位置的变量，用于比较当前帧的位置，然后决定蛇是前进还是不动
        --蛇身采用顺序表逻辑，一个接一个
        this.setKnot(self, n)
        --[[for i = 1, n do
            self.body_list[i] = snake_body.new(i, self)
        end]]
        self.length_time = body_length_time or this.default_length_time  --每个体节间隔的路径数
    end
    function this.update(self)
        --相位逻辑，用于处理各体节正弦运动情况
        self.phase = self.phase + this.dphase
        if self.phase >= 360 then
            self.phase = self.phase - 360
        end
        --基础运动逻辑
        self.vx, self.vy = self.vx + self.ax, self.vy + self.ay
        self.x, self.y = self.x + self.vx, self.y + self.vy
        task.Do(self)
        local head = self:getHead()
        --更新路径表
        self:updateRouteList()
        local index = 1 --对路径表的索引 self.route_list
        --以下是对头进行的更新
        head:setByRoute(self.route_list[index])
        head:update()
        --以下是对各体节的更新
        local body
        local max_index = #self.route_list
        for i = 1, #self.body_list do
            body = self.body_list[i]
            index = index + self.length_time --索引值增加
            if index <= max_index then --越界检测
                body:setByRoute(self.route_list[index], self.route_list[index - self.length_time]) --不用担心， index - self.length_time 无论如何也不可能越界
            end
            body:update()
        end
    end
    --获取蛇头
    function this.getHead(self)
        return self.head
    end
    --获取蛇身表
    function this.getBodyList(self)
        return self.body_list
    end
    --更新路径表
    function this.updateRouteList(self)
        --位置发生变化就要记录
        if self.x ~= self.last_x or self.y ~= self.last_y then
            self.rot = Angle(self.last_x, self.last_y, self.x, self.y)
            --SystemLog(string.format("last_x:%f, last_y:%f, x:%f, y:%f, rot:%f", self.last_x, self.last_y, self.x, self.y, self.rot))
            --记录到路径表上
            table.insert(self.route_list, 1, Route.new(self.x, self.y, self.rot))
            self.last_x, self.last_y = self.x, self.y
        end
        --丢弃无用的路径
        for _ = max(self.length_time + 1, #self.body_list*self.length_time + 1), #self.route_list do
            table.remove(self.route_list)
        end
    end
    --初始化路径表
    function this.initRouteList(self)
        for _, route in pairs(self.route_list) do
            route:reset(-999, 0, 0)
        end
    end
    --长出一节
    function this.addKnot(self)
        table.insert(self.body_list, snake_body.new(#self.body_list, self))
    end
    --设置蛇的节数
    function this.setKnot(self, n)
        if n > #self.body_list then
            for i = #self.body_list, n do
                self.body_list[i] = snake_body.new(i, self)
            end
        else
            for i = n + 1, #self.body_list do
                self.body_list[i]:del()
            end
        end
    end
    --获取相位对应的sin值
    function this.getSinPhase(phase)
        return this.SIN_list[math.floor(phase/this.dphase) + 1]
    end
    function this.del(self)
        self:getHead():del()
        for _, body in pairs(self.body_list) do
            body:del()
        end
        self = nil
    end
end



local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    local cat_king
    local snake_inst
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
    --region Bullet 自定义子弹
    --猫王控制者
    B.cat_king_controller = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y)
                    local obj = stg.newBullet(x, y, stg.arrow_big, COLOR_RED, true)
                    obj.hide = true
                    obj.bound = false
                    obj.group = GROUP_ENEMY
                    obj.colli = false
                    obj.hp = 999999
                    cat_king = obj
                end
                return create
            end
    )

    --内脏
    B.ceil = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local radius = 5 --单个活动半径
                local function create(dx0, dy0, x, y, a, layer)
                    local obj = stg.newSimpleBullet(cat_king.x + dx0, cat_king.y + dy0, stg.ball_mid, COLOR_RED, true)
                    obj.group = GROUP_GHOST
                    obj.bound = false
                    robject.set_color(obj, "mul+add", 255, 100, 0, 0)
                    setSize(obj, 0, 0)
                    obj.size_controller = Size_Controller.new(obj, 4.5, 0.3, ran:Int(0, 360), 1)
                    --向外膨胀
                    task.New(obj, function()
                        local t = 30
                        local dx, dy = cos(a), sin(a)
                        local v = 1*layer
                        local dv = -v/t
                        for _ = 1, t do
                            v = v + dv
                            dx0, dy0 = dx0 + v*dx, dy0 + v*dy
                        end
                    end)
                    --鬼畜抖动+跟随
                    task.New(obj, function()
                        local dx, dy, a
                        for _ = 1, 30 do
                            a = ran:Float(0, 360)
                            dx, dy = 2*cos(a), 2*sin(a)
                            --预移动，判断情况，限制范围
                            if Dist(0, 0, x + dx, y + dy) >= radius then
                                dx, dy = -dx, -dy
                            end
                            x, y = x + dx, y + dy
                            obj.x, obj.y = cat_king.x + dx0 + x, cat_king.y + dy0 + y
                            task.Wait(1)
                        end
                        local t = ran:Int(60, 90)
                        velchTask(obj, ran:Float(5, 10), 2, ran:Float(0, 360), t)
                        obj.size_controller:sizeChange(ran:Float(2, 4), t + 60)
                        alphaChangeTask(obj, 255, 0, t + 120)
                        task.Wait(t)
                        aimToPoint(obj, 0, 270, 3, 60, 0.2)
                        task.Wait(60)
                        _del(obj, false)
                    end)
                end
                return create
            end
    )


    --贪吃蛇的食物
    B.ceil2 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local radius = 10 --单个活动半径
                local SIN, COS = {}, {}
                for i = 1, 360 do
                    SIN[i] = sin(i)
                    COS[i] = cos(i)
                end
                local function create(x0, y0)
                    local obj = stg.newSimpleBullet(x0, y0, stg.ball_mid, COLOR_RED, true)
                    robject.set_color(obj, "", 100, 255, 255, 255)
                    obj.colli = false
                    setSize(obj, 0, 0)
                    obj.size_controller = Size_Controller.new(obj, 1, 0.1, ran:Int(0, 180), 30)
                    --鬼畜抖动+跟随
                    task.New(obj, function()
                        local x, y, dx, dy, a = 0, 0
                        for _ = 1, _infinite do
                            a = ran:Int(1, 360)
                            dx, dy = 0.2*COS[a], 0.2*SIN[a]
                            --预移动，判断情况，限制范围
                            if Dist(0, 0, x + dx, y + dy) >= radius then
                                dx, dy = -dx, -dy
                            end
                            x, y = x + dx, y + dy
                            obj.x, obj.y = x0 + x, y0 + y
                            task.Wait(1)
                        end
                    end)
                    task.New(obj, function()
                        task.Wait(120)
                        alphaChange(obj, 100, 255, 30)
                        obj.colli = true
                    end)
                    return obj
                end
                return create
            end
    )

    --二阶段蛇从洞里突袭
    B.cave = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, wt)
                    local obj = New(cave, x, y)
                    setSize(obj, 1, 0)
                    --形变逻辑
                    task.New(obj, function()
                        --出现效果
                        local t = 45
                        local phase = 120
                        local dphase = phase/t
                        local v = 0
                        local dv = 2/t*sin(phase)
                        phase = 0
                        for _ = 1, t do
                            v = v + dv
                            phase = phase + dphase
                            obj.vscale = v*sin(phase)
                            task.Wait(1)
                        end
                        task.Wait(wt)
                        --消失效果
                        t = 45
                        dv = -2*obj.vscale/t
                        local d_dv = -dv/t
                        for _ = 1, t do
                            dv = dv + d_dv
                            v = v + dv
                            obj.vscale = v
                            task.Wait(1)
                        end
                        _del(obj, false)
                    end)
                end
                return create
            end
    )

    --预警线
    B.warning_laser = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, a)
                    local obj = New(warning_laser,
                            x, y,
                            600, 10, 10, 10, a, --len, l_t, wide, w_t, a
                            "", Color(255, 255, 0, 0), --blend, color
                            60 --disappear
                    )
                    warning_laser.setTrailLength(obj, 40)
                end
                return create
            end
    )
    --endregion
    --region 子弹发射点定义
    --开花弹攻击
    P.circle1 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = 2.7*defaultSwitchVelocityByRank(rank)
                local dv = 0.9*defaultSwitchVelocityByRank(rank)
                local way = 18 + switch(rank, {
                    0, 0, 0, 0, 2
                })
                local dlayer = switch(rank, {
                    4, 4, 4, 4, 2
                })
                local style, color = stg.ball_big, COLOR_ORANGE
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, 0, v, a, 60, 0, style, color, true)
                end
                local function attack(x, y, a, layer)
                    layer = math.ceil(layer/dlayer)
                    PlaySound("kira00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(x, y, v, a, way, layer, dv, 0, 0, bullet_func)
                            end)
                end
                return attack
            end
    )

    --p2逼走位的大玉
    P.ball_big_p2 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local layer = 6
                local number = 15
                local v = 3*defaultSwitchVelocityByRank(rank)
                local dv = 0.5*defaultSwitchVelocityByRank(rank)
                local style, color = stg.ball_huge, COLOR_RED
                local function attack(x, y, x_range)
                    PlaySound("kira00")
                    local dx = x_range/(number - 1)
                    local n = (number - 1)/2
                    for i = -n, n do
                        B.warning_laser.create(x + dx*i, y, -90)
                        for j = 0, layer - 1 do
                            robject.set_color(stg.newStrChV(x + dx*i, y, 0, v + dv*j, -90, 180, 0, style, color, true), "mul+add", 255, 255, 255, 255)
                        end
                    end
                end
                return attack
            end
    )

    --p3逼走位的大玉
    P.ball_big_p3 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local layer = 6
                local number = 15
                local v = 3*defaultSwitchVelocityByRank(rank)
                local dv = 0.5*defaultSwitchVelocityByRank(rank)

                local style, color = stg.ball_huge, COLOR_ORANGE
                local function attack()
                    PlaySound("kira00")
                    local x, y = -100, -245
                    local x_range = 300
                    local dx = x_range/(number - 1)
                    local n = (number - 1)/2
                    for i = -n, n do
                        B.warning_laser.create(x + dx*i, y, 90)
                        for j = 0, layer - 1 do
                            robject.set_color(stg.newStrChV(x + dx*i, y, 0, v + dv*j, 90, 180, 0, style, color, true), "mul+add", 255, 255, 255, 255)
                        end
                    end

                    local x, y = -224, -125
                    local y_range = 448
                    local dy = y_range/(number - 1)
                    local n = (number - 1)/2
                    for i = -n, n do
                        B.warning_laser.create(x, y + dy*i, 0)
                        for j = 0, layer - 1 do
                            robject.set_color(stg.newStrChV(x, y + dy*i, 0, v + dv*j, 0, 180, 0, style, color, true), "mul+add", 255, 255, 255, 255)
                        end
                    end
                end
                return attack
            end
    )

    --p2的椭弹
    P.ellipse_p2 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.ellipse, COLOR_ORANGE
                local v = 4*defaultSwitchVelocityByRank(rank)
                local dv = 2*defaultSwitchVelocityByRank(rank)
                local layer = switch(rank, {
                    1, 1, 1, 1, 2
                })
                local way = switch(rank, {
                    1, 1, 1, 1, 3
                })
                local da = switch(rank, {
                    0, 0, 0, 0, 60
                })
                local a_range = switch(rank, {
                    5, 5, 5, 5, 10
                })
                local function bullet_func(x, y, v, a)
                    stg.setBoundTime(stg.newStrChV(x, y, 0, v, a + ran:Float(-0.5*a_range, 0.5*a_range), 30, 0, stg.ellipse, COLOR_ORANGE, true), 60)
                end
                local function attack(x, y, a)
                    PlaySound("kira00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                sect_layer1(x, y, v, a, way, da, --base
                                        layer, dv, 0, --layer, dv_l, da_l
                                        bullet_func
                                )
                                circle_layer1(x, y, v, a, 1, layer, dv, 0, 0, bullet_func)
                            end)
                end
                return attack
            end
    )

    --p3的鳞弹
    P.arrow_big_p3 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.arrow_big, COLOR_ORANGE
                local v = 1*defaultSwitchVelocityByRank(rank)
                local dv = 0.2*defaultSwitchVelocityByRank(rank)
                local layer = switch(rank, {
                    1, 1, 1, 1, 2
                })
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, 0, v, a, 60, 0, style, color, true)
                end
                local function attack(x, y, a)
                    PlaySound("kira00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(x, y, v, a, 3, layer, dv, 0, 0, bullet_func)
                            end)
                end
                return attack
            end
    )
    --endregion
    --region 自定义敌人
    --endregion
    --region Tasker 任务执行器
    --endregion
    --region 组合攻击
    --第一阶段：蛇变长并且来回变向追逐自机
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local function main(b)
                    --存放血肉细胞刷新点的表
                    local ceil_list = {}
                    --画# 更新#
                    local Ceil = newSimpleClass()
                    do
                        local this = Ceil
                        --override
                        function this.constructor(self, x, y)
                            self.x, self.y = x, y
                            self.bullet = B.ceil2.create(x, y)
                            self.cd = 240
                            self.timer = self.cd + 1
                        end
                        function this.update(self)
                            if self.timer < self.cd then
                                self.timer = self.timer + 1
                            elseif self.timer == self.cd then --生成弹幕
                                self.timer = self.timer + 1
                                self.bullet = B.ceil2.create(self.x, self.y)
                            elseif not IsValid(self.bullet) then --重置cd
                                self.timer = 0
                            end
                        end
                        function this.getBullet(self)
                            return self.bullet
                        end
                        function this.del(self)
                            local obj = self:getBullet()
                            if IsValid(obj) then
                                _del(obj, true)
                            end
                            self = nil
                        end
                    end

                    local x0, y0 = 7, 0
                    local d = 42
                    local col, row = 450/(d+1), 550/d
                    col = (col - 1)/2
                    row = (row - 1)/2
                    for i = -col, col do
                        for j = -row, row do
                            table.insert(ceil_list, Ceil.new(x0 + d*i, y0 + d*j))
                        end
                    end


                    --血肉细胞更新
                    local function updateCeilList()
                        for _, ceil in pairs(ceil_list) do
                            ceil:update()
                            local obj = ceil:getBullet()
                            if IsValid(obj) and obj.colli and not obj.attract and Dist(snake_inst.x, snake_inst.y, obj.x, obj.y) < 60 then
                                task.clear(obj)
                                obj.attract = true
                                task.New(obj, function()
                                    local t = 60
                                    local v, a, dv = Dist(0, 0, obj.vx, obj.vy), Angle(0, 0, obj.vx, obj.vy), 20/t
                                    for _ = 1, t do
                                        if Dist(snake_inst.x, snake_inst.y, obj.x, obj.y) > 20 then
                                            v = v + dv
                                            a = Angle(obj.x, obj.y, snake_inst.x, snake_inst.y)
                                            setV(obj, v, a)
                                        else
                                            break
                                        end
                                        task.Wait(1)
                                    end
                                    _del(obj, true)
                                end)
                            end
                        end
                    end

                    local end_signal = false --本阶段逻辑结束的信号
                    --本阶段额外帧逻辑
                    task.New(b, function()
                        while not end_signal do
                            updateCeilList()
                            task.Wait(1)
                        end
                    end)

                    --操纵蛇
                    velch(snake_inst, 1, 0.2, -90, 60, 60)
                    reFresh()
                    task.Wait(60)
                    velch(snake_inst, 0, 0.8, -90, 60)
                    for i = 1, 10 do
                        P.circle1.attack(snake_inst.x, snake_inst.y, Angle(snake_inst.x, snake_inst.y, player.x, player.y), i)
                        PlaySound("gluttony00")
                        aimToTarget(snake_inst, player, 4, 60, 0.1)
                        velch(snake_inst, 0, -4, snake_inst.rot, 30)
                        snake_inst:addKnot()
                        task.Wait(30)
                    end
                    velch(snake_inst, 0, 6, snake_inst.rot, 60)
                    task.Wait(240)
                    end_signal = true --本阶段逻辑结束
                    --销毁本阶段的弹幕及其生成点
                    for _, ceil in pairs(ceil_list) do
                        ceil:del()
                    end
                    task.Wait(60)
                end
                return main
            end)

    --第二阶段，蛇从左右版快速向自机发起突袭！
    C.SECOND = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local x_side = 800 --蛇头会从x多少的地方出现
                local function main(b, test)
                    --[[if test then
                        snake_inst:setKnot(10)
                    end]]
                    --为蛇每节装上发弹装置
                    local Attacker = newSimpleClass()
                    do
                        local this = Attacker
                        this.min_intv = 5 --最小攻击间隔
                        this.max_intv = 10 --最大攻击间隔
                        function this.constructor(self, body)
                            self.next_attack = 60 + ran:Int(this.min_intv, this.max_intv)
                            self.body = body --附属的蛇身
                        end
                        function this.update(self)
                            self.next_attack = self.next_attack - 1
                            if self.next_attack <= 0 then
                                local body = self.body
                                --PlaySound("tan00")
                                P.ellipse_p2.attack(body.x, body.y, Angle(body.x, body.y, player.x, player.y))
                                self.next_attack = ran:Int(this.min_intv, this.max_intv)
                            end
                        end
                        function this.getBody(self)
                            return self.body
                        end
                    end


                    --画# 更新#
                    local Ceil = newSimpleClass()
                    do
                        local this = Ceil
                        this.list = {}
                        --override
                        function this.constructor(self, x, y)
                            self.x, self.y = x, y
                            self.bullet = nil
                            self.cd = 420
                            self.timer = self.cd - 60
                        end
                        function this.update(self)
                            if self.timer < self.cd then
                                self.timer = self.timer + 1
                            elseif self.timer == self.cd then --生成弹幕
                                self.timer = self.timer + 1
                                self.bullet = B.ceil2.create(self.x, self.y)
                            elseif not IsValid(self.bullet) then --重置cd
                                self.timer = 0
                            end
                        end
                        function this.getBullet(self)
                            return self.bullet
                        end
                        function this.del(self)
                            local obj = self:getBullet()
                            if IsValid(obj) then
                                _del(obj, true)
                            end
                            self = nil
                        end
                        --消除本阶段弹幕生成点
                        function this.clearAllCeil()
                            for _, ceil in pairs(this.list) do
                                ceil:del()
                            end
                        end
                    end



                    local end_signal = false
                    --本阶段蛇的逻辑
                    task.New(b, function()
                        --为蛇每节装上发弹装置
                        local body_list = snake_inst:getBodyList()
                        local attacker_list = {}
                        do
                            for _, body in pairs(body_list) do
                                table.insert(attacker_list, Attacker.new(body))
                            end
                        end
                        --设置血肉细胞生成点
                        --存放血肉细胞刷新点的表
                        --local ceil_list = {}
                        local ceil_list = Ceil.list
                        local updateCeilList
                        do
                            local x0, y0 = 30, 0
                            local dx, dy = 100, switch(rank, {
                                10, 10, 10, 10, 5
                            })
                            local col, row = 384/dx, 448/dy
                            col = (col - 1)/2
                            row = (row - 1)/2
                            for i = -col, col do
                                for j = -row, row do
                                    table.insert(ceil_list, Ceil.new(x0 + dx*i, y0 + dy*j))
                                end
                            end

                            --血肉细胞更新
                            function updateCeilList()
                                for _, ceil in pairs(ceil_list) do
                                    ceil:update()
                                    local obj = ceil:getBullet()
                                    if IsValid(obj) and obj.colli and not obj.attract and Dist(snake_inst.x, snake_inst.y, obj.x, obj.y) < 60 then
                                        task.clear(obj)
                                        obj.attract = true
                                        task.New(obj, function()
                                            local t = 60
                                            local v, a, dv = Dist(0, 0, obj.vx, obj.vy), Angle(0, 0, obj.vx, obj.vy), 20/t
                                            for _ = 1, t do
                                                if Dist(snake_inst.x, snake_inst.y, obj.x, obj.y) > 20 then
                                                    v = v + dv
                                                    a = Angle(obj.x, obj.y, snake_inst.x, snake_inst.y)
                                                    setV(obj, v, a)
                                                else
                                                    break
                                                end
                                                task.Wait(1)
                                            end
                                            _del(obj, true)
                                        end)
                                    end
                                end
                            end
                        end

                        local body
                        while not end_signal do
                            for _, attacker in pairs(attacker_list) do
                                body = attacker:getBody()
                                --只有对应的身子进入范围了才会执行发射器的帧逻辑
                                if body.x > -192 and body.x < 192 then
                                    attacker:update()
                                end
                            end
                            --血肉细胞生成更新逻辑
                            updateCeilList()
                            task.Wait(1)
                        end
                    end)
                    local u, y
                    stop(snake_inst)
                    snake_inst:initRouteList() --把蛇的所有轨迹位置更新到 x = -999， y = 0 ， 目的是为了不让attacker触发update，以防止上一阶段如果是在上边或下边离场的蛇会在第一轮发弹幕
                    --先发一大排大玉逼迫玩家走到正确的位置
                    P.ball_big_p2.attack(-50, 245, 300)
                    task.Wait(120)
                    reFresh()
                    task.Wait(60)
                    --蛇撞人逻辑
                    for i = 1, 6 do
                        y = player.y
                        u = tranU(i)
                        snake_inst.x, snake_inst.y = -x_side*u, y - 200*u
                        PlaySound("gluttony00")
                        B.cave.create(-192*u, y, 240)
                        movePointWithPar(snake_inst, x_side*u, y - 200*u, 4*u, 240, u)
                    end
                    setV(snake_inst, 1, 180)
                    task.Wait(180)
                    end_signal = true
                    --销毁本阶段的弹幕及其生成点
                    Ceil.clearAllCeil()
                    --销毁这条蛇
                    snake_inst:del()
                end
                return main
            end)

    --第三阶段，紧跟着+S形追人
    C.THIRD = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local function main(b)
                    snake_inst = snake.new(-224, 180, 30, 60) --创建了一条新蛇
                    if true then
                        snake_inst:setKnot(60)
                    end
                    --为蛇每节装上发弹装置
                    local Attacker = newSimpleClass()
                    do
                        local this = Attacker
                        this.min_intv = 150 --最小攻击间隔
                        this.max_intv = 150 --最大攻击间隔
                        function this.constructor(self, body)
                            self.next_attack = ran:Int(this.min_intv, this.max_intv)
                            self.body = body --附属的蛇身
                        end
                        function this.update(self)
                            self.next_attack = self.next_attack - 1
                            if self.next_attack <= 0 then
                                local body = self.body
                                PlaySound("tan00")
                                if Dist(0, 0, body.x, body.y) > 60 then --以0, 0为圆心，在任意蛇身进入半径60的圆内，不再产生新的鳞弹
                                    P.arrow_big_p3.attack(body.x, body.y, Angle(body.x, body.y, player.x, player.y))
                                end
                                self.next_attack = ran:Int(this.min_intv, this.max_intv)
                            end
                        end
                        function this.getBody(self)
                            return self.body
                        end
                    end


                    --画# 更新#
                    local Ceil = newSimpleClass()
                    do
                        local this = Ceil
                        this.list = {}
                        --override
                        function this.constructor(self, x, y)
                            self.x, self.y = x, y
                            self.bullet = nil
                            self.cd = 9999
                            self.timer = self.cd - 60
                        end
                        function this.update(self)
                            if self.timer < self.cd then
                                self.timer = self.timer + 1
                            elseif self.timer == self.cd then --生成弹幕
                                self.timer = self.timer + 1
                                self.bullet = B.ceil2.create(self.x, self.y)
                            elseif not IsValid(self.bullet) then --重置cd
                                self.timer = 0
                            end
                        end
                        function this.getBullet(self)
                            return self.bullet
                        end
                        function this.del(self)
                            local obj = self:getBullet()
                            if IsValid(obj) then
                                _del(obj, true)
                            end
                            self = nil
                        end
                        --消除本阶段弹幕生成点
                        function this.clearAllCeil()
                            for _, ceil in pairs(this.list) do
                                ceil:del()
                            end
                        end
                    end

                    --为这条蛇装上摆动器
                    local Swinger = newSimpleClass()
                    do
                        local this = Swinger
                        this.dphase = 5
                        this.SIN_list = {}
                        local n = math.ceil(360/this.dphase)
                        for i = 0, n do
                            this.SIN_list[i+1] = sin(i*this.dphase)
                        end
                        this.amplitude = 15
                        function this.constructor(self, snake)
                            self.amplitude = 15
                            self.x, self.y = snake.x, snake.y
                            self.vx, self.vy, self.ax, self.ay = 0, 0, 0, 0 --实现运动接口
                            self.phase = 0
                            self.snake = snake --被操纵的蛇
                        end
                        function this.update(self)
                            self.vx, self.vy = self.vx + self.ax, self.vy + self.ay
                            self.x, self.y = self.x + self.vx, self.y + self.vy
                            self.rot = Angle(0, 0, self.vx, self.vy)
                            self.phase = self.phase + self.dphase
                            if self.phase >= 360 then
                                self.phase = self.phase - 360
                            end
                            local snake = self.snake
                            local dx, dy = 0, self.amplitude*self:getSinPhase()
                            dx, dy = tranRot(dx, dy, self.rot)
                            snake.x, snake.y = self.x + dx, self.y + dy
                        end
                        function this.getSinPhase(self)
                            return this.SIN_list[math.floor(self.phase/this.dphase) + 1]
                        end
                        function this.setAmplitude(self, a)
                            self.amplitude = a
                        end
                    end

                    local end_signal = false
                    --本阶段蛇的逻辑
                    task.New(b, function()
                        --为蛇每节装上发弹装置
                        local body_list = snake_inst:getBodyList()
                        local attacker_list = {}
                        do
                            for _, body in pairs(body_list) do
                                table.insert(attacker_list, Attacker.new(body))
                            end
                        end
                        --设置血肉细胞生成点
                        --存放血肉细胞刷新点的表
                        local ceil_list = Ceil.list
                        local updateCeilList
                        do
                            local x0, y0 = 0, -10
                            local dx, dy = 20, 20
                            local col, row = 340/dx, 380/dy
                            col = (col - 1)/2
                            row = (row - 1)/2
                            for i = -col, col do
                                for j = -row, row do
                                    table.insert(ceil_list, Ceil.new(x0 + dx*i, y0 + dy*j))
                                end
                            end

                            --血肉细胞更新
                            function updateCeilList()
                                for _, ceil in pairs(ceil_list) do
                                    ceil:update()
                                    local obj = ceil:getBullet()
                                    if IsValid(obj) and obj.colli and not obj.attract and Dist(snake_inst.x, snake_inst.y, obj.x, obj.y) < 60 then
                                        task.clear(obj)
                                        obj.attract = true
                                        task.New(obj, function()
                                            local t = 60
                                            local v, a, dv = Dist(0, 0, obj.vx, obj.vy), Angle(0, 0, obj.vx, obj.vy), 20/t
                                            for _ = 1, t do
                                                if Dist(snake_inst.x, snake_inst.y, obj.x, obj.y) > 20 then
                                                    v = v + dv
                                                    a = Angle(obj.x, obj.y, snake_inst.x, snake_inst.y)
                                                    setV(obj, v, a)
                                                else
                                                    break
                                                end
                                                task.Wait(1)
                                            end
                                            _del(obj, true)
                                        end)
                                    end
                                end
                            end
                        end

                        local body
                        while not end_signal do
                            for _, attacker in pairs(attacker_list) do
                                body = attacker:getBody()
                                --只有对应的身子进入范围了才会执行发射器的帧逻辑
                                if body.x > -192 and body.x < 192 then
                                    attacker:update()
                                end
                            end
                            --血肉细胞生成更新逻辑
                            updateCeilList()
                            task.Wait(1)
                        end
                    end)
                    stop(snake_inst)
                    snake_inst.x, snake_inst.y = -224, 180
                    task.Wait(60)
                    --先发一大排大玉逼迫玩家走到正确的位置
                    reFresh()
                    task.Wait(120)
                    PlaySound("gluttony00")
                    --这卡开着音效打一晚上谁受得了啊.jpg
                    task.New(b, function()
                        while true do
                            PlaySound("gluttony01")
                            task.Wait(330)
                        end
                    end)
                    B.cave.create(-192, 180, 1500)
                    task.Wait(60)
                    --蛇追人逻辑
                    local swinger = Swinger.new(snake_inst) --为蛇装上扭动器
                    local t = 2160
                    local a = 180
                    local r = 280
                    local amplitude_rate = 15/280
                    local dr = (35 - r)/t
                    local da
                    if rank == 4 then
                        da = -1440/t
                    else
                        da = -1080/t
                    end
                    for i = 1, t do
                        r = r + dr
                        a = a + da
                        --setV(swinger, v, a)
                        swinger:setAmplitude(r*amplitude_rate) --振幅与半径相关
                        swinger.x, swinger.y = r*cos(a), r*sin(a)
                        swinger:update()
                        if i > t - 90 then
                            if player.death == 90 then
                                achievement.unlock("s7_sc9", true, true)  -- AchievementReminder.unlock("s7_sc9", "最后一颗猫粮")
                            end
                        end
                        task.Wait(1)
                    end
                    end_signal = true
                    Ceil.clearAllCeil()
                end
                return main
            end)
    --endregion

    local function bossAction(b)
        --创建猫王
        B.cat_king_controller.create(0, 300)
        local da, way
        local list = {}
        local num_list = {}
        local index, a0, r, a
        effect.shakeScreen(270, 10)
        for i = 0, 7 do
            a0 = ran:Float(0, 360)
            way = 6+4*i
            da = 360/way
            for j = 1, way do
                list[j] = j
            end
            for j = 1, #list do
                index = ran:Int(1, #list)
                num_list[j] = list[index]
                table.remove(list, index)
            end
            for j = 1, #num_list do
                r = 25 + 20*i
                a = a0 + da*num_list[j]
                B.ceil.create(r*cos(a), r*sin(a), 0, 0, a, i)
            end
        end
        --整体向上偏移
        task.New(cat_king, function()
            task.MoveTo(cat_king, 0, 600, 180, MOVE_ACCEL)
        end)
        task.Wait(90)
        task.Wait(30)
        b.absorbEffect(b, 60, 0, 224)
        b.breakEffect(b, 0, 0, 224)
        --生成蛇的演出
        setNextCardNoScOpenEffect(b)
    end

    local card = EGGlib.BossCard.createFullCard(
            "name-boss9-card9", -- 「耶梦加得游戏」
            "timespell", --类型
            {100, 100, 100}, --时间
            1800, --耐久
            {50, 50}, --掉落
            function(b) --普通模式攻击前动作
                bossAction(b)
                PlaySound("cat02")
            end,
            function(b) --练习模式攻击前动作
                New(mask)
                b.hide = true
                b.colli = false
                b.x, b.y = 0, 144
                boss.show_aura(b, false)
                bossAction(b)
                PlaySound("cat02")
            end,
            function(b) --main
                reFresh()
                snake_inst = snake.new(0, 270, 0)
                --蛇的帧逻辑
                task.New(b, function()
                    while true do
                        snake_inst:update()
                        task.Wait(1)
                    end
                end)
                C.FIRST.main(b)
                reFresh()
                C.SECOND.main(b)
                reFresh()
                C.THIRD.main(b)
            end,
            function(b) --finish
                if player.death >= 90 then --补充一层判断
                    achievement.unlock("s7_sc9", true, true)  -- AchievementReminder.unlock("s7_sc9", "最后一颗猫粮")
                end
                b.hide = false
                b.colli = true
                if IsValid(cat_king) then
                    Del(cat_king)
                end
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard
