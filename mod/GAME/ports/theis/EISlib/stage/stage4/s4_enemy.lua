s4_road = {}

local E
local _m, _a, _b, _c, _d, _e, _f, _s, _o, _road = {}, {}, {}, {}, {}, {}, {}, {}, {}
E = {_m, _a, _b, _c, _d, _e, _f, _s, _o, _road}
local dec_dmg
--boss加载
local path = "EISlib/stage/stage4/"
Include(path .. "s4_boss_defined.lua")
--资源加载
do
    local path = "res/stage/stage4/s4title/"
    --local path = ""
    LoadImageFromFile("s4_t1", path .. "s4_t1.png")
    LoadImageFromFile("s4_t2", path .. "s4_t2.png")
    LoadImageFromFile("s4_t3", path .. "s4_t3.png")
    LoadImageFromFile("s4_t4", path .. "s4_t4.png")
    LoadImageFromFile("s4_t5", path .. "s4_t5.png")
    local path= "res/bullet/"
    LoadTexture("s4_road_ls", path.."laser4.png")
    LoadImage("s4_road_ls_blue", "s4_road_ls", 0, 5*16, 256, 16)
end
----------------------------------标题
local s4_title
do
    local s4_t1=Class(_object)
    s4_t1.init=function(self,_x,_y,size)
        self.x,self.y=_x,_y
        self.img="s4_t1"
        self.layer=LAYER_BG+2
        self.group=GROUP_GHOST
        self.hide=false
        self.bound=true
        self.navi=false
        self.hp=10
        self.maxhp=10
        self.colli=true
        self._servants={}
        self._blend,self._a,self._r,self._g,self._b='',255,255,255,255
        self.hscale, self.vscale = size, size
        self.rot = -30
        self.x = self.x + 30*size
        _object.set_color(self,"",0,255,255,255)
        lasttask=task.New(self,function()
            do local x,_d_x=(0),(1/59) for _=1,60 do
                self.rot = -30 + 30*x
                self.x = self.x - 0.5*size
                _object.set_color(self,"",255*x,255,255,255)
                task._Wait(1)
                x=x+_d_x end end
            task._Wait(200)
            do local x,_d_x=(1),(-1/179) for _=1,180 do
                _object.set_color(self,"",255*x,255,255,255)
                task._Wait(1)
                x=x+_d_x end end
            _del(self,false)
        end)
    end
    local s4_t2=Class(_object)
    s4_t2.init=function(self,_x,_y,size)
        self.x,self.y=_x,_y
        self.img="s4_t2"
        self.layer=LAYER_BG+2
        self.group=GROUP_GHOST
        self.hide=false
        self.bound=true
        self.navi=false
        self.hp=10
        self.maxhp=10
        self.colli=true
        self._servants={}
        self._blend,self._a,self._r,self._g,self._b='',255,255,255,255
        self.hscale, self.vscale = size, size
        _object.set_color(self,"",0,255,255,255)
        self.x, self.y = self.x + 60*size, self.y + 30*size
        lasttask=task.New(self,function()
            task._Wait(160)
            do local x,_d_x=(0),(1/59) for _=1,60 do
                self.x, self.y = self.x - size, self.y - 0.5*size
                _object.set_color(self,"",255*x,255,255,255)
                task._Wait(1)
                x=x+_d_x end end
            task._Wait(40)
            do local x,_d_x=(1),(-1/119) for _=1,120 do
                _object.set_color(self,"",255*x,255,255,255)
                task._Wait(1)
                x=x+_d_x end end
            _del(self,false)
        end)
    end
    local s4_t3=Class(_object)
    s4_t3.init=function(self,_x,_y,size)
        self.x,self.y=_x,_y
        self.img="s4_t3"
        self.layer=LAYER_BG+2
        self.group=GROUP_GHOST
        self.hide=false
        self.bound=true
        self.navi=false
        self.hp=10
        self.maxhp=10
        self.colli=true
        self._servants={}
        self._blend,self._a,self._r,self._g,self._b='',255,255,255,255
        self.hscale, self.vscale = 1.25*size, 1.25*size
        _object.set_color(self,"",0,255,255,255)
        New(egg.trail, self, 10, 1, nil, 1, "", 200)
        lasttask=task.New(self,function()
            task._Wait(200)
            do local x,_d_x=(0),(1/59) for _=1,60 do
                _object.set_color(self,"",255*x,255,255,255)
                self.hscale, self.vscale = 1.25*size - 0.25*size*x, 1.25*size - 0.25*size*x
                task._Wait(1)
                x=x+_d_x end end
            do local x,_d_x=(1),(-1/119) for _=1,120 do
                _object.set_color(self,"",255*x,255,255,255)
                task._Wait(1)
                x=x+_d_x end end
            _del(self,false)
        end)
    end
    local s4_t4=Class(_object)
    s4_t4.init=function(self,_x,_y,size)
        self.x,self.y=_x,_y
        self.img="s4_t4"
        self.layer=LAYER_BG+2
        self.group=GROUP_GHOST
        self.hide=false
        self.bound=true
        self.navi=false
        self.hp=10
        self.maxhp=10
        self.colli=true
        self._servants={}
        self._blend,self._a,self._r,self._g,self._b='',255,255,255,255
        self.hscale, self.vscale = size, size
        _object.set_color(self,"",0,255,255,255)
        self.x = self.x - 60*size
        lasttask=task.New(self,function()
            task._Wait(60)
            do local x,_d_x=(0),(1/59) for _=1,60 do
                self.x = self.x + 1*size
                self.rot = 60*cos(90*x)
                _object.set_color(self,"",255*x,255,255,255)
                task._Wait(1)
                x=x+_d_x end end
            task._Wait(140)
            do local x,_d_x=(1),(-1/119) for _=1,120 do
                _object.set_color(self,"",255*x,255,255,255)
                task._Wait(1)
                x=x+_d_x end end
            _del(self,false)
        end)
    end
    local s4_t5=Class(_object)
    s4_t5.init=function(self,_x,_y,size)
        self.x,self.y=_x,_y
        self.img="s4_t5"
        self.layer=LAYER_BG+2
        self.group=GROUP_GHOST
        self.hide=false
        self.bound=true
        self.navi=false
        self.hp=10
        self.maxhp=10
        self.colli=true
        self._servants={}
        self._blend,self._a,self._r,self._g,self._b='',255,255,255,255
        self.hscale, self.vscale = size, size
        _object.set_color(self,"",0,255,255,255)
        self.x = self.x - 60*size
        lasttask=task.New(self,function()
            task._Wait(120)
            task.New(self, function()
                AddSimStrChV(self, 0, 1*size, 0, 30)
                task.Wait(30)
                AddSimStrChV(self, 0, -0.9*size, 0, 90)
            end)

            do local x,_d_x=(0),(1/59) for _=1,60 do
                _object.set_color(self,"",255*x,255,255,255)
                task._Wait(1)
                x=x+_d_x end end
            task._Wait(80)
            do local x,_d_x=(1),(-1/119) for _=1,120 do
                _object.set_color(self,"",255*x,255,255,255)
                task._Wait(1)
                x=x+_d_x end end
            _del(self,false)
        end)
    end
    function s4_title()
        New(tasker,function()
            local size, x, y = 0.8, 0, 75
            New(s4_t1,x - 130*size, y + 0,size)
            New(s4_t4,x + 80*size, y - 15*size,size)
            New(s4_t5,x + 20*size, y - 30*size,size)
            New(s4_t2,x, y,size)
            New(s4_t3,x, y,size)
            task.Wait(120)
            local a, co, last = 30, {2, 14, 12, 10, 8, 6, 4}
            for i = 1, 7 do
                last = New(_e[6], -130*size + 50*cos(a), 40 + 50*sin(a), 3, a, a, co[i])
                a = a + 20
                task.Wait(1)
                last.layer = LAYER_BG+1
                task.Wait(4)
            end
            task.Wait(75)
            last = New(_e[12], -130*size, 60, 1, nil, nil, 100)
            task.New(last, function ()
                last.layer = LAYER_BG+1
                dec_dmg(last, 120, 30, 0.05)
                task.Wait(60)
                task.Wait(120)
                egg.AddSimStrChV(last, 0, 1, 90, 90)
            end)
        end)
    end
end

--祈华梦四面小怪行为定义，由一个类封装起来
-------------------------------------

--- _m = move, --移动
--- _a = attack, --攻击
--- _b = bullet --自定义弹幕
--- _c = change --特殊变化（如透明度）
--- _d = death --死尸弹
--- _e = enemy --定义的敌人
--- _f = function --定义的方法
--- _s = spawn --衍生怪
--- _o = object --自定义obj
--- _road  --道中
----------------------------------局部变量定义与访问方法-------------------------------------
local speed = 0 --局部的speed
_f[1] = function(v)--仅仅是简单的设置局部speed的值
    speed = v
end

local enemy_count = {0, 0, 0, 0}
_f[8] = function(i, count)--小怪团存在数变化
    enemy_count[i] = enemy_count[i] + count
end
_f[9] = function(i)--小怪团获取存在数
    return enemy_count[i]
end
_f[10] = function(i)--重置计数器
    enemy_count[i] = 0
end
_f[11] = function()
    for i = 1, 4 do
        _f[10](i)
    end
end
----------------------------------不能访问的函数的定义-------------------------------------
local delay_bound = function(self, t) --延迟出屏
    self.bound = false
    task.New(self, function ()
        task.Wait(t or 180)
        self.bound = true
    end)
end
--染色圈的线性变化
local dye_range_add = function(self, t, dr)
    t = t or 90
    dr = dr or 45
    dr = dr/t
    task.New(self, function ()
        for _ = 1, t do
            self.dye_range = self.dye_range + dr
            task.Wait(1)
        end
    end)
end
dec_dmg = function (self, t1, t2, rate) --设置线性减伤时间
    rate = rate or 0.1
    self.dmgrate = rate
    t1 = t1 or 180
    t2 = t2 or 60
    task.New(self, function ()
        task.Wait(t1)
        local d = (1-rate)/t2
        for _ = 1, t2 do
            self.dmgrate = self.dmgrate + d
            task.Wait(1)
        end
    end)
end
--粘人的小妖精
local trace_to_player = function(self, t, vr)
    vr = vr or 75 --vr是与小怪追踪速度有关的参数，数值越大追踪速度越小
    task.New(self, function ()
        t = t or 360
        local v, a = 0
        for _ = 1, t do
            if v < Dist(self, player)/vr then
                v = v + 0.01
            else
                v = Dist(self, player)/vr
            end
            v, a = min(2, max(0.1, v )), Angle(self, player)
            SetV(self, v, a)
            task.Wait(1)
        end
        task.Wait(150)
        egg.AddSimStrChV(self, 0, 3 - v, a, 120)
    end)
end
--间歇性靠近玩家的妖精
local trace_to_player2 = function(self, times, interval, dt, maxv, minv, dr, v1, t1, ymin)
    times = times or 3
    interval = interval or 60
    dt = dt or 30
    maxv = maxv or 1.5
    minv = minv or 0.5
    dr = dr or 30
    ymin = ymin or -40
    local v, a
    task.New(self, function ()
        for _ = 1, times do
            a = Angle(self, player)
            v = (Dist(self, player)>=dr) and min(maxv, 2*Dist(self.x, self.y, player.x - dr*cos(a), player.y - dr*sin(a)/interval)) or minv--a:b?c
            egg.AddSimStrChV(self, 0, v, a, 0.5*interval)
            egg.AddSimStrChV(self, 0, -v, a, 0.5*interval, 0.5*interval + dt)
            for _ = 1, interval + dt do
                if (self.y < ymin) then
                    self.y = self.y + 0.6
                end
                task.Wait(1)
            end
        end
        v1 = v1 or 2
        t1 = t1 or 120
        egg.AddSimStrChV(self, 0, v1, a, t1)--溜了溜了
    end)
end

--初始化默认半径和圆心位置，重置背景相对运动速度,染色圈的相位
local setRadius, getRadius, setAngPos, getAngPos, updateAngPos, setDAngPos,
getDAngPos, updateDAngPos, setRate, getRate, updateRate, getCenter, setTimes, getTimes, updateTimes,
setDyeRate, updateDyeRate, setAllDyeRate, getDyeRate,
updateCenter, updateRadius, setCenter, setDefault, s4_circle

local function clearEnemyAndBullet()
    for _, unit in ObjList(GROUP_NONTJT) do
        Del(unit)
    end
    for _, unit in ObjList(GROUP_ENEMY) do
        Del(unit)
    end
    for _, unit in ObjList(GROUP_ENEMY_BULLET) do
        _del(unit, true)
    end
end
----------------------------------移动定义-------------------------------------
_m[1] = function(self, a, x, y)
    self.bound = false
    task.New(self, function ()
        _f[8](1, 1)
        self.x, self.y = x, y
        self.colli = true
        SetV(self, 2, a)
        task.Wait(55)
        egg.AddSimStrChV(self, 0, -2, a, 120)
        task.Wait(120)
        self.bound = true
        --trace_to_player(self, 360)
        trace_to_player2(self)
    end)
end

_m[2] = function(self, a0)
    task.New(self, function ()
        egg.AddSimStrChV(self, 1, 0, 90, 30)
        task.Wait(30)
        egg.AddSimStrChV(self, 0, 2.75, 90, 90)
        task.Wait(120)
        egg.AddSimStrChV(self, 0, -2.75, 90, 60)
        task.Wait(60)
        egg.AddSimStrChV(self, 0, 0.5, a0, 120)
        task.Wait(440)
        egg.AddSimStrChV(self, 0, -0.5, a0, 30)
        task.Wait(300)
        egg.AddSimStrChV(self, 0, 2, a0, 180)
    end)
end

