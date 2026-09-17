---=====================================
---TH03  白玉楼：西行寺幽幽子专场
---
---  十张符卡，母题来自幽幽子的三张经典符卡——
---    灵神「毘沙门之诞生」(th07)  · 双发射 / 镜像 / 相位漂移的轮盘 / 双反向激光轮
---    圣灵「樱花结界」  (th07)  · 用「沿半径排成一条线」的子弹拼几何结界
---    「蝴蝶梦之舞」    (th08)  · 扇幕封边 / 场地收缩 / 华尔兹滑步 / 密度递增
---  归纳下来就是三样东西：扇、蝶、樱。外加一条几何结界的做法。
---
---  写法沿用 th01 / th02 的房屋风格：
---    · 每张卡一个 do 块，常量集中在块首，改手感只动那里
---    · 需要复杂运动（弧线、螺线、被风推）的弹一律走 path_bullet 子类，不用协程
---    · 长时间 / 多阶段的演出控制器是挂在 boss 上的 object 子类，del 里清理
---
---  关于回收：引擎里 `bound` = 「离开边界自动回收」。
---    · NewSimpleBullet 造的弹保持默认 bound = true，飞出屏幕引擎自己收，不用管
---    · 自己 Class(object/bullet, ...) 造的、把 bound 关掉的，必须在 frame 里
---      用 retire() 或自己判寿命兜底回收，否则会漏对象
---=====================================

local class = {}
_editor_class["TH03"] = class

local Class = Class
local boss = boss
local task = task
local object = object
local bullet = bullet
local New = New
local NewSimpleBullet = NewSimpleBullet
local PlaySound = PlaySound
local Angle = Angle
local Dist = Dist
local IsValid = IsValid
local GROUP, LAYER = GROUP, LAYER
local SetImageState = SetImageState
local Render = Render
local ran = ran
local cos, sin, max, min, abs, int, Forbid = cos, sin, max, min, abs, int, Forbid
local Newcharge_in, Newcharge_out = Newcharge_in, Newcharge_out

class["SCBG1"] = Class(_SC_BG)
class["SCBG1"].init = function(self)
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th03_0", true, 0, 0, 0, 0, -0.05, 0, "", 1, 1, function(l)
        --符卡背景：一层偏粉的夜色
        l.r, l.g, l.b = 224, 150, 190
    end)
end

boss.Define("1a", "西行寺幽幽子", "TH03_0", TH03_bg, { 0, 300 }, class["SCBG1"], "Yuyuko", 23)

--============================
--公用小工具
--============================

---加算细线（自绘，不生成对象，所以没有判定）
local function thin_line(x1, y1, x2, y2, a, r, g, b, w)
    local len = Dist(x1, y1, x2, y2)
    if a <= 0 or len < 1 then
        return
    end
    SetImageState("white", "mul+add", a, r, g, b)
    Render("white", (x1 + x2) * 0.5, (y1 + y2) * 0.5, Angle(x1, y1, x2, y2), len / 16, w or 0.2)
end

---画一颗带光晕的光玉（自绘）
local function draw_orb(x, y, size, a, r, g, b)
    if a <= 0 or size <= 0 then
        return
    end
    SetImageState("ball_huge6", "mul+add", 62 * a, r * 0.55, g * 0.55, b * 0.8)
    Render("ball_huge6", x, y, 0, size * 1.45, size * 1.45)
    SetImageState("ball_big6", "mul+add", 175 * a, r, g, b)
    Render("ball_big6", x, y, 0, size * 0.52, size * 0.52)
    SetImageState("ball_mid6", "mul+add", 210 * a, 255, 255, 255)
    Render("ball_mid6", x, y, 0, size * 0.20, size * 0.20)
end

---画一片花瓣：ellipse 贴图本来就是椭圆，当花瓣正合适
local function draw_petal(x, y, rot, size, a, r, g, b)
    if a <= 0 or size <= 0 then
        return
    end
    SetImageState("ellipse6", "mul+add", a, r, g, b)
    Render("ellipse6", x, y, rot, size * 1.55, size)
end

---画一只蝶（翅膀一开一合）
local function draw_butterfly(x, y, rot, size, a, flap, col)
    if a <= 0 then
        return
    end
    local img = "butterfly" .. (Forbid(col or 2, 1, 8))
    local k = 0.55 + 0.45 * abs(sin(flap))
    SetImageState(img, "mul+add", a, 255, 200, 236)
    Render(img, x, y, rot, size * 2.2, size * 2.2 * k)
end

---立刻起飞的普通弹：stay = false，一出膛就走，不在原地悬停
---@param glow boolean @加算发光，默认 true
local function fly(style, col, x, y, v, a, omiga, glow)
    local o = NewSimpleBullet(style, col, x, y, v, a, false, omiga or 0, false)
    if glow ~= false then
        o._blend = "mul+add"
    end
    return o
end

---通用「路径弹」：位置由每帧调用的 path(self, t) 决定，不用协程。
---速度交给 path 自己算，所以这里不 SetV；bound 关掉（不让引擎边界回收），
---改由寿命 / 离屏兜底回收，避免路径写漏了漏对象。
local path_bullet = Class(bullet, {
    init = function(self, style, col, x, y, a, path)
        bullet.init(self, style, col, false, true)
        self.x, self.y, self.rot = x, y, a or 0
        self.path = path
        self.bound = false
        self.max_life = 720
        self.max_r2 = 620 * 620
    end,
    frame = function(self)
        bullet.frame(self)
        local t = self.timer
        if t > self.max_life or self.x * self.x + self.y * self.y > self.max_r2 then
            object.RawDel(self)
            return
        end
        self.path(self, t)
    end,
    render = function(self)
        bullet.render(self)
    end,
})

