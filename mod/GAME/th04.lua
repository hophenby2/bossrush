---=====================================
---TH04  彼岸：西行寺幽幽子 · 第二版
---
---  这是 th03「白玉楼」的重制版。母题还是扇 / 蝶 / 樱，
---  但每一张卡的**限位层**都改成按 AGENTS.md 第 10 节的量化规范来写：
---    · 参数回到项目惯例 (1,1,60) 档、hp 700~900（th03 的 hp 1400~2000 偏高了一档）
---    · 每张卡 init 里 2~4 个独立循环：一层管限位、一层管实弹，只靠 boss 坐标耦合
---    · 限位用「弹幕几何」而不是夹自机；每个限位都标出
---        ——缺口宽度、转换容错时间、预警帧数
---    · 转换容错时间 ≥ 需要移动的距离 ÷ 4（玩家 4 px/帧），再留 2~4 倍余量
---    · 限位生效前一定先有一段「只画不判」的预警（60~190 帧）
---    · 光效三件套：before 走位 → init 先 Wait(60) 再 Newcharge_in →
---        每个展开点 boss.cast + Newcharge_out
---
---  各卡块的注释里写了 [限位/缺口/容错/预警] 四个数，那是设计意图，改动前先看它。
---
---  回收规则同 th03：NewSimpleBullet 造的弹引擎自己收；自己 Class(object, ...) 造的
---  只要把 bound 关掉了，就必须在 frame 里自己 RawDel。
---=====================================

local class = {}
_editor_class["TH04"] = class

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
    _SC_BG.AddLayer(self, "th04_0", true, 0, 0, 0, 0, -0.05, 0, "", 1, 1, function(l)
        --符卡背景：一层偏绯红的暮色
        l.r, l.g, l.b = 236, 138, 150
    end)
end

boss.Define("1a", "西行寺幽幽子", "TH04_0", TH04_bg, { 0, 300 }, class["SCBG1"], "Yuyuko", 24)

--============================
--公用小工具（与 th03 一致，只是把常量都标了出来）
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

---画一段圆弧（画限位预警用）
local function arc(cx, cy, r, a0, a1, segs, alpha, gr, gg, gb, w)
    if r <= 0 or alpha <= 0 then
        return
    end
    local step = (a1 - a0) / segs
    for i = 1, segs do
        local s1 = a0 + step * (i - 1)
        local s2 = a0 + step * i
        thin_line(cx + cos(s1) * r, cy + sin(s1) * r,
                cx + cos(s2) * r, cy + sin(s2) * r, alpha, gr, gg, gb, w)
    end
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

---画一片花瓣
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
local function fly(style, col, x, y, v, a, omiga, glow)
    local o = NewSimpleBullet(style, col, x, y, v, a, false, omiga or 0, false)
    if glow ~= false then
        o._blend = "mul+add"
    end
    return o
end