_m[3] = function(self, a0, u)
    --local road = {}
    self.bound = false
    local a = a0
    task.New(self, function ()
        SetV(self, 1, a)
        a = a + 80*u
        for _ = 1, 300 do
            a = a + 0.15*u
            SetA(self, 0.01, a, 0,0, 0, false)
            task.Wait(1)
        end
        self.bound = true
    end)
end
---4类似于1的跟踪小怪
_m[4] = function(self, a, dt)
    self.bound = false
    dt = dt or 90
    task.New(self, function ()
        egg.AddSimStrChV(self, 0, 1, a, 60)
        task.Wait(60)
        egg.AddSimStrChV(self, 0, -1, a, 30)
        task.Wait(30)
        task.Wait(dt)
        self.bound = true
        trace_to_player2(self, 3, 60, 60, 1.5, 0.5, 40)
    end)
end
---5
_m[5] = function(self, u)
    task.New(self, function ()
        SetV(self, 1.8, 90 + 90*u)
        egg.AddSimStrChV(self, 0, 1.5, -90, 120)
        task.Wait(120)
        self.bound = true
        egg.AddSimStrChV(self, 0, -1.5, -90, 30)
        egg.AddSimStrChV(self, 0, -1.8, 90 + 90*u, 30)
        task.Wait(20)
        egg.AddSimStrChV(self, 0, 1.5, 90, 60)
        egg.AddSimStrChV(self, 0, 1.8, 90 + 90*u, 60)
        task.Wait(60)
        egg.AddSimStrChV(self, 0, 2.1, -90, 150)
        egg.AddSimStrChV(self, 0, 0.3, 90 + 90*u, 150)
    end)
end
--6 从云里浮上来的动作
_m[6] = function(self, a)
    task.New(self, function()
        egg.AddAccDecChV(self, 0.3, a, 60, 60, 30)
        task.Wait(150)
        egg.AddSimStrChV(self, 0, 0.5, -90, 120)
        task.Wait(240)
        egg.AddSimStrChV(self, 0, 1, -90, 120) --加速跑路
    end)
end
----------------------------------特殊的弹幕定义-------------------------------------
--生成常用加速弹
local function accbullet(st, co, x, y, v, a, t)
    local obj = stg.newBulletStraight(st, co, true, x, y, 0, a)
    egg.AddSimStrChV(obj, 0, v, a, t)
    return obj
end
---1相对上升运动的简单弹幕
local _bullet
_bullet = Class(bullet)
function _bullet:init(x, y, v, a, st, co)
    straight.init(self, st,co or 1,true,x,y,v,a,0)
end
function _bullet:frame()
    straight.frame(self)
    self.y = self.y + speed
end
_b[1] = _bullet
---2作为彩虹的装饰弹幕
_bullet = Class(bullet)
function _bullet:init(x, y, co, change, wt)
    wt = wt or 180
    straight.init(self, star_small,co or 1,true,x,y,0,0,1)
    self.group = GROUP_GHOST
    self.a, self.b = 4, 4
    --self._blend = "mul+add"
    self.colli = false
    self.timer = 11 --取消弹雾
    egg.SimAlpCh(self, 10, 90, 60)
    egg.SimSizeCh(self, 1, 1.5, 60)
    task.New(self, function()
        self.layer = LAYER_ENEMY-1
        task.Wait(wt)
        if change then
            egg.SimAlpCh(self, 90, 0, 10)
            task.Wait(10)
            self.img = "star_big"..co
            egg.SimSizeCh(self, 0, 0.75, 60)
            egg.SimAlpCh(self, 0, 255, 60)
            task.Wait(60)
            self.a, self.b = 4, 4
            self.colli = true
            self.group = GROUP_ENEMY_BULLET
            self.layer = LAYER_ENEMY_BULLET
            local diff = difficulty
            if diff == 4 then
                egg.AddSimStrChV(self, 0, 2.5, -90, 240)
            elseif diff == 3 then
                egg.AddSimStrChV(self, 0, 2.25, -90, 240)
            elseif diff == 2 then
                egg.AddSimStrChV(self, 0, 2, -90, 240)
            else
                egg.AddSimStrChV(self, 0, 1.5, -90, 240)
            end
        else
            egg.SimAlpCh(self, 90, 0, 60)
            task.Wait(60)
            Del(self)
        end
    end)
end
function _bullet:frame()
    task.Do(self)
end
function _bullet:render()
    bullet.render(self)
end
function _bullet:del()

end
_b[2] = _bullet
---3藏着小妖精的樱花弹幕
local ex = Class(bullet)
function ex:init(x, y, a, mst, da)
    straight.init(self, arrow_big,3,true,x,y,0,a,2)
    self.layer = LAYER_ENEMY_BULLET-1
    self.hscale, self.vscale = 0, 0
    self._a = 0
    self.timer = 11
    self.colli = false
    task.New(self, function ()
        local x, dx = 0, 1/60
        for _ = 1, 60 do
            if IsValid(mst) then
                x = x + dx
                self._a = 120*x
                self.hscale, self.vscale = x, x
                self.x, self.y = mst.x + 12.5*x*cos(self.rot), mst.y + 10*x*sin(self.rot)
            else
                break
            end
            task.Wait(1)
        end
        local d_o = 2/30
        for _ = 1, 30 do
            if IsValid(mst) then
                self.omiga = self.omiga - d_o
                self.x, self.y = mst.x + 12.5*cos(self.rot), mst.y + 10*sin(self.rot)
            else
                break
            end
            task.Wait(1)
        end
        x, dx = 0, 1/30
        for _ = 1, 30 do
            x = x + dx
            self._a = 120 + 135*x
            task.Wait(1)
        end
        self.colli = true
        self.navi = true
        if difficulty == 4 then
            egg.AddSimStrChV(self, 0, 0.5, self.rot, 120)
            task.Wait(120)
            egg.AddSimStrChV(self, 0, 1.5, self.rot, 150)
            task.Wait(30)
            egg.AddSimStrChV(self, 0, -1, self.rot + da or 0, 120)
        end
    end)
end
function ex:render()
    SetImgState(self, "", self._a, 255, 255, 255)
    Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
    --object.render(self)
end
_bullet = Class(bullet)
function _bullet:init(x, y, a0)
    straight.init(self, star_small,3,true,x,y,0,a0,2)
    --self.group = GROUP_INDES
    self.hscale, self.vscale = 0, 0
    self.a, self.b = 6, 6
    self._a = 0
    self.timer = 11
    self.colli = false
    self.spawn = false
    do--创建绑定的花瓣对象
        if difficulty == 4 then
            local a = 36 + a0
            local da = -15
            for _ = 1, 5 do
                da = -60
                for _ = 1, 2 do
                    New(ex, x, y, a, self, da)
                    da = da + 120
                end
                a = a + 72
            end
        end
    end
    task.New(self, function ()
        egg.AddSimStrChV(self, 0, 1, a0, 30)
        task.Wait(30)
        egg.AddSimStrChV(self, 0, -1, a0, 60)
    end)
    task.New(self, function ()
        local x, dx = 0, 1/60
        for _ = 1, 60 do
            x = x + dx
            self._a = 120*x
            self.hscale, self.vscale = 1.5*x, 1.5*x
            task.Wait(1)
        end
        local d_o = 2/30
        for _ = 1, 30 do
            self.omiga = self.omiga - d_o
            task.Wait(1)
        end
        x, dx = 0, 1/30
        for _ = 1, 30 do
            x = x + dx
            self._a = 120 + 135*x
            task.Wait(1)
        end
        self.colli = true
        if not self.spawn then
            New(_e[8], self.x, self.y, nil)
            self.spawn = true
        end
        local a = Angle(self, player)
        task.New(self, function ()
            for _ = 1, 60 do
                self.omiga = self.omiga + d_o
                task.Wait(1)
            end
        end)
        egg.AddSimStrChV(self, 0, 0.5, a, 120)
        task.Wait(120)
        egg.AddSimStrChV(self, 0, 1.5, a, 150)
    end)
end
function _bullet:render()
    SetImgState(self, "", self._a, 255, 255, 255)
    Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
    --object.render(self)
end
function _bullet:kill()
    if not self.spawn then
        New(_e[8], self.x, self.y, nil)
        self.spawn = true
    end
end
function _bullet:del()
    if not self.spawn then
        New(_e[8], self.x, self.y, nil)
        self.spawn = true
    end
end
_b[3] = _bullet
---4作为彩虹的装饰弹幕2
_bullet = Class(bullet)
function _bullet:init(x, y, co, a, da, change)
    straight.init(self, star_small,co or 1,true,x,y,0,0,1)
    --self.flag = true --flag为true时表示这个弹幕会受到背景相对移动影响
    self.group = GROUP_GHOST
    self.a, self.b = 4, 4
    --self._blend = "mul+add"
    self.colli = false
    self.timer = 11 --取消弹雾
    egg.SimAlpCh(self, 10, 60, 20)
    egg.SimSizeCh(self, 2.4, 1.8, 20)
    task.New(self, function ()
        task.Wait(20)
        task.Wait(20)
        self.colli = false
        self.group = GROUP_GHOST
        if change then --是否变成实弹
            egg.SimAlpCh(self, 90, 0, 10)
            task.Wait(10)
            self.img = "star_big"..co
            egg.SimSizeCh(self, 0, 0.75, 20)
            egg.SimAlpCh(self, 0, 255, 20)
            task.Wait(20)
            self.a, self.b = 4, 4
            self.colli = true
            self.group = GROUP_ENEMY_BULLET
            self.layer = LAYER_ENEMY_BULLET
            local diff = difficulty
            if diff == 4 then
                egg.AddSimStrChV(self, 0, 1, a, 30)
                egg.AddSimStrChV(self, 0, 1.5, a + da, 120)
            elseif diff == 3 then
                egg.AddSimStrChV(self, 0, 0.9, a, 30)
                egg.AddSimStrChV(self, 0, 1.5, a + da, 120)
            elseif diff == 2 then
                egg.AddSimStrChV(self, 0, 0.8, a, 30)
                egg.AddSimStrChV(self, 0, 1.5, a + da, 120)
            else
                egg.AddSimStrChV(self, 0, 0.7, a, 30)
                egg.AddSimStrChV(self, 0, 1.5, a + da, 120)
            end
        else
            egg.SimAlpCh(self, 60, 0, 30)
            egg.SimSizeCh(self, 1.8, 0, 75)
            task.Wait(75)
            Del(self)
        end
    end)
end
function _bullet:del()
    if self.timer >= 105 then
        straight.del(self)
    end
end
_b[4] = _bullet
---5工具蝶的星弹
_bullet = Class(bullet)
function _bullet:init(x, y, a, co)
    straight.init(self, star_small,co or 1,true,x,y,0,0,1)
    self.a, self.b = 3, 3
    self.colli = false
    self.timer = 11 --取消弹雾
    egg.SimAlpCh(self, 0, 70, 60)
    egg.SimSizeCh(self, 2, 1.25, 60)
    egg.AddSimStrChV(self, 0, 0.8, a, 20)
    egg.AddSimStrChV(self, 0, -0.6, a, 60, 20)
    egg.AddSimStrChV(self, 0, 0.25, a, 180, 80)
    egg.AddSimStrChV(self, 0, 1.5, a, 180, 300)
    task.New(self, function()
        task.Wait(200)
        egg.SimAlpCh(self, 70, 255, 100)
        self.colli = true
    end)
end
_b[5] = _bullet
---------------------------------攻击方式定义-------------------------------------

---1
_a[1] = function(self)
    task.New(self, function ()
        task.New(self, function()
            local diff = difficulty
            if diff == 4 then
                task.Wait(30)
                local a = Angle(self, player) + ran:Float(-5, 5) + 40
                local last
                for _ = 1, 9 do
                    last = stg.newBulletStraight(stg.star_small, 5, true, self.x, self.y, 0, a)
                    _object.set_color(last, "", 255, 255, 255, 255)
                    last.omiga = 3
                    egg.AddSimStrChV(last, 1.25, 0.25, a, 30)
                    egg.AddSimStrChV(last, 0, 1.5, a, 40, 60)
                    egg.AddSimStrChV(last, 0, -1, a, 60, 90)
                    egg.AddSimStrChV(last, 0, 1.75, a, 60, 210)
                    a  = a - 10
                end
            elseif diff == 3 then
                task.Wait(30)
                local a = Angle(self, player) + ran:Float(-5, 5) + 40
                local last
                for _ = 1, 6 do
                    last = stg.newBulletStraight(stg.star_small, 5, true, self.x, self.y, 0, a)
                    _object.set_color(last, "", 255, 255, 255, 255)
                    last.omiga = 3
                    egg.AddSimStrChV(last, 1.25, 0.25, a, 30)
                    egg.AddSimStrChV(last, 0, 1.5, a, 40, 60)
                    egg.AddSimStrChV(last, 0, -1, a, 60, 90)
                    egg.AddSimStrChV(last, 0, 1.5, a, 60, 210)
                    a  = a - 16
                end
            elseif diff == 2 then
                task.Wait(30)
                local a = Angle(self, player) + ran:Float(-5, 5) + 40
                local last
                for _ = 1, 4 do
                    last = stg.newBulletStraight(stg.star_small, 5, true, self.x, self.y, 0, a)
                    _object.set_color(last, "", 255, 255, 255, 255)
                    last.omiga = 3
                    egg.AddSimStrChV(last, 1.25, 0.25, a, 30)
                    egg.AddSimStrChV(last, 0, 1.5, a, 40, 60)
                    egg.AddSimStrChV(last, 0, -1, a, 60, 90)
                    egg.AddSimStrChV(last, 0, 1.25, a, 60, 210)
                    a  = a - 80/3
                end
            else
                task.Wait(40)
                local a = Angle(self, player) + ran:Float(-5, 5) + 20
                local last
                for _ = 1, 2 do
                    last = stg.newBulletStraight(stg.star_small, 5, true, self.x, self.y, 0, a)
                    _object.set_color(last, "", 255, 255, 255, 255)
                    last.omiga = 3
                    egg.AddSimStrChV(last, 1.25, 0.25, a, 30)
                    egg.AddSimStrChV(last, 0, 1.5, a, 40, 60)
                    egg.AddSimStrChV(last, 0, -1, a, 60, 90)
                    egg.AddSimStrChV(last, 0, 1, a, 60, 210)
                    a  = a - 40
                end
            end
        end)
    end)