--============================
--道中的装饰落樱（main_stage 里用）
--  无判定、不循环，飞出下边界即回收
--============================
class["th03_petal_sky"] = Class(object, {
    init = function(self, x, y)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET - 40
        self.bound, self.colli = false, false
        self.vy = -ran:Float(0.6, 1.7)
        self.sway = ran:Float(0, 360)
        self.sway_v = ran:Float(0.5, 1.6) * ran:Sign()
        self.size = ran:Float(0.5, 1.15)
        self.a = ran:Int(60, 145)
        self.rot = ran:Float(0, 360)
        self.spin = ran:Float(-1.2, 1.2)
        self.k = 0
    end,
    frame = function(self)
        self.y = self.y + self.vy
        self.sway = self.sway + self.sway_v
        self.x = self.x + sin(self.sway) * 0.65
        self.rot = self.rot + self.spin
        self.k = min(1, self.timer / 26)
        if self.y < lstg.world.boundb - 30 then
            object.RawDel(self)
        end
    end,
    render = function(self)
        draw_petal(self.x, self.y, self.rot, self.size, self.a * self.k, 255, 190, 222)
    end,
}, true)

--============================
--[符卡1] 蝶符「死蝶之梦」
--  一圈蝶绕着 boss 公转，一边转一边振翅。整个环还在「呼吸」——
--  半径一张一缩，环的相位也跟着呼吸漂，所以蝶不是硬转圈，
--  而是挤到一起又散开。每只蝶沿自己的切线放 3 发，
--  速度递增拉成一道弧，蝶自己还在空中翻滚（omiga）。
--============================
do
    local N = 6                    --环上几只蝶
    local R0, R1 = 96, 150         --呼吸半径的下限 / 上限
    local BREATH = 260             --一次完整呼吸多少帧
    local SPIN = 0.85              --环整体角速度（度/帧）
    local VOLLEY = 30              --每只蝶多久放一轮
    local V0, DV = 3.0, 0.9        --一轮 3 发，速度递增
    local SPREAD = 13              --3 发之间张开的角度
    local OMIGA = 1.6              --蝶在空中翻滚
    --boss 站在屏幕偏下：环要整个落在可视区里（可视区 y 只到 ±224），
    --环上的蝶又是发弹点，跑出边界就白发了
    local BOSS_X, BOSS_Y = 0, 34

    class["th03_dream_ring"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.ang = 0
            self.breath = 0
            self.t = 0
            self.flap = 0
            self.rad = R0
            self.bx, self.by = BOSS_X, BOSS_Y
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 30
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            local m = self.master
            if IsValid(m) then
                self.bx, self.by = m.x, m.y
            end

            self.breath = self.breath + 360 / BREATH
            self.ang = (self.ang + SPIN) % 360
            --半径跟着呼吸走
            self.rad = (R0 + R1) * 0.5 + (R1 - R0) * 0.5 * sin(self.breath)
            --相位也跟着呼吸漂：转半格，形成错位叠加
            local drift = sin(self.breath) * 180 / N
            self.t = self.t + 1
            self.flap = self.t * 0.22

            if self.t % VOLLEY == 0 then
                for i = 1, N do
                    local a = self.ang + drift + (i - 1) * 360 / N
                    local px = self.bx + cos(a) * self.rad
                    local py = self.by + sin(a) * self.rad
                    local tan = a + 90
                    for k = 1, 3 do
                        local o = fly(butterfly, 2 + (i % 2) * 2, px, py,
                                V0 + (k - 1) * DV, tan + (k - 2) * SPREAD, OMIGA)
                        o._r, o._g, o._b = 255, 176, 214
                    end
                end
                PlaySound("tan00", 0.03, self.bx / 256, true)
            end
        end,
        render = function(self)
            local rad = self.rad
            --环画成一条虚线圆，蝶只是圆上的节点
            local segs = 72
            local drift = sin(self.breath) * 180 / N
            for i = 1, segs do
                if i % 6 ~= 0 then
                    local s1 = i / segs * 360
                    local s2 = (i + 1) / segs * 360
                    thin_line(self.bx + cos(s1) * rad, self.by + sin(s1) * rad,
                            self.bx + cos(s2) * rad, self.by + sin(s2) * rad,
                            36, 226, 150, 220, 0.09)
                end
            end
            for i = 1, N do
                local a = self.ang + drift + (i - 1) * 360 / N
                draw_butterfly(self.bx + cos(a) * rad, self.by + sin(a) * rad,
                        a + 90, 0.55, 235, self.flap + i, 2 + (i % 2) * 2)
            end
            draw_orb(self.bx, self.by, 0.95, 0.85, 255, 205, 238)
        end,
    }, true)

    do
        local name = "蝶符「死蝶之梦」"
        local card = boss.card.New(name, 1, 2, 50, 1400)
        boss.card.add({ { card, "1a" } }, 23, name, 266)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__ring = New(class["th03_dream_ring"], self)
        end

        function card:del()
            if IsValid(self.__ring) then
                object.RawDel(self.__ring)
            end
            self.__ring = nil
        end
    end
end

