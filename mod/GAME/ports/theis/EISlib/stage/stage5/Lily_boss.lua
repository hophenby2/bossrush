lstg.wis = lstg.wis or {}
if not s5_mid_boss then s5_mid_boss = {} end --五道中boss内容表
local path = ""

local _ACT_NONE_AUTO_Lily, _ACT_CAST_Lily


--行走图设置
local hscale, vscale = 0.5, 0.5
local tex = "Lily_boss"
local tex_u, tex_v, tex_n = 220, 220, 9


--加载其他资源
local function load_res()
    local path = ""
    --五面boss符卡背景
    path = "res/background/boss5a/"
    LoadImageFromFile("s5_boss_scbg5", path .. "scbg5.png", true, 0, 0, false, 0)
    LoadImageFromFile("s5_boss_scbg6", path .. "scbg6.png", true, 0, 0, false, 0)
    path = "res/stage/stage5/"
    LoadTexture(tex, path .. "Lily_boss.png")--载入行走图资源
    LoadImageFromFile("s5midboss_pic", path .. "s5midboss_pic.png", true, 0, 0, false, 0)--立绘加载
    --樱花特效
    LoadImageFromFile("Cherry_eff", path.."Cherry_eff.png", false, 8, 8)
    --樱花弹
    LoadImageFromFile("Lily_Cherry_bullet", path.."Lily_Cherry_bullet.png", false, 8, 8)
end
load_res()