end
---2
_a[2] = function(self)
    task.New(self, function()
        local diff = difficulty
        local last
        if diff == 4 then
            task.New(self, function ()
                task.Wait(240)
                local a, sp = -90 + 22.5
                PlaySound("tan00", 0.5)
                for _ = 1, 8 do
                    sp = -6
                    for i = 1, 7 do
                        last = stg.newBulletStraight(stg.ball_mid_c, 1, true, self.x + 20*cos(a), self.y + 20*sin(a), 0, a + sp)
                        egg.AddSimStrChV(last, 2, -0.5, a + sp, 45)
                        egg.AddSimStrChV(last, 0, 2 - 0.15*abs(i-4), a - 0.75*sp, 60, 60)
                        sp = sp + 2
                    end
                    a = a + 45
                end
            end)
        elseif diff == 3 then
            task.New(self, function ()
                task.Wait(260)
                local a, sp = -90 + 22.5
                PlaySound("tan00", 0.5)
                for _ = 1, 6 do
                    sp = -4
                    for i = 1, 5 do
                        last = stg.newBulletStraight(stg.ball_mid_c, 1, true, self.x + 20*cos(a), self.y + 20*sin(a), 0, a + sp)
                        egg.AddSimStrChV(last, 2, -0.5, a + sp, 45)
                        egg.AddSimStrChV(last, 0, 1.75 - 0.15*abs(i-4), a - 0.75*sp, 60, 60)
                        sp = sp + 2
                    end
                    a = a + 60
                end
            end)
        elseif diff == 2 then
            task.New(self, function ()
                task.Wait(280)
                local a, sp = -90 + 22.5
                PlaySound("tan00", 0.5)
                for _ = 1, 6 do
                    sp = -2
                    for i = 1, 3 do
                        last = stg.newBulletStraight(stg.ball_mid_c, 1, true, self.x + 20*cos(a), self.y + 20*sin(a), 0, a + sp)
                        egg.AddSimStrChV(last, 2, -0.5, a + sp, 45)
                        egg.AddSimStrChV(last, 0, 1.5 - 0.15*abs(i-4), a - 0.75*sp, 60, 60)
                        sp = sp + 2
                    end
                    a = a + 60
                end
            end)
        else
            task.New(self, function ()
                task.Wait(300)
                local a, sp = -90 + 22.5
                PlaySound("tan00", 0.5)
                for _ = 1, 6 do
                    sp = 0
                    for i = 1, 1 do
                        last = stg.newBulletStraight(stg.ball_mid_c, 1, true, self.x + 20*cos(a), self.y + 20*sin(a), 0, a + sp)
                        egg.AddSimStrChV(last, 2, -0.5, a + sp, 45)
                        egg.AddSimStrChV(last, 0, 1.25 - 0.15*abs(i-4), a - 0.75*sp, 60, 60)
                        sp = sp + 0
                    end
                    a = a + 60
                end
            end)
        end
    end)

end
---3
_a[3] = function(self)
    task.New(self, function()
        local diff = difficulty
        if diff == 4 then
            task.Wait(70)
            local a, da, last = -90, 360/24
            for i = 1, 24 do
                for j = 0, 2 do
                    last = New(_b[1], self.x, self.y, 1 + 0.5*j, a + da*(i + 0.5*j), ball_mid, 6)
                    egg.AddSimStrChV(last, 0, -1, a + da*(i + 0.5*j), 180, 60)
                end
            end
        elseif diff == 3 then
            task.Wait(80)
            local a, da, last = -90, 360/18
            for i = 1, 18 do
                for j = 0, 1 do
                    last = New(_b[1], self.x, self.y, 1 + 0.5*j, a + da*(i + 0.5*j), ball_mid, 6)
                    egg.AddSimStrChV(last, 0, -1, a + da*(i + 0.5*j), 180, 60)
                end
            end
        elseif diff == 2 then
            task.Wait(85)
            local a, da, last = -90, 360/16
            for i = 1, 16 do
                for j = 0, 0 do
                    last = New(_b[1], self.x, self.y, 1 + 0.5*j, a + da*(i + 0.5*j), ball_mid, 6)
                    egg.AddSimStrChV(last, 0, -1, a + da*(i + 0.5*j), 180, 60)
                end
            end
        else
            task.Wait(90)
            local a, da, last = -90, 360/8
            for i = 1, 8 do
                for j = 0, 0 do
                    last = New(_b[1], self.x, self.y, 1 + 0.5*j, a + da*(i + 0.5*j), ball_mid, 6)
                    egg.AddSimStrChV(last, 0, -1, a + da*(i + 0.5*j), 180, 60)
                end
            end
        end
    end)
end
---4--彩虹尾巴
_a[4] = function(self, co)
    task.New(self, function ()
        local diff = difficulty
        if diff == 4 then
            for i = 1, 150 do
                if i%5 == 0 then
                    New(_b[2], self.x, self.y, co, true)
                else
                    New(_b[2], self.x, self.y, co)
                end
                task.Wait(3)
            end
        elseif diff == 3 then
            for i = 1, 150 do
                if i%8 == 0 then
                    New(_b[2], self.x, self.y, co, true)
                else
                    New(_b[2], self.x, self.y, co)
                end
                task.Wait(3)
            end
        elseif diff == 2 then
            for i = 1, 150 do
                if i%12 == 0 then
                    New(_b[2], self.x, self.y, co, true)
                else
                    New(_b[2], self.x, self.y, co)
                end
                task.Wait(3)
            end
        else
            for i = 1, 150 do
                if i%30 == 0 then
                    New(_b[2], self.x, self.y, co, true)
                else
                    New(_b[2], self.x, self.y, co)
                end
                task.Wait(3)
            end
        end
    end)
end
---5--简单的自机狙
_a[5] = function(self)
    local a, a0, last
    task.New(self, function()
        local diff = difficulty
        if diff == 4 then
            task.Wait(30)
            for _ = 1, 3 do
                a0 = Angle(self, player)
                for j = -1, 1 do
                    a = a0 + 30*j
                    last = stg.newBulletStraight(stg.grain_c, 3, true ,self.x, self.y, 0, a)
                    egg.AddSimStrChV(last, 0, 3, a, 60)
                    egg.AddSimStrChV(last, 0, -0.6, a, 60, 30)
                end
                task.Wait(30)
            end
        elseif diff == 3 then
            task.Wait(40)
            for _ = 1, 2 do
                a0 = Angle(self, player)
                for j = -1, 1 do
                    a = a0 + 60*j
                    last = stg.newBulletStraight(stg.grain_c, 3, true ,self.x, self.y, 0, a)
                    egg.AddSimStrChV(last, 0, 2.5, a, 60)
                    egg.AddSimStrChV(last, 0, -0.6, a, 60, 30)
                end
                task.Wait(45)
            end
        elseif diff == 2 then
            task.Wait(50)
            for _ = 1, 2 do
                a0 = Angle(self, player)
                a = a0
                last = stg.newBulletStraight(stg.grain_c, 3, true ,self.x, self.y, 0, a)
                egg.AddSimStrChV(last, 0, 2, a, 60)
                egg.AddSimStrChV(last, 0, -0.6, a, 60, 30)
                task.Wait(60)
            end
        else
            task.Wait(60)
            for _ = 1, 1 do
                a0 = Angle(self, player)
                a = a0
                last = stg.newBulletStraight(stg.grain_c, 3, true ,self.x, self.y, 0, a)
                egg.AddSimStrChV(last, 0, 1.75, a, 60)
                egg.AddSimStrChV(last, 0, -0.6, a, 60, 30)
                task.Wait(60)
            end
        end
    end)
end

--特定拖影类
--拖影类2(拖影位置会跟随对象本体，需要主人对象)
local trail2 = Class(object)
function trail2:init(master, maxnum, frame, img, size, blend, times, _a_rate, Isdsize, a, da, i)
    self.layer = LAYER_ENEMY-1
    self.bound = false
    self.master = master
    self.alpha = 80
    self.img = img
    self.size = size or 1
    self.trail = {} --拖影表
    self.max = maxnum or 10
    self.frame = frame or 3
    self.co = {255, 255, 255} --留一个可以外部操作的接口co
    self.blend = blend or "mul+alpha"
    self.times = times or 99999
    self._a_rate = _a_rate or 1
    self.Isdsize = Isdsize
    --self.x, self.y =
    --self.a0 = a
    --self.da0 = da
    --self.i = i
end
function trail2:frame()
    if IsValid(self.master) then
        self.x, self.y = self.master.x, self.master.y
    end
    --[[if (_t<3330) then
        self.a0 = self.a0 + self.da0
        self.x, self.y = cen[1], cen[2]
    end]]
    if self.frame == 1 or self.timer%self.frame == 1  then
        if IsValid(self.master) and self.timer < self.times then
            local master = self.master
            table.insert(self.trail, 1, {master.x, master.y, master.rot, master.hscale*self.size, master.vscale*self.size}) --更新主人当前图像状态
            if #self.trail > self.max then table.remove(self.trail) end
        else--即便主人不存在了，拖影也会保留一段时间渐渐消失
            if #self.trail == 0 then
                Del(self)
            else
                table.remove(self.trail)
            end
        end
    end
end
function trail2:render()
    local co = self.co
    local size = 0.5
    local dsize
    if self.Isdsize then
        dsize = 0.5/self.max
    else
        dsize = 0
    end
    if IsValid(self.master) then
        self.alpha = 255*self._a_rate
    end
    local alpha, d, n = 0.2*self.alpha, 0.8*self.alpha/self.max, #self.trail
    for i = n, 1, -1 do
        local obj = self.trail[i]
        SetImgState(self, self.blend, alpha, co[1], co[2], co[3])
        Render(self.img, obj[1], obj[2], obj[3], obj[4]*size, obj[5]*size)
        alpha = alpha + d
        --alpha = 255
        size = size + dsize
    end
    SetImgState(self, "", 255, 255, 255, 255) -- 记得恢复渲染状态
end
---6--彩虹尾巴2
_a[6] = function(self, co, u0)
    self._a = 255
    task.New(self, function ()
        local diff = difficulty
        if diff == 4 then
            local Trail = New(trail2, self, 30, 3, "star_small"..co, 2, "", 9999, 1, true)
            local a0
            while true do
                if self._a >= 255 and IsValid(Trail) and Trail.trail[1] and Trail.trail[2] then
                    a0 = Angle(Trail.trail[1][1], Trail.trail[1][2], Trail.trail[2][1], Trail.trail[2][2])
                    for u = -1, 1, 2 do
                        New(_b[4], self.x, self.y, co, a0, -15*u0 + 30*u, true)
                    end
                end
                task.Wait(12)
            end
        elseif diff == 3 then
            local Trail = New(trail2, self, 30, 3, "star_small"..co, 2, "", 9999, 1, true)
            local a0
            while true do
                if self._a >= 255 and IsValid(Trail) and Trail.trail[1] and Trail.trail[2] then
                    a0 = Angle(Trail.trail[1][1], Trail.trail[1][2], Trail.trail[2][1], Trail.trail[2][2])
                    for u = -1, 1, 2 do
                        New(_b[4], self.x, self.y, co, a0, -45*u0 + 30*u, true)
                    end
                end
                task.Wait(18)
            end
        elseif diff == 2 then
            local Trail = New(trail2, self, 30, 3, "star_small"..co, 2, "", 9999, 1, true)
            local a0
            while true do
                if self._a >= 255 and IsValid(Trail) and Trail.trail[1] and Trail.trail[2] then
                    a0 = Angle(Trail.trail[1][1], Trail.trail[1][2], Trail.trail[2][1], Trail.trail[2][2])
                    New(_b[4], self.x, self.y, co, a0, -60*u0, true)
                end
                task.Wait(24)
            end
        end
    end)
end
---7--工具蝶弹幕
_a[7] = function(self)
    task.New(self, function()
        local diff = difficulty
        if diff == 4 then
            local r, a, co = 60, 45, {1, 13, 9, 5, 3}
            for _ = 1, 35 do
                for i = 1, 5 do
                    New(_b[5], self.x + r*cos(a), self.y + r*sin(a), a + 150, co[i])
                    a = a + 72
                end
                a = a + 12
                r = r - 0.2
                task.Wait(2)
            end
        elseif diff == 3 then
            local r, a, co = 60, 45, {1, 13, 9, 5, 3}
            for _ = 1, 25 do
                for i = 1, 5 do
                    New(_b[5], self.x + r*cos(a), self.y + r*sin(a), a + 150, co[i])
                    a = a + 72
                end
                a = a + 9
                r = r - 0.2
                task.Wait(2)
            end
        elseif diff == 2 then
            local r, a, co = 60, 45, {1, 13, 9, 5, 3}
            for _ = 1, 18 do
                for i = 1, 4 do
                    New(_b[5], self.x + r*cos(a), self.y + r*sin(a), a + 150, co[i])
                    a = a + 90
                end
                a = a + 12
                r = r - 0.3
                task.Wait(3)
            end
        else
            local r, a, co = 60, 45, {1, 13, 9, 5, 3}
            for _ = 1, 10 do
                for i = 1, 3 do
                    New(_b[5], self.x + r*cos(a), self.y + r*sin(a), a + 150, co[i])
                    a = a + 120
                end
                a = a + 20
                r = r - 0.5
                task.Wait(5)
            end
        end
    end)