--============================
--[符卡2] 樱符「墨染之樱」
--  花瓣从上方飘落，一路横向打摆；越往下颜色越深——
--  这就是「墨染」：白樱落进墨里。落到下面一条线就炸开成 5 向。
--  花瓣本身有判定，是一条要用走位躲下来的花雨。
--============================
do
    local FALL_V = 1.9              --下落速度
    local SWAY = 46                 --横向摆幅
    local SPLIT_Y = -60             --落到底部这条线就炸开
    local SPAWN_Y = 228             --从屏幕上方多高开始落（可视区顶是 224）
    local SPLIT_N = 5               --炸成几向
    local SPLIT_V = 2.7             --炸开的速度
    local SPLIT_SPREAD = 13         --相邻两向的角度
    local GAP = 14                  --每隔多少帧放一片
    local BATCH = 2                 --一次放几片

    ---花瓣专用路径：自己算位置、自己换颜色、落到底就炸
    local function petal_path(self, t)
        self.y = self.sy - FALL_V * t
        self.x = self.sx + sin(t * 0.042 + self.ph) * SWAY
        self.rot = self.spin0 + t * 1.4
        --「墨染」：越往下越深
        local f = Forbid((self.sy - self.y) / (self.sy - SPLIT_Y), 0, 1)
        self._r = int(255 - 55 * f)
        self._g = int(216 - 128 * f)
        self._b = int(234 - 96 * f)
        if self.y <= SPLIT_Y then
            for k = 1, SPLIT_N do
                local a = 90 + (k - (SPLIT_N + 1) / 2) * SPLIT_SPREAD
                local o = fly(knife, 4, self.x, self.y, SPLIT_V, a, 0)
                o._r, o._g, o._b = 255, 176, 208
            end
            PlaySound("tan00", 0.02, self.x / 256, true)
            object.RawDel(self)
        end
    end

    class["th03_petal"] = Class(path_bullet, {
        init = function(self, x, y)
            path_bullet.init(self, ellipse, 4, x, y, -90, petal_path)
            self.sx, self.sy = x, y
            self.ph = ran:Float(0, 360)
            self.spin0 = ran:Float(0, 360)
            self._blend = "mul+add"
        end,
    }, true)

    do
        local name = "樱符「墨染之樱」"
        local card = boss.card.New(name, 1, 2, 50, 1350)
        boss.card.add({ { card, "1a" } }, 23, name, 267)

        function card:before()
            task.MoveTo(0, 168, 60, VALUE_SET.DECEL)
        end

        function card:init()
            --花雨：从上方不断落
            task.New(self, function()
                while true do
                    for _ = 1, BATCH do
                        New(class["th03_petal"],
                                ran:Float(lstg.world.l, lstg.world.r),
                                SPAWN_Y + ran:Float(0, 28))
                    end
                    task.Wait(GAP)
                end
            end)
            --boss 自己再时不时补一圈「抬头的花瓣」，逼玩家动
            task.New(self, function()
                task.Wait(240)
                while true do
                    local a0 = Angle(self, player)
                    for k = 1, 16 do
                        local o = fly(ellipse, 6, self.x, self.y, 2.2,
                                a0 + (k - 1) * 360 / 16, 2.2)
                        o._r, o._g, o._b = 226, 170, 232
                    end
                    PlaySound("tan00", 0.06, self.x / 256, true)
                    task.Wait(210)
                end
            end)
        end
    end
end