---通用「路径弹」：位置由 path(self, t) 每帧算，bound 关掉所以要自己回收
local path_bullet = Class(bullet, {
    init = function(self, style, col, x, y, a, path)
        bullet.init(self, style, col, false, true)
        self.x, self.y, self.rot = x, y, a or 0
        self.path = path
        self.bound = false
        self.max_life = 720
        self.max_r2 = 640 * 640
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

---限位墙的标准做法（见 AGENTS.md 10.4）：
---  高密度环 + 挖掉一个扇区。
---  这里把扇区做成参数：gap_a 是缺口中心角，gap_w 是缺口角宽。
---  n 路均匀铺一圈，落在缺口里的直接跳过。
local function ring_with_gap(style, col, cx, cy, R, n, v, gap_a, gap_w, inward)
    local half = gap_w * 0.5
    for i = 1, n do
        local a = (i - 1) * 360 / n
        -- 到缺口中心的角距离
        local d = (a - gap_a) % 360
        if d > 180 then
            d = 360 - d
        end
        if d > half then
            local dir = inward and (a + 180) or a
            local o = fly(style, col, cx + cos(a) * R, cy + sin(a) * R, v, dir, 0)
            o._r, o._g, o._b = 255, 176, 210
        end
    end
end

--============================
--道中的装饰魂火（main_stage 里用）
--  无判定、不循环，飘出上边界即回收
--============================
class["th04_wisp"] = Class(object, {
    init = function(self, x, y)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET - 40
        self.bound, self.colli = false, false
        self.vy = ran:Float(0.5, 1.5)
        self.sway = ran:Float(0, 360)
        self.sway_v = ran:Float(0.4, 1.3) * ran:Sign()
        self.size = ran:Float(0.35, 0.9)
        self.a = ran:Int(60, 150)
        self.k = 0
    end,
    frame = function(self)
        self.y = self.y + self.vy
        self.sway = self.sway + self.sway_v
        self.x = self.x + sin(self.sway) * 0.7
        self.k = min(1, self.timer / 30)
        if self.y > lstg.world.boundt + 30 then
            object.RawDel(self)
        end
    end,
    render = function(self)
        local k = self.a * self.k
        SetImageState("ball_light5", "mul+add", k * 0.5, 120, 200, 255)
        Render("ball_light5", self.x, self.y, 0, self.size * 0.9, self.size * 0.9)
        SetImageState("ball_mid6", "mul+add", k, 226, 246, 255)
        Render("ball_mid6", self.x, self.y, 0, self.size * 0.22, self.size * 0.22)
    end,
}, true)

--============================
--[符卡1] 蝶符「胡蝶之栅」
--  限位：一圈向心收缩的蝶弹环，只留一个 36° 的缺口。
--  缺口：36°（在 R=150 处弧长约 94 px）
--  容错：缺口每 90 帧跳一格（36°）。要走 94 px → 94/4 ≈ 24 帧，余量 3.7 倍
--  预警：每轮开头的 36 帧用自绘圆弧标出缺口；整面墙出现前另有 90 帧预热
--  实弹：boss 每 40 帧朝玩家放 12 路扇形（v=2.2），逼你在缺口里还要动
--============================
do
    local SECTORS = 10               -- 一圈切几格
    local GAP_A = 36                 -- 缺口角宽（一格）
    local RING_N = 36                -- 环上几颗（10° 一颗 → 墙够密）
    local RING_R = 260               -- 从多远往里收
    local RING_V = 2.6               -- 收的速度
    local CYCLE = 30                 -- 每 30 帧补一圈
    local JUMP = 90                  -- 每 90 帧缺口跳一格
    local WARN = 36                  -- 每轮开头 36 帧只画预警
    local START_WARN = 90            -- 整面墙出现前的预热
    local AIM_GAP = 40               -- 实弹间隔
    local AIM_WAYS = 12
    local AIM_V = 2.2
    local BOSS_X, BOSS_Y = 0, 40     -- boss 站中间偏下，环整个落在可视区里

    class["th04_ring_cage"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.gap = 0                 -- 缺口中心角
            self.t = 0
            self.ready = false
            self.cx, self.cy = BOSS_X, BOSS_Y
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 30
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            local m = self.master
            if IsValid(m) then
                self.cx, self.cy = m.x, m.y
            end
            self.t = self.t + 1
            if self.t < START_WARN then
                return                      -- 预热期：只画不判
            end
            if not self.ready then
                self.ready = true
                self.t = 0
                PlaySound("kira00", 0.2, 0, true)
            end
            --缺口每 JUMP 帧跳一格（顺时针）
            if self.t % JUMP == 1 then
                self.gap = (self.gap + 360 / SECTORS) % 360
                PlaySound("tan00", 0.05, self.cx / 256, true)
            end
            --每 CYCLE 帧补一圈；每轮开头 WARN 帧不发实体，只留预警
            if self.t % CYCLE == 1 and (self.t % JUMP) > WARN then
                ring_with_gap(butterfly, 2, self.cx, self.cy, RING_R, RING_N,
                        RING_V, self.gap, GAP_A, true)
            end
        end,
        render = function(self)
            local r = RING_R - 74         -- 预警圆画在墙的内缘附近
            --整圈：暗的
            arc(self.cx, self.cy, r, 0, 360, 60, 42, 226, 150, 220, 0.06)
            --缺口：亮的（这就是预警）
            local half = GAP_A * 0.5
            arc(self.cx, self.cy, r, self.gap - half, self.gap + half, 10, 200, 255, 210, 240, 0.12)
            if self.t < START_WARN then
                local k = 1 - self.t / START_WARN
                thin_line(self.cx, self.cy, self.cx + cos(self.gap) * r, self.cy + sin(self.gap) * r,
                        120 * k, 255, 210, 240, 0.10)
            end
            draw_orb(self.cx, self.cy, 0.9, 0.85, 255, 205, 238)
        end,
    }, true)

    do
        local name = "蝶符「胡蝶之栅」"
        local card = boss.card.New(name, 1, 1, 60, 800)
        boss.card.add({ { card, "1a" } }, 24, name, 276)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__cage = New(class["th04_ring_cage"], self)
            --实弹层：朝玩家放 12 路扇形
            task.New(self, function()
                task.Wait(60)
                Newcharge_in(self.x, self.y, 255, 255, 100)
                boss.cast(self, 90)
                task.Wait(90)
                Newcharge_out(self.x, self.y, 255, 255, 100)
                while true do
                    local a0 = Angle(self, player)
                    for i = 1, AIM_WAYS do
                        local o = fly(ball_mid, 4, self.x, self.y, AIM_V,
                                a0 + (i - 1) * 360 / AIM_WAYS, 0)
                        o._r, o._g, o._b = 255, 186, 220
                    end
                    PlaySound("tan00", 0.06, self.x / 256, true)
                    task.Wait(AIM_GAP)
                end
            end)
        end

        function card:del()
            if IsValid(self.__cage) then
                object.RawDel(self.__cage)
            end
            self.__cage = nil
        end
    end
end

--============================
--[卡2] 樱符「墨染之川」
--  限位：三途川的水位上涨——一道自下而上的樱幕把玩家往上推（th07:819 的做法）
--  缺口：幕布分成 5 段，段间留 40 px 的缝（每帧往上挪 5 px，玩家 4 px/帧 追不上，
--        所以只能横向挪到缝里，不能往下退）
--  容错：幕布从 -240 升到 +240 需要 96 帧；缝之间相距 76 px → 19 帧，余量 5 倍
--  预警：幕布升起前，先用一条亮线在底部标出 5 个缝的位置，持续 90 帧
--  实弹：上方落下的花瓣（v=1.8），落到 -60 炸开成 5 向
--============================
do
    local FLOOR_V = 5.0              -- 水位上涨速度
    local SEG = 5                    -- 幕布分几段
    local SEG_W = 40                 -- 缝隙宽度
    local FLOOR_WARN = 90            -- 预警多少帧
    local FALL_V = 1.8               -- 花瓣下落速度
    local FALL_SWAY = 44
    local SPLIT_Y = -60
    local SPLIT_N = 5
    local SPLIT_V = 2.6
    local BOSS_X, BOSS_Y = 0, 160

    ---水位：自绘的抬升地板 + 把玩家往上顶
    class["th04_water"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.x, self.y = 0, -260
            self.t = 0
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 20
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            if self.t < FLOOR_WARN then
                return                       -- 预警期：水位还没动
            end
            self.y = self.y + FLOOR_V
            if self.y > lstg.world.t then
                self.y = -260                -- 升到顶就从头再来（一轮 97 帧）
            end
            --把玩家顶到水面之上（这就是限位）
            if player.y < self.y then
                -- 玩家落在某一段幕布下面 → 顶上去；落在缝里 → 不动
                local in_gap = false
                for i = 1, SEG do
                    local cx = (i - 0.5) * 384 / SEG - 192
                    if abs(player.x - cx) < SEG_W * 0.5 then
                        in_gap = true
                        break
                    end
                end
                if not in_gap then
                    player.y = self.y
                end
            end
        end,
        render = function(self)
            local y = self.y
            if self.t < FLOOR_WARN then
                --预警：先在底部画出 5 个缝的位置
                local k = 0.4 + 0.6 * sin(self.t * 0.15)
                for i = 1, SEG do
                    local cx = (i - 0.5) * 384 / SEG - 192
                    thin_line(cx - SEG_W * 0.5, -238, cx - SEG_W * 0.5, -170,
                            120 * k, 255, 214, 236, 0.12)
                    thin_line(cx + SEG_W * 0.5, -238, cx + SEG_W * 0.5, -170,
                            120 * k, 255, 214, 236, 0.12)
                end
                return
            end
            for i = 1, SEG do
                local cx = (i - 0.5) * 384 / SEG - 192
                local hw = 384 / SEG * 0.5 - SEG_W * 0.5
                thin_line(cx - hw, y, cx, y, 190, 236, 96, 130, 0.16)
                thin_line(cx, y, cx + hw, y, 190, 236, 96, 130, 0.16)
                --水面高光
                SetImageState("ball_light5", "mul+add", 40, 255, 130, 150)
                Render("ball_light5", cx, y, 0, hw / 100, 0.28)
            end
        end,
    }, true)

    ---花瓣：落下 → 到线炸开
    local function petal_path(self, t)
        self.y = self.sy - FALL_V * t
        self.x = self.sx + sin(t * 0.04 + self.ph) * FALL_SWAY
        self.rot = self.spin0 + t * 1.3
        if self.y <= SPLIT_Y then
            for k = 1, SPLIT_N do
                local a = 90 + (k - (SPLIT_N + 1) / 2) * 13
                local o = fly(knife, 4, self.x, self.y, SPLIT_V, a, 0)
                o._r, o._g, o._b = 255, 176, 208
            end
            PlaySound("tan00", 0.02, self.x / 256, true)
            object.RawDel(self)
        end
    end

    class["th04_petal"] = Class(path_bullet, {
        init = function(self, x, y)
            path_bullet.init(self, ellipse, 4, x, y, -90, petal_path)
            self.sx, self.sy = x, y
            self.ph = ran:Float(0, 360)
            self.spin0 = ran:Float(0, 360)
            self._blend = "mul+add"
        end,
    }, true)

    do
        local name = "樱符「墨染之川」"
        local card = boss.card.New(name, 1, 1, 60, 750)
        boss.card.add({ { card, "1a" } }, 24, name, 277)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__water = New(class["th04_water"], self)
            --实弹层：花瓣雨
            task.New(self, function()
                task.Wait(60)
                Newcharge_in(self.x, self.y, 236, 96, 130)
                boss.cast(self, 60)
                task.Wait(30)
                Newcharge_out(self.x, self.y, 236, 96, 130)
                while true do
                    New(class["th04_petal"], ran:Float(lstg.world.l, lstg.world.r), 236)
                    task.Wait(16)
                end
            end)
            --boss 自己补一轮，免得只顾着看水
            task.New(self, function()
                task.Wait(240)
                while true do
                    local a0 = Angle(self, player)
                    for k = 1, 7 do
                        local o = fly(ball_mid, 2, self.x, self.y, 3.0, a0 + (k - 4) * 11, 0)
                        o._r, o._g, o._b = 255, 178, 212
                    end
                    PlaySound("tan00", 0.07, self.x / 256, true)
                    task.Wait(150)
                end
            end)
        end

        function card:del()
            if IsValid(self.__water) then
                object.RawDel(self.__water)
            end
            self.__water = nil
        end
    end