end
---8--大风车
_a[8] = function(self, co, u)
    task.New(self, function()
        local diff = difficulty
        if diff == 4 then
            local function f(x, y, a)
                local obj = stg.newBulletStraight(stg.arrow_big, co, true, x, y, 0, a)
                obj.navi = true
                task.New(obj, function ()
                    egg.AddSimStrChV(obj, 2.5, -1, a, 60)
                    task.Wait(60)
                    egg.AddSimStrChV(obj, 0, 3, a, 120)
                end)
            end
            task.Wait(15)
            local a = 0
            for _ = 1, 60 do
                for _ = 1, 4 do
                    f(self.x, self.y, a)
                    a = a + 90
                end
                a = a + 12*u
                task.Wait(6)
            end
        elseif diff == 3 then
            local function f(x, y, a)
                local obj = stg.newBulletStraight(stg.arrow_big, co, true, x, y, 0, a)
                obj.navi = true
                task.New(obj, function ()
                    egg.AddSimStrChV(obj, 2.25, -1, a, 60)
                    task.Wait(60)
                    egg.AddSimStrChV(obj, 0, 2.5, a, 120)
                end)
            end
            task.Wait(30)
            local a = 0
            for _ = 1, 36 do
                for _ = 1, 3 do
                    f(self.x, self.y, a)
                    a = a + 120
                end
                a = a + 18*u
                task.Wait(10)
            end
        elseif diff == 2 then
            local function f(x, y, a)
                local obj = stg.newBulletStraight(stg.arrow_big, co, true, x, y, 0, a)
                obj.navi = true
                task.New(obj, function ()
                    egg.AddSimStrChV(obj, 2, -1, a, 60)
                    task.Wait(60)
                    egg.AddSimStrChV(obj, 0, 2, a, 120)
                end)
            end
            task.Wait(45)
            local a = 0
            for _ = 1, 18 do
                for _ = 1, 3 do
                    f(self.x, self.y, a)
                    a = a + 120
                end
                a = a + 24*u
                task.Wait(20)
            end
        else
            local function f(x, y, a)
                local obj = stg.newBulletStraight(stg.arrow_big, co, true, x, y, 0, a)
                obj.navi = true
                task.New(obj, function ()
                    egg.AddSimStrChV(obj, 1.75, -1, a, 60)
                    task.Wait(60)
                    egg.AddSimStrChV(obj, 0, 1.5, a, 120)
                end)
            end
            task.Wait(60)
            local a = 0
            for _ = 1, 12 do
                for _ = 1, 2 do
                    f(self.x, self.y, a)
                    a = a + 180
                end
                a = a + 30*u
                task.Wait(30)
            end
        end
    end)
end
---9--小妖精最后的攻击
_a[9] = function(self)
    task.New(self, function ()
        local diff = difficulty
        if diff == 4 then
            local v = 1
            for _ = 1, 20 do
                stg.newBulletStraight(stg.star_small, 3, true, self.x, self.y, v, Angle(0, 0, self.vx, self.vy) + 180)
                v = v + 0.125
                task.Wait(3)
            end
        elseif diff == 3 then
            local v = 1
            for _ = 1, 15 do
                stg.newBulletStraight(stg.star_small, 3, true, self.x, self.y, v, Angle(0, 0, self.vx, self.vy) + 180)
                v = v + 0.125
                task.Wait(4)
            end
        elseif diff == 2 then
            local v = 1
            for _ = 1, 10 do
                stg.newBulletStraight(stg.star_small, 3, true, self.x, self.y, v, Angle(0, 0, self.vx, self.vy) + 180)
                v = v + 0.125
                task.Wait(6)
            end
        else
            local v = 1
            for _ = 1, 5 do
                stg.newBulletStraight(stg.star_small, 3, true, self.x, self.y, v, Angle(0, 0, self.vx, self.vy) + 180)
                v = v + 0.125
                task.Wait(12)
            end
        end
    end)
end
----------------------------------状态改变定义-------------------------------------
_c[1] = function(self, t)
    _object.set_color(self, "", 0, 0, 0, 0)
    t = t or 180
    --egg.SimAlpCh(self, 0, 255, t or 180)
    egg.SimSizeCh(self, 0.5, 1, t)
    egg.SimAlpRGBCh(self, t)
end
----------------------------------死尸弹定义-------------------------------------

---1
_d[1] = function(self)
    task.New(self, function()
        local diff = difficulty
        if diff == 4 then
            task.New(self, function ()
                local a = Angle(self, player)
                local last
                if not(self.sys_co == 1 or self.sys_co == 2) then
                    local a0
                    for _ = 1, 8 do
                        a0 = a + ran:Float(-15, 15) + 180
                        last = stg.newBulletStraight(stg.arrow_small, 5, true, self.x, self.y, ran:Float(1.5, 2), a0)
                        egg.AddSimStrChV(last, 0,  5, a, 135)
                        last.navi = true
                        egg.AddSimStrChV(last, 0, -2, a, 75, 135)
                    end
                end
            end)
        elseif diff == 3 then
            task.New(self, function ()
                local a = Angle(self, player)
                local last
                if not(self.sys_co == 1 or self.sys_co == 2) then
                    local a0
                    for _ = 1, 5 do
                        a0 = a + ran:Float(-15, 15) + 180
                        last = stg.newBulletStraight(stg.arrow_small, 5, true, self.x, self.y, ran:Float(1.25, 1.75), a0)
                        egg.AddSimStrChV(last, 0,  5, a, 135)
                        last.navi = true
                        egg.AddSimStrChV(last, 0, -2.5, a, 75, 135)
                    end
                end
            end)
        elseif diff == 2 then
            task.New(self, function ()
                local a = Angle(self, player)
                local last
                if not(self.sys_co == 1 or self.sys_co == 2) then
                    local a0
                    for _ = 1, 3 do
                        a0 = a + ran:Float(-15, 15) + 180
                        last = stg.newBulletStraight(stg.arrow_small, 5, true, self.x, self.y, ran:Float(1.2, 1.6), a0)
                        egg.AddSimStrChV(last, 0,  5, a, 135)
                        last.navi = true
                        egg.AddSimStrChV(last, 0, -3, a, 75, 135)
                    end
                end
            end)
        end
    end)

end
---2
_d[2] = function(self)
    task.New(self, function()
        local diff = difficulty
        if diff == 4 then
            local a, last = 0
            if not (self.sys_co == 1 or self.sys_co == 2) then
                for _ = 1, 16 do
                    last = New(_b[1], self.x, self.y, 0, a, ball_mid_c)
                    egg.AddSimStrChV(last, 1.5, 0.25, a, 30)
                    last.navi = true
                    egg.AddSimStrChV(last, 0, -1.75, a, 150,60)
                    a  = a + 22.5
                end
            end
        elseif diff == 3 then
            local a, last = 0
            if not (self.sys_co == 1 or self.sys_co == 2) then
                for _ = 1, 12 do
                    last = New(_b[1], self.x, self.y, 0, a, ball_mid_c)
                    egg.AddSimStrChV(last, 1.25, 0.25, a, 30)
                    last.navi = true
                    egg.AddSimStrChV(last, 0, -1.5, a, 150,60)
                    a  = a + 30
                end
            end
        elseif diff == 2 then
            local a, last = 0
            if not (self.sys_co == 1 or self.sys_co == 2) then
                for _ = 1, 9 do
                    last = New(_b[1], self.x, self.y, 0, a, ball_mid_c)
                    egg.AddSimStrChV(last, 1, 0.25, a, 30)
                    last.navi = true
                    egg.AddSimStrChV(last, 0, -1.25, a, 150,60)
                    a  = a + 40
                end
            end
        end
    end)
end
---3
_d[3] = function(self)
    local a, last = 0
    if not(self.sys_co == 1 or self.sys_co == 2) then
        task.New(self, function()
            local diff = difficulty
            if diff == 4 then
                a = Angle(self, player) + 20
                for _ = 1, 5 do
                    last = stg.newBulletStraight(stg.arrow_small, 3, true, self.x, self.y, 0, a)
                    egg.AddSimStrChV(last, 0, 3, a, 60)
                    egg.AddSimStrChV(last, 0, -1, a, 30, 60)
                    a  = a - 10
                end
            elseif diff == 3 then
                a = Angle(self, player) + 10
                for _ = 1, 3 do
                    last = stg.newBulletStraight(stg.arrow_small, 3, true, self.x, self.y, 0, a)
                    egg.AddSimStrChV(last, 0, 2.5, a, 60)
                    egg.AddSimStrChV(last, 0, -1, a, 30, 60)
                    a  = a - 10
                end
            elseif diff == 2 then
                a = Angle(self, player) + 3
                for _ = 1, 3 do
                    last = stg.newBulletStraight(stg.arrow_small, 3, true, self.x, self.y, 0, a)
                    egg.AddSimStrChV(last, 0, 2, a, 60)
                    egg.AddSimStrChV(last, 0, -1, a, 30, 60)
                    a  = a - 3
                end
            end
        end)
    end

end
---4
_d[4] = function(self)
    if Dist(self, player) > 30 then
        task.New(self, function()
            local diff = difficulty
            if diff == 4 then
                local a, last = Angle(self, player)
                if not (self.sys_co == 1 or  self.sys_co == 2) then
                    local a0
                    for _ = 1, 8 do
                        a0 = a + ran:Float(-30, 30)
                        last = stg.newBulletStraight(stg.arrow_small, 1, true, self.x, self.y, ran:Float(2.5, 3.5), a0)
                        egg.AddSimStrChV(last, 0,  -0.5, a0, 135, 60)
                    end
                else
                    local a0
                    for _ = 1, 4 do
                        a0 = a + ran:Float(-15, 15)
                        last = stg.newBulletStraight(stg.arrow_small, 1, true, self.x, self.y, ran:Float(1.5, 2), a0)
                        egg.AddSimStrChV(last, 0,  -0.25, a0, 135, 60)
                    end
                end
            elseif diff == 3 then
                local a, last = Angle(self, player)
                if not (self.sys_co == 1 or  self.sys_co == 2) then
                    local a0
                    for _ = 1, 6 do
                        a0 = a + ran:Float(-20, 20)
                        last = stg.newBulletStraight(stg.arrow_small, 1, true, self.x, self.y, ran:Float(2, 3), a0)
                        egg.AddSimStrChV(last, 0,  -0.5, a0, 135, 60)
                    end
                else
                    local a0
                    for _ = 1, 2 do
                        a0 = a + ran:Float(-10, 10)
                        last = stg.newBulletStraight(stg.arrow_small, 1, true, self.x, self.y, ran:Float(1.25, 1.75), a0)
                        egg.AddSimStrChV(last, 0,  -0.25, a0, 135, 60)
                    end
                end
            elseif diff == 2 then
                local a, last = Angle(self, player)
                if not (self.sys_co == 1 or  self.sys_co == 2) then
                    local a0
                    for _ = 1, 3 do
                        a0 = a + ran:Float(-15, 15)
                        last = stg.newBulletStraight(stg.arrow_small, 1, true, self.x, self.y, ran:Float(1.75, 2.75), a0)
                        egg.AddSimStrChV(last, 0,  -0.5, a0, 135, 60)
                    end
                else
                    local a0
                    for _ = 1, 1 do
                        a0 = a
                        last = stg.newBulletStraight(stg.arrow_small, 1, true, self.x, self.y, 1, a0)
                        egg.AddSimStrChV(last, 0,  -0.25, a0, 135, 60)
                    end
                end
            end
        end)
    end
end
----------------------------------obj定义--------------------------------------------

local _obj
---1
_obj = Class(object)
function _obj:init(x, y, co, a, u, spawn)
    self.x, self.y = x, y
    self.bound = false
    self.group = GROUP_GHOST
    _m[3](self, a, u)
    _a[4](self, co)
    dec_dmg(self)
    task.New(self, function ()
        if spawn then
            _s[1](self)
        end
        task.Wait(90)
        self.bound = true
    end)
end
function _obj:frame()
    object.frame(self)
    task.Do(self)
end
_o[1] = _obj

----------------------------------小怪、衍生定义-------------------------------------
--开幕从远处飘过去的装饰小妖精
local e0 = Class(enemy)
function e0:init(x, y, a, x1, y1)
    self.x, self.y = x, y
    enemy.init(self,4, 20,false,false,false, false, nil, 0, 1, true)
    self.group = GROUP_GHOST
    --_a[1](self)
    --远处的黑色装饰妖精
    _c[1](self)
    --运动
    task.New(self, function()
        self.colli = false
        egg.AddSimStrChV(self, 1, 2, a + 180 + ran:Float(-10, 10), 60)
        task.Wait(60)
        egg.StopCurrentV(self, 30)
        task.Wait(30)
        SetV(self, 0, a)
        Del(self)
    end)
end

---1
local _enemy
_enemy = Class(enemy)
function _enemy:init(x, y, a)
    self.x, self.y = x, y
    enemy.init(self,4, 20,false,false,false, false, nil, 0, 1)
    self.group = GROUP_NONTJT
    _m[1](self, a, x, y)
    _a[1](self)
    --_c[1](self)
end
function _enemy:kill()
    enemy.kill(self)
    _f[8](1, -1)
    _d[1](self)
end
function _enemy:del()
    enemy.del(self)
    _f[8](1, -1)
end
_e[1] = _enemy
---2
_enemy = Class(enemy)
function _enemy:init(x, y, co, a0)
    self.x, self.y = x, y
    enemy.init(self,8 + co, 20,false,false,false, true, co, 90, 1)
    self.group = GROUP_NONTJT
    _a[2](self)
    _m[2](self, a0)
    dec_dmg(self, 10, 20)