--通常
do
    local id, anime, list
    local cutFrame = 8
    local wi = {
        ["normal"] = {
            id = { 1, 2, 3, 4, 5, 6, 1, 2, 3, 7, 8, 9 },
        },
        ["left"] = {
            id = { 10, 11, 12, 13, 14, 15, 16},
            loop = 4,
        },
        ["right"] = {
            id = { 19, 20, 21, 22, 23, 24, 25},
            loop = 4,
        },
    }
    function _ACT_NONE_AUTO_Lily(wisys, self, actionCount, actionCountMax)
        self.lr = self.lr or 1
        if self.dx > 0.005 then
            self.lr = min(self.lr + 2, 28)
        elseif self.dx < -0.005 then
            self.lr = max(self.lr - 2, -28)
        end
        if self.lr == 0 then
            if self.dx < 0 then
                self.lr = self.lr - 2
            else
                self.lr = self.lr + 2
            end
        end
        if self.dx == 0 then
            self.lr = sign(self.lr) * max(1, abs(self.lr) - 1)
        end
        if abs(self.lr) == 1 then
            list = wi["normal"]
            anime = int(self.ani / cutFrame) % #list.id + 1
            id = list.id[anime]
        elseif self.lr == 28 then
            list = wi["right"]
            anime = int(self.ani / cutFrame) % list.loop + 1
            id = list.id[#list.id - list.loop + anime]
            hscale = list.hscale or hscale
        elseif self.lr == -28 then
            list = wi["left"]
            anime = int(self.ani / cutFrame) % list.loop + 1
            id = list.id[#list.id - list.loop + anime]
            hscale = list.hscale or hscale
        elseif self.lr > 1 then
            list = wi["right"]
            anime = int((self.lr / 28) * #list.id) + 1
            id = list.id[anime]
            hscale = list.hscale or hscale
        elseif self.lr < -1 then
            list = wi["left"]
            anime = int((self.lr / 28) * #list.id) + 1
            id = list.id[anime]
            hscale = list.hscale or hscale
        end
        return id, hscale, vscale
    end
end

--施法(撒花)
local cast
do
    --4 5循环表示蓄力
    --12 - 15为施法循环
    local absorb = 0 --蓄力参数
    local absorb_max = 0 --最大蓄力时间
    local cirtime = 0 --循环时间

    local cutFrame = 8
    local id = { 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43}
    function _ACT_CAST_Lily(wisys, self, actionCount, actionCountMax)
        local anime = int(actionCount / cutFrame)
        local anime1 = int((actionCount - absorb_max) / cutFrame)
        local n
        if anime < 3 then
            n = anime + 1 --前三帧动画是一定要的
        elseif absorb > 0 then --蓄力动作循环
            absorb = absorb - 1
            n = 4 + (anime + 1)%2
        elseif anime1 < 11  then --蓄力之后的动作
            n = anime1 + 1
        elseif cirtime > 0 then --最后的抬手循环
            n = 12 + (anime1 + 1)%4
        else
            n = 16 --最后一帧放手
        end
        return id[n], hscale, vscale
    end

    --函数本体
    ---@param t0 number 蓄力时间
    ---@param t1 number 循环时间
    function cast(self, t0, t1)
        t0 = t0 or 16
        t0 = max(t0 - t0%4, 16)
        t1 = t1 or 32
        t1 = max(t1 - t1%4, 32) --都搞成4的倍数且限制最小值
        absorb, absorb_max = t0, t0
        cirtime = t1
        self._wisys:setAction("cast", 80 + t0 + t1)
    end
end

--莉莉白符卡背景
local scbg = Class(_spellcard_background)
function scbg:init()
    _spellcard_background.init(self)
    _spellcard_background.AddLayer(self, "s5_boss_scbg6", true, 0, 0, 0, 0.5, 0.5, 0, "mul+rev", 1, 1,
            function(self)
            end,
            function(self)
                task.Do(self)
            end,
            function(self)
            end
    )
    _spellcard_background.AddLayer(self, "s5_boss_scbg5", false, 0, 0, 0, 0, 0, 0, "", 1, 1,
            function(self)
            end,
            function(self)
                task.Do(self)
            end,
            function(self)
            end
    )
end
s5_mid_boss.scbg = scbg

-- 莉莉白立绘演出
local pic_show
do
    local pic = Class(object)
    function pic:init()
        self.x, self.y = 0, 100
        self.img = "s5midboss_pic"
        self.layer = LAYER_TOP + 1
        self.group = GROUP_GHOST
        _object.set_color(self, "", 0, 255, 255, 255)
        self.x, self.y = 120, 50
        self.bound = false
        self.hscale, self.vscale = 1.1, 1.1
        self.size = 1.1
        self.trails = {}
        task.New(self, function()
            egg.AddSimStrChV(self, 8, 1, 200, 30)
            egg.AddSimStrChV(self, 0, 4, 170, 70, 60)
            egg.SimAlpCh(self, 0, 255, 30)
            for _ = 1, 60 do
                table.insert(self.trails, { self.x, self.y, self.size, self.size, 20 }) --x, y, hscale, vscale, _a
                task.Wait(1)
            end
            task.Wait(20)
            egg.SimAlpCh(self, 255, 0, 20)
            task.Wait(20)
            Del(self)
        end)
    end
    function pic:frame()
        task.Do(self)
        for _, o in ipairs(self.trails) do
            o[3] = o[3] + 0.01
            o[4] = o[4] + 0.01
            o[5] = o[5] - 1.5
            if o[5] <= 0 then
                table.remove(self.trails, 1)
            end
        end
    end
    function pic:render()
        SetImageState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
        --SetImgState(self, self._blend, self._a, self._r, self._g, self._b)
        Render(self.img, self.x, self.y, 0, self.size, self.size)
        for _, o in ipairs(self.trails) do
            SetImgState(self, "", o[5], 255, 255, 255)
            Render(self.img, o[1], o[2], 0, o[3], o[4])
        end
    end
    function pic_show()
        New(tasker, function()
            New(pic)
            task.Wait(20)
            New(spell_open_circle_eff, 0, 0, 255, 0, 255, "tree_leaf_white", "tree_leaf_white")  --配合开卡立绘的特效
            misc.ShakeScreen(10, 3)
        end)
    end
end
s5_mid_boss.pic_show = pic_show


--樱花弹幕基类，不推荐直接new，生成实现由下面的函数实现
local cherry_bullet_class = Class(object)
function cherry_bullet_class:init(x, y, rot, size)
    bullet.init(self, ball_mid, 3, true, true)
    _object.set_color(self, "", 255, 255, 255, 255)
    self.x, self.y = x, y
    self.hscale, self.vscale = size, size
    self.rot = rot
    self.navi = true
    self.img = "Lily_Cherry_bullet"
end
function cherry_bullet_class:frame()
    task.Do(self)
end
function cherry_bullet_class:render()
    _object.render(self)
end
function cherry_bullet_class:colli(other)
    bullet.colli(self, other)
end
function cherry_bullet_class:kill()
    bullet.kill(self)
end
function cherry_bullet_class:del()
    bullet.del(self)
end
s5_mid_boss.cherry_bullet_class = cherry_bullet_class

--设置行走图
function lstg.wis.Lily(self)
    self._wisys = DNHWalkImageSystem(self, tex, 0, 0, tex_u, tex_v, tex_n)
    self._wisys:connectAction("normal", _ACT_NONE_AUTO_Lily)
    self._wisys:connectAction("cast", _ACT_CAST_Lily)
    self.cast = cast    --蓄力动作
    self.saoqiR, self.saoqiG, self.saoqiB, self.saoqiBlend = 0, 255, 0, "mul+rev"
    self.saoqi = New(boss_saoqi, self)
end

--五道中boss蓄力特效
local eff, bkeff, scbkeff, laser_eff, appear_eff
do
    function eff(x, y, t)
        New(AbEff, x, y, 'tree_leaf_white', 'Lily_Cherry_bullet', 168, 114, 235)
        if t then task.Wait(t) end
    end
    function bkeff(x, y)
        Spell_break_eff(x, y, 255, 0, 255, 'tree_leaf_white', 'Cherry_eff', 0)
    end
    function scbkeff(x, y)
        Spell_break_eff(x, y, 255, 0, 255, 'tree_leaf_white', 'Cherry_eff', 0.5)
    end
    function laser_eff(x, y, a, r, g, b)
        --New(s4_boss.lasereff, x, y, a, r, g, b)
    end
    --蓄力特效
    local appear = Class(object)
    function appear:init(x, y, R, G, B, blend)
        blend = blend or "mul+add"
        local imgs = {'tree_leaf_white', 'Cherry_eff'}
        self.bound = false
        self.x, self.y = 0, 0
        PlaySound("power02", 0.5)
        task.New(self, function()
            local a, r
            for _ = 1, 60 do
                for _ = 1, 3 do
                    a, r = ran:Float(0, 360), ran:Float(350, 600)
                    New(qhm_eff.eff_12, imgs[ran:Int(1, 2)], x + r*cos(a), y + r*sin(a), x, y, ran:Float(0.5, 1.25), R, G, B, blend)
                end
                task.Wait(2)
            end
            Del(self)
        end)
        task.New(self, function()
            local a, r
            for _ = 1, 40 do
                for _ = 1, 4 do
                    a, r = ran:Float(0,360), ran:Float(300,600)
                    New(qhm_eff.eff_12, imgs[ran:Int(1, 2)], x + r*cos(a), y + r*sin(a), x, y, ran:Float(0.075,0.125), R, G, B, blend)
                end
                task.Wait(4)
            end
        end)
        task.New(self, function()
            task.Wait(90)
            for _ = 1, 1 do
                New(qhm_eff.eff_11, x, y, 3, 100, 100, 100, "mul+add")
                New(qhm_eff.eff_11, x, y, 3.1, R, G, B, blend)
                task.Wait(20)
            end
        end)
    end
    function appear:frame()
        task.Do(self)
    end
    function appear_eff(x, y)
        New(appear, x, y, 255, 0, 255)
    end
end


--五面道中boss对雷减伤
local function bombDecDmage(self)
    task.New(self, function()
        while true do
            self.dmgrate = min(self.dmgrate + 0.01, 1)
            if IsValid(player) and player.protect > 0 then
                self.dmgrate = 0.5
            end
            task.Wait(1)
        end
    end)
end



--五道中boss默认的随机x朝向自机移动函数
local move_rd
do
    function move_rd(t, y0, dy)
        y0 = y0 or 144
        dy = dy or 25
        task.MoveToPlayer(t or 60, -40, 40, y0 - dy, y0 + dy, 10, 20, 10, 20, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
    end
end

local atks, scs = {}, {}  --存放非符和符卡函数的表
--开幕演出
local function boss_show(self, x, y)
    self.x, self.y = x or 0, y or 144
    self.colli = false
    self.hide = true
    _object.set_color(self, "", 0, 255, 255, 255)

    --动作
    do
        New(player_board_ch, 0, 255, 0, 300) --加一个屏幕变色
        appear_eff(self.x, self.y)
        task.Wait(120)
        self.hide = false
        egg.SimAlpCh(self, 0, 255, 60)
        task.Wait(60)
        boss.show_aura(self, true)
        self:cast()
        task.Wait(60)
        self.colli = true
        bkeff(self.x, self.y)
    end
end
--攻击阶段(1-4代表 E-L难度)
local function boss_atk1_normal_show(self)
    boss_show(self)
end
local function boss_atk1_scpr_show(self)
    boss_show(self)
end
local function boss_atk4(self)
    --cheat = true
    --攻击方式定义
    local f1, f2, f3, f4
    do
        --会变向的粉小玉弹
        function f1(x, y, dv0, dv1, a, u)
            local obj = stg.newBulletStraight(stg.ball_mid, 3, true, x, y, 0, a)
            obj.navi = true
            task.New(obj, function()
                egg.AddSimStrChV(obj, 3 + dv0, 1, a, 30)
                task.Wait(20)
                egg.AddSimStrChV(obj, 0, dv1, a, 30)
                task.Wait(30)
                PlaySound("kira00")
                egg.AddCirMove(obj, a + 90*u, 0, u, 0, 60, 30, 60, 60)
            end)
        end
        --春终
        function f2(x, y, a, dv, dt)
            local obj = stg.newBulletStraight(stg.grain_a, 3, true, x, y, 0, a)
            obj.rot = a
            SetV(obj, 2, a)
            task.New(obj, function()
                task.Wait(30)
                egg.AddSimStrChV(obj, 0, -1.75, a, 30)
                task.Wait(dt)
                PlaySound("kira00")
                egg.AddSimStrChV(obj, 0, 1 + dv, a, 60)
            end)
        end
        --普通蝶弹
        function f3(x, y, a, t)
            local obj = stg.newBulletStraight(stg.butterfly, 4, true, x, y, 0, a)
            SetV(obj, 1, a)
            egg.AddAccDecChV(obj, 1.5, a, 30, t)
        end
        --奇怪的拼弹
        function f4(x, y, a, t)
            local obj = stg.newBulletStraight(stg.ball_mid, 3, true, x, y, 0, a)
            obj.vscale = 0.65
            obj.b = obj.vscale*obj.b
            obj.rot = a
            obj.bound = false
            SetV(obj, 2, a)
            t = t or 9999
            task.New(obj, function()
                task.Wait(t)
                PlaySound("kira00")
                egg.AddSimStrChV(obj, 0, -4, a, 60)
            end)
            task.New(obj, function()
                task.Wait(300)
                obj.bound = true
            end)
        end
    end

    --炸出一堆蝶弹
    do
        local a = Angle(self, player)
        for j = 1, 24 do
            for i = 1, 12 do
                stg.newBulletStraight(stg.butterfly, 4, true, self.x, self.y, 1 + 0.25*i, a + 15*j + 5*i)
            end
        end
        task.Wait(30)
    end
    --攻击
    do
        local a, da, r, dr, dx, dy = ran:Float(-5, 5), 60/9, 15, 10
        local u = 1
        for _ = 1, 2 do
            for _ = 1, 6 do
                for i = -4, 4 do
                    r = 10
                    dx, dy = cos(a), sin(a)
                    for j = 0, 5 do
                        f1(self.x + r*dx, self.y + r*dy, 0.5*j, 0.25*abs(i), a + 1*j*u, u)
                        r = r + dr
                    end
                    a = a + da
                end
            end
            u = -u
            PlaySound("tan00")
            task.Wait(30)
            move_rd(30)
            task.Wait(30)
        end
    end
    --春终
    do
        local a, da, r, dr, a0, way, da0 = 0, 1.75, nil, -5, 0, 24
        for la = 0, 2 do
            a, da = 0, -da
            r = -(7 + 3*la)*dr + 10
            for t = 7 + 3*la, 1, -1 do
                for i = 1, 20 do
                    a0 = a + 18*i
                    for j = 0, 1 do --两层春终
                        f2(self.x + r*cos(a0), self.y + r*sin(a0), a0, 1.5*j, (24-12*j)*t)
                    end
                end
                PlaySound("tan00")
                task.Wait(4)
                a = a + da
                r = r + dr
            end
            task.Wait(30)
            --way = 24
            a = Angle(self, player)
            for t = 0, la + 1 do
                da0 = 360/way
                a0 = a + 0.5*da0*(t%2)
                for _ = 1, way do
                    f3(self.x, self.y, a0, 30*t)
                    a0 = a0 + da0
                end
                way = way + 3
                task.Wait(10)
            end
            move_rd(30)
        end
    end
    --三阶段拼花
    do
        task.MoveTo(0, 100, 90, MOVE_ACC_DEC)
        local a, r, a0, r0, da1
        local da, u, way = 60/12, -1, 32
        for _ = 1, 3 do
            a = Angle(self, player)
            da1 = 360/way
            for t = 0, 5 do
                a = a + da1/2
                for _ = 1, way do
                    f3(self.x, self.y, a, 20*t)
                    a = a + da1
                end
                PlaySound("kira00")
                task.Wait(6)
            end
            a = 20*u
            r = 30
            for _ = 1, 12 do
                for i = 1, 6 do
                    a0 = a + i*60
                    r0 = r
                    f4(self.x + r0*cos(a0), self.y + r0*sin(a0), a0, 60)
                    a0 = a0 - 2.5*u
                    r0 = r0 - 15
                    for _ = 1, 3 do
                        f4(self.x + r0*cos(a0), self.y + r0*sin(a0), a0)
                        a0 = a0 - 1.67*u
                        r0 = r0 - 4
                    end
                end
                PlaySound("tan00")
                task.Wait(5)
                a = a + da
            end
            task.Wait(115)
            u = -u
            da = -da
            way = way + 6
        end
    end
end
local function boss_atk3(self)
    --cheat = true
    --攻击方式定义
    local f1, f2, f3, f4
    do
        --会变向的粉小玉弹
        function f1(x, y, dv0, dv1, a, u)
            local obj = stg.newBulletStraight(stg.ball_mid, 3, true, x, y, 0, a)
            obj.navi = true
            task.New(obj, function()
                egg.AddSimStrChV(obj, 3 + dv0, 1, a, 30)
                task.Wait(20)
                egg.AddSimStrChV(obj, 0, dv1, a, 30)
                task.Wait(30)
                PlaySound("kira00")
                egg.AddCirMove(obj, a + 90*u, 0, u, 0, 50, 30, 30, 60)
            end)
        end
        --春终
        function f2(x, y, a, dv, dt)
            local obj = stg.newBulletStraight(stg.grain_a, 3, true, x, y, 0, a)
            obj.rot = a
            SetV(obj, 2, a)
            task.New(obj, function()
                task.Wait(30)
                egg.AddSimStrChV(obj, 0, -1.5, a, 30)
                task.Wait(dt)
                PlaySound("kira00")
                egg.AddSimStrChV(obj, 0, 1 + dv, a, 60)
            end)
        end
        --普通蝶弹
        function f3(x, y, a, t)
            local obj = stg.newBulletStraight(stg.butterfly, 4, true, x, y, 0, a)
            SetV(obj, 1, a)
            egg.AddAccDecChV(obj, 1.5, a, 30, t, 45)
        end
        --奇怪的拼弹
        function f4(x, y, a, t)
            local obj = stg.newBulletStraight(stg.ball_mid, 3, true, x, y, 0, a)
            obj.vscale = 0.65
            obj.b = obj.vscale*obj.b
            obj.rot = a
            obj.bound = false
            SetV(obj, 1.75, a)
            t = t or 9999
            task.New(obj, function()
                task.Wait(t)
                PlaySound("kira00")
                egg.AddSimStrChV(obj, 0, -3.5, a, 60)
            end)
            task.New(obj, function()
                task.Wait(300)
                obj.bound = true
            end)
        end
    end

    --炸出一堆蝶弹
    do
        local a = Angle(self, player)
        for j = 1, 18 do
            for i = 1, 9 do
                stg.newBulletStraight(stg.butterfly, 4, true, self.x, self.y, 1 + 0.25*i, a + 6*i + 20*j)
            end
        end
        task.Wait(30)
    end
    --攻击
    do
        local a, da, r, dr, dx, dy = 0, 60/7, 15, 15
        local u = 1
        for _ = 1, 2 do
            for _ = 1, 6 do
                for i = -3, 3 do
                    r = 10
                    dx, dy = cos(a), sin(a)
                    for j = 0, 3 do
                        f1(self.x + r*dx, self.y + r*dy, 0.5*j, 0.25*abs(i), a + 1*j*u, u)
                        r = r + dr
                    end
                    a = a + da
                end
            end
            u = -u
            PlaySound("tan00")
            task.Wait(30)
            move_rd(30)
            task.Wait(30)
        end
    end
    --春终
    do
        local a, da, r, dr, a0, way, da0 = 0, 2.5, nil, -5, 0, 18
        for la = 0, 2 do
            a, da = 0, -da
            r = -(6 + 2*la)*dr + 10
            for t = 6 + 2*la, 1, -1 do
                for i = 1, 15 do
                    a0 = a + 24*i
                    for j = 0, 1 do
                        f2(self.x + r*cos(a0), self.y + r*sin(a0), a0, 1.25*j, (24 - 12*j)*t)
                    end
                end
                PlaySound("tan00")
                task.Wait(4)
                a = a + da
                r = r + dr
            end
            task.Wait(30)
            a = Angle(self, player)
            for t = 0, la + 1 do
                da0 = 360/way
                a0 = a + 0.5*da0*(t%2)
                for _ = 1, way do
                    f3(self.x, self.y, a0, 30*t)
                    a0 = a0 + 15
                end
                way = way + 3
                task.Wait(10)
            end
            move_rd(30)
        end
    end
    --三阶段拼花
    do
        task.MoveTo(0, 100, 90, MOVE_ACC_DEC)
        local a, r, a0, r0, da1
        local da, u, way = 60/10, -1, 24
        for _ = 1, 3 do
            a = Angle(self, player)
            da1 = 360/way
            for t = 1, 3 do
                a = a + da1/3
                for _ = 1, way do
                    f3(self.x, self.y, a, 30*t)
                    a = a + da1
                end
                PlaySound("kira00")
                task.Wait(10)
            end
            a = 15*u
            r = 30
            for _ = 1, 10 do
                for i = 1, 6 do
                    a0 = a + i*60
                    r0 = r
                    f4(self.x + r0*cos(a0), self.y + r0*sin(a0), a0, 60)
                    a0 = a0 - 2.5*u
                    r0 = r0 - 15
                    for _ = 1, 3 do
                        f4(self.x + r0*cos(a0), self.y + r0*sin(a0), a0)
                        a0 = a0 - 1.67*u
                        r0 = r0 - 4
                    end
                end
                PlaySound("tan00")
                task.Wait(6)
                a = a + da
            end
            task.Wait(115)
            u = -u
            da = -da
            way = way + 6
        end
    end
end
local function boss_atk2(self)
    --cheat = true
    --攻击方式定义
    local f1, f2, f3, f4
    do
        --会变向的粉小玉弹
        function f1(x, y, dv0, dv1, a, u)
            local obj = stg.newBulletStraight(stg.ball_mid, 3, true, x, y, 0, a)
            obj.navi = true
            task.New(obj, function()
                egg.AddSimStrChV(obj, 3 + dv0, 1, a, 30)
                task.Wait(20)
                egg.AddSimStrChV(obj, 0, dv1, a, 30)
                task.Wait(30)
                PlaySound("kira00")
                --egg.AddCirMove(obj, a + 90*u, 0, u, 0, 100, 30, 30, 60)
                egg.AddSimStrChV(obj, 0, 0.75, a, 20)
            end)
        end
        --春终
        function f2(x, y, a, dt)
            local obj = stg.newBulletStraight(stg.grain_a, 3, true, x, y, 0, a)
            obj.rot = a
            SetV(obj, 2, a)
            task.New(obj, function()
                task.Wait(30)
                egg.AddSimStrChV(obj, 0, -1.5, a, 30)
                task.Wait(dt)
                PlaySound("kira00")
                egg.AddSimStrChV(obj, 0, 2, a, 60)
            end)
        end
        --普通蝶弹
        function f3(x, y, a, t)
            local obj = stg.newBulletStraight(stg.butterfly, 4, true, x, y, 0, a)
            SetV(obj, 0.9, a)
            egg.AddAccDecChV(obj, 1.5, a, 30, t, 60)
        end
        --奇怪的拼弹
        function f4(x, y, a, t)
            local obj = stg.newBulletStraight(stg.ball_mid, 3, true, x, y, 0, a)
            obj.vscale = 0.65
            obj.b = obj.vscale*obj.b
            obj.rot = a
            obj.bound = false
            SetV(obj, 1.5, a)
            t = t or 9999
            task.New(obj, function()
                task.Wait(t)
                PlaySound("kira00")
                egg.AddSimStrChV(obj, 0, -3, a, 60)
            end)
            task.New(obj, function()
                task.Wait(300)
                obj.bound = true
            end)
        end
    end

    --炸出一堆蝶弹
    do
        local a = Angle(self, player)
        for j = 1, 15 do
            for i = 1, 8 do
                stg.newBulletStraight(stg.butterfly, 4, true, self.x, self.y, 1 + 0.2*i, a + 8*i + 24*j)
            end
        end
        task.Wait(30)
    end
    --攻击
    do
        local a, da, r, dr, dx, dy = 0, 60/7, 15, 15
        local u = 1
        for _ = 1, 2 do
            for _ = 1, 6 do
                for i = -3, 3 do
                    r = 10
                    dx, dy = cos(a), sin(a)
                    for j = 0, 4 do
                        f1(self.x + r*dx, self.y + r*dy, 0.5*j, 0.25*abs(i), a + 1*j*u, u)
                        r = r + dr
                    end
                    a = a + da
                end
            end
            u = -u
            PlaySound("tan00")
            task.Wait(30)
            move_rd(30)
            task.Wait(30)
        end
    end
    --春终
    do
        local a, da, r, dr, a0, way, da0 = 0, 2, nil, -5, 0, 16
        for la = 0, 2 do
            a, da = 0, -da
            r = -(5 + 2*la)*dr + 10
            for t = 5 + 2*la, 1, -1 do
                for i = 1, 20 do
                    a0 = a + 18*i
                    f2(self.x + r*cos(a0), self.y + r*sin(a0), a0, 12*t)
                end
                PlaySound("tan00")
                task.Wait(4)
                a = a + da
                r = r + dr
            end
            task.Wait(30)
            a = Angle(self, player)
            for t = 0, la + 1 do
                da0 = 360/way
                a0 = a + 0.5*da0*(t%2)
                for _ = 1, way do
                    f3(self.x, self.y, a0, 30*t)
                    a0 = a0 + 20
                end
                way = way + 2
                task.Wait(10)
            end
            move_rd(30)
        end
    end
    --三阶段拼花
    do
        task.MoveTo(0, 100, 90, MOVE_ACC_DEC)
        local a, r, a0, r0, da1
        local da, u, way = 60/8, -1, 12
        for _ = 1, 3 do
            a = Angle(self, player)
            da1 = 360/way
            for t = 1, 3 do
                a = a + da1/3
                for _ = 1, way do
                    f3(self.x, self.y, a, 30*t)
                    a = a + da1
                end
                PlaySound("kira00")
                task.Wait(10)
            end
            a = 15*u
            r = 30
            for _ = 1, 8 do
                for i = 1, 6 do
                    a0 = a + i*60
                    r0 = r
                    f4(self.x + r0*cos(a0), self.y + r0*sin(a0), a0, 60)
                    a0 = a0 - 2.5*u
                    r0 = r0 - 15
                    for _ = 1, 2 do
                        f4(self.x + r0*cos(a0), self.y + r0*sin(a0), a0)
                        a0 = a0 - 2*u
                        r0 = r0 - 7.5
                    end
                end
                PlaySound("tan00")
                task.Wait(6)
                a = a + da
            end
            task.Wait(115)
            u = -u
            da = -da
            way = way + 6
        end
    end
end
local function boss_atk1(self)
    --cheat = true
    --攻击方式定义
    local f1, f2, f3, f4
    do
        --会变向的粉小玉弹
        function f1(x, y, dv0, dv1, a, u)
            local obj = stg.newBulletStraight(stg.ball_mid, 3, true, x, y, 0, a)
            obj.navi = true
            task.New(obj, function()
                egg.AddSimStrChV(obj, 3 + dv0, 1, a, 30)
                task.Wait(20)
                egg.AddSimStrChV(obj, 0, dv1, a, 30)
                task.Wait(30)
                PlaySound("kira00")
                --egg.AddCirMove(obj, a + 90*u, 0, u, 0, 100, 30, 30, 60)
                egg.AddSimStrChV(obj, 0, 0.5, a, 20)
            end)
        end
        --春终
        function f2(x, y, a, dt)
            local obj = stg.newBulletStraight(stg.grain_a, 3, true, x, y, 0, a)
            obj.rot = a
            SetV(obj, 2, a)
            task.New(obj, function()
                task.Wait(30)
                egg.AddSimStrChV(obj, 0, -1.5, a, 30)
                task.Wait(dt)
                PlaySound("kira00")
                egg.AddSimStrChV(obj, 0, 1.5, a, 60)
            end)
        end
        --普通蝶弹
        function f3(x, y, a, t)
            local obj = stg.newBulletStraight(stg.butterfly, 4, true, x, y, 0, a)
            SetV(obj, 0.8, a)
            egg.AddAccDecChV(obj, 1.4, a, 30, t, 60)
        end
        --奇怪的拼弹
        function f4(x, y, a, t)
            local obj = stg.newBulletStraight(stg.ball_mid, 3, true, x, y, 0, a)
            obj.vscale = 0.65
            obj.b = obj.vscale*obj.b
            obj.rot = a
            obj.bound = false
            SetV(obj, 1.25, a)
            t = t or 9999
            task.New(obj, function()
                task.Wait(t)
                PlaySound("kira00")
                egg.AddSimStrChV(obj, 0, -2.5, a, 60)
            end)
            task.New(obj, function()
                task.Wait(300)
                obj.bound = true
            end)
        end
    end

    --炸出一堆蝶弹
    do
        local a = Angle(self, player)
        for j = 1, 12 do
            for i = 1, 5 do
                stg.newBulletStraight(stg.butterfly, 4, true, self.x, self.y, 1 + 0.2*i, a + 10*i + 30*j)
            end
        end
        task.Wait(30)
    end
    --攻击
    do
        local a, da, r, dr, dx, dy = 0, 60/5, 15, 15
        local u = 1
        for _ = 1, 2 do
            for _ = 1, 6 do
                for i = -2, 2 do
                    r = 10
                    dx, dy = cos(a), sin(a)
                    for j = 0, 2 do
                        f1(self.x + r*dx, self.y + r*dy, 0.5*j, 0.25*abs(i), a + 1*j*u, u)
                        r = r + dr
                    end
                    a = a + da
                end
            end
            u = -u
            PlaySound("tan00")
            task.Wait(30)
            move_rd(30)
            task.Wait(30)
        end
    end
    --春终
    do
        local a, da, r, dr, a0, way, da0 = 0, 2, nil, -5, 0, 12
        for la = 0, 2 do
            a, da = 0, -da
            r = -(4 + 1*la)*dr + 10
            for t = 4 + 1*la, 1, -1 do
                for i = 1, 12 do
                    a0 = a + 30*i
                    f2(self.x + r*cos(a0), self.y + r*sin(a0), a0, 12*t)
                end
                PlaySound("tan00")
                task.Wait(4)
                a = a + da
                r = r + dr
            end
            task.Wait(30)
            a = Angle(self, player)
            for t = 0, la + 1 do
                da0 = 360/way
                a0 = a + 0.5*da0*(t%2)
                for _ = 1, way do
                    f3(self.x, self.y, a0, 30*t)
                    a0 = a0 + 30
                end
                way = way + 2
                task.Wait(10)
            end
            move_rd(30)
        end
    end
    --三阶段拼花
    do
        task.MoveTo(0, 100, 90, MOVE_ACC_DEC)
        local a, r, a0, r0, da1
        local da, u, way = 60/8, -1, 12
        for _ = 1, 3 do
            a = Angle(self, player)
            da1 = 360/way
            for t = 1, 3 do
                a = a + da1/3
                for _ = 1, way do
                    f3(self.x, self.y, a, 30*t)
                    a = a + da1
                end
                PlaySound("kira00")
                task.Wait(10)
            end
            a = 15*u
            r = 30
            for _ = 1, 8 do
                for i = 1, 6 do
                    a0 = a + i*60
                    r0 = r
                    f4(self.x + r0*cos(a0), self.y + r0*sin(a0), a0, 60)
                    a0 = a0 - 2.5*u
                    r0 = r0 - 15
                    f4(self.x + r0*cos(a0), self.y + r0*sin(a0), a0)
                    a0 = a0 - 2.5*u
                    r0 = r0 - 15
                end
                PlaySound("tan00")
                task.Wait(6)
                a = a + da
            end
            task.Wait(115)
            u = -u
            da = -da
            way = way + 3
        end
    end
end
table.insert(atks, {boss_atk1, boss_atk1_normal_show, boss_atk1_scpr_show})
table.insert(atks, {boss_atk2, boss_atk1_normal_show, boss_atk1_scpr_show})
table.insert(atks, {boss_atk3, boss_atk1_normal_show, boss_atk1_scpr_show})
table.insert(atks, {boss_atk4, boss_atk1_normal_show, boss_atk1_scpr_show})
--符卡阶段(1-4代表 E-L难度)
local function boss_sc1_normal_show(self)
    task.MoveTo(0, 144, 60, MOVE_ACC_DEC)
end
local function boss_sc1_scpr_show(self)
    self.x, self.y = 0, 144
    self.colli = false
    self.hide = true
    _object.set_color(self, "", 0, 255, 255, 255)

    --动作
    do
        appear_eff(self.x, self.y)
        task.Wait(120)
        self.hide = false
        self.colli = true
        egg.SimAlpCh(self, 0, 255, 60)
        boss.show_aura(self, true)
        task.Wait(60)
    end
end
local function boss_sc4(self)
    --self.x, self.y = 0, 90 --测试用的位置
    --cheat = true
    --攻击方式定义
    local f1, f2, f2_1, f3, f4, f5, f5_1
    do
        function f1(x, y, a, u, dt)
            local obj = stg.newBulletStraight(stg.butterfly, 3, true, x, y, 0, a, true)
            obj.hscale, obj.vscale = 1.5, 1.5
            obj.a, obj.b = obj.a*obj.hscale, obj.b*obj.vscale
            obj.navi = true
            obj.bound = false
            egg.AddCirMove(obj, a, 0.5*u, u, 50, 200, 100, 100, 100)
            task.New(obj, function()
                task.Wait(300)
                egg.AddSimStrChV(obj, 0, 5, a, 300)
            end)
            task.New(obj, function()
                task.Wait(80)
                for _ = 1, 9 do
                    for i = -1, 1 do
                        f2(obj.x, obj.y, obj.rot + 180 + 30*u*i, u, dt)
                    end
                    PlaySound("kira00")
                    task.Wait(2)
                    dt = dt - 2
                end
                task.Wait(30)
                for _ = 1, 30 do
                    f3(obj.x, obj.y, obj.rot + 180, 0)
                    PlaySound("kira00")
                    task.Wait(2)
                end
                Del(obj)
                obj.bound = true
            end)
        end
        --樱花弹
        function f2(x, y, a, u, dt)
            local obj = stg.newBulletStraight(stg.grain_a, 3, true, x, y, 0, a, true)
            egg.AddAccDecChV(obj, 2, a, 20, 10, 30)
            obj.navi = true
            task.New(obj, function()
                task.Wait(60)
                f2_1(obj.x, obj.y, a, u, dt)
                _del(obj, false)
            end)
        end
        --衍生花瓣弹
        function f2_1(x, y, a, u, dt)
            local obj = New(cherry_bullet_class, x, y, a, 1.25)
            obj.group = GROUP_INDES
            obj.navi = true
            obj.colli = false
            obj.timer = 11
            obj._a = 0
            task.New(obj, function()
                local d_a, ds = 255/11, -0.5/11
                for _ = 1, 11 do
                    obj._a = obj._a + d_a
                    obj.hscale, obj.vscale = obj.hscale + ds, obj.vscale + ds
                    task.Wait(1)
                end
                obj.colli = true
                obj.a, obj.b = 0.5*obj.a*obj.hscale, 0.5*obj.b*obj.vscale
                task.Wait(dt)
                egg.AddCirMove(obj, a - 90*u, -0.5*u, -(0.5 - 180/300)*u, 0, 200, 150, 30, 1)
                task.Wait(90)
                egg.AddSimStrChV(obj, 0, 2 + ran:Float(-0.5, 0.5), obj.rot + ran:Float(-5, 5), 160)
            end)
        end
        --星弹
        function f3(x, y, a)
            local obj = stg.newBulletStraight(stg.star_big, 3, true, x, y, 0, a, true)
            obj.bound = false
            obj.omiga = 2
            egg.AddAccDecChV(obj, 1, a, 30, 60, 30)
            egg.AddSimStrChV(obj, 0, ran:Float(1, 1.5), a + ran:Float(-90, 90), 180, 90)
            task.New(obj, function()
                task.Wait(180)
                obj.bound = true
            end)
        end
        --会变向的蝶弹
        function f4(x, y, dv0, a, u)
            local obj = stg.newBulletStraight(stg.butterfly, 3, true, x, y, 0, a)
            obj.hscale, obj.vscale = 1.25, 1.25
            obj.navi = true
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET+1
                egg.AddSimStrChV(obj, 3, 2 + dv0, a, 30)
                task.Wait(30)
                egg.AddCirMove(obj, a - 60*u, 0, u, 0, 75, 45, 45, 60)
            end)
        end
        --发射一次交叉花瓣
        function f5(a)
            for i = 1, 24 do
                for j = 0, 3 do
                    for u = -1, 1, 2 do
                        f5_1(self.x, self.y, 0.75 + 0.35*j, a + i*15 + 5*j, u)
                    end
                end
            end
        end
        --交叉花瓣
        function f5_1(x, y, v, a, u)
            local obj = New(cherry_bullet_class, x, y, a, 1)
            obj.navi = true
            obj.hscale, obj.vscale = 0.6, 0.6
            obj.a, obj.b = 2, 2
            egg.ChV(obj, 3, v, a, 75*u, 60, 60)
            task.New(obj, function()
                task.Wait(60)
                egg.AddSimStrChV(obj, 0, 1, obj.rot, 120)
            end)
        end
    end
    --攻击内容
    do
        s5_mid_boss.pic_show()
        task.Wait(90)
        self:cast()
        local u0 = 1
        for _ = 1, 2 do
            --丢蝶弹
            eff(self.x, self.y, 60)
            self._wisys:setAction("normal")
            do
                local a, u = Angle(self, player), u0
                for _ = 1, 2 do
                    for _ = 1, 24 do
                        for i = 0, 3 do
                            f4(self.x, self.y, 0.25*i, a + 4*i*u, u)
                        end
                        a = a + 15
                    end
                    PlaySound("tan00")
                    task.Wait(30)
                    --交叉花瓣
                    f5(a)
                    PlaySound("kira00")
                    move_rd(30, 144, 25)
                    u = -u
                end
            end
            --丢蝶弹与主体弹幕
            do
                task.MoveTo(0, 144, 30, MOVE_ACC_DEC)
                local a = Angle(self, player)
                for i = 1, 6 do
                    f1(self.x, self.y, 30 + 60*i, u0, 60)
                end
                f5(a)
                task.Wait(30)
                for i = 1, 6 do
                    f1(self.x, self.y, 30 + 60*i, -u0, 30)
                end
                f5(a)
                task.Wait(60)
                move_rd(30, 144, 25)
                eff(self.x, self.y, 60)
                local a, r
                for k = 1, 30 do
                    r = 120 - 5*k
                    for i = 1, 6 do
                        a = 10*k + 60*i
                        for j = 0, 2 + int(k/10) do
                            stg.newBulletStraight(stg.butterfly, 3, true, self.x + r*cos(a), self.y + r*sin(a), 3 - 0.065*k + 0.2*j, 90 + a + 0*k + 3*j)
                        end
                    end
                    PlaySound("kira00")
                    task.Wait(3)
                end
            end
            task.Wait(180)
        end
    end

end
local function boss_sc3(self)
    --攻击方式定义
    local f1, f2, f2_1, f3, f4, f5, f5_1
    do
        function f1(x, y, a, u, dt)
            local obj = stg.newBulletStraight(stg.butterfly, 3, true, x, y, 0, a, true)
            obj.hscale, obj.vscale = 1.5, 1.5
            obj.a, obj.b = obj.a*obj.hscale, obj.b*obj.vscale
            obj.navi = true
            obj.bound = false
            egg.AddCirMove(obj, a, 0.5*u, u, 50, 200, 100, 100, 100)
            task.New(obj, function()
                task.Wait(300)
                egg.AddSimStrChV(obj, 0, 5, a, 300)
            end)
            task.New(obj, function()
                task.Wait(80)
                for _ = 1, 9 do
                    for i = -1, 1 do
                        f2(obj.x, obj.y, obj.rot + 180 + 30*u*i, u, dt)
                    end
                    PlaySound("kira00")
                    task.Wait(2)
                    dt = dt - 2
                end
                task.Wait(30)
                for _ = 1, 20 do
                    f3(obj.x, obj.y, obj.rot + 180, 0)
                    PlaySound("kira00")
                    task.Wait(3)
                end
                Del(obj)
                obj.bound = true
            end)
        end
        --樱花弹
        function f2(x, y, a, u, dt)
            local obj = stg.newBulletStraight(stg.grain_a, 3, true, x, y, 0, a, true)
            egg.AddAccDecChV(obj, 2, a, 20, 10, 30)
            obj.navi = true
            task.New(obj, function()
                task.Wait(60)
                f2_1(obj.x, obj.y, a, u, dt)
                _del(obj, false)
            end)
        end
        --衍生花瓣弹
        function f2_1(x, y, a, u, dt)
            local obj = New(cherry_bullet_class, x, y, a, 1.25)
            obj.group = GROUP_INDES
            obj.navi = true
            obj.colli = false
            obj.timer = 11
            obj._a = 0
            task.New(obj, function()
                local d_a, ds = 255/11, -0.5/11
                for _ = 1, 11 do
                    obj._a = obj._a + d_a
                    obj.hscale, obj.vscale = obj.hscale + ds, obj.vscale + ds
                    task.Wait(1)
                end
                obj.colli = true
                obj.a, obj.b = 0.5*obj.a*obj.hscale, 0.5*obj.b*obj.vscale
                task.Wait(dt)
                egg.AddCirMove(obj, a - 90*u, -0.5*u, -(0.5 - 180/300)*u, 0, 200, 150, 30, 1)
                task.Wait(90)
                egg.AddSimStrChV(obj, 0, 1.5 + ran:Float(-0.5, 0.5), obj.rot + ran:Float(-5, 5), 160)
            end)
        end
        --星弹
        function f3(x, y, a)
            local obj = stg.newBulletStraight(stg.star_big, 3, true, x, y, 0, a, true)
            obj.bound = false
            obj.omiga = 2
            egg.AddAccDecChV(obj, 1, a, 30, 60, 30)
            egg.AddSimStrChV(obj, 0, ran:Float(1, 1.25), a + ran:Float(-90, 90), 180, 90)
            task.New(obj, function()
                task.Wait(180)
                obj.bound = true
            end)
        end
        --会变向的蝶弹
        function f4(x, y, dv0, a, u)
            local obj = stg.newBulletStraight(stg.butterfly, 3, true, x, y, 0, a)
            obj.hscale, obj.vscale = 1.25, 1.25
            obj.navi = true
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET+1
                egg.AddSimStrChV(obj, 3, 2 + dv0, a, 30)
                task.Wait(30)
                egg.AddCirMove(obj, a - 60*u, 0, u, 0, 75, 45, 45, 60)
            end)
        end
        --发射一次交叉花瓣
        function f5(a)
            for i = 1, 20 do
                for j = 0, 2 do
                    for u = -1, 1, 2 do
                        f5_1(self.x, self.y, 0.75 + 0.35*j, a + i*18 + 6*j, u)
                    end
                end
            end
        end
        --交叉花瓣
        function f5_1(x, y, v, a, u)
            local obj = New(cherry_bullet_class, x, y, a, 1)
            obj.navi = true
            obj.hscale, obj.vscale = 0.6, 0.6
            obj.a, obj.b = 2, 2
            egg.ChV(obj, 3, v, a, 75*u, 60, 60)
            task.New(obj, function()
                task.Wait(60)
                egg.AddSimStrChV(obj, 0, 1, obj.rot, 120)
            end)
        end
    end
    --攻击内容
    do
        s5_mid_boss.pic_show()
        task.Wait(90)
        self:cast()
        local u0 = 1
        for _ = 1, 2 do
            --丢蝶弹
            eff(self.x, self.y, 60)
            self._wisys:setAction("normal")
            do
                local a, u = Angle(self, player), u0
                for _ = 1, 2 do
                    for _ = 1, 20 do
                        for i = 0, 2 do
                            f4(self.x, self.y, 0.25*i, a + 4*i*u, u)
                        end
                        a = a + 18
                    end
                    PlaySound("tan00")
                    task.Wait(30)
                    --交叉花瓣
                    f5(a)
                    PlaySound("kira00")
                    move_rd(30, 144, 25)
                    u = -u
                end
            end
            --丢蝶弹与主体弹幕
            do
                task.MoveTo(0, 144, 30, MOVE_ACC_DEC)
                local a = Angle(self, player)
                for i = 1, 6 do
                    f1(self.x, self.y, 30 + 60*i, u0, 60)
                end
                f5(a)
                task.Wait(30)
                for i = 1, 6 do
                    f1(self.x, self.y, 30 + 60*i, -u0, 30)
                end
                f5(a)
                task.Wait(60)
                move_rd(30, 144, 25)
                eff(self.x, self.y, 60)
                local a, r
                for k = 1, 25 do
                    r = 120 - 5*k
                    for i = 1, 6 do
                        a = 10*k + 60*i
                        for j = 0, 2 + int(k/10) do
                            stg.newBulletStraight(stg.butterfly, 3, true, self.x + r*cos(a), self.y + r*sin(a), 3 - 0.065*k + 0.2*j, 90 + a + 0*k + 3*j)
                        end
                    end
                    PlaySound("kira00")
                    task.Wait(4)
                end
            end
            task.Wait(180)
        end
    end

end
local function boss_sc2(self)
    --攻击方式定义
    local f1, f2, f2_1, f3, f4, f5, f5_1
    do
        function f1(x, y, a, u, dt)
            local obj = stg.newBulletStraight(stg.butterfly, 3, true, x, y, 0, a, true)
            obj.hscale, obj.vscale = 1.5, 1.5
            obj.a, obj.b = obj.a*obj.hscale, obj.b*obj.vscale
            obj.navi = true
            obj.bound = false
            egg.AddCirMove(obj, a, 0.5*u, u, 50, 200, 100, 100, 100)
            task.New(obj, function()
                task.Wait(300)
                egg.AddSimStrChV(obj, 0, 5, a, 300)
            end)
            task.New(obj, function()
                task.Wait(80)
                for _ = 1, 9 do
                    for i = -1, 1 do
                        f2(obj.x, obj.y, obj.rot + 180 + 30*u*i, u, dt)
                    end
                    PlaySound("kira00")
                    task.Wait(2)
                    dt = dt - 2
                end
                task.Wait(30)
                for _ = 1, 15 do
                    f3(obj.x, obj.y, obj.rot + 180, 0)
                    PlaySound("kira00")
                    task.Wait(4)
                end
                Del(obj)
                obj.bound = true
            end)
        end
        --樱花弹
        function f2(x, y, a, u, dt)
            local obj = stg.newBulletStraight(stg.grain_a, 3, true, x, y, 0, a, true)
            egg.AddAccDecChV(obj, 2, a, 20, 10, 30)
            obj.navi = true
            task.New(obj, function()
                task.Wait(60)
                f2_1(obj.x, obj.y, a, u, dt)
                _del(obj, false)
            end)
        end
        --衍生花瓣弹
        function f2_1(x, y, a, u, dt)
            local obj = New(cherry_bullet_class, x, y, a, 1.25)
            obj.group = GROUP_INDES
            obj.navi = true
            obj.colli = false
            obj.timer = 11
            obj._a = 0
            task.New(obj, function()
                local d_a, ds = 255/11, -0.5/11
                for _ = 1, 11 do
                    obj._a = obj._a + d_a
                    obj.hscale, obj.vscale = obj.hscale + ds, obj.vscale + ds
                    task.Wait(1)
                end
                obj.colli = true
                obj.a, obj.b = 0.5*obj.a*obj.hscale, 0.5*obj.b*obj.vscale
                task.Wait(dt)
                egg.AddCirMove(obj, a - 90*u, -0.5*u, -(0.5 - 180/300)*u, 0, 200, 150, 30, 1)
                task.Wait(90)
                egg.AddSimStrChV(obj, 0, 1.5 + ran:Float(-0.5, 0.5), obj.rot + ran:Float(-5, 5), 160)
            end)
        end
        --星弹
        function f3(x, y, a)
            local obj = stg.newBulletStraight(stg.star_big, 3, true, x, y, 0, a, true)
            obj.bound = false
            obj.omiga = 2
            egg.AddAccDecChV(obj, 1, a, 30, 60, 30)
            egg.AddSimStrChV(obj, 0, ran:Float(0.9, 1.1), a + ran:Float(-90, 90), 180, 90)
            task.New(obj, function()
                task.Wait(180)
                obj.bound = true
            end)
        end
        --会变向的蝶弹
        function f4(x, y, dv0, a, u)
            local obj = stg.newBulletStraight(stg.butterfly, 3, true, x, y, 0, a)
            obj.hscale, obj.vscale = 1.25, 1.25
            obj.navi = true
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET+1
                egg.AddSimStrChV(obj, 3, 2 + dv0, a, 30)
                task.Wait(30)
                egg.AddCirMove(obj, a - 60*u, 0, u, 0, 75, 45, 45, 60)
            end)
        end
        --发射一次交叉花瓣
        function f5(a)
            for i = 1, 18 do
                for j = 0, 1 do
                    for u = -1, 1, 2 do
                        f5_1(self.x, self.y, 0.75 + 0.35*j, a + i*20 + 10*j, u)
                    end
                end
            end
        end
        --交叉花瓣
        function f5_1(x, y, v, a, u)
            local obj = New(cherry_bullet_class, x, y, a, 1)
            obj.navi = true
            obj.hscale, obj.vscale = 0.6, 0.6
            obj.a, obj.b = 2, 2
            egg.ChV(obj, 3, v, a, 75*u, 60, 60)
            task.New(obj, function()
                task.Wait(60)
                egg.AddSimStrChV(obj, 0, 1, obj.rot, 120)
            end)
        end
    end
    --攻击内容
    do
        s5_mid_boss.pic_show()
        task.Wait(90)
        self:cast()
        local u0 = 1
        for _ = 1, 2 do
            --丢蝶弹
            eff(self.x, self.y, 60)
            self._wisys:setAction("normal")
            do
                local a, u = Angle(self, player), u0
                for _ = 1, 2 do
                    for _ = 1, 18 do
                        for i = 0, 1 do
                            f4(self.x, self.y, 0.25*i, a + 4*i*u, u)
                        end
                        a = a + 20
                    end
                    PlaySound("tan00")
                    task.Wait(30)
                    --交叉花瓣
                    f5(a)
                    PlaySound("kira00")
                    move_rd(30, 144, 25)
                    u = -u
                end
            end
            --丢蝶弹与主体弹幕
            do
                task.MoveTo(0, 144, 30, MOVE_ACC_DEC)
                local a = Angle(self, player)
                for i = 1, 6 do
                    f1(self.x, self.y, 30 + 60*i, u0, 60)
                end
                f5(a)
                task.Wait(30)
                for i = 1, 6 do
                    f1(self.x, self.y, 30 + 60*i, -u0, 30)
                end
                f5(a)
                task.Wait(60)
                move_rd(30, 144, 25)
                eff(self.x, self.y, 60)
                local a, r
                for k = 1, 20 do
                    r = 120 - 5*k
                    for i = 1, 6 do
                        a = 10*k + 60*i
                        for j = 0, 2 + int(k/10) do
                            stg.newBulletStraight(stg.butterfly, 3, true, self.x + r*cos(a), self.y + r*sin(a), 3 - 0.065*k + 0.2*j, 90 + a + 0*k + 3*j)
                        end
                    end
                    PlaySound("kira00")
                    task.Wait(5)
                end
            end
            task.Wait(180)
        end
    end

end
local function boss_sc1(self)
    --攻击方式定义
    local f1, f2, f2_1, f3, f4, f5, f5_1
    do
        function f1(x, y, a, u, dt)
            local obj = stg.newBulletStraight(stg.butterfly, 3, true, x, y, 0, a, true)
            obj.hscale, obj.vscale = 1.5, 1.5
            obj.a, obj.b = obj.a*obj.hscale, obj.b*obj.vscale
            obj.navi = true
            obj.bound = false
            egg.AddCirMove(obj, a, 0.5*u, u, 50, 200, 100, 100, 100)
            task.New(obj, function()
                task.Wait(300)
                egg.AddSimStrChV(obj, 0, 5, a, 300)
            end)
            task.New(obj, function()
                task.Wait(80)
                for _ = 1, 9 do
                    for i = -1, 1 do
                        f2(obj.x, obj.y, obj.rot + 180 + 30*u*i, u, dt)
                    end
                    PlaySound("kira00")
                    task.Wait(2)
                    dt = dt - 2
                end
                task.Wait(30)
                for _ = 1, 10 do
                    f3(obj.x, obj.y, obj.rot + 180, 0)
                    PlaySound("kira00")
                    task.Wait(6)
                end
                Del(obj)
                obj.bound = true
            end)
        end
        --樱花弹
        function f2(x, y, a, u, dt)
            local obj = stg.newBulletStraight(stg.grain_a, 3, true, x, y, 0, a, true)
            egg.AddAccDecChV(obj, 2, a, 20, 10, 30)
            obj.navi = true
            task.New(obj, function()
                task.Wait(60)
                f2_1(obj.x, obj.y, a, u, dt)
                _del(obj, false)
            end)
        end
        --衍生花瓣弹
        function f2_1(x, y, a, u, dt)
            local obj = New(cherry_bullet_class, x, y, a, 1.25)
            obj.group = GROUP_INDES
            obj.navi = true
            obj.colli = false
            obj.timer = 11
            obj._a = 0
            task.New(obj, function()
                local d_a, ds = 255/11, -0.5/11
                for _ = 1, 11 do
                    obj._a = obj._a + d_a
                    obj.hscale, obj.vscale = obj.hscale + ds, obj.vscale + ds
                    task.Wait(1)
                end
                obj.colli = true
                obj.a, obj.b = 0.5*obj.a*obj.hscale, 0.5*obj.b*obj.vscale
                task.Wait(dt)
                egg.AddCirMove(obj, a - 90*u, -0.5*u, -(0.5 - 180/300)*u, 0, 200, 150, 30, 1)
                task.Wait(90)
                egg.AddSimStrChV(obj, 0, 1.25 + ran:Float(-0.5, 0.5), obj.rot + ran:Float(-5, 5), 160)
            end)
        end
        --星弹
        function f3(x, y, a)
            local obj = stg.newBulletStraight(stg.star_big, 3, true, x, y, 0, a, true)
            obj.bound = false
            obj.omiga = 2
            egg.AddAccDecChV(obj, 1, a, 30, 60, 30)
            egg.AddSimStrChV(obj, 0, ran:Float(0.8, 1), a + ran:Float(-90, 90), 180, 90)
            task.New(obj, function()
                task.Wait(180)
                obj.bound = true
            end)
        end
        --会变向的蝶弹
        function f4(x, y, dv0, a, u)
            local obj = stg.newBulletStraight(stg.butterfly, 3, true, x, y, 0, a)
            obj.hscale, obj.vscale = 1.25, 1.25
            obj.navi = true
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET+1
                egg.AddSimStrChV(obj, 3, 2 + dv0, a, 30)
                task.Wait(30)
                egg.AddCirMove(obj, a - 60*u, 0, u, 0, 75, 45, 45, 60)
            end)
        end
        --发射一次交叉花瓣
        function f5(a)
            for i = 1, 16 do
                for j = 0, 0 do
                    for u = -1, 1, 2 do
                        f5_1(self.x, self.y, 0.75 + 0.35*j, a + i*22.5 + 10*j, u)
                    end
                end
            end
        end
        --交叉花瓣
        function f5_1(x, y, v, a, u)
            local obj = New(cherry_bullet_class, x, y, a, 1)
            obj.navi = true
            obj.hscale, obj.vscale = 0.6, 0.6
            obj.a, obj.b = 2, 2
            egg.ChV(obj, 3, v, a, 75*u, 60, 60)
            task.New(obj, function()
                task.Wait(60)
                egg.AddSimStrChV(obj, 0, 1, obj.rot, 120)
            end)
        end
    end
    --攻击内容
    do
        s5_mid_boss.pic_show()
        task.Wait(90)
        self:cast()
        local u0 = 1
        for _ = 1, 2 do
            --丢蝶弹
            eff(self.x, self.y, 60)
            self._wisys:setAction("normal")
            do
                local a, u = Angle(self, player), u0
                for _ = 1, 2 do
                    for _ = 1, 12 do
                        for i = 0, 0 do
                            f4(self.x, self.y, 0.25*i, a + 4*i*u, u)
                        end
                        a = a + 30
                    end
                    PlaySound("tan00")
                    task.Wait(30)
                    --交叉花瓣
                    f5(a)
                    PlaySound("kira00")
                    move_rd(30, 144, 25)
                    u = -u
                end
            end
            --丢蝶弹与主体弹幕
            do
                task.MoveTo(0, 144, 30, MOVE_ACC_DEC)
                local a = Angle(self, player)
                for i = 1, 6 do
                    f1(self.x, self.y, 30 + 60*i, u0, 60)
                end
                f5(a)
                task.Wait(30)
                for i = 1, 6 do
                    f1(self.x, self.y, 30 + 60*i, -u0, 30)
                end
                f5(a)
                task.Wait(60)
                move_rd(30, 144, 25)
                eff(self.x, self.y, 60)
                local a, r
                for k = 1, 10 do
                    r = 120 - 5*k
                    for i = 1, 6 do
                        a = 10*k + 60*i
                        for j = 0, 2 + int(k/10) do
                            stg.newBulletStraight(stg.butterfly, 3, true, self.x + r*cos(a), self.y + r*sin(a), 3 - 0.065*k + 0.2*j, 90 + a + 0*k + 3*j)
                        end
                    end
                    PlaySound("kira00")
                    task.Wait(9)
                end
            end
            task.Wait(180)
        end
    end

end
table.insert(scs, {boss_sc1, boss_sc1_normal_show, boss_sc1_scpr_show})
table.insert(scs, {boss_sc2, boss_sc1_normal_show, boss_sc1_scpr_show})
table.insert(scs, {boss_sc3, boss_sc1_normal_show, boss_sc1_scpr_show})
table.insert(scs, {boss_sc4, boss_sc1_normal_show, boss_sc1_scpr_show})

-- 创建一个 boss 类
local function create_boss_class(class_name, group_name)
    local cls = Class(boss)
    _editor_class[class_name] = cls
    cls.cards = {}
    cls._name = class_name
    cls.name = "Lily White"
    cls.bgm = "s5"
    cls._bg = function() return stage5_background end
    cls.difficulty = group_name
    function cls:init(cards)
        boss.init(self, 0, 144, "Lily White", cards, New(s5_mid_boss.scbg), group_name)
        lstg.wis.Lily(self)
        self.colli = false
        self.extendBonus = true --奖残开关
    end
    return cls
end
-- 创建一个符卡
local function create_card_class(index, name, timet, hp, dropt, mode, advance)
    local _sc = boss.card.New(name, timet[1], timet[2], timet[3], hp, dropt, false, mode)
    _sc.perform = advance
    if mode == "normal" then
        function _sc:init()
            --bombDecDmage(self)
            task.New(self,function()
                atks[index][1](self)
            end)
        end
        function _sc:del()
            self.hscale = 1
            self._wisys:setAction("normal")
            self.vx, self.vy = 0, 0 --该停下来啦
            self.ax, self.ay = 0, 0
        end
    elseif mode == "spellcard" then
        function _sc:init()
            --bombDecDmage(self)
            task.New(self,function()
                scs[index][1](self)
            end)
        end
        function _sc:del()
            if self.timeout == 1 then --超时了不给残的
                self.extendBonus = false
            else
                bkeff(self.x, self.y)
            end
            self.hscale = 1
            self._wisys:setAction("normal")
            self.vx, self.vy = 0, 0 --该停下来啦
            self.ax, self.ay = 0, 0
        end
    end
    return _sc
end
-- 创建一个符卡练习
local function create_cardpr_class(index, name, timet, hp, dropt, mode, boss_class)
    local _sc = boss.card.New(name, timet[1], timet[2], timet[3], hp, dropt, false, mode)
    _sc.perform = true
    if mode == "normal" then
        function _sc:init()
            task.New(self,function()
                atks[index][1](self)
            end)
        end
        function _sc:del()
            self._wisys:setAction("normal")
        end
    elseif mode == "spellcard" then
        function _sc:init()
            task.New(self,function()
                scs[index][1](self)
            end)
        end
        function _sc:del()
            if self.timeout == 1 then
                self.extendBonus = false
            end
            self._wisys:setAction("normal")
        end
    end
    table.insert(_sc_table, { boss_class._name, name, _sc, #boss_class.cards+1, true })
    --table.insert(_sc_table, { boss_class._name, name, _sc, #boss_class.cards, advance })
    return _sc
end
-- 创建一个正常的演出
local function create_normal_show_class(index, mode)
    local _show = boss.dialog.New(true)
    function _show:init()
        player.dialog=false
        self.dialog_displayer=New(dialog_displayer)
        self._dialog_maintask=task.New(self,function()
            if mode == "normal" then
                atks[index][2](self)
            elseif mode == "spellcard" then
                scs[index][2](self)
            end
        end)
    end
    return _show
end
-- 创建一个符卡练习的演出
local function create_scpr_show_class(index, mode)
    local _show = boss.dialog.New(true)
    function _show:init()
        player.dialog=false
        self.dialog_displayer=New(dialog_displayer)
        self._dialog_maintask=task.New(self,function()
            if mode == "normal" then
                atks[index][3](self)
            elseif mode == "spellcard" then
                scs[index][3](self)
            end
        end)
    end
    return _show
end

--boss定义
local diff = {"Easy", "Normal", "Hard", "Lunatic"}

for j = 1, 4 do
    --主线boss
    local stage5mid_boss
    do
        stage5mid_boss = create_boss_class("stage5mid_boss:"..diff[j], diff[j])
        local card_info = {
            {"常规攻击1", {2,10,22},1200,{0,0,0}, "normal", false},
            {"「迎春之舞」", {2,12,25},1500,{10, 20, 30}, "spellcard", false},
        }
        stage5mid_boss.cards={}
        local i, info = 1
        --如果要插入新的card，请务必在local n之上插入，否则会影响后面二符的del函数
        local n = #stage5mid_boss.cards
        --五boss比较特殊，手动插入
        for i = 1, 2 do
            info = card_info[i]
            table.insert(stage5mid_boss.cards, create_normal_show_class(1, info[5]))
            table.insert(stage5mid_boss.cards, create_card_class(j, info[1], info[2], info[3], info[4], info[5], info[6]))
        end
        --用来溜的对话
        local _sc
        _sc = boss.dialog.New(true)
        --下面插入击破莉莉白后对话的sc...
        function _sc:init()
            self.colli = false
            player.dialog=false
            self.dialog_displayer=New(dialog_displayer)
            self._dialog_maintask=task.New(self,function()
                if self.extendBonus then
                    misc.ShakeScreen(60, 3)
                    PlaySound("enep01")
                    _drop_item(item_extend, 1, self.x, self.y)
                end
                task.Wait(60)
                task.MoveTo(320, 420,60, MOVE_ACCEL)
                if EISlib.stage.canDialog() then
                    --莉莉白离场后插入固定时长的对话吧
                    dialog.player.playScene("Stage5_mid", true)
                end
                Del(self)
            end)
        end
        table.insert(stage5mid_boss.cards,_sc)
        --防止boss自爆的非
        _sc = boss.card.New("",2,10,23,1000,{0,0,0},false)
        function _sc:init() end
        function _sc:del() end
        table.insert(stage5mid_boss.cards,_sc)
    end

    --符卡练习
    local stage5mid_bossScpr
    do
        stage5mid_bossScpr = create_boss_class("stage5mid_bossScpr:"..diff[j], diff[j])
        local card_info = {
            {"常规攻击1", {2,10,22},1200,{0,0,0}, "normal", false},
            {"「迎春之舞」", {2,12,25},1500,{10, 20, 30}, "spellcard", false},
        }
        stage5mid_bossScpr.cards={}
        local i, info = 1
        --如果要插入新的card，请务必在local n之上插入，否则会影响后面二符的del函数
        local n = #stage5mid_bossScpr.cards
        --五boss比较特殊，手动插入
        for i = 1, 2 do
            info = card_info[i]
            table.insert(stage5mid_bossScpr.cards, create_scpr_show_class(1, info[5]))
            table.insert(stage5mid_bossScpr.cards, create_cardpr_class(j, info[1], info[2], info[3], info[4], info[5], stage5mid_bossScpr))
        end
    end
end