end

--============================
--[卡3] 扇符「胡蝶扇舞」
--  限位：贴着屏幕边缘的一圈扇幕，持续朝内发弹（蝴蝶梦之舞的做法）
--  缺口：没有固定缺口，是「软限位」——靠 20 把扇的弹流互相咬住
--  容错：连续型，每把扇每 60 帧放一轮 5 发，弹流之间始终有 30~50 px 的缝
--  预警：扇幕出现前 90 帧先画出 20 个扇位（自绘扇骨）
--  实弹：boss 踩华尔兹滑步，每步朝玩家放 20 路扇形，路数每轮 +4（封顶 48）
--============================
do
    local FAN_TOP, FAN_SIDE = 6, 4    -- 上下各 6 把、左右各 4 把（共 20 把）
    local FAN_GAP = 60                -- 扇幕发弹间隔
    local FAN_V = 2.4
    local FAN_SPREAD = 34
    local FAN_WARN = 90               -- 预警
    local WALTZ_T = 150
    local RING_V0, RING_DV = 1.2, 0.7
    local RING_T0, RING_DT, RING_TMAX = 20, 4, 48
    local BOSS_X, BOSS_Y = 0, 140

    class["th04_fan"] = Class(object, {
        init = function(self, x, y, dir, born)
            self.x, self.y = x, y
            self.dir = dir
            self.born = born
            self.t = ran:Int(0, FAN_GAP)
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 22
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            if self.t < FAN_WARN then
                return                    -- 预警期：只画扇骨，不发弹
            end
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
            local k = self.t < FAN_WARN and (0.4 + 0.6 * sin(self.t * 0.15)) or (0.72 + 0.28 * sin(self.t * 0.09))
            for i = -2, 2 do
                local a = self.dir + i * FAN_SPREAD / 2
                thin_line(self.x, self.y,
                        self.x + cos(a) * 34, self.y + sin(a) * 34,
                        120 * k, 255, 200, 232, 0.13)
            end
            draw_orb(self.x, self.y, 0.26, 0.9, 255, 214, 238)
        end,
    }, true)

    do
        local name = "扇符「胡蝶扇舞」"
        local card = boss.card.New(name, 1, 1, 60, 850)
        boss.card.add({ { card, "1a" } }, 24, name, 278)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__fans = {}
            --限位层：贴边扇幕
            task.New(self, function()
                local w = lstg.world
                for i = 0, FAN_TOP - 1 do
                    local x = w.l + (w.r - w.l) * i / (FAN_TOP - 1)
                    self.__fans[#self.__fans + 1] = New(class["th04_fan"], x, w.t + 6, 90)
                    self.__fans[#self.__fans + 1] = New(class["th04_fan"], x, w.b - 6, -90)
                end
                for i = 0, FAN_SIDE - 1 do
                    local y = w.b + (w.t - w.b) * i / (FAN_SIDE - 1)
                    self.__fans[#self.__fans + 1] = New(class["th04_fan"], w.l - 6, y, 0)
                    self.__fans[#self.__fans + 1] = New(class["th04_fan"], w.r + 6, y, 180)
                end
                PlaySound("kira00", 0.25, 0, true)
            end)
            --实弹层：华尔兹滑步 + 扇形轮
            task.New(self, function()
                local d = 1
                local t = RING_T0
                task.Wait(60)
                Newcharge_in(self.x, self.y, 255, 255, 100)
                task.Wait(FAN_WARN)
                while true do
                    local a0 = Angle(self, player)
                    for i = 1, t do
                        for v = 1, 3 do
                            local o = fly(ball_mid, 4, self.x, self.y,
                                    RING_V0 + (v - 1) * RING_DV, a0 + (i - 1) * 360 / t, 0)
                            o._r, o._g, o._b = 255, 186, 220
                        end
                    end
                    PlaySound("tan00", 0.1, self.x / 256, true)
                    Newcharge_out(self.x, self.y, 255, 255, 100)
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
--[卡4] 死符「无寿之栏」
--  限位：直接夹住自机的方框，分三档收缩（蝴蝶梦之舞的做法，但把档位标出来）
--  缺口：无（整块缩小）
--  容错：每档之间留 300 帧，足够从 384 宽挪到 288 宽（96 px → 24 帧，余量 12 倍）
--  预警：每次收缩前 60 帧，用亮框画出「下一档的边界」
--  实弹：同心环，每环留一个旋转缺口（缺口每环前进 5 格）
--============================
do
    local STEPS = { 320, 288, 256 }   -- 三档半宽
    local STEP_T = 300                -- 每档撑多少帧
    local FRAME_WARN = 60             -- 收缩前提前多少帧画预警
    local RING_GAP = 34
    local RING_N = 38
    local GAP_W = 7
    local GAP_STEP = 5
    local RING_V = 3.1
    local AIM_GAP = 150
    local BOSS_X, BOSS_Y = 0, 150

    do
        local name = "死符「无寿之栏」"
        local card = boss.card.New(name, 1, 1, 60, 750)
        boss.card.add({ { card, "1a" } }, 24, name, 279)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:frame()
            --自己的计时器（不能用 self.ani：那是 boss 出生以来的总帧数）
            self.__t = (self.__t or 0) + 1
            local step = min(int(self.__t / STEP_T) + 1, #STEPS)
            self.__hw = STEPS[step]
            local hh = self.__hw * 0.76
            player.x = min(self.__hw, max(-self.__hw, player.x))
            player.y = min(hh, max(-hh, player.y))
        end

        function card:render()
            --下一档的预警框：收缩前 FRAME_WARN 帧开始闪
            local t = self.__t or 0
            local step = min(int(t / STEP_T) + 1, #STEPS)
            local left = STEP_T - (t % STEP_T)
            if step < #STEPS and left <= FRAME_WARN then
                local k = 0.4 + 0.6 * sin(t * 0.3)
                local nh = STEPS[step + 1]
                local nhh = nh * 0.76
                SetImageState("white", "mul+add", 90 * k, 255, 160, 180)
                Render("white", 0, nhh, 0, nh / 8, 0.06)
                Render("white", 0, -nhh, 0, nh / 8, 0.06)
                Render("white", -nh, 0, 90, nhh / 8, 0.06)
                Render("white", nh, 0, 90, nhh / 8, 0.06)
            end
        end

        function card:init()
            self.__t = 0
            task.New(self, function()
                local gap = 0
                task.Wait(60)
                Newcharge_in(self.x, self.y, 226, 178, 246)
                boss.cast(self, 60)
                task.Wait(30)
                Newcharge_out(self.x, self.y, 226, 178, 246)
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
                        local o = fly(ball_big, 2, self.x, self.y, 3.4, a0 + (k - 3) * 9, 0)
                        o._r, o._g, o._b = 255, 168, 200
                    end
                    task.Wait(AIM_GAP)
                end
            end)
        end
    end
end

--============================
--[卡5] 幽符「西行妖」
--  限位：用「沿半径排成一条线」的子弹拼出六芒星结界（樱花结界的做法）
--  缺口：6 条射线之间 60° 的角缝；在 R=140 处每条缝约 146 px
--  容错：结界每 200 帧张缩一次，缩到最小时的缝仍有 60°，是连续型软限位
--  预警：结界出现前先画 6 条暗线，第 90 帧才落成实弹
--  实弹：枝端绽放的 7 向花瓣 + 从上方飘落的花雨
--============================
do
    local ARMS = 6                    -- 六条射线
    local LINE_N = 18                 -- 每条线排几颗
    local R_IN, R_OUT = 110, 178      -- 张缩半径
    local PULSE = 200                 -- 一次张缩
    local LINE_V = 1.6                -- 线整体向外漂
    local TREE_WARN = 90
    local BLOOM_N = 7
    local BLOOM_V = 2.3
    local BOSS_X, BOSS_Y = 0, 60

    class["th04_hexagram"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.t = 0
            self.rot = 0
            self.group, self.layer = GROUP.GHOST, LAYER.TOP
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            local m = self.master
            local cx, cy = BOSS_X, BOSS_Y
            if IsValid(m) then
                cx, cy = m.x, m.y
            end
            self.cx, self.cy = cx, cy
            self.t = self.t + 1
            self.rot = (self.rot + 0.35) % 360
            local ph = self.t * 360 / PULSE
            self.r = (R_IN + R_OUT) * 0.5 + (R_OUT - R_IN) * 0.5 * sin(ph)
            --整面结界出现前只画不判
            if self.t < TREE_WARN then
                return
            end
            if self.t == TREE_WARN then
                PlaySound("kira00", 0.25, 0, true)
            end
            --缩到最小半径时把这一轮的线放出去
            if self.t % PULSE == 0 then
                --每条臂 = 沿半径 a 从 (r - L/2) 排到 (r + L/2) 的一列弹；
                --六条这样的径向线就拼成一个六芒星（樱花结界的做法）
                local half = LINE_V * PULSE * 0.5
                for k = 1, ARMS do
                    local a = self.rot + (k - 1) * 360 / ARMS
                    for i = 1, LINE_N do
                        local f = (i - 1) / (LINE_N - 1) - 0.5   -- -0.5 ~ 0.5
                        local rr = self.r + f * 2 * half
                        local o = fly(ellipse, 6, cx + cos(a) * rr, cy + sin(a) * rr,
                                LINE_V, a, 0)
                        o._r, o._g, o._b = 255, 206, 230
                    end
                end
                --枝端绽放
                for k = 1, ARMS do
                    local a = self.rot + (k - 1) * 360 / ARMS
                    for j = 1, BLOOM_N do
                        local ang = a + (j - (BLOOM_N + 1) / 2) * 20
                        local o = fly(butterfly, 2 + (j % 2) * 2,
                                cx + cos(a) * self.r, cy + sin(a) * self.r,
                                BLOOM_V, ang, 1.4)
                        o._r, o._g, o._b = 255, 190, 224
                    end
                end
                PlaySound("tan00", 0.06, 0, true)
            end
        end,
        render = function(self)
            local r = self.r or R_IN
            local alpha = self.t < TREE_WARN and (60 + 90 * sin(self.t * 0.12)) or 130
            for k = 1, ARMS do
                local a = self.rot + (k - 1) * 360 / ARMS
                thin_line(self.cx, self.cy, self.cx + cos(a) * r, self.cy + sin(a) * r,
                        alpha, 220, 170, 230, 0.09)
            end
            draw_orb(self.cx, self.cy, 0.8, 0.8, 255, 210, 240)
        end,
    }, true)

    do
        local name = "幽符「西行妖」"
        local card = boss.card.New(name, 1, 1, 60, 800)
        boss.card.add({ { card, "1a" } }, 24, name, 280)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__hex = New(class["th04_hexagram"], self)
            --实弹层：花雨
            task.New(self, function()
                task.Wait(60)
                Newcharge_in(self.x, self.y, 255, 214, 244)
                boss.cast(self, 90)
                task.Wait(30)
                Newcharge_out(self.x, self.y, 255, 214, 244)
                while true do
                    New(class["th04_petal"], ran:Float(lstg.world.l, lstg.world.r), 236)
                    task.Wait(26)
                end
            end)
        end

        function card:del()
            if IsValid(self.__hex) then
                object.RawDel(self.__hex)
            end
            self.__hex = nil
        end
    end
end

--============================
--[卡6] 蝶符「凤蝶圆舞」
--  限位：四条旋转的蝶臂，臂间 90° 的角缝
--  缺口：90°（在 R=120 处弧长约 188 px，是全项目最宽的「规律型」缺口）
--  容错：臂以 0.8°/帧 转，扫过 90° 要 112 帧 → 容错 112 帧（余量 7 倍，偏宽松）
--  预警：前 60 帧只画出四条臂的骨架，之后才挂上蝶
--  实弹：臂上的蝶沿切向排开，越靠外越快（v 从 3.0 插值到 3.9），另有 boss 的瞄准轮
--============================
do
    local ARMS = 4
    local ARM_SPIN = 0.8              -- 臂的角速度
    local ARM_R0, ARM_R1 = 60, 150    -- 臂上的弹从内往外排
    local ARM_N = 9                   -- 一条臂上几颗
    local ARM_GAP = 26                -- 发一轮的间隔
    local ARM_V0, ARM_DV = 3.0, 0.9
    local WARN = 60
    local AIM_GAP = 170
    local BOSS_X, BOSS_Y = 0, 40

    class["th04_wheel"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.t = 0
            self.rot = 0
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 30
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            local m = self.master
            self.cx, self.cy = BOSS_X, BOSS_Y
            if IsValid(m) then
                self.cx, self.cy = m.x, m.y
            end
            self.t = self.t + 1
            self.rot = (self.rot + ARM_SPIN) % 360
            if self.t < WARN then
                return
            end
            if self.t % ARM_GAP == 0 then
                for k = 1, ARMS do
                    local a = self.rot + (k - 1) * 360 / ARMS
                    --一条臂上的弹从内到外排开，越外面越快 → 臂被拉成一道弧
                    for i = 1, ARM_N do
                        local r = ARM_R0 + (ARM_R1 - ARM_R0) * (i - 1) / (ARM_N - 1)
                        local o = fly(butterfly, 2 + (k % 2) * 2,
                                self.cx + cos(a) * r, self.cy + sin(a) * r,
                                ARM_V0 + (i - 1) / (ARM_N - 1) * ARM_DV, a + 90, 1.5)
                        o._r, o._g, o._b = 255, 176, 214
                    end
                end
                PlaySound("tan00", 0.04, self.cx / 256, true)
            end
        end,
        render = function(self)
            local k = self.t < WARN and (0.35 + 0.65 * sin(self.t * 0.14)) or 0.5
            for i = 1, ARMS do
                local a = self.rot + (i - 1) * 360 / ARMS
                thin_line(self.cx + cos(a) * ARM_R0, self.cy + sin(a) * ARM_R0,
                        self.cx + cos(a) * ARM_R1, self.cy + sin(a) * ARM_R1,
                        90 * k, 226, 150, 220, 0.09)
            end
            draw_butterfly(self.cx, self.cy, self.rot, 0.7, 220, self.t * 0.2, 2)
        end,
    }, true)

    do
        local name = "蝶符「凤蝶圆舞」"
        local card = boss.card.New(name, 1, 1, 60, 800)
        boss.card.add({ { card, "1a" } }, 24, name, 281)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__wheel = New(class["th04_wheel"], self)
            task.New(self, function()
                task.Wait(60)
                Newcharge_in(self.x, self.y, 255, 255, 100)
                task.Wait(WARN)
                while true do
                    local a0 = Angle(self, player)
                    for k = 1, 6 do
                        local o = fly(ball_small, 4, self.x, self.y, 2.6,
                                a0 + (k - 4) * 9, 0)
                        o._r, o._g, o._b = 255, 180, 214
                    end
                    task.Wait(AIM_GAP)
                end
            end)
        end

        function card:del()
            if IsValid(self.__wheel) then
                object.RawDel(self.__wheel)
            end
            self.__wheel = nil
        end
    end
end

--============================
--[卡7] 樱符「樱吹雪」
--  限位：风——横向推全场子弹（已在空中的也推），每 300 帧反向一次
--  缺口：无（是「推力限位」而不是「几何限位」）
--  容错：反向的瞬间外力为 0，那 ±20 帧是唯一的自由窗口（th095 的做法）
--  预警：风向反转前 60 帧，屏幕两侧的「风柱」亮度变化提示要变向了
--  实弹：从风的上游飘进来的花瓣（v=1.6）+ boss 的瞄准轮
--============================
do
    local WIND_PERIOD = 300
    local WIND_MAX = 1.8
    local BLOW_GAP = 6
    local BLOW_N = 3
    local BLOW_V = 1.6
    local BLOW_SPREAD = 26
    local BOSS_X, BOSS_Y = 0, 150

    local wind_vx = 0
    local wind_dead = {}

    local function blow(o)
        if o.th04_wind then
            o.x = o.x + wind_vx
            o.th04_age = (o.th04_age or 0) + 1
            if o.th04_age > 300 then
                wind_dead[#wind_dead + 1] = o
            end
        end
    end

    class["th04_windwall"] = Class(object, {
        init = function(self)
            self.group, self.layer = GROUP.GHOST, LAYER.TOP
            self.bound, self.colli = false, false
        end,
        frame = function() end,
        render = function(self)
            --两侧的风柱：哪边亮，风就从哪边吹过来
            local w = lstg.world
            local k = wind_vx / WIND_MAX           -- -1 ~ 1
            --哪边的风柱亮，风就是从哪边吹过来的
            if k < -0.02 then
                SetImageState("white", "mul+add", -k * 110, 190, 226, 255)
                RenderRect("white", w.l, w.l + 26, w.b, w.t)
            elseif k > 0.02 then
                SetImageState("white", "mul+add", k * 110, 190, 226, 255)
                RenderRect("white", w.r - 26, w.r, w.b, w.t)
            end
        end,
    }, true)

    do
        local name = "樱符「樱吹雪」"
        local card = boss.card.New(name, 1, 1, 60, 750)
        boss.card.add({ { card, "1a" } }, 24, name, 282)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:frame()
            self.__t = (self.__t or 0) + 1
            wind_vx = WIND_MAX * sin(self.__t * 360 / WIND_PERIOD)
            object.BulletDo(blow)
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
            for i = #wind_dead, 1, -1 do wind_dead[i] = nil end
            self.__wall = New(class["th04_windwall"])
            task.New(self, function()
                task.Wait(60)
                Newcharge_in(self.x, self.y, 190, 226, 255)
                boss.cast(self, 60)
                task.Wait(60)
                Newcharge_out(self.x, self.y, 190, 226, 255)
                while true do
                    local from_left = wind_vx >= 0
                    local x = from_left and (lstg.world.l - 16) or (lstg.world.r + 16)
                    for _ = 1, BLOW_N do
                        local o = fly(ellipse, 4, x,
                                ran:Float(lstg.world.b - 10, lstg.world.t + 10),
                                BLOW_V, ran:Float(-BLOW_SPREAD, BLOW_SPREAD)
                                + (from_left and 0 or 180), ran:Float(-2, 2))
                        o._r, o._g, o._b = 255, 194, 224
                        o.th04_wind = true
                    end
                    task.Wait(BLOW_GAP)
                end
            end)
            task.New(self, function()
                task.Wait(180)
                while true do
                    local a0 = Angle(self, player)
                    for k = 1, 7 do
                        local o = fly(ball_mid, 2, self.x, self.y, 3.0, a0 + (k - 4) * 11, 0)
                        o._r, o._g, o._b = 255, 178, 212
                    end
                    PlaySound("tan00", 0.07, self.x / 256, true)
                    task.Wait(160)
                end
            end)
        end

        function card:del()
            if IsValid(self.__wall) then
                object.RawDel(self.__wall)
            end
            self.__wall = nil
        end
    end
end

--============================
--[卡8] 灵符「亡灵之渡」
--  限位：三途川上的三条摆渡船——**只有船周围 70 px 圆内，敌弹才有判定**
--        （th12「血バサミ女」的圆环判定做法，把「哪里危险」变成可移动的区域）
--  缺口：船外全是安全区，等于是「跟着船走」的反向限位
--  容错：船横渡全屏 384 px 用 300 帧；玩家 96 帧能跑完全程 → 余量 3 倍
--  预警：船出现前 90 帧先画出三条航线和 70 px 的判定圈
--  实弹：全屏铺一层「平时无判定」的慢速花弹，只有进圈才致命
--============================
do
    local BOAT_R = 70                 -- 判定半径
    local BOAT_N = 3
    local CROSS_T = 300               -- 横渡耗时
    local SHIP_WARN = 90
    -- 每波铺几颗 / 多久一波。这两个数直接决定同屏对象数：
    --   峰值 ≈ FIELD_N × (穿场帧数 / FIELD_GAP)，穿场约 600 帧，所以取 16/150 → 峰值 ~120
    -- 船圈总覆盖面积约 3×π×70² ≈ 全场 27%，所以 120 颗里随时有 ~30 颗在圈内，够压迫了
    local FIELD_N = 16
    local FIELD_GAP = 150
    local FIELD_V = 0.6               -- 极慢，会长时间滞留在圈里
    local BOSS_X, BOSS_Y = 0, 150

    ---摆渡船：只负责移动和画圈；判定由它给全场的花弹打标
    class["th04_boat"] = Class(object, {
        init = function(self, dir, phase)
            self.dir = dir
            self.phase = phase
            self.t = 0
            self.x = -dir * 260
            self.y = -150 + phase * 90
            self.group, self.layer = GROUP.GHOST, LAYER.TOP
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            if self.t < SHIP_WARN then
                return
            end
            local k = ((self.t - SHIP_WARN) % CROSS_T) / CROSS_T
            self.x = (-260 + 520 * k) * self.dir
        end,
        render = function(self)
            local warn = self.t < SHIP_WARN
            local k = warn and (0.4 + 0.6 * sin(self.t * 0.14)) or 1
            --航线
            thin_line(-260 * self.dir, self.y, 260 * self.dir, self.y, 70 * k, 190, 226, 255, 0.06)
            --判定圈
            arc(self.x, self.y, BOAT_R, 0, 360, 32, 130 * k, 255, 170, 200, 0.10)
            draw_orb(self.x, self.y, 0.7, 0.9 * k, 226, 240, 255)
        end,
    }, true)

    ---花弹：平时 colli = false，进圈才 lethal
    class["th04_lilybullet"] = Class(object, {
        init = function(self, x, y, v, a, boats)
            self.x, self.y = x, y
            self.vx, self.vy = v * cos(a), v * sin(a)
            self.boats = boats
            --INDES：打不掉，但 colli 为真时会撞自机 —— 正合适这种「时有时无的判定」
            self.group, self.layer = GROUP.INDES, LAYER.ENEMY_BULLET
            self.bound, self.colli = true, false
            self.hscale, self.vscale = 1.2, 0.8
            self._blend, self._a = "mul+add", 200
            self._r, self._g, self._b = 255, 190, 222
        end,
        frame = function(self)
            local lethal = false
            for i = 1, #self.boats do
                local b = self.boats[i]
                if IsValid(b) and b.t >= SHIP_WARN then
                    if Dist(self.x, self.y, b.x, b.y) < BOAT_R then
                        lethal = true
                        break
                    end
                end
            end
            self.colli = lethal
            self._a = lethal and 255 or 90
        end,
        render = function(self)
            draw_petal(self.x, self.y, 0, 1.0, self._a, 255, 190, 222)
        end,
    }, true)

    do
        local name = "灵符「亡灵之渡」"
        local card = boss.card.New(name, 1, 1, 60, 800)
        boss.card.add({ { card, "1a" } }, 24, name, 283)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__boats = {}
            for i = 1, BOAT_N do
                self.__boats[#self.__boats + 1] =
                        New(class["th04_boat"], (i % 2 == 0) and 1 or -1, i - 2)
            end
            task.New(self, function()
                task.Wait(60)
                Newcharge_in(self.x, self.y, 255, 170, 200)
                task.Wait(SHIP_WARN)
                while true do
                    for _ = 1, FIELD_N do
                        New(class["th04_lilybullet"],
                                ran:Float(lstg.world.l, lstg.world.r),
                                ran:Float(lstg.world.b, lstg.world.t),
                                FIELD_V * ran:Float(0.6, 1.4),
                                ran:Float(0, 360), self.__boats)
                    end
                    PlaySound("tan00", 0.06, 0, true)
                    task.Wait(FIELD_GAP)
                end
            end)
        end

        function card:del()
            local bs = self.__boats or {}
            for i = 1, #bs do
                if IsValid(bs[i]) then object.RawDel(bs[i]) end
            end
            self.__boats = {}
        end
    end
end

--============================
--[卡9] 结界「生死之境」
--  限位：两个反向旋转、且反相张缩的六边形结界（樱花结界的立体版）
--  缺口：张的时候半径 168，缝在六个角之间；缩到 70 时缝收窄但两环错开 30°，
--        所以「一个缩进去的时候另一个正张开」，永远有一条路
--  容错：一次张缩 150 帧，缩到最小半径时吐弹
--  预警：结界出现前 90 帧只画两个六边形的骨架
--  实弹：每 190 帧补一轮玩家方向的轮盘（18 路起，封顶 48）
--============================
do
    local HEX_CX, HEX_CY = 0, -6
    local R_IN, R_OUT = 70, 168
    local PULSE = 150
    local PULSE_EMIT = 112
    local HEX_STEPS = 9
    local HEX_V = 2.4
    local HEX_WARN = 90
    local WHEEL_GAP = 190
    local WHEEL_T0, WHEEL_TMAX = 18, 48
    local BOSS_X, BOSS_Y = 0, 150

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

    class["th04_barrier"] = Class(object, {
        init = function(self)
            self.t = 0
            self.rot_a, self.rot_b = 0, 60
            self.group, self.layer = GROUP.GHOST, LAYER.TOP
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.t = self.t + 1
            self.rot_a = (self.rot_a + 0.55) % 360
            self.rot_b = (self.rot_b - 0.55) % 360
            local ph = self.t * 360 / PULSE
            self.r_a = (R_IN + R_OUT) * 0.5 + (R_OUT - R_IN) * 0.5 * sin(ph)
            self.r_b = (R_IN + R_OUT) * 0.5 - (R_OUT - R_IN) * 0.5 * sin(ph)
            if self.t < HEX_WARN then
                return
            end
            if self.t % PULSE == PULSE_EMIT then
                emit_hex(HEX_CX, HEX_CY, self.r_a, self.rot_a, 6)
                emit_hex(HEX_CX, HEX_CY, self.r_b, self.rot_b, 10)
                PlaySound("tan00", 0.07, 0, true)
            end
        end,
        render = function(self)
            local k = self.t < HEX_WARN and (0.4 + 0.6 * sin(self.t * 0.13)) or 1
            draw_hex(HEX_CX, HEX_CY, self.r_a, self.rot_a, 150 * k)
            draw_hex(HEX_CX, HEX_CY, self.r_b, self.rot_b, 110 * k)
            draw_orb(HEX_CX, HEX_CY, 0.55, 0.7 * k, 255, 214, 244)
        end,
    }, true)

    do
        local name = "结界「生死之境」"
        local card = boss.card.New(name, 1, 1, 60, 850)
        boss.card.add({ { card, "1a" } }, 24, name, 284)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            self.__barrier = New(class["th04_barrier"])
            task.New(self, function()
                local t = WHEEL_T0
                task.Wait(60)
                Newcharge_in(HEX_CX, HEX_CY, 200, 190, 255)
                task.Wait(HEX_WARN)
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
--[终符] 「彼岸无余涅槃」
--  血量驱动四阶段，只追加不替换（th01 镜花水月的路子）：
--    ① 蝶环 + 花雨        ② 追加六芒结界
--    ③ 追加摆渡船（判定圈） ④ 追加风 + 全屏花幕
--  ⚠ 用了 ToBigScreen，场地变成 ±320/±240，限位几何要按大屏算：
--     蝶环半径 150（大屏半高 240，够放）、结界 R_OUT 168、缺口按角度算不受影响
--============================
do
    local HP_P2, HP_P3, HP_P4 = 700, 1400, 2100
    local PH_P2, PH_P3, PH_P4 = 20 * 60, 34 * 60, 46 * 60
    local BOSS_X, BOSS_Y = 0, 60

    local RING_N = 36
    local RING_R = 280
    local RING_V = 2.4
    local RING_CYCLE = 34
    local RING_JUMP = 90
    local RING_WARN = 90
    local SECTORS = 10
    local GAP_A = 36
    local PETAL_GAP = 26
    local BARRIER_R_OUT = 168

    local wind_vx = 0
    local wind_dead = {}

    local function blow(o)
        if o.th04_wind then
            o.x = o.x + wind_vx
            o.th04_age = (o.th04_age or 0) + 1
            if o.th04_age > 300 then
                wind_dead[#wind_dead + 1] = o
            end
        end
    end

    class["th04_nirvana"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.phase = 1
            self.t = 0
            self.gap = 0
            self.wind_t = 0
            wind_vx = 0
            self.orbs = {}
            self.group, self.layer = GROUP.GHOST, LAYER.TOP
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            local m = self.master
            self.t = self.t + 1
            local cx, cy = BOSS_X, BOSS_Y
            if IsValid(m) then
                cx, cy = m.x, m.y
            end
            --阶段推进：血量（或兜底时间）驱动
            local left = 0
            if m and m._sp_point_auto then
                left = #m._sp_point_auto
            end
            local done = 3 - left
            if done >= 1 and self.phase < 2 then
                self.phase = 2
                Newcharge_out(cx, cy, 200, 190, 255)
            end
            if done >= 2 and self.phase < 3 then
                self.phase = 3
                Newcharge_out(cx, cy, 255, 170, 200)
            end
            if done >= 3 and self.phase < 4 then
                self.phase = 4
                PlaySound("kira00", 0.3, 0, true)
            end

            --① 蝶环（全程）：大屏下半径 280，缺口 36°，每 90 帧跳一格
            if self.t > RING_WARN then
                if self.t % RING_JUMP == 1 then
                    self.gap = (self.gap + 360 / SECTORS) % 360
                end
                if self.t % RING_CYCLE == 1 and (self.t % RING_JUMP) > 30 then
                    ring_with_gap(butterfly, 2, cx, cy, RING_R, RING_N,
                            RING_V, self.gap, GAP_A, true)
                end
                if self.phase >= 4 and self.t % 14 == 0 then
                    ring_with_gap(butterfly, 4, cx, cy, RING_R + 40, RING_N,
                            RING_V, self.gap, GAP_A, true)
                end
            end
            --① 花雨
            if self.t % PETAL_GAP == 0 then
                New(class["th04_petal"], ran:Float(lstg.world.l, lstg.world.r),
                        lstg.world.t + 20)
            end

            --② 六芒结界（二阶段起）
            if self.phase >= 2 and not self.hex then
                self.hex = New(class["th04_hexagram"], m)
            end

            --③ 摆渡船（三阶段起）
            if self.phase >= 3 and not self.boats then
                self.boats = {}
                for i = 1, 3 do
                    self.boats[#self.boats + 1] =
                            New(class["th04_boat"], (i % 2 == 0) and 1 or -1, i - 2)
                end
            end

            --④ 风（四阶段起）
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
                if self.t % 4 == 0 then
                    local from_left = wind_vx >= 0
                    local o = fly(ellipse, 4,
                            from_left and (lstg.world.l - 16) or (lstg.world.r + 16),
                            ran:Float(lstg.world.b - 10, lstg.world.t + 10),
                            1.6, from_left and 0 or 180, ran:Float(-2, 2))
                    o._r, o._g, o._b = 255, 196, 226
                    o.th04_wind = true
                end
            end
        end,
        render = function() end,
        del = function(self)
            if IsValid(self.hex) then object.RawDel(self.hex) end
            local bs = self.boats or {}
            for i = 1, #bs do
                if IsValid(bs[i]) then object.RawDel(bs[i]) end
            end
            self.boats = nil
            self.hex = nil
        end,
    }, true)

    do
        local name = "「彼岸无余涅槃」"
        local card = boss.card.New(name, 1, 1, 60, 1200)
        boss.card.add({ { card, "1a" } }, 24, name, 285)

        function card:before()
            ToBigScreen(60)
            task.MoveTo(BOSS_X, BOSS_Y, 60, VALUE_SET.DECEL)
        end

        function card:init()
            --最后一个 true = 用本张符卡的计时器做兜底
            self._bosssys:addAutoSPPoint(HP_P2, PH_P2, true)
            self._bosssys:addAutoSPPoint(HP_P3, PH_P3, true)
            self._bosssys:addAutoSPPoint(HP_P4, PH_P4, true)
            self.__nir = New(class["th04_nirvana"], self)
        end

        function card:del()
            if IsValid(self.__nir) then
                object.RawDel(self.__nir)
            end
            self.__nir = nil
        end
    end
end