end
_e[2] = _enemy
---3
_enemy = Class(enemy)
function _enemy:init(x, y, co)
    self.x, self.y = x, y
    enemy.init(self,co or 4, 10,false,false,false, false, co, 0, 1)
    self.group = GROUP_NONTJT
    delay_bound(self, 420)
    self.slow = 0
    self.ds = 0.05
    task.New(self, function()
        local diff = difficulty
        if diff == 4 then
            task.Wait(60)
            PlaySound("tan00")
            local da = 360/7
            for i = -3, 3 do
                for j = 0, 3 do
                    New(_b[1], self.x, self.y, 1 + 0.15*j, -90 + da*i, arrow_big, 9)
                end
            end
        elseif diff == 3 then
            task.Wait(70)
            PlaySound("tan00")
            local da = 360/5
            for i = -2, 2 do
                for j = 0, 2 do
                    New(_b[1], self.x, self.y, 1 + 0.15*j, -90 + da*i, arrow_big, 9)
                end
            end
        elseif diff == 2 then
            task.Wait(80)
            PlaySound("tan00")
            local da = 72
            for i = -1, 1, 2 do
                for j = 0, 1 do
                    New(_b[1], self.x, self.y, 1 + 0.15*j, -90 + da*i, arrow_big, 9)
                end
            end
        end
    end)
end
function _enemy:frame()
    enemy.frame(self)
    if not (self.sys_co == 1 or self.sys_co == 2) then
        self.y = self.y + speed --根据这个speed的值来决定速度
    else
        if self.slow >= 3 then self.ds = -0.125*self.ds end
        self.slow = max(0, self.slow + self.ds)
        self.y = self.y + speed + self.slow --根据这个speed的值来决定速度
    end
    if speed == 0 then --达到顶端时小怪也从两边散去
        if self.x<= 0 then
            AddV1(self, 0.025, -150)
        else
            AddV1(self, 0.025, -30)
        end
    end
end
function _enemy:kill()
    enemy.kill(self)
    _d[2](self)
end
_e[3] = _enemy
---4
_enemy = Class(enemy)
function _enemy:init(x, y, co, max)
    self.x, self.y = x, y
    enemy.init(self,4 + co, 20,false,false,false, true, 1, 0, 1)
    self.group = GROUP_NONTJT
    self.dye_range = 0
    self.max = max or 110
    delay_bound(self)
    _a[3](self)
end
function _enemy:frame()
    enemy.frame(self)
    self.dye_range = min(self.max, self.dye_range + 1.2)
    self.y = self.y + speed --根据这个speed的值来决定速度
    if speed == 0 then --达到顶端时小怪也从两边散去
        if self.x<= 0 then
            AddV1(self, 0.025, -150)
        else
            AddV1(self, 0.025, -30)
        end
    end
end
_e[4] = _enemy
---5--云上极光妖精
_enemy = Class(enemy)
function _enemy:init(x, y, co, a, u)
    _f[8](2, 1)
    self.x, self.y = x, y
    if co == 4 then co = nil end
    enemy.init(self,28 + (co or 4), 10,false,false,false, true, 1, 30, 1)
    self.group = GROUP_NONTJT
    _m[3](self, a, u)
    dec_dmg(self, 30, 30)
    task.New(self, function ()
        dye_range_add(self, 60, 45)
    end)
end
function _enemy:kill()
    enemy.kill(self)
    _f[8](2, -1)
end
function _enemy:del()
    _f[8](2, -1)
end
_e[5] = _enemy
---6--躲在极光里的妖精
_enemy = Class(enemy)
function _enemy:init(x, y, co, a, a0, b_c)
    _f[8](1, 1)
    self.x, self.y = x, y
    if co == 4 then co = nil end
    enemy.init(self,24 + (co or 4), 20,false,false,false, false, co, 0, 1, 1)
    self.group = GROUP_NONTJT
    self.colli = false
    self.hide = true
    task.New(self, function ()
        self.hide = false
        self.colli = true
        _c[1](self, 60)
        _m[6](self, a)
        task.Wait(60)
        task.Wait(90)
    end)
    --弹幕攻击
    if not co then
        task.New(self, function()
            local diff = difficulty
            if diff == 4 then
                task.Wait(60)
                for _ = 1, 20 do
                    accbullet(stg.star_small, b_c, self.x, self.y, 3, a0 + 180, 60).omiga = 3
                    task.Wait(10)
                end
            elseif diff == 3 then
                task.Wait(70)
                for _ = 1, 13 do
                    accbullet(stg.star_small, b_c, self.x, self.y, 2.25, a0 + 180, 60).omiga = 3
                    task.Wait(15)
                end
            elseif diff == 2 then
                task.Wait(80)
                for _ = 1, 9 do
                    accbullet(stg.star_small, b_c, self.x, self.y, 1.8, a0 + 180, 60).omiga = 3
                    task.Wait(20)
                end
            else
                task.Wait(90)
                for _ = 1, 6 do
                    accbullet(stg.star_small, b_c, self.x, self.y, 1.5, a0 + 180, 60).omiga = 3
                    task.Wait(30)
                end
            end
        end)
    end

end
function _enemy:kill()
    enemy.kill(self)
    _f[8](1, -1)
    _d[3](self)
end
function _enemy:del()
    enemy.del(self)
    _f[8](1, -1)
end
_e[6] = _enemy
---7--击破了会产生小怪的大怪
_enemy = Class(enemy)
function _enemy:init(x, y, co, u)
    _f[8](3, 1)
    self.x, self.y = x, y
    enemy.init(self,28 + co, 30,false,false,false, true, co, 30, 1)
    self.group = GROUP_NONTJT
    _m[5](self, u)
    dec_dmg(self, 60, 60)
    dye_range_add(self, 90, 60)
    if co == 2 then co = 6 end
    if co == 1 then co = 2 end
    _a[8](self, co, u)
end
function _enemy:kill()
    enemy.kill(self)
    --_s[2](self)
    _f[8](3, -1)
end
function _enemy:del()
    enemy.del(self)
    --_s[2](self)
    _f[8](3, -1)
end
_e[7] = _enemy
---8--
_enemy = Class(enemy)
function _enemy:init(x, y, co)
    _f[8](4, 1)
    self.x, self.y = x, y
    if co == 4 then co = nil end
    enemy.init(self,24 + (co or 4), 20,false,true,false, false, co, 0, 1)
    self.group = GROUP_NONTJT
    task.New(self, function ()
        task.Wait(100)
        _a[5](self)
    end)
    task.New(self, function ()
        _c[1](self, 20)
        task.Wait(20 + 60)
        trace_to_player2(self, 3, 90, 60, 1.35, 0.25, 30, 2, 120, 30)
    end)
end
function _enemy:kill()
    enemy.kill(self)
    _f[8](4, -1)
    _d[3](self)
end
function _enemy:del()
    _enemy.del(self)
    _f[8](4, -1)
end
_e[8] = _enemy
---9--绕圆运动的大妖精

---9号旋转大蝴蝶
_enemy = Class(enemy)
function _enemy:init(co, i, a, b_c, da)
    self.x, self.y = cen[1] + _r[i]*cos(a), cen[2] + _r[i]*sin(a)
    if co == 4 then co = nil end
    enemy.init(self,28 + (co or 4), 20,false,false,true, true, 1, 0, 1)
    _a[6](self, b_c, da, a, i)
    task.New(self, function ()
        while (_t<3330) do
            self.dye_range = max(30, min(100, 65 + 80*sin(_x[co])))
            a = a + da
            self.x, self.y = cen[1] + _r[i]*cos(a), cen[2] + _r[i]*sin(a)
            task.Wait(1)
        end
        self.vx, self.vy = _r[i]*(cos(a + da) - cos(a)), _r[i]*(sin(a + da) - sin(a)) --设置沿径向的速度
        if da < 0 then
            egg.AddSimStrChV(self, 0, 4, a - 235, 360)
        else
            egg.AddSimStrChV(self, 0, 4, a + 235, 360)
        end
        for _ = 1, 120 do
            self.dye_range = max(30, min(100, 65 + 80*sin(_x[co])))
            task.Wait(1)
        end
        while(self.dye_range > 0) do
            self.dye_range = max(0, self.dye_range - 0.5)
            task.Wait(1)
        end
        self._type = false
        self.bound = true
        while true do
            if self.sys_co then self.sys_co = 4 end
            task.Wait(1)
        end
    end)
end
_e[9] = _enemy
local spawn_big = Class(object)--上述大蝴蝶的侦测器
function spawn_big:init(co, i, a, b_c, da, wt)
    self.x, self.y = cen[1] + _r[i]*cos(a), cen[2] + _r[i]*sin(a)
    local enemy = nil
    self.bound = false
    task.New(self, function()
        while (_t<wt) do --可以实现对应位置的小怪被消灭后，出屏可以补充一只新的小怪
            if not IsValid(enemy) and (self.x < -224 or self.x > 224 or self.y > 245 or self.y < -245) then
                enemy = New(_e[9], co, i, a, b_c, da)
            end
            a = a + da
            self.x, self.y = cen[1] + _r[i]*cos(a), cen[2] + _r[i]*sin(a)
            task.Wait(1)
        end
        Del(self) --超过预期时间wt就不再补充新小怪了
    end)
end
function spawn_big:frame()
    task.Do(self)
end
function spawn_big:render() end
---10号旋转小妖精
_enemy = Class(enemy)
function _enemy:init(i, a, da, dr)
    self.x, self.y = cen[1] + _r[i]*cos(a), cen[2] + _r[i]*sin(a)
    enemy.init(self,28, 20,false,false,true, false, nil, 0, 1, 1)
    task.New(self, function ()
        local r
        while _t<3330 do
            r = _r[i] + dr
            a = a + da
            self.x, self.y = cen[1] + r*cos(a), cen[2] + r*sin(a)
            task.Wait(1)
        end
        self.vx, self.vy = _r[i]*(cos(a + da) - cos(a)), _r[i]*(sin(a + da) - sin(a)) --设置沿径向的速度
        if da < 0 then
            egg.AddSimStrChV(self, 0, 4, a - 235 , 360)
        else
            egg.AddSimStrChV(self, 0, 4, a + 235, 360)
        end
        task.Wait(240)
        _a[9](self)
        self.bound = true
    end)
    --
    task.New(self, function()
        local diff = difficulty
        if diff == 4 then
            task.Wait(120)
            for _ = 1, 3 do
                if Dist(self, player) > 100 and self.y > 0 then
                    stg.newBulletStraight(stg.ball_mid_c, 3, true, self.x, self.y, 3, Angle(self, player))
                end
                task.Wait(180)
            end
        elseif diff == 3 then
            task.Wait(180)
            for _ = 1, 3 do
                if Dist(self, player) > 100 and self.y > 0 then
                    stg.newBulletStraight(stg.ball_mid_c, 3, true, self.x, self.y, 2, Angle(self, player))
                end
                task.Wait(240)
            end
        elseif diff == 2 then
            task.Wait(360)
            for _ = 1, 2 do
                if Dist(self, player) > 100 and self.y > 0 then
                    stg.newBulletStraight(stg.ball_mid_c, 3, true, self.x, self.y, 1, Angle(self, player))
                end
                task.Wait(360)
            end
        else

        end
    end)
end
function _enemy:kill()
    enemy.kill(self)
    _d[4](self)
end
function _enemy:dyeKill()
    enemy.kill(self)
    _del(self, false)
end
_e[10] = _enemy
local spawn_small = Class(object)--上述小妖精的侦测器
function spawn_small:init(i, a, da, dr, wt)
    self.x, self.y = cen[1] + _r[i]*cos(a), cen[2] + _r[i]*sin(a)
    local enemy = nil
    self.bound = false
    task.New(self, function ()
        while (_t<wt) do --可以实现对应位置的小怪被消灭后，出屏可以补充一只新的小怪
            if not IsValid(enemy) and (self.x < -224 or self.x > 224 or self.y > 245 or self.y < -245) then
                enemy = New(_e[10], i, a, da, dr)
            end
            a = a + da
            self.x, self.y = cen[1] + _r[i]*cos(a), cen[2] + _r[i]*sin(a)
            task.Wait(1)
        end
        Del(self)
    end)
end
function spawn_small:frame()
    task.Do(self)