--============================
--[符卡3] 扇符「胡蝶扇舞」
--  致敬「蝴蝶梦之舞」：boss 踩着华尔兹滑步在屏幕里横移，
--  四周贴着屏幕边缘的「扇幕」一起朝内发弹，把你关在扇框里。
--  每滑完一步，正对你放一轮扇形轮；每轮路数和速度都往上加。
--============================
do
    local BOSS_X, BOSS_Y = 0, 140
    local FAN_GAP = 56              --扇幕多久发一次
    local FAN_V = 2.4               --扇幕弹速（快一点，早点飞出屏幕）
    local FAN_SPREAD = 34           --扇面的张角
    local FAN_LEN = 34              --扇骨多长（只是画出来的，没有判定）
    local FAN_TOP = 6               --上/下各几把扇
    local FAN_SIDE = 4              --左/右各几把扇
    local WALTZ_T = 150             --一步滑多久
    local RING_V0 = 1.0             --扇形轮的基础速度
    local RING_DV = 0.85            --三档速度的步长
    local RING_T0 = 20              --第一轮几路
    local RING_DT = 4               --每轮加几路
    local RING_TMAX = 60            --路数封顶，不然最后一轮会一次放几百发

    class["th03_fan"] = Class(object, {
        init = function(self, x, y, dir)
            self.x, self.y = x, y
            self.dir = dir
            self.t = ran:Int(0, FAN_GAP)
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 22
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            if self.t % FAN_GAP == 0 then
                for k = -2, 2 do
                    local o = fly(knife, 2, self.x, self.y, FAN_V,
                            self.dir + k * FAN_SPREAD / 2, 0)
                    o._r, o._g, o._b = 255, 194, 216
                end
                PlaySound("tan00", 0.02, self.x / 256, true)
            end
        end,
        render = function(self)
            local k = 0.72 + 0.28 * sin(self.t * 0.09)
            for i = -2, 2 do
                local a = self.dir + i * FAN_SPREAD / 2
                thin_line(self.x, self.y,
                        self.x + cos(a) * FAN_LEN, self.y + sin(a) * FAN_LEN,
                        120 * k, 255, 200, 232, 0.13)
            end
            --扇钉
            draw_orb(self.x, self.y, 0.26, 0.9, 255, 214, 238)
        end,
    }, true)

    do
        local name = "扇符「胡蝶扇舞」"
        local card = boss.card.New(name, 1, 2, 55, 1500)
        boss.card.add({ { card, "1a" } }, 23, name, 268)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            --四周的扇幕
            self.__fans = {}
            task.New(self, function()
                local w = lstg.world
                task.Wait(40)
                --上下各 FAN_TOP 把，左右各 FAN_SIDE 把，贴着屏幕边缘朝内。
                --扇幕是持续发弹的，把数量压住，不然同屏弹数一下子就上去了
                for i = 0, FAN_TOP - 1 do
                    local x = w.l + (w.r - w.l) * i / (FAN_TOP - 1)
                    self.__fans[#self.__fans + 1] = New(class["th03_fan"], x, w.t + 6, 90)
                    self.__fans[#self.__fans + 1] = New(class["th03_fan"], x, w.b - 6, -90)
                end
                for i = 0, FAN_SIDE - 1 do
                    local y = w.b + (w.t - w.b) * i / (FAN_SIDE - 1)
                    self.__fans[#self.__fans + 1] = New(class["th03_fan"], w.l - 6, y, 0)
                    self.__fans[#self.__fans + 1] = New(class["th03_fan"], w.r + 6, y, 180)
                end
                PlaySound("kira00", 0.25, 0, true)
            end)
            --华尔兹滑步 + 每步一轮扇形
            task.New(self, function()
                local d = 1
                local t = RING_T0
                task.Wait(90)
                while true do
                    Newcharge_in(self.x, self.y, 255, 255, 100)
                    task.Wait(26)
                    local a0 = Angle(self, player)
                    for i = 1, t do
                        for v = 1, 3 do
                            local o = fly(ball_mid, 4, self.x, self.y,
                                    RING_V0 + (v - 1) * RING_DV,
                                    a0 + (i - 1) * 360 / t, 0)
                            o._r, o._g, o._b = 255, 186, 220
                        end
                    end
                    PlaySound("tan00", 0.1, self.x / 256, true)
                    Newcharge_out(self.x, self.y, 255, 255, 100)
                    --镜像地滑到另一边
                    task.CRMoveTo(WALTZ_T, VALUE_SET.DECEL,
                            -180 * d, 130, 0, 110, 180 * d, 130)
                    d = -d
                    t = min(t + RING_DT, RING_TMAX)
                    task.Wait(30)
                end
            end)
        end

        function card:del()
            local fans = self.__fans or {}
            for i = 1, #fans do
                if IsValid(fans[i]) then
                    object.RawDel(fans[i])
                end
            end
            self.__fans = {}
        end
    end
end

--============================
--[符卡4] 死符「无寿之梦」
--  场地随时间收缩（和蝴蝶梦之舞一样夹住自机坐标），
--  boss 放同心环，每环留一个缺口——缺口一圈一圈地转，
--  所以要顺着缺口的方向绕。越往后格子越窄。
--============================
do
    local FIELD_FULL = 300          --起始半宽
    local FIELD_MIN = 130           --收到最窄时的半宽
    local SHRINK_T = 1500           --多少帧收到最窄
    local RING_GAP = 32             --环的间隔
    local RING_N = 38               --一圈几格
    local GAP_W = 7                 --缺口占几格
    local GAP_STEP = 5              --缺口每环推进几格
    local RING_V = 3.1              --环的扩散速度
    local AIM_GAP = 150             --多久补一轮瞄准弹
    local BOSS_X, BOSS_Y = 0, 150

    do
        local name = "死符「无寿之梦」"
        local card = boss.card.New(name, 1, 2, 50, 1400)
        boss.card.add({ { card, "1a" } }, 23, name, 269)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:frame()
            --场地收缩：把自机夹在越来越小的方框里。
            --注意别用 self.ani——那是 boss 从出生算起的总帧数，
            --打到第四张卡时早就跑满了，一进卡场地就是最小的
            self.__t = (self.__t or 0) + 1
            local t = min(self.__t / SHRINK_T, 1)
            local hw = FIELD_FULL + (FIELD_MIN - FIELD_FULL) * t
            local hh = hw * 0.76
            player.x = min(hw, max(-hw, player.x))
            player.y = min(hh, max(-hh, player.y))
        end

        function card:init()
            self.__t = 0
            task.New(self, function()
                local gap = 0
                task.Wait(60)
                while true do
                    for i = 1, RING_N do
                        if not ((i - gap) % RING_N < GAP_W) then
                            local a = (i - 1) * 360 / RING_N
                            local o = fly(ball_mid, 12, self.x, self.y, RING_V, a, 0)
                            o._r, o._g, o._b = 226, 178, 246
                        end
                    end
                    PlaySound("tan00", 0.05, self.x / 256, true)
                    gap = gap + GAP_STEP
                    task.Wait(RING_GAP)
                end
            end)
            task.New(self, function()
                task.Wait(200)
                while true do
                    local a0 = Angle(self, player)
                    for k = 1, 5 do
                        local o = fly(ball_big, 2, self.x, self.y, 3.4,
                                a0 + (k - 3) * 9, 0)
                        o._r, o._g, o._b = 255, 168, 200
                    end
                    task.Wait(AIM_GAP)
                end
            end)
        end
    end
end

--============================
--[符卡5] 幽符「西行妖」
--  树是从「线排弹」长出来的：枝条沿一条半径一颗一颗往外长，
--  每颗都带着向外的速度，所以这条线不会被扯散，看上去就是一根
--  伸出去的枝。长到尽头，枝端炸开成 7 向花瓣。
--  树根处的角度一圈一圈慢慢转，看着就像整棵树在转。
--============================
do
    local ROOT_X, ROOT_Y = 0, -210    --树根（屏幕下方）
    local BRANCHES = 5                --一次伸几根枝
    local ARC = 150                   --所有枝条铺开的扇形张角（以正上方为中心）
    local BRANCH_LEN = 175            --枝长（长过这个就绽放；要保证枝端还在可视区里）
    local BRANCH_STEP = 18            --每颗之间多远
    local BRANCH_TICK = 3             --多少帧长一颗
    local BRANCH_V = 1.5              --枝条整体的漂移速度
    local BRANCH_GAP = 110            --每轮隔多久
    local WOBBLE = 26                 --整棵树左右摆的幅度
    local BLOOM_N = 7                 --枝端开几瓣
    local BLOOM_V = 2.3
    local BOSS_X, BOSS_Y = 0, 150

    class["th03_branch"] = Class(object, {
        init = function(self, a, col)
            self.a = a
            self.col = col
            self.r = 0
            self.acc = 0
            self.group, self.layer = GROUP.GHOST, LAYER.TOP
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.acc = self.acc + 1
            if self.acc < BRANCH_TICK then
                return
            end
            self.acc = 0
            self.r = self.r + BRANCH_STEP
            if self.r >= BRANCH_LEN then
                --枝端绽放
                for k = 1, BLOOM_N do
                    local ang = self.a + (k - (BLOOM_N + 1) / 2) * 20
                    local o = fly(butterfly, 2 + (k % 2) * 2,
                            ROOT_X + cos(self.a) * self.r, ROOT_Y + sin(self.a) * self.r,
                            BLOOM_V, ang, 1.4)
                    o._r, o._g, o._b = 255, 190, 224
                end
                PlaySound("tan00", 0.05, 0, true)
                object.RawDel(self)
                return
            end
            --沿枝长一颗，它带着向外的速度，所以整条枝一起往外漂
            local o = fly(ellipse, self.col,
                    ROOT_X + cos(self.a) * self.r, ROOT_Y + sin(self.a) * self.r,
                    BRANCH_V, self.a, 0)
            o._r, o._g, o._b = 255, 206, 230
        end,
    }, true)

    do
        local name = "幽符「西行妖」"
        local card = boss.card.New(name, 1, 2, 55, 1500)
        boss.card.add({ { card, "1a" } }, 23, name, 270)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__branches = {}
            task.New(self, function()
                local sway_t = 0
                task.Wait(50)
                while true do
                    sway_t = sway_t + 1
                    --整棵树慢慢地左右摆：枝条都对着「正上方」铺开一个扇形
                    local sway = WOBBLE * sin(sway_t * BRANCH_GAP * 0.011)
                    for i = 1, BRANCHES do
                        local a = 90 + sway + (-ARC / 2 + (i - 1) * ARC / (BRANCHES - 1))
                        self.__branches[#self.__branches + 1] =
                                New(class["th03_branch"], a, 4 + (i % 3) * 2)
                    end
                    PlaySound("tan00", 0.06, 0, true)
                    task.Wait(BRANCH_GAP)
                end
            end)
            --顺便从树上飘点花下来
            task.New(self, function()
                while true do
                    New(class["th03_petal"], ran:Float(lstg.world.l, lstg.world.r), 250)
                    task.Wait(30)
                end
            end)
        end

        function card:del()
            local bs = self.__branches or {}
            for i = 1, #bs do
                if IsValid(bs[i]) then
                    object.RawDel(bs[i])
                end
            end
            self.__branches = {}
        end
    end
end

--============================
--[符卡6] 蝶符「凤蝶圆舞」
--  两只蝶在屏幕中心 180° 相对地公转，一只放顺时针的螺旋、
--  另一只放逆时针的，两股螺旋在中间交叉。
--  两只蝶的发射角还在各自进动，所以交叉点会慢慢挪。
--============================
do
    local ORBIT = 150                --两只蝶的公转半径
    local ORBIT_SPIN = 1.15          --公转角速度
    local PRECESS = 2.6              --发射角的进动速度
    local WAYS = 3                   --每只蝶一轮放几条臂
    local EMIT_GAP = 8               --多少帧放一轮
    local SPIRAL_V = 2.6             --螺旋弹速
    local BOSS_X, BOSS_Y = 0, 150

    class["th03_twin_swirl"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.ang = -90
            self.prec = 0
            self.t = 0
            self.flap = 0
            self.ax, self.ay = 0, -ORBIT
            self.bx, self.by = 0, ORBIT
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 30
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.ang = (self.ang + ORBIT_SPIN) % 360
            self.prec = (self.prec + PRECESS) % 360
            self.t = self.t + 1
            self.flap = self.t * 0.24
            self.ax, self.ay = cos(self.ang) * ORBIT, sin(self.ang) * ORBIT
            self.bx, self.by = -self.ax, -self.ay

            if self.t % EMIT_GAP == 0 then
                for k = 1, WAYS do
                    local base = (k - 1) * 360 / WAYS
                    --一只顺时针、一只逆时针
                    local o1 = fly(ball_light, 4, self.ax, self.ay, SPIRAL_V,
                            self.prec + base, 0)
                    o1._r, o1._g, o1._b = 255, 182, 220
                    local o2 = fly(ball_light, 6, self.bx, self.by, SPIRAL_V,
                            -self.prec + base, 0)
                    o2._r, o2._g, o2._b = 208, 176, 255
                end
            end
        end,
        render = function(self)
            draw_butterfly(self.ax, self.ay, self.ang + 90, 0.95, 245, self.flap, 2)
            draw_butterfly(self.bx, self.by, self.ang - 90, 0.95, 245, self.flap + 2, 4)
            --两只蝶之间牵一根线，把「成对」这件事说清楚
            thin_line(self.ax, self.ay, self.bx, self.by, 46, 226, 170, 226, 0.07)
            draw_orb(0, 0, 0.7, 0.6, 255, 210, 240)
        end,
    }, true)

    do
        local name = "蝶符「凤蝶圆舞」"
        local card = boss.card.New(name, 1, 2, 50, 1400)
        boss.card.add({ { card, "1a" } }, 23, name, 271)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__swirl = New(class["th03_twin_swirl"], self)
        end

        function card:del()
            if IsValid(self.__swirl) then
                object.RawDel(self.__swirl)
            end
            self.__swirl = nil
        end
    end
end

--============================
--[符卡7] 樱符「樱吹雪」
--  漫天的花瓣横着吹过屏幕，风向周期性地反向。
--  重点在于「风」不只吹新弹——已经在空中的花瓣也会被推着走
--  （每帧遍历一遍本卡生成的弹，给它们加一个横向位移），
--  所以整片花幕会一起倒向另一边，像暴风雪忽然换了方向。
--============================
do
    local WIND_PERIOD = 420          --风向来回一次多少帧
    local WIND_MAX = 1.9             --风最大横向速度
    local WIND_LIFE = 300            --花瓣最多活多久
    local BLOW_GAP = 5               --每几帧放一撮花
    local BLOW_N = 3                 --一撮几片
    local BLOW_V = 1.5               --花瓣自己的初速
    local BLOW_SPREAD = 26           --初速方向的散布
    local BOSS_X, BOSS_Y = 0, 150

    --本卡共享的风速（文件级 upvalue，进卡时归零）
    local wind_vx = 0
    --攒下这一帧到寿命的花瓣，帧末统一收：
    --不能在 BulletDo 的遍历里删对象，那样会把遍历跳过一格
    local wind_dead = {}

    ---只推本卡生成的花瓣。风逆吹的时候会顶住花瓣，
    ---所以还得给个寿命上限，否则它们会堆在屏幕边上不走
    local function blow(o)
        if o.th03_wind then
            o.x = o.x + wind_vx
            o.th03_age = (o.th03_age or 0) + 1
            if o.th03_age > WIND_LIFE then
                wind_dead[#wind_dead + 1] = o
            end
        end
    end

    do
        local name = "樱符「樱吹雪」"
        local card = boss.card.New(name, 1, 2, 50, 1400)
        boss.card.add({ { card, "1a" } }, 23, name, 272)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:frame()
            --风向平滑地来回摆。用卡自己的计时器，不用 self.ani
            self.__t = (self.__t or 0) + 1
            wind_vx = WIND_MAX * sin(self.__t * 360 / WIND_PERIOD)
            object.BulletDo(blow)
            --把这一帧攒下的过期花瓣收掉
            if #wind_dead > 0 then
                for i = #wind_dead, 1, -1 do
                    object.RawDel(wind_dead[i])
                    wind_dead[i] = nil
                end
            end
        end

        function card:init()
            wind_vx = 0
            self.__t = 0
            for i = #wind_dead, 1, -1 do
                wind_dead[i] = nil
            end
            task.New(self, function()
                while true do
                    --风往哪边吹，就从另一边放花
                    local from_left = wind_vx >= 0
                    local x = from_left and (lstg.world.l - 16) or (lstg.world.r + 16)
                    for _ = 1, BLOW_N do
                        local o = fly(ellipse, 4, x,
                                ran:Float(lstg.world.b - 10, lstg.world.t + 10),
                                BLOW_V, ran:Float(-BLOW_SPREAD, BLOW_SPREAD)
                                + (from_left and 0 or 180), ran:Float(-2, 2))
                        o._r, o._g, o._b = 255, 194, 224
                        o.th03_wind = true
                    end
                    task.Wait(BLOW_GAP)
                end
            end)
            --boss 自己补一轮瞄准弹，免得只顾着看雪
            task.New(self, function()
                task.Wait(180)
                while true do
                    local a0 = Angle(self, player)
                    for k = 1, 7 do
                        local o = fly(ball_mid, 2, self.x, self.y, 3.0,
                                a0 + (k - 4) * 11, 0)
                        o._r, o._g, o._b = 255, 178, 212
                    end
                    PlaySound("tan00", 0.07, self.x / 256, true)
                    task.Wait(160)
                end
            end)
        end
    end
end

--============================
--[符卡8] 灵符「亡灵之舞」
--  一堆幽灵球围着 boss 一圈圈生成、往外漂，每个都定时朝你放 5 向。
--  数量随时间递增，外面那圈还慢慢地向心收，
--  所以越到后面越像被一群鬼围住。
--============================
do
    local ORB_R0 = 70                --生成半径
    local ORB_R1 = 130               --漂到多远就停住
    local ORB_DRIFT = 0.8            --外漂速度
    local ORB_SPIN = 0.42            --绕行角速度（度/帧）
    local PUBLK_R0 = 168             --外面那圈的半径（要整圈落在可视区里）
    local PUBLK_SPIN = -0.22         --外面那圈反向绕
    local AIM_GAP0 = 130             --最初的攻击间隔
    local AIM_GAP_MIN = 62           --最快的攻击间隔
    local AIM_V = 2.7
    local AIM_WAYS = 5
    local AIM_SPREAD = 10
    local SPAWN_GAP0 = 150           --最初的生成间隔
    local SPAWN_GAP_MIN = 46
    local MAX_ORBS = 14
    local BOSS_X, BOSS_Y = 0, 150

    class["th03_ghost"] = Class(object, {
        init = function(self, a, r0, r1, aim_gap, spin)
            self.a = a
            self.r = r0
            self.r0, self.r1 = r0, r1
            self.aim_gap = aim_gap
            self.spin = spin or ORB_SPIN
            self.t = ran:Int(0, aim_gap)
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 18
            self.bound, self.colli = false, false
            self.x, self.y = cos(a) * r0, sin(a) * r0
        end,
        frame = function(self)
            if self.r < self.r1 then
                self.r = min(self.r1, self.r + ORB_DRIFT)
            end
            self.a = self.a + self.spin
            self.x = cos(self.a) * self.r
            self.y = sin(self.a) * self.r

            self.t = self.t + 1
            if self.t % self.aim_gap == 0 then
                local a0 = Angle(self.x, self.y, player.x, player.y)
                for k = 1, AIM_WAYS do
                    local o = fly(ball_small, 4, self.x, self.y, AIM_V,
                            a0 + (k - (AIM_WAYS + 1) / 2) * AIM_SPREAD, 0)
                    o._r, o._g, o._b = 255, 180, 214
                end
                PlaySound("tan00", 0.025, self.x / 256, true)
            end
        end,
        render = function(self)
            local k = 0.85 + 0.15 * sin(self.t * 0.12)
            draw_orb(self.x, self.y, 0.62 * k, 0.9, 206, 226, 255)
            --一圈飘着的尾迹，让它看着像「灵」
            for i = 1, 3 do
                local tail = self.a - i * 16
                thin_line(cos(tail) * self.r, sin(tail) * self.r,
                        cos(tail - 10) * self.r, sin(tail - 10) * self.r,
                        34 / i, 190, 214, 255, 0.06)
            end
        end,
    }, true)

    do
        local name = "灵符「亡灵之舞」"
        local card = boss.card.New(name, 1, 2, 50, 1450)
        boss.card.add({ { card, "1a" } }, 23, name, 273)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__orbs = {}
            task.New(self, function()
                task.Wait(50)
                --一开始先把外圈摆好
                for i = 1, 7 do
                    self.__orbs[#self.__orbs + 1] =
                            New(class["th03_ghost"], i * 360 / 7, PUBLK_R0, PUBLK_R0,
                                    AIM_GAP0 + 40, PUBLK_SPIN)
                end
                local el = 0
                while true do
                    --越到后面生成得越快。这里自己数帧，不用 self.ani
                    --（self 是 boss，ani 从 boss 出生算起，早就跑满了）
                    local k = min(1, el / 2400)
                    if #self.__orbs < MAX_ORBS then
                        local a = ran:Float(0, 360)
                        self.__orbs[#self.__orbs + 1] = New(class["th03_ghost"],
                                a, ORB_R0, ORB_R1,
                                int(AIM_GAP0 + (AIM_GAP_MIN - AIM_GAP0) * k))
                    end
                    local gap = int(SPAWN_GAP0 + (SPAWN_GAP_MIN - SPAWN_GAP0) * k)
                    task.Wait(gap)
                    el = el + gap
                end
            end)
        end

        function card:del()
            local orbs = self.__orbs or {}
            for i = 1, #orbs do
                if IsValid(orbs[i]) then
                    object.RawDel(orbs[i])
                end
            end
            self.__orbs = {}
        end
    end
end

--============================
--[符卡9] 结界「生死之境」
--  樱花结界的做法：把子弹沿一条边一颗一颗排满，用弹本身拼出图形。
--  这里拼的是两个六边形——一正一反地转，还周期性地张缩。
--  缺口是错开的：一个收进去的时候另一个正张开，只能从缝里钻。
--  每次张缩之间补一轮玩家方向的轮盘。
--============================
do
    local HEX_CX, HEX_CY = 0, -6     --结界中心（钉在画面中央，不跟着 boss 跑）
    local R_IN, R_OUT = 70, 168      --张缩半径（最大 168，正好整只落在可视区里）
    local PULSE = 150                --一次张缩多少帧
    local PULSE_EMIT = 112           --缩到最小半径的那一刻把弹吐出去（sin = -1 的位置）
    local HEX_STEPS = 9              --每条边排几颗
    local HEX_V = 2.4                --沿外法线飞出去的速度
    local WHEEL_GAP = 190            --多久补一轮轮盘
    local WHEEL_T0 = 18              --第一轮几路
    local WHEEL_TMAX = 48            --路数封顶
    local BOSS_X, BOSS_Y = 0, 150

    ---画一个六边形结界：六条边各排 HEX_STEPS 颗，沿外法线方向飞出去
    local function emit_hex(cx, cy, R, rot, col)
        for k = 1, 6 do
            local a0 = rot + (k - 1) * 60
            local a1 = rot + k * 60
            local x0, y0 = cx + cos(a0) * R, cy + sin(a0) * R
            local x1, y1 = cx + cos(a1) * R, cy + sin(a1) * R
            for i = 0, HEX_STEPS - 1 do
                local f = i / HEX_STEPS
                local px, py = x0 + (x1 - x0) * f, y0 + (y1 - y0) * f
                local o = fly(square, col, px, py, HEX_V, Angle(cx, cy, px, py), 0)
                o._r, o._g, o._b = 224, 192, 255
            end
        end
    end

    ---画六边形的骨架（自绘，无判定），让玩家一眼看出缺口在哪
    local function draw_hex(cx, cy, R, rot, a)
        local px, py
        for k = 1, 6 do
            local ang = rot + (k - 1) * 60
            local nx, ny = cx + cos(ang) * R, cy + sin(ang) * R
            if px then
                thin_line(px, py, nx, ny, a, 200, 190, 255, 0.075)
            end
            px, py = nx, ny
        end
        thin_line(px, py, cx + cos(rot) * R, cy + sin(rot) * R, a, 200, 190, 255, 0.075)
    end

    class["th03_barrier"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.t = 0
            self.rot_a = 0
            self.rot_b = 60
            self.group, self.layer = GROUP.GHOST, LAYER.TOP
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            --两个六边形反向转
            self.rot_a = (self.rot_a + 0.55) % 360
            self.rot_b = (self.rot_b - 0.55) % 360
            --张缩：一个张的时候另一个缩
            local ph = self.t * 360 / PULSE
            self.r_a = (R_IN + R_OUT) * 0.5 + (R_OUT - R_IN) * 0.5 * sin(ph)
            self.r_b = (R_IN + R_OUT) * 0.5 - (R_OUT - R_IN) * 0.5 * sin(ph)

            --缩到最小半径的那一刻把弹放出去，结界就「张开」了
            if self.t % PULSE == PULSE_EMIT then
                emit_hex(HEX_CX, HEX_CY, self.r_a, self.rot_a, 6)
                emit_hex(HEX_CX, HEX_CY, self.r_b, self.rot_b, 10)
                PlaySound("tan00", 0.07, 0, true)
            end
        end,
        render = function(self)
            draw_hex(HEX_CX, HEX_CY, self.r_a, self.rot_a, 150)
            draw_hex(HEX_CX, HEX_CY, self.r_b, self.rot_b, 110)
            draw_orb(HEX_CX, HEX_CY, 0.55, 0.7, 255, 214, 244)
        end,
    }, true)

    do
        local name = "结界「生死之境」"
        local card = boss.card.New(name, 1, 2, 55, 1500)
        boss.card.add({ { card, "1a" } }, 23, name, 274)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__barrier = New(class["th03_barrier"], self)
            task.New(self, function()
                local t = WHEEL_T0
                task.Wait(120)
                while true do
                    local a0 = Angle(self, player)
                    for i = 1, t do
                        for v = 1, 2 do
                            local o = fly(ball_mid, 4, self.x, self.y,
                                    1.2 + (v - 1) * 1.5, a0 + (i - 1) * 360 / t, 0)
                            o._r, o._g, o._b = 255, 184, 218
                        end
                    end
                    PlaySound("tan00", 0.08, self.x / 256, true)
                    t = min(t + 3, WHEEL_TMAX)
                    task.Wait(WHEEL_GAP)
                end
            end)
        end

        function card:del()
            if IsValid(self.__barrier) then
                object.RawDel(self.__barrier)
            end
            self.__barrier = nil
        end
    end
end

--============================
--[符卡10] 「西行寺无余涅槃」（终符）
--  血量驱动的四阶段，只追加不替换（和 th01 的镜花水月一个路子）：
--    ① 蝶环 + 花雨      ② 追加几何结界
--    ③ 追加幽灵球瞄准    ④ 追加风推全屏
--  把前面几张卡的东西一层层摞上来，越打越满。
--============================
do
    --⚠ 阈值必须落在本卡血量（2000）**之内**：写 2700 的话那一档靠掉血永远触发不了，
    --  玩家看到的就是「血打下去了却没新弹幕」（自检会直接报出来）。
    local HP_P2, HP_P3, HP_P4 = 500, 1000, 1500
    local PH_P2, PH_P3, PH_P4 = 20 * 60, 34 * 60, 46 * 60
    local BOSS_X, BOSS_Y = 0, 140

    --风（只有第四阶段才推得动）
    local WIND_LIFE = 300            --风推的花瓣最多活多久
    local wind_vx = 0
    local wind_dead = {}

    local function blow(o)
        if o.th03_wind then
            o.x = o.x + wind_vx
            o.th03_age = (o.th03_age or 0) + 1
            if o.th03_age > WIND_LIFE then
                wind_dead[#wind_dead + 1] = o
            end
        end
    end

    class["th03_nirvana"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.phase = 1
            self.t = 0
            self.wind_t = 0
            wind_vx = 0
            self.orbs = {}
            self.group, self.layer = GROUP.GHOST, LAYER.TOP
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            local m = self.master
            self.t = self.t + 1

            --========== 阶段推进：血量（或兜底时间）驱动 ==========
            local left = 0
            if m and m._sp_point_auto then
                left = #m._sp_point_auto
            end
            local done = 3 - left
            if done >= 1 and self.phase < 2 then
                self.phase = 2
            end
            if done >= 2 and self.phase < 3 then
                self.phase = 3
                --追加幽灵球
                for i = 1, 5 do
                    self.orbs[#self.orbs + 1] =
                            New(class["th03_ghost"], i * 360 / 5, 190, 190, 92)
                end
            end
            if done >= 3 and self.phase < 4 then
                self.phase = 4
                PlaySound("kira00", 0.3, 0, true)
            end

            --========== ① 蝶环 + 花雨（全程） ==========
            self.ring = self.ring or New(class["th03_dream_ring"], m)
            if self.t % 26 == 0 then
                New(class["th03_petal"],
                        ran:Float(lstg.world.l, lstg.world.r), 250 + ran:Float(0, 30))
            end
            --阶段越高，花雨越密
            if self.phase >= 4 and self.t % 8 == 0 then
                New(class["th03_petal"], ran:Float(lstg.world.l, lstg.world.r), 252)
            end

            --========== ② 几何结界（二阶段起追加） ==========
            if self.phase >= 2 and not self.barrier then
                self.barrier = New(class["th03_barrier"], m)
            end

            --========== ③ 幽灵球（三阶段起追加） ==========
            if self.phase >= 3 then
                for i = #self.orbs, 1, -1 do
                    if not IsValid(self.orbs[i]) then
                        table.remove(self.orbs, i)
                    end
                end
            end

            --========== ④ 风（四阶段起） ==========
            if self.phase >= 4 then
                self.wind_t = self.wind_t + 1
                wind_vx = 1.7 * sin(self.wind_t * 360 / 460)
                object.BulletDo(blow)
                if #wind_dead > 0 then
                    for i = #wind_dead, 1, -1 do
                        object.RawDel(wind_dead[i])
                        wind_dead[i] = nil
                    end
                end
                --风把花瓣从侧面吹进来
                if self.t % 4 == 0 then
                    local from_left = wind_vx >= 0
                    local o = fly(ellipse, 4,
                            from_left and (lstg.world.l - 16) or (lstg.world.r + 16),
                            ran:Float(lstg.world.b - 10, lstg.world.t + 10),
                            1.6, from_left and 0 or 180, ran:Float(-2, 2))
                    o._r, o._g, o._b = 255, 196, 226
                    o.th03_wind = true
                end
            end
        end,
        render = function() end,
        del = function(self)
            if IsValid(self.ring) then
                object.RawDel(self.ring)
            end
            if IsValid(self.barrier) then
                object.RawDel(self.barrier)
            end
            for i = 1, #self.orbs do
                if IsValid(self.orbs[i]) then
                    object.RawDel(self.orbs[i])
                end
            end
            self.orbs = {}
            self.ring, self.barrier = nil, nil
        end,
    }, true)

    do
        local name = "「西行寺无余涅槃」"
        local card = boss.card.New(name, 1, 2, 60, 2000)
        boss.card.add({ { card, "1a" } }, 23, name, 275)

        function card:before()
            ToBigScreen(60)
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            --最后一个 true = 用「本张符卡」的计时器做兜底
            self._bosssys:addAutoSPPoint(HP_P2, PH_P2, true)
            self._bosssys:addAutoSPPoint(HP_P3, PH_P3, true)
            self._bosssys:addAutoSPPoint(HP_P4, PH_P4, true)
            self.__nirvana = New(class["th03_nirvana"], self)
        end

        function card:del()
            if IsValid(self.__nirvana) then
                object.RawDel(self.__nirvana)
            end
            self.__nirvana = nil
        end
    end
end