end
---11--躲在极光里的妖精(旧
_enemy = Class(enemy)
function _enemy:init(x, y, co, a)
    self.x, self.y = x, y
    if co == 4 then co = nil end
    enemy.init(self,24 + (co or 4), 20,false,false,false, false, co, 0, 1)
    self.group = GROUP_NONTJT
    self.colli = false
    self.hide = true
    task.New(self, function ()
        task.Wait(100)
        self.hide = false
        _c[1](self, 60)
        _m[4](self, a, 100)
        task.Wait(60)
        self.colli = true
        task.Wait(30)
        _a[5](self, 3)
    end)
end
function _enemy:kill()
    enemy.kill(self)
    _d[3](self)
end
_e[11] = _enemy
---工具大蝴蝶（因为数量极少，移动单独在关内定义
_enemy = Class(enemy)
function _enemy:init(x, y, co, hp, dt, range)
    range = range or 140
    dt = dt or 30
    hp = hp or 20
    self.x, self.y = x, y
    if co == 4 then co = nil end
    enemy.init(self,28 + (co or 4), hp,false,false,true, true, co, 0, 1)
    self.group = GROUP_NONTJT
    task.New(self, function()
        dec_dmg(self, 60, 60)
        task.Wait(dt)
        _a[7](self)
        for x = 1, 60 do
            self.dye_range = range*sin(1.75*x)
            task.Wait(1)
        end
        task.Wait(240)
        --溜了溜了
        egg.AddSimStrChV(self, 0, 1, 90, 120)
    end)
end
_e[12] = _enemy
--新彩虹桥工具人蝴蝶
local e13 = Class(enemy)
function e13:init(x, y, co, hp, dt, range)
    range = range or 140
    dt = dt or 30
    hp = hp or 20
    self.x, self.y = x, y
    if co == 4 then co = nil end
    enemy.init(self,28 + (co or 4), hp,false,false,true, true, 2, 0, 1)
    self.group = GROUP_NONTJT
    task.New(self, function()
        dec_dmg(self, 60 + dt, 10, 0.05)
        _c[1](self, 60)
        _m[6](self, 90)
        task.Wait(dt)
        _a[7](self)
        for x = 1, 60 do
            self.dye_range = range*sin(1.75*x)
            task.Wait(1)
        end
        task.Wait(360)
        --溜了溜了
        egg.AddSimStrChV(self, 0, 2, 120, 120)
    end)
end
--彩虹桥之后那段道中新增的妖精
local e14 = Class(enemy)
function e14:init(x, y, a, co)
    enemy.init(self,28, 20,false,false,false, false, nil, 0, 1)
    self.group = GROUP_NONTJT
    self.x, self.y = x, y
    --移动
    task.New(self, function()
        egg.AddSimStrChV(self, 1.5, -1.5, -90, 300)
        SetV(self, 0.5, a)
    end)
    --攻击
    task.New(self, function()
        local diff = difficulty
        if diff == 4 then
            while true do
                for i = 1, 5 do
                    accbullet(stg.star_small, co, self.x, self.y, 3, a + 72*i, 30).omiga = 3
                end
                task.Wait(10)
            end
        elseif diff == 3 then
            while true do
                for i = 1, 5 do
                    accbullet(stg.star_small, co, self.x, self.y, 2, a + 72*i, 30).omiga = 3
                end
                task.Wait(15)
            end
        elseif diff == 2 then
            while true do
                for i = 1, 5 do
                    accbullet(stg.star_small, co, self.x, self.y, 1.5, a + 72*i + 36, 30).omiga = 3
                end
                task.Wait(20)
            end
        else
            while true do
                for i = 1, 3 do
                    accbullet(stg.star_small, co, self.x, self.y, 1.25, a + 120*i + 60, 30).omiga = 3
                end
                task.Wait(30)
            end
        end
    end)
end
function e14:kill()
    local color = {1, 13, 9, 7, 5, 3}
    local a, diff = Angle(self, player) + ran:Float(-5, 5), difficulty
    PlaySound("kira00")
    if diff == 4 then
        for i = 0, 4 do
            for j = 1, 6 do
                stg.newBulletStraight(stg.arrow_small, color[j], true, self.x, self.y, 2 + 0.5*i, a + 10*(j-3.5))
            end
        end
    elseif diff == 3 then
        for i = 0, 2 do
            for j = 1, 6 do
                stg.newBulletStraight(stg.arrow_small, color[j], true, self.x, self.y, 1.7 + 0.3*i, a + 10*(j-3.5))
            end
        end
    elseif diff == 2 then
        for i = 0, 1 do
            for j = 1, 6 do
                stg.newBulletStraight(stg.arrow_small, color[j], true, self.x, self.y, 1.5 + 0*i, a + 10*(j-3.5))
            end
        end
    end
    enemy.kill(self)
end
function e14:dyeKill()
    enemy.kill(self)
    _del(self, false)
end

---小怪召唤术----------------------------------------
_s[1] = function(self)
    local n, co = 3, {2, 14, 12, 10, 8, 6, 4}
    --local timer = 0
    task.New(self, function ()
        task.Wait(45)
        local frame, da, a = 180/n, 360/7
        local function spawn()
            for i = 0, 6 do
                a = 90 + da*i
                New(_e[6], self.x + 30*cos(a), self.y + 30*sin(a), nil, 90, a, co[i+1])
            end
            New(e13, self.x, self.y, 1, 30, 20, 60)
        end
        task.Wait(50)
        spawn()
        task.Wait(80)
        spawn()
        task.Wait(60)
        spawn()
    end)
end
_s[2] = function(self)
    local a = 45
    for _ = 1, 4 do
        New(_e[8], self.x + 50*cos(a), self.y + 50*sin(a), nil)
        a = a + 90
    end
end


s4_road = E --导出定义

---特殊道中片段----------------------------
do
    --道末的大圆
    local smallenemys = {} --存放所有小怪对象
    local bigenemys = {} --存放所有大怪对象
    local center = {0 - 40, 224 + 360} --圆心坐标
    local radius = {130, 170, 220, 280, 350} --每层的半径r表
    local angpos = {0, 0, 0, 0, 0} --每层妖精的角速度
    local dAngpos = {1, -1, -1, 1, -1}
    local dyerate = {0, 0, 0, 0, 0} --染色圈大小比例
    local rate = 0 --染色圈的相位
    local times = 0 --计时器
    local maxtimes, dectimes = 3150, 120
    local killcount = 0 --大妖精击破统计
    local colors = {1, 13, 9, 7, 5, 3}
    local greenflag = true --绿妖精全存活开关
    --更新圆心位置
    function updateCenter(dx, dy)
        center[1] = center[1] + dx
        center[2] = center[2] + dy
        for _,o in ObjList(GROUP_ENEMY_BULLET) do
            if o.flag then
                o.x, o.y = o.x + dx, o.y + dy
            end
        end
    end
    --设置半径大小
    function setRadius(r1, r2, r3, r4, r5)
        radius[1], radius[2], radius[3], radius[4], radius[5] = r1, r2, r3, r4, r5
    end
    --获取半径大小
    function getRadius(i)
        return radius[i]
    end
    --更新同心圆的半径
    function updateRadius(i, dr)
        radius[i] = radius[i] + dr
    end
    --设置圆心角
    function setAngPos(a1, a2, a3, a4, a5)
        angpos[1], angpos[2], angpos[3], angpos[4], angpos[5] = a1, a2, a3, a4, a5
    end
    --获取i层圆心角
    function getAngPos(i)
        return angpos[i]
    end
    --更新i层圆心角
    function updateAngPos(i, da)
        angpos[i] = angpos[i] + da
    end
    --设置圆心角差
    function setDAngPos(da1, da2, da3, da4, da5)
        dAngpos[1], dAngpos[2], dAngpos[3], dAngpos[4], dAngpos[5] = da1, da2, da3, da4, da5
    end
    --获取i层圆心角差
    function getDAngPos(i)
        return dAngpos[i]
    end
    --更新i层圆心角差
    function updateDAngPos(i, da)
        dAngpos[i] = dAngpos[i] + da
    end
    --设置相位
    function setRate(p)
        rate = p
    end
    --获取相位
    function getRate()
        return rate
    end
    --更新相位
    function updateRate(drate)
        rate = max(0, min(1, rate + drate))
    end
    --设置圆心位置
    function setCenter(x, y)
        center[1], center[2] = x, y
    end
    --获取圆心位置
    function getCenter(i)
        return center[i]
    end
    --设置计时器
    function setTimes(t)
        times = t
    end
    --更新计时器
    function updateTimes()
        times = times + 1
    end
    --获取计时器
    function getTimes()
        return times
    end
    --设置i层染色圈比率
    function setDyeRate(i, rate)
        dyerate[i] = rate
    end
    --获取i层染色圈比率
    function getDyeRate(i)
        return dyerate[i]
    end
    --更新i层染色圈比率
    function updateDyeRate(i, drate)
        dyerate[i] = dyerate[i] + drate
    end
    --设置染色圈比率
    function setAllDyeRate(r1, r2, r3, r4, r5)
        dyerate[1], dyerate[2], dyerate[3], dyerate[4], dyerate[5] = r1, r2, r3, r4, r5
    end
    --初始化默认半径和圆心位置，重置背景相对运动速度,染色圈的相位
    function setDefault()
        setRadius(130, 170, 220, 280, 350) --半径初始化
        setCenter(400, 420) --圆心位置初始化
        setRate(0) --染色圈张开率
        setTimes(0) --计时器初始化
        setAngPos(0, 0, -180 - 30, -90 + 7.5 + 90 + 15, 0 + 12 + 24) --圆心角初始化
        setDAngPos(0.75, -0.65, -0.55, 0.4, -0.4) --圆心角差初始化
        setAllDyeRate(0, 0, 0, 0, 0) --染色圈大小初始化
        killcount = 0 --清零
        greenflag = true --绿妖精存活判断
    end

    --摩天轮大妖精
    local big_fairy = Class(enemy)
    function big_fairy:init(i, a, co, dr, rangemax, t0, t1, co_num)
        local r = getRadius(i) + dr
        local u = sign(getDAngPos(i)) --旋转方向
        dec_dmg(self, t0 + t1, 30, 0)
        self.i = i
        self.x, self.y = getCenter(1) + r*cos(a + getAngPos(i)), getCenter(2) + r*sin(a + getAngPos(i))
        enemy.init(self, 80, 15,false,false,true, true, co, 0, 0)
        self.group = GROUP_NONTJT
        _object.set_color(self, "", 255, 255, 255, 255)
        task.New(self, function ()
            local getRange
            if co == 1 then
                if i == 3 or i == 5 then
                    function getRange()
                        return 2*rangemax*getRate()*getDyeRate(i)
                    end
                else
                    function getRange()
                        return 2*rangemax*(1 - getRate())*getDyeRate(i)
                    end
                end
            else
                if i == 3 or i == 5 then
                    function getRange()
                        return 2*rangemax*(1 - getRate())*getDyeRate(i)
                    end
                else
                    function getRange()
                        return 2*rangemax*getRate()*getDyeRate(i)
                    end
                end
            end
            while getTimes() < maxtimes + dectimes do
                r = getRadius(i) + dr
                --self.dye_range = 2*rangemax*getRate()
                self.dye_range = getRange()
                self.x, self.y = getCenter(1) + r*cos(a + getAngPos(i)), getCenter(2) + r*sin(a + getAngPos(i))
                task.Wait(1)
            end
            self.bound = true
        end)
        table.insert(bigenemys, self)
        _a[6](self, colors[co_num], u)
    end
    function big_fairy:frame()
        enemy.frame(self)
        if self.i == 3 or self.i == 5 then
            if self.sys_co == 1 then
                if rate < 1 then
                    self.colli = false
                    self._a = max(70, self._a - 10)
                else
                    self.colli = true
                    self._a = min(255, self._a + 10)
                end
            elseif self.sys_co == 2 then
                if rate > 0 then
                    self.colli = false
                    self._a = max(70, self._a - 10)
                else
                    self.colli = true
                    self._a = min(255, self._a + 10)
                end
            end
        else
            if self.sys_co == 1 then
                if rate > 0 then
                    self.colli = false
                    self._a = max(70, self._a - 10)
                else
                    self.colli = true
                    self._a = min(255, self._a + 10)
                end
            elseif self.sys_co == 2 then
                if rate < 1 then
                    self.colli = false
                    self._a = max(70, self._a - 10)
                else
                    self.colli = true
                    self._a = min(255, self._a + 10)
                end
            end
        end

        --放雷时高防
        if player.nextspell > 10 then
            self.dmgrate = 0.05
        else
            self.dmgrate = 1
        end
    end
    function big_fairy:kill()
        enemy.kill(self)
        killcount = killcount + 1
    end
    --摩天轮小妖精
    local small_fairy = Class(enemy)
    function small_fairy:init(i, a, co, co_num)
        local r = getRadius(i)
        self.x, self.y = getCenter(1) + r*cos(a + getAngPos(i)), getCenter(2) + r*sin(a + getAngPos(i))
        enemy.init(self,28, 30,false,false,true, false, co, 0, 1)
        self.group = GROUP_NONTJT
        self.layer = LAYER_ENEMY+1
        local u = sign(getDAngPos(i)) --旋转方向
        --移动
        task.New(self, function ()
            while getTimes() < maxtimes + dectimes do
                r = getRadius(i)
                self.x, self.y = getCenter(1) + r*cos(a + getAngPos(i)), getCenter(2) + r*sin(a + getAngPos(i))
                task.Wait(1)
            end
            if self.sys_co == 3 then
                task.Wait(90)
                local v, a = getRadius(i)/150, Angle(self.x, self.y, center[1], center[2])
                local t0 = 300
                egg.AddSimStrChV(self, 0, v, a + 10*u, t0)
                local diff = difficulty
                if diff == 4 then
                    for _ = 1, 10 do
                        for i = 0, 1 do
                            accbullet(stg.arrow_big, colors[co_num] + 1, self.x, self.y, 1 + 0.25*i, a + 30 - 10*i, 30)
                        end
                        PlaySound("tan00")
                        task.Wait(15)
                    end
                elseif diff == 3 then
                    for _ = 1, 10 do
                        for i = 0, 0 do
                            accbullet(stg.arrow_big, colors[co_num] + 1, self.x, self.y, 1 + 0.25*i, a + 30 - 10*i, 30)
                        end
                        PlaySound("tan00")
                        task.Wait(15)
                    end
                elseif diff == 2 then
                    for _ = 1, 5 do
                        for i = 0, 0 do
                            accbullet(stg.arrow_big, colors[co_num] + 1, self.x, self.y, 1 + 0.25*i, a + 30 - 10*i, 30)
                        end
                        PlaySound("tan00")
                        task.Wait(30)
                    end
                else
                    task.Wait(30)
                    for _ = 1, 2 do
                        for i = 0, 0 do
                            accbullet(stg.arrow_big, colors[co_num] + 1, self.x, self.y, 1 + 0.25*i, a + 30 - 10*i, 30)
                        end
                        PlaySound("tan00")
                        task.Wait(60)
                    end
                end
                task.Wait(300)
                self.bound = true
            else
                self.bound = true
            end
        end)
        --攻击
        task.New(self, function ()
            while killcount < 54 do
                task.Wait(1)
            end
            task.Wait(60)
            local diff = difficulty
            if diff == 4 then
                local a0, da0, a = 180, 3*u
                while getTimes() < maxtimes + dectimes do
                    a0 = a0 + da0
                    a = Angle(center[1], center[2], self.x, self.y) + a0
                    if self.y > -50 and Dist(self, player) > 60 then
                        for i = 0, 1 do
                            accbullet(stg.arrow_big, colors[co_num] + 1, self.x, self.y, 1.5 + 0.5*i, a, 60)
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(60)
                end
            elseif diff == 3 then
                local a0, da0, a = 180, 3*u
                while getTimes() < maxtimes + dectimes do
                    a0 = a0 + da0
                    a = Angle(center[1], center[2], self.x, self.y) + a0
                    if self.y > -50 and Dist(self, player) > 60 then
                        for i = 0, 0 do
                            accbullet(stg.arrow_big, colors[co_num] + 1, self.x, self.y, 2, a, 60)
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(60)
                end
            elseif diff == 2 then
                local a0, da0, a = 180, 3*u
                while getTimes() < maxtimes + dectimes do
                    a0 = a0 + da0
                    a = Angle(center[1], center[2], self.x, self.y) + a0
                    if self.y > -50 and Dist(self, player) > 60 then
                        for i = 0, 0 do
                            accbullet(stg.arrow_big, colors[co_num] + 1, self.x, self.y, 1.5, a, 60)
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(90)
                end
            else
                local a0, da0, a = 180, 3*u
                while getTimes() < maxtimes + dectimes do
                    a0 = a0 + da0
                    a = Angle(center[1], center[2], self.x, self.y) + a0
                    if self.y > -50 and Dist(self, player) > 60 then
                        for i = 0, 0 do
                            accbullet(stg.arrow_big, colors[co_num] + 1, self.x, self.y, 1.25, a, 60)
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(120)
                end
            end

        end)
        table.insert(smallenemys, self)
    end
    function small_fairy:frame()
        enemy.frame(self)
        --放雷时高防
        if player.nextspell > 10 then
            self.dmgrate = 0.05
        else
            self.dmgrate = 1
        end
    end
    function small_fairy:kill()
        enemy.kill(self)
        _d[4](self)
        if self.sys_co == 3 then
            greenflag = false
        end
    end
    function small_fairy:dyeKill()
        enemy.kill(self)
        _del(self, false)
        if self.sys_co == 3 then
            greenflag = false
        end
    end
    --靓仔妖精
    local special_fairy = Class(enemy)
    function special_fairy:init()
        self.x, self.y = getCenter(1), getCenter(2)
        enemy.init(self, 88, 100,false,false,true, true, 2, 0, 0)
        _object.set_color(self, "", 0, 255, 255, 255)
        self.colli = false
        self.bomb_bonus = false
        self.group = GROUP_NONTJT
        --到了规定时间靓仔才有判定
        task.New(self, function()
            egg.SimAlpCh(self, 0, 255, 60, false)
            while getTimes() < maxtimes + dectimes do
                self.x, self.y = getCenter(1), getCenter(2)
                task.Wait(1)
            end
            s4_boss.dark_eff(self.x, self.y, 30)
            egg.SimAlpCh(self, 150, 255, 30)
            task.Wait(30)
            self.colli = true
            self.group = GROUP_NONTJT
            local flag = false --逃跑判定
            for _ = 1, 150 do
                if Dist(self, player) < 50 then
                    flag = true
                    break
                end
                task.Wait(1)
            end
            --flag = true
            if flag then
                dye_range_add(self, 300, 240)
            else
                egg.AddSimStrChV(self, 0, 3, 90, 120) --溜了溜了
            end
            task.Wait(300)
            self.bomb_bonus = true
        end)
    end
    function special_fairy:kill()
        enemy.kill(self)
        if self.bomb_bonus then
            _drop_item(item_bomb, 1, self.x, self.y)
        end
        item.DropItem(self.x, self.y, {10, 20, 30})
    end
    --激光圈
    local laserCircle = Class(object)
    function laserCircle:init(i, enemys)
        self.group = GROUP_GHOST
        self.layer = LAYER_ENEMY-1
        self.img = "s4_road_ls_blue"
        self.i = i
        self.r0 = getRadius(self.i) - 5
        self.r1 = getRadius(self.i) + 5
        self.bound = false
        self.enemys = enemys
    end
    function laserCircle:frame()
        self.x, self.y = getCenter(1), getCenter(2)
        self.r0, self.r1 = getRadius(self.i) - 7.5, getRadius(self.i) + 7.5
        --[[
        if Dist(self, player) >= self.r0 and Dist(self, player) <= self.r1 and player.death <=0 and player.protect <= 0 then
            player.death = 90 + player.check
            PlaySound("pldead00")
        end
        --]]
        -- 碰撞检测，要加上自机判定
        if Dist(self, player) >= max(0, self.r0 - player.A) and Dist(self, player) <= (self.r1 + player.A) then
            player.class.colli(player, self)
        end
        -- 擦弹，要加上擦弹圈的半径
        if self.timer % 4 == 0 and Dist(self, player.grazer) >= max(0, self.r0 - player.grazer.a) and Dist(self, player.grazer) <= (self.r1 + player.grazer.a) then
            player.grazer.class.colli(player.grazer, self)
            self._graze = false
            self._grazed = false
        end
        --
        local flag
        for i = 1, #self.enemys do
            if IsValid(self.enemys[i]) then
                flag = true
                break
            end
        end
        if not flag then
            Del(self)
        end
    end
    function laserCircle:render()
        SetImageState(self.img, "mul+add", Color(255*0.5, 255, 255, 255))
        if type(sp) == "table" then
            sp.misc.RenderRing(self.img, self.x, self.y, self.r0, self.r1, 128, 0, 360)
        else
            Del(self)
        end

        --misc.RenderRing(self.img, self.x, self.y, self.r0, self.r1, 0, 60, 1)
        --Render(self.img, 0, 0, 0, 1)
    end


    --半径扩展动画
    local function chRadiusTo(i)
        --默认50半径的缓冲
        local v = 2
        local rmax = getRadius(i) - 50
        local t0, t1 = rmax/v, 2*50/v
        local dv = -v/t1
        --setRadius(i, 0)
        radius[i] = 0
        New(tasker, function()
            for _ = 1, t0 do
                updateRadius(i, v)
                task.Wait(1)
            end
            local drate = 1/t1
            for _ = 1, t1 do
                v = v + dv
                updateRadius(i, v)
                updateDyeRate(i, drate)
                --setDyeRate(i, rate)
                task.Wait(1)
            end
        end)
        return t0, t1
    end

    --生成敌人
    local function spawnEnemy(self)
        task.New(self, function()
            --生成小妖精
            local num = {24, 30, 36, 48, 60} --小妖精数量表
            local da
            local i
            --第五层妖精要先出
            do
                --第五层小妖精
                i = 5
                da = 360/num[i]
                local enemys = {}
                local t0, t1 = chRadiusTo(i)
                for j = 1, 14 do
                    New(small_fairy, i, da*j, nil, j%6+1)
                end
                for j = 15 + 1, 30 - 1 do
                    New(small_fairy, i, da*j, 3, j%6+1)
                end
                for j = 31, 44 do
                    New(small_fairy, i, da*j, nil, j%6+1)
                end
                for j = 45 + 1, 60 - 1 do
                    New(small_fairy, i, da*j, 3, j%6+1)
                end
                --第五层大妖精
                i = 5
                da = 360/num[i]
                --蓝妖精
                for j = 1, 5 do
                    for u = 0, 1 do
                        table.insert(enemys, New(big_fairy, i, (-1 + 3*j)*da + 180*u, 2, -6, 24, t0, t1, j))
                    end
                end
                --红妖精
                for j = 1, 5 do
                    for u = 0, 1 do
                        table.insert(enemys, New(big_fairy, i, (-2 + 3*j)*da + 180*u, 1, 6, 25, t0, t1, 7-j))
                    end
                end
                New(laserCircle, i, enemys)
            end
            task.Wait(600)
            --第四层妖精
            do
                --第四层小妖精
                i = 4
                da = 360/num[i]
                local t0, t1 = chRadiusTo(i)
                for j = 1, 12 do
                    New(small_fairy, i, da*j, nil, j%6+1)
                end
                for j = 13 + 1, 24 - 1 do
                    New(small_fairy, i, da*j, 3, j%6+1)
                end
                for j = 25, 36 do
                    New(small_fairy, i, da*j, nil, j%6+1)
                end
                for j = 37 + 1, 48 - 1 do
                    New(small_fairy, i, da*j, 3, j%6+1)
                end

                local enemys = {}
                --第四层大妖精
                i = 4
                da = 360/num[i]
                --蓝妖精
                for j = 1, 6 do
                    for u = 0, 1 do
                        table.insert(enemys, New(big_fairy, i, (-0.5 + 2*j)*da + 180*u, 2, -6, 18, t0, t1, j))
                    end
                end
                --红妖精
                for j = 1, 4 do
                    for u = 0, 1 do
                        table.insert(enemys, New(big_fairy, i, (-1 + 3*j)*da + 180*u, 1, 6, 24, t0, t1, 7 - j))
                    end
                end
                New(laserCircle, i, enemys)
            end
            task.Wait(600)
            --第三层妖精
            do
                --第三层小妖精
                i = 3
                da = 360/num[i]
                local t0, t1 = chRadiusTo(i)
                for j = 1, 8 do
                    New(small_fairy, i, da*j, nil, j%6+1)
                end
                for j = 9 + 1, 18 - 1 do
                    New(small_fairy, i, da*j, 3, j%6+1)
                end
                for j = 19, 26 do
                    New(small_fairy, i, da*j, nil, j%6+1)
                end
                for j = 27 + 1, 36 - 1 do
                    New(small_fairy, i, da*j, 3, j%6+1)
                end
                --第三层大妖精
                i = 3
                da = 360/num[i]
                local enemys = {}
                --蓝妖精
                for j = 1, 4 do
                    for u = 0, 1 do
                        table.insert(enemys, New(big_fairy, i, (-0.5 + 2*j)*da + 180*u, 2, -6, 16, t0, t1, j))
                    end
                end
                --红妖精
                for j = 1, 5 do
                    for u = 0, 1 do
                        table.insert(enemys, New(big_fairy, i, (-1.5 + 2*j)*da + 180*u, 1, 6, 18, t0, t1, 7-j))
                    end
                end
                New(laserCircle, i, enemys)
            end
            --第二层小妖精
            i = 2
            chRadiusTo(i)
            da = 360/num[i]
            for j = 1, num[i] do
                New(small_fairy, i, da*j, 3, j%6+1)
            end
            task.Wait(300)
            i = 1
            local t0, t1 = chRadiusTo(i)
            --第一层小妖精
            da = 360/num[i]
            for j = 1, num[i] do
                New(small_fairy, i, 7.5 + da*j, nil, j%6+1)
            end

            local enemys = {}
            --第一层大妖精
            i = 1
            for j = 1, 12 do
                table.insert(enemys, New(big_fairy, i, 30*j, 1 + j%2, -24, 30, t0, t1, j%6+1))
            end
            New(laserCircle, 2, enemys)  --注意，这里是第二层激光，但条件是第一层大妖精全死

            --击破70只大妖精且时间不超过所有妖精开始减速时后生成靓仔
            while killcount < 70 do
                task.Wait(1)
            end
            if greenflag then
                if getTimes() < maxtimes then
                    --成就 靓仔妖精 (id:3001)
                    achievement.unlock("3001", true)
                    for _ = 1, 3 do
                        s4_boss.dark_eff(center[1], center[2], 20)
                    end
                    New(special_fairy)
                end
            end
        end)


    end
    --更新所有敌人位置
    local function updateEnemy(self)
        for i = 1, 5 do
            updateAngPos(i, getDAngPos(i))
        end
        if self.timer%180 == 0 then
            self.drate = -self.drate
        end
        updateRate(self.drate)
    end

    --加速减速变化圆心位置
    local function accDeccenter(self, v, a, t0, t1, t2)
        task.New(self, function()
            local v0, dv, dx, dy = 0, v/t0, cos(a), sin(a)
            for _ = 1, t0 do
                v0 = v0 + dv
                updateCenter(v0*dx, v0*dy)
                task.Wait(1)
            end
            for _ = 1, t1 do
                updateCenter(v0*dx, v0*dy)
                task.Wait(1)
            end
            dv = -v/t2
            for _ = 1, t2 do
                v0 = v0 + dv
                updateCenter(v0*dx, v0*dy)
                task.Wait(1)
            end
        end)
    end

    s4_circle = Class(object) --圆心变化器
    function s4_circle:init()
        self.bound = false
        self.group = GROUP_GHOST
        self.drate = -0.1 --与染色圈变大变小切换相关
        --self.dphase = 1.75 --相位更新量

        --圆心初始化
        setDefault()
        --生成敌人
        spawnEnemy(self)

        --圆心移动
        task.New(self, function ()
            accDeccenter(self, 0.5, 180, 120, 740, 360)
            task.Wait(760)
            accDeccenter(self, 0.25, -90, 300, 0, 300)
            task.Wait(300)
            accDeccenter(self, 0.15, 0, 120, 480, 120)
            task.Wait(720)
            accDeccenter(self, 0.25, -90, 120, 900, 120)
            task.Wait(900)
            accDeccenter(self, 0.2, -90, 220, 230, 220)
            task.Wait(300)
            --accDeccenter(self, 0.5, 0, 100, 50, 100)
        end)
        --妖精逃逸
        task.New(self, function()
            while getTimes() < maxtimes do
                task.Wait(1)
            end
            local rate, drate = 1, -1/120
            local dangpos = {} --先记录
            for i = 1, 5 do
                dangpos[i] = getDAngPos(i)
            end
            for _ = 1, 120 do
                rate = rate + drate
                for i = 1, 5 do
                    updateDyeRate(i, drate)
                end
                setDAngPos(dangpos[1]*rate, dangpos[2]*rate, dangpos[3]*rate, dangpos[4]*rate, dangpos[5]*rate) --都开始停止转
                task.Wait(1)
            end
            for _, obj in ipairs(bigenemys) do
                if IsValid(obj) then
                    egg.AddSimStrChV(obj, 0, 2, Angle(center[1], center[2], obj.x, obj.y), 300) --远离中间的方向逃逸
                end
            end
            for _, obj in ipairs(smallenemys) do
                if IsValid(obj) then
                    if obj.sys_co ~= 3 then
                        egg.AddSimStrChV(obj, 0, 2, Angle(center[1], center[2], obj.x, obj.y), 300) --远离中间的方向逃逸
                    end
                end
            end
        end)
    end
    function s4_circle:frame()

        task.Do(self)
        updateTimes(1) --每帧更新计时器1
        --计时器超过3600摩天轮结束
        if getTimes() > 3600 then
            Del(self)
        end
        --updatePhase(self.dphase) --更新圆心位置
        updateEnemy(self)

        self.x, self.y = center[1], center[2] --测试用
    end
    function s4_circle:render()
        --RenderText("ui_font_80green", center[1], 90,-150, 0.25)
        --RenderText("ui_font_80green", center[2], 90,-180, 0.25)
        --RenderText("ui_font_80green", _x[1], 90,-150, 0.25)
        --RenderText("ui_font_80green", _x[2], 90,-180, 0.25)
        --SetImageState("ball_huge1", "", Color(50, 255, 255, 255))
        --Render("ball_huge1", center[1], center[2], 0, 2, 2)
    end
end


local s4 = s4_road
local e = s4[6]
local f = s4[7]
local o = s4[9]

local reset_kill_count = f[10] -- i
local get_kill_count = f[9] --i
local add_kill_count = f[8] --i, count
local reset_all = f[11]


local function p1(self)
    --开幕
    reset_all()
    task.Wait(60)
    task.New(self, function()
        local enemy = {}
        local t = {0, 0, 0, 0}
        while(self.timer <= 60 + 725) do
            if not IsValid(enemy[1]) and t[1] == 0 then
                enemy[1] = New(e[2], -95, -270, 2, 45)
                t[1] = 150
            end
            if not IsValid(enemy[2]) and t[2] == 0 then
                enemy[2] = New(e[2], -35, -245, 1, 100)
                t[2] = 150
            end
            if not IsValid(enemy[3]) and t[3] == 0 then
                enemy[3] = New(e[2], 35, -245, 1, 80)
                t[3] = 150
            end
            if not IsValid(enemy[4]) and t[4] == 0 then
                enemy[4] = New(e[2], 95, -270, 2, 135)
                t[4] = 150
            end
            for i = 1, 4 do
                t[i] = max(0, t[i] - 1)
            end
            task.Wait(1)
        end
    end)
    task.Wait(0)
    local da = -30
    local dx = 224
    local dy = 170
    task.New(self, function()
        local u = -1
        local t = 0 --计时器
        for i = 1, 2 do
            da = -45
            dx = 224
            for j = 1, 4 do
                --New(e[1], ran:Float(50, 90)*u, 120, -90 + da*u, dx*u, dy)
                New(e0, ran:Float(50, 90)*u, 120, -90 + da*u) --装饰妖精
                task.Wait(5)
                da = da - 10
                dx = dx + 15
                dy = dy - 2
            end
            u = -u
            task.Wait(30)
        end
        task.Wait(61)
        while(self.timer <= 60 + 725) do
            if get_kill_count(1) <= 28 or t >= 90 then
                --if true then
                da = -45
                dx = 224
                for _ = 1, 4 do
                    New(e0, ran:Float(50, 90)*u, 120, -90 + da*u) --装饰妖精
                    New(e[1], dx*u, dy, -90 + da*u) --真妖精
                    task.Wait(5)
                    da = da - 10
                    dx = dx + 15
                    --dy = dy - 2
                end
                u = -u
                t = 0
                task.Wait(20)
            end
            t = t + 1
            task.Wait(1)
        end
    end)
    --420
    task.Wait(825)--705
    reset_all()
end
local function p2(self)
    --上升段
    do
        local h = 0
        local speed = -0.5
        local x = -100
        local dx = -50
        local co = 0.5
        local u = -1
        local n = 1
        while(self.timer <= 2000) do
            if(h <= 0) then
                if(self.timer <= 1750) then
                    New(e[3], x, 245 + h, nil)
                elseif self.timer <= 1950 then
                    New(e[3], x, 245 + h, 3)
                end

                h = h + 24
                x = x + dx
                if(x >= 150 + 25*(u - 1)) or (x <= -150 + 25*(u + 1)) then
                    New(e[4], (x - 1.4*dx), 240 + h, 1 + int(co)%2)
                    dx = -dx
                    if((2*co)%2==0) then u = -u end
                    co = co + 0.5
                    if(n%4 == 0) then
                        x = x - 0.01
                    elseif (n > 4 and n%4 == 1) then
                        x = x + 0.01
                    end
                    n = n + 1
                end
            else
                h = h + speed
            end
            if(self.timer <= 1800) then
                speed = max(-2.5, speed - 0.006)
            else
                speed = min(0, speed + 0.0125)
            end
            f[1](speed)
            task.Wait(1)
        end
    end
    --1850
    --task.Wait(150) --四面背景创建时的帧数，测试用，从头连起来时请删掉
    reset_all()
end
local function p3(self)
    s4_title()
    task.Wait(120)
    clearEnemyAndBullet()
    task.Wait(60) --2300
    do
        ----------------------1
        local y = 100
        local u = 1
        local b_c = {10, 6, 2} --弹幕颜色表
        for i = 1, 2 do
            if i == 1 then
                New(o[1], 224*u, y, b_c[i], 90 + 45*u, u, true)
            else
                New(o[1], 224*u, y, b_c[i], 90 + 45*u, u)
            end
            y = y +15
            task.Wait(60)
        end
        task.Wait(30)
        task.New(self, function()
            local y0, u0 = y - 100, u
            for i = 1, 3 do
                New(_o[1], -224*u0, y0 - 40*(i-1), b_c[i], 90 - 45*u0, -u0)
                task.Wait(30)
            end
            task.Wait(30)
            local dy = {32, -37, -112}
            for i = 1, 3 do
                New(e[5], -224*u0, y0 + dy[i] + 5, 1 + (0.5*(u0 + 1) + i)%2, 90 - 45*u0, -u0)
                task.Wait(150) -- 90f刷新一只
            end
        end)
        task.Wait(290) --2740
        ----------------------2
        y = 80
        u = -u
        b_c = {10, 6, 2} --弹幕颜色表
        for i = 1, 3 do
            if i == 1 then
                New(o[1], 224*u, y, b_c[i], 90 + 45*u, u, true)
            else
                New(o[1], 224*u, y, b_c[i], 90 + 45*u, u)
            end
            y = y + 15
            task.Wait(60)
        end
        --task.Wait(30)
        task.New(self, function()
            local y0, u0 = y - 100, u
            for i = 1, 3 do
                New(_o[1], -224*u0, y0 - 30*(i-1), b_c[i], 90 - 45*u0, -u0)
                task.Wait(30)
            end
            task.Wait(10)
            local dy = {17, -65, -140}
            for i = 1, 3 do
                New(e[5], -224*u0, y0 + dy[i] + 5, 1 + (0.5*(u0 + 1) + i)%2, 90 - 45*u0, -u0)
                task.Wait(150) -- 90f刷新一只
            end
        end)
        task.Wait(220) --3140
        ----------------------3
        b_c = {14, 6, 4, 2} --弹幕颜色表
        y = 80
        u = -u
        for i = 1, 4 do
            if i == 1 then
                New(o[1], 224*u, y, b_c[i], 90 + 45*u, u, true)
            else
                New(o[1], 224*u, y, b_c[i], 90 + 45*u, u)
            end
            y = y + 15
            task.Wait(45)
        end
        task.New(self, function()
            local y0, u0 = y - 100, u
            for i = 1, 3 do
                New(_o[1], -224*u0, y0 - 40*(i-1), b_c[i], 90 - 45*u0, -u0)
                task.Wait(30)
            end
            task.Wait(10)
            local dy = {-2, -80, -160}
            for i = 1, 3 do
                New(e[5], -224*u0, y0 + dy[i] + 5, 1 + (0.5*(u0 + 1) + i)%2, 90 - 45*u0, -u0)
                task.Wait(150) -- 90f刷新一只
            end
        end)
    end
    --3320
    task.Wait(360 + 120)--3680 + 120(后延2s
    reset_all()
end
local function p4(self)
    local co = {1, 13, 11, 9, 7, 5, 3}
    --蝴蝶阵
    self.timer = 3890 + 120
    do
        reset_all()
        local u = 1
        local x, y = 0, 50
        u = -u
        y = 150
        x = 0
        --一团小妖精
        for i = -3, 3 do
            New(e14, 0, 235, -90 + 10*i, co[i+4])
        end
        for i = 0, 1 do
            New(e[7], (224 + x)*u, y, 1 + i%2, u)
            y = y + 30
            x = x + 40
            task.Wait(30)
        end
        task.Wait(180)

        u = -u
        y = 150
        x = 0
        --一团小妖精
        for i = -3, 3 do
            New(e14, 0, 235, -90 + 10*i, co[i+4])
        end
        for i = 0, 1 do
            New(e[7], (224 + x)*u, y, 1 + i%2, u)
            y = y + 30
            x = x + 20
            task.Wait(30)
        end
        task.Wait(180)

        u = -u
        y = 130
        x = 0
        New(tasker, function()
            --一团小妖精
            for i = -3, 3 do
                New(e14, -30, 235, -90 + 10*i, co[i+4])
            end
            task.Wait(90)
            --一团小妖精
            for i = -3, 3 do
                New(e14, 30, 235, -90 + 10*i, co[i+4])
            end
        end)
        for i = 0, 2 do
            New(e[7], (224 + x)*u, y, 1 + i%2, u)
            y = y + 20
            x = x + 10
            task.Wait(30)
        end
        task.Wait(120)

        u = -u
        y = 130
        x = 0
        New(tasker, function()
            --一团小妖精
            for i = -3, 3 do
                New(e14, 30, 235, -90 + 10*i, co[i+4])
            end
            task.Wait(90)
            --一团小妖精
            for i = -3, 3 do
                New(e14, -30, 235, -90 + 10*i, co[i+4])
            end
        end)
        for i = 1, 3 do
            New(e[7], (224 + x)*u, y, 1 + i%2, u)
            y = y + 20
            x = x + 10
            task.Wait(30)
        end
        task.Wait(180)

        u = -u
        --两团小妖精
        for i = -3, 3 do
            New(e14, 30, 235, -90 + 10*i, co[i+4])
            New(e14, -30, 235, -90 + 10*i, co[i+4])
        end
        for i = 1, 1 do
            for u = -1, 1, 2 do
                New(e[7], (204 + 20*i)*u, 100 + 30*i, 1.5 - 0.5*u, u)
            end
            task.Wait(30)
        end
        task.Wait(90)

        --两团小妖精
        for i = -3, 3 do
            New(e14, 60, 235, -90 + 10*i, co[i+4])
            New(e14, -60, 235, -90 + 10*i, co[i+4])
        end
        for i = 1, 1 do
            for u = -1, 1, 2 do
                New(e[7], (204 + 20*i)*u, 100 + 30*i, 2, u)
                task.Wait(60)
            end
        end
        task.New(self, function ()
            local function f(self)
                task.New(self, function ()
                    SetV(self, 2.5, -90)
                    task.Wait(30)
                    egg.AddSimStrChV(self, 0, -2.5, -90, 60)
                    task.Wait(240)
                    egg.AddSimStrChV(self, 0, 1, 90, 90)
                end)
            end
            f(New(e[12], -50, 224, 2, 20, 30))
            f(New(e[12], 50, 224, 2, 20, 30))
            task.Wait(60)
            --再来中间一团
            for i = -3, 3 do
                New(e14, 0, 235, -90 + 10*i, co[i+4])
            end
        end)
    end
    --

    --4940
    while(self.timer <= 5260 + 240) do
        task.Wait(1)
    end
end
local function p5(self)
    New(s4_circle)
    task.Wait(4000 + 120)
    clearEnemyAndBullet()
    task.Wait(60)
end

local function road(self)
    do
        system.setTargetChain(700)
        LoadMusicRecord("s4")
        LoadMusicRecord("s4_boss")
        dialog.cacheResource("Stage4")
        dialog.cacheResource("Stage4_after")
        New(stage4_background_road)
        EISlib.stage.playMusic("s4", 0, true)
    end
    p1(self)
    p2(self)
    p3(self)
    p4(self)
    p5(self)
    s4_boss.main()
    task.Wait(120)
    system.makeSettlement(4)
    task.Wait(120)
end
s4_road.main = road
--四后半摩天轮单独练习
local function lastRoad(self)
    do
        LoadMusicRecord("s4")
        New(stage4_background, true) -- 使用类似符卡练习的背景
        EISlib.stage.playMusic("s4", 5500/60, true)
    end
    p5(self)
    task.Wait(120)
end
s4_road.lastRoad = lastRoad
-------------------------------
