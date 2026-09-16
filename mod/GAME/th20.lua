---=====================================
---TH20  地底：地灵殿全员（level 26）
---
---  七位 BOSS 依次登场，每位**两张非符 + 三张符卡**，一共 35 张。
---    1 黑谷山女 / 2 水桥帕露西 / 3 星熊勇仪 / 4 古明地觉
---    5 火焰猫燐  / 6 灵乌路火    / 7 古明地恋
---
---========================================
---  设计原则（这一版是重写，读 SR_Subterrain_Reanimation_v100 之后定的）
---========================================
---
---  ① **没有「限位层」这个东西。** 老版本（th19）把限位当成一个要单独完成的任务，
---    于是越做越硬：先画矩形弹墙，再直接夹 `player.x/y`。那是错的。
---    SR 全作 61 张卡里，**改自机坐标 0 次、铺满屏的自绘墙 0 次**。
---    约束是**攻击图案本身的副产品**，不是一层外加的东西。
---
---  ② 约束来自三样东西，按重要性排：
---     (a) **boss 一直贴在自机旁边** —— `task.MoveToPlayer(...)`，SR 每张卡反复调。
---         它决定所有自机狙的出膛距离恒定，压迫感主要来自这里。
---     (b) **挂在 boss 身上的实体**（`class["hitter"]`）—— 无限血、`colli = true`、
---         位置 = `master + (xx,yy)*sc`，每帧算。它跟着 boss 走，自机要绕开它。
---         SR 的 `hitter` 用了 42 次，是它最核心的原语。
---         链状物体更省事：`x = o1.x*sc + o2.x*(1-sc)`，两点插值，
---         boss 一动整张网自动变形 —— 不需要谁去维护它。
---     (c) **子弹从结构上发出来**（不是从 boss），以及**冻结/解冻的节奏**
---         （SR 的 `4p0-wait`：先 `v=0` 冻住，等 w 帧再加速射出 →
---          整屏是弹，但「哪些已激活」的波前在推进，安全区就是这个波前）。
---
---  ③ 密度靠**形状**，不靠**墙**。常用的几种（每张卡换一种，别一张抄十遍）：
---     · 多路扇 + 相位每波重掷 / `d = -d` 反向
---     · 同心环 + **层间速度差**（每环相位差 1°、速度差 1/L → 环在径向上自己拉开）
---     · 双螺旋（正反两股，半径递减 + 相位每层推进）
---     · 冻结环 → 解冻外射
---     · 结构节点吐扇
---    做法全都用 `NewSimpleBullet(..., frame)` 的**末位钩子**写自定义运动
---    （`b.frame_other`，见 `th07.lua:812`），不要再写一堆子弹子类。
---
---  ④ **不显脏**（同一图案重复时）—— 每轮至少改一个量：
---     `d = -d` / 基准角递增 / 半径 `min(s+k, 上限)` / 预警时长递减 /
---     第 i 次的参数写成 i 的函数。两层同转时要**个数、半径、角速度三项都不同**。
---
---  ⑤ 装饰层：**符卡背景（SCBG）是面积最大的装饰面**，每张卡 2~4 层，
---     贴图用 `Resources/BossBackGround/th11_*.png`（**地灵殿自己的背景**）。
---     同图铺两层、`vy` 相反、一层 `mul+add`，是最省事又好看的做法。
---     前景装饰用主题贴图（`Nuclear1/2`、`FireBird`、`cat`、`eyeL/eyeR`、`mirror`）。
---
---  ⑥ 老版本踩过、这一版必须避开的坑（AGENTS.md §9 / §10）：
---     · `sin`/`cos` 是**角度制**；`% N == offset` 的 offset 必须 < N
---     · `card.frame` 会**先于** `card.init` 跑满整个 `before()` 期间 →
---       状态一律 `(self.__x or 0)` 或写在 `before` 里
---     · 自绘物件 `bound=false` 必须自己 `RawDel`，且**寿命判断不能写在提前 return 后面**
---     · 装饰图形**自绘**，不要「每 N 帧往同一批坐标撒 v=0 的弹」（弹数会线性涨）
---=====================================

local class = {}
_editor_class["TH20"] = class

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
local RenderRect = RenderRect
local ran = ran
local cos, sin, max, min, abs, int, Forbid = cos, sin, max, min, abs, int, Forbid
local Newcharge_in, Newcharge_out = Newcharge_in, Newcharge_out

--============================
--符卡背景：每位 BOSS 一套，用地灵殿自己的背景贴图（th11_*）
--  两层同图、vy 相反、一层 mul+add —— 这是原作最省事又好看的做法
--  （th07.lua:26 的 SCBG3 就是这么写的）
--============================

---@param tex string 背景贴图名（th11_1 … th11_12）
---@param cr,cg,cb number 染色
local function make_scbg(tex, cr, cg, cb, omi)
    local c = Class(_SC_BG)
    c.init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, tex, true, 0, 0, 0, 0, 0.6, 0, "mul+add", 1, 1,
                function(l) l.r, l.g, l.b = cr, cg, cb end)
        _SC_BG.AddLayer(self, tex, true, -128, 0, 0, 0, -0.6, 0, "", 1, 1,
                function(l) l.r, l.g, l.b = cr * 0.8, cg * 0.8, cb * 0.8 end)
        --第三层：缓慢自转的极坐标盘，做「在动」的底
        local b = _SC_BG.AddLayer(self, tex, false, 0, 0, 0, 0, 0, omi or 0.25,
                "mul+add", 1.8, 1.8)
        if b then
            b.Beforeframe = function(u)
                u.a = 90 + 60 * sin(u.timer / 2)
            end
        end
    end
    return c
end

class["SCBG1"] = make_scbg("th11_1", 226, 150, 120, 0.30)   -- 山女：土红
class["SCBG2"] = make_scbg("th11_3", 120, 226, 170, -0.30)  -- 帕露西：妒绿
class["SCBG3"] = make_scbg("th11_5", 255, 196, 130, 0.22)   -- 勇仪：鬼火橙
class["SCBG4"] = make_scbg("th11_7", 200, 160, 255, -0.22)  -- 觉：心眼紫
class["SCBG5"] = make_scbg("th11_9", 255, 140, 110, 0.34)   -- 燐：火车红
class["SCBG6"] = make_scbg("th11_10", 255, 210, 140, -0.34) -- 空：核融合金
class["SCBG7"] = make_scbg("th11_12", 235, 170, 255, 0.26)  -- 恋：玫瑰紫

--============================
--七位 BOSS
--============================
boss.Define("1a", "黑谷山女", "TH20_0", TH20_bg, { 0, 112 }, class["SCBG1"], "Yamame", 26)
boss.Define("2a", "水桥帕露西", "TH20_0", TH20_bg, { 0, 112 }, class["SCBG2"], "Parsee", 26)
boss.Define("3a", "星熊勇仪", "TH20_0", TH20_bg, { 0, 112 }, class["SCBG3"], "Yugi", 26)
boss.Define("4a", "古明地觉", "TH20_0", TH20_bg, { 0, 112 }, class["SCBG4"], "Satori", 26)
boss.Define("5a", "火焰猫燐", "TH20_0", TH20_bg, { 0, 112 }, class["SCBG5"], "Rin", 26)
boss.Define("6a", "灵乌路火", "TH20_0", TH20_bg, { 0, 112 }, class["SCBG6"], "Utsuho", 26)
boss.Define("7a", "古明地恋", "TH20_0", TH20_bg, { 0, 112 }, class["SCBG7"], "Koishi", 26)

--============================
--公用小工具
--============================

---加算细线（自绘，没有判定）
local function thin_line(x1, y1, x2, y2, a, r, g, b, w)
    local len = Dist(x1, y1, x2, y2)
    if a <= 0 or len < 1 then
        return
    end
    SetImageState("white", "mul+add", a, r, g, b)
    Render("white", (x1 + x2) * 0.5, (y1 + y2) * 0.5, Angle(x1, y1, x2, y2), len / 16, w or 0.2)
end

---画一段圆弧
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

---带光晕的光玉（自绘）
local function draw_orb(x, y, size, a, r, g, b)
    if a <= 0 or size <= 0 then
        return
    end
    SetImageState("ball_huge6", "mul+add", 58 * a, r * 0.55, g * 0.55, b * 0.8)
    Render("ball_huge6", x, y, 0, size * 1.5, size * 1.5)
    SetImageState("ball_big6", "mul+add", 170 * a, r, g, b)
    Render("ball_big6", x, y, 0, size * 0.52, size * 0.52)
    SetImageState("ball_mid6", "mul+add", 205 * a, 255, 255, 255)
    Render("ball_mid6", x, y, 0, size * 0.20, size * 0.20)
end

---一片花瓣（自绘）
local function draw_petal(x, y, rot, size, a, r, g, b)
    if a <= 0 or size <= 0 then
        return
    end
    SetImageState("ellipse6", "mul+add", a, r, g, b)
    Render("ellipse6", x, y, rot, size * 1.55, size)
end

---立刻起飞的普通弹
local function fly(style, col, x, y, v, a, omiga, glow)
    local o = NewSimpleBullet(style, col, x, y, v, a, false, omiga or 0, false)
    if glow ~= false then
        o._blend = "mul+add"
    end
    return o
end

---带自定义运动的弹：`fn(self)` 每帧回调（用引擎自带的钩子，
---不用再写子弹子类 —— 见 `THlib/bullet/bullet.lua:287` 的末两参）
---⚠ 回调**只收一个参数**（`bullet.lua:251` 是 `self.frame_other(self)`）。
---  要计时就读 `self.timer`，**不要**写 `function(self, t)` —— 那个 `t` 恒为 nil。
local function fly_path(style, col, x, y, v, a, r, g, b, fn)
    local o = NewSimpleBullet(style, col, x, y, v, a, false, 0, false, false,
            false, false, fn)
    o._r, o._g, o._b = r or 255, g or 255, b or 255
    o._blend = "mul+add"
    return o
end

---把自己的东西挂到 boss 名下（换卡时 refresh(1) 会一起收掉）
local function attach(master, obj)
    if IsValid(master) and obj then
        object.Connect(master, obj, 0, true)
    end
    return obj
end

--============================
--★ 核心原语：boss 身上的实体（对应 SR 的 `hitter`）
---  无判定关不掉：`group = GROUP.ENEMY` 时**自机会撞到它**（`ext.lua:205`
---  `ck(GROUP.PLAYER, GROUP.ENEMY)`），这就是「结构本身也是障碍」。
---  位置 = `master + (xx,yy)*sc`，`sc` 是 0→1 的 sin 半周 → 从 boss 身上长出来。
---  ⚠ 挂在 boss 上（`object.Connect(...,con_death=true)`），boss 一动它跟着动，
---    所以整张图是「本地」的 —— 这正是 SR 的做法，不需要谁去维护它。
--============================
class["hitter"] = Class(object, {
    init = function(self, master, xx, yy, o)
        o = o or {}
        self.master = master
        self.xx, self.yy = xx, yy
        self.sc, self.t = 0, 0
        self.grow = o.grow or 45
        self.r, self.g, self.b = o.r or 255, o.g or 255, o.b or 255
        self.size = o.size or 1
        self.sway = o.sway or 0          -- >0 时绕 master 摆动（度/帧）
        self.ph = o.ph or 0
        self.group, self.layer = GROUP.ENEMY, o.layer or LAYER.ENEMY_BULLET + 5
        self.bound, self.colli = false, true
        self.a, self.b_ = o.a or 18, o.b or 18
        self.free = o.free and true or false   -- true = 不跟 master，坐标自己维护
        --挂到 master：整张卡的寿命
        if IsValid(master) then
            object.Connect(master, self, 0, true)
        end
        --长出来：sc 0→1
        task.New(self, function()
            local ap, d = 0, 180 / self.grow
            for _ = 1, self.grow do
                self.sc = sin(ap)
                ap = ap + d
                task.Wait()
            end
            self.sc = 1
            while true do
                task.Wait()
            end
        end)
    end,
    frame = function(self)
        self.t = self.t + 1
        if self.free then
            return                      -- 自己维护坐标（例如卡 5-5 的车厢）
        end
        if not IsValid(self.master) then
            object.RawDel(self)
            return
        end
        local xx, yy = self.xx, self.yy
        if self.sway ~= 0 then
            local a = self.sway * self.t + self.ph
            local c, s = cos(a), sin(a)
            xx, yy = self.xx * c - self.yy * s, self.xx * s + self.yy * c
        end
        self.x = self.master.x + xx * self.sc
        self.y = self.master.y + yy * self.sc
    end,
    render = function(self)
        if self.sc <= 0.01 then
            return
        end
        local k = self.sc
        SetImageState("ball_huge6", "mul+add", 40 * k, self.r * 0.5, self.g * 0.5, self.b * 0.6)
        Render("ball_huge6", self.x, self.y, 0, 1.1 * self.size * k, 1.1 * self.size * k)
        SetImageState("ball_big6", "mul+add", 170 * k, self.r, self.g, self.b)
        Render("ball_big6", self.x, self.y, 0, 0.42 * self.size * k, 0.42 * self.size * k)
        SetImageState("ball_mid6", "mul+add", 220 * k, 255, 255, 255)
        Render("ball_mid6", self.x, self.y, 0, 0.17 * self.size * k, 0.17 * self.size * k)
    end,
}, true)

---一条「链子」：位置是**两个锚点的插值**，每帧重算。
---  boss 一动、节点一动，整条链自己就跟着变形（SR 的 `1p1-chain` 就是这个）。
class["chain"] = Class(object, {
    init = function(self, o1, o2, sc, o)
        o = o or {}
        self.o1, self.o2, self.sc = o1, o2, sc
        self.r, self.g, self.b = o.r or 220, o.g or 190, o.b or 255
        self.w = o.w or 0.06
        self.pulse = o.pulse or 0
        self.t = 0
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 4
        self.bound, self.colli = false, false
    end,
    frame = function(self)
        self.t = self.t + 1
        if not IsValid(self.o1) then
            object.RawDel(self)
            return
        end
        if not IsValid(self.o2) then
            object.RawDel(self)
            return
        end
        self.x = self.o1.x * self.sc + self.o2.x * (1 - self.sc)
        self.y = self.o1.y * self.sc + self.o2.y * (1 - self.sc)
    end,
    render = function(self)
        local a = 120 + (self.pulse > 0 and 80 * sin(self.t * self.pulse) or 0)
        if IsValid(self.o1) and IsValid(self.o2) then
            thin_line(self.o1.x, self.o1.y, self.o2.x, self.o2.y, a * 0.35,
                    self.r, self.g, self.b, self.w)
        end
        draw_orb(self.x, self.y, 0.11, 0.8, self.r, self.g, self.b)
    end,
}, true)

--============================
--七位 BOSS 的「结构」控制器
--  每个控制器挂在 boss 上，负责造自己的结构 + 从结构上发弹。
--  它们不碰自机 —— 约束靠「结构在哪、弹从哪来」。
--============================

---山女的蛛网：8 个节点 + 每个 7 节链子连回 boss
class["web"] = Class(object, {
    init = function(self, master, o)
        self.master = master
        self.nodes, self.chains = {}, {}
        self.t = 0
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET
        self.bound, self.colli = false, false
        --8 个节点铺在上半场（x ∈ {-192, 204}，y ∈ {32,96,160,224}）
        local i = 0
        for _, nx in ipairs({ -192, 204 }) do
            for _, ny in ipairs({ 32, 96, 160, 224 }) do
                i = i + 1
                local n = attach(master, New(class["hitter"], master, nx, ny, {
                    r = 226, g = 190, b = 255,
                    size = 1.0, grow = 45 + i * 3,
                    sway = 0.12, ph = i * 40,
                }))
                self.nodes[i] = n
                --7 节链子挂在节点和 boss 之间
                for k = 1, 7 do
                    self.chains[#self.chains + 1] = New(class["chain"], n, master,
                            k / 8, { r = 226, g = 190, b = 255, pulse = 3 })
                    object.Connect(n, self.chains[#self.chains], 0, true)
                end
            end
        end
        if IsValid(master) then
            object.Connect(master, self, 0, true)
        end
    end,
    frame = function(self)
        self.t = self.t + 1
        if not IsValid(self.master) then
            object.RawDel(self)
            return
        end
    end,
    render = function(self)
        --网线：节点两两之间拉细线（自绘，没有判定）
        if not IsValid(self.master) then
            return
        end
        for i = 1, #self.nodes do
            local a = self.nodes[i]
            local b = self.nodes[i % #self.nodes + 1]
            if IsValid(a) and IsValid(b) then
                thin_line(a.x, a.y, b.x, b.y, 40, 226, 200, 255, 0.05)
            end
        end
    end,
}, true)

---两盏探照灯：绕 boss 走李萨如曲线，各自扫出一道光束
---  （SR 的 `2p0-cctv`：`x = boss.x + xx*cos(aa)`、`y = boss.y + yy*cos(aa+30)`）
class["cctv"] = Class(object, {
    init = function(self, master, o)
        o = o or {}
        self.master = master
        self.dx, self.dy = o.dx or 96, o.dy or 64
        self.aa = o.a0 or 0
        self.sa = o.sa or -90
        self.spin = o.spin or 3
        self.sweep = o.sweep or 3
        self.gap = o.gap or 8
        self.v = o.v or 2.0
        self.n = o.n or 3
        self.col = o.col or 4
        self.t = 0
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 40
        self.bound, self.colli = false, false
        if IsValid(master) then
            object.Connect(master, self, 0, true)
        end
    end,
    frame = function(self)
        self.t = self.t + 1
        if not IsValid(self.master) then
            object.RawDel(self)
            return
        end
        self.aa = self.aa + self.spin
        self.sa = self.sa + self.sweep
        self.x = self.master.x + self.dx * cos(self.aa)
        self.y = self.master.y + self.dy * cos(self.aa + 30)
        if self.t % self.gap == 1 then
            for k = 1, self.n do
                local a = self.sa + (k - (self.n + 1) / 2) * 7
                local b = fly(ball_mid, self.col, self.x, self.y, self.v, a)
                b._r, b._g, b._b = 190, 255, 210
            end
            PlaySound("tan00", 0.04, self.x / 256, true)
        end
    end,
    render = function(self)
        --光束（自绘，只是画面）
        local a = 150
        for k = 1, self.n do
            local ang = self.sa + (k - (self.n + 1) / 2) * 7
            thin_line(self.x, self.y, self.x + cos(ang) * 150, self.y + sin(ang) * 150,
                    a * 0.5, 190, 255, 210, 0.05)
        end
        draw_orb(self.x, self.y, 0.3, 0.9, 190, 255, 210)
    end,
}, true)

---星阵：4 个节点绕 boss 公转，每个到外圈时炸一次（勇仪）
class["starring"] = Class(object, {
    init = function(self, master, o)
        o = o or {}
        self.master = master
        self.n = o.n or 4
        self.r0, self.r1 = o.r0 or 54, o.r1 or 130
        self.spin = o.spin or 1.6
        self.beat = o.beat or 26
        self.v = o.v or 2.4
        self.t = 0
        self.nodes = {}
        for i = 1, self.n do
            self.nodes[i] = attach(master, New(class["hitter"], master,
                    cos((i - 1) * 360 / self.n) * self.r0,
                    sin((i - 1) * 360 / self.n) * self.r0, {
                        r = 255, g = 210, b = 140, size = 0.85, grow = 40,
                        a = 16, b = 16,
                    }))
        end
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 40
        self.bound, self.colli = false, false
        if IsValid(master) then
            object.Connect(master, self, 0, true)
        end
    end,
    frame = function(self)
        self.t = self.t + 1
        if not IsValid(self.master) then
            object.RawDel(self)
            return
        end
        --半径一张一缩
        local ph = sin(self.t * (180 / 150))
        local r = self.r0 + (self.r1 - self.r0) * (0.5 + 0.5 * ph)
        local base = self.t * self.spin
        for i = 1, self.n do
            local nd = self.nodes[i]
            if IsValid(nd) then
                local a = base + (i - 1) * 360 / self.n
                nd.xx, nd.yy = cos(a) * r, sin(a) * r
                nd.sc = max(nd.sc, 0.999)
            end
        end
        --到最外圈时整圈吐一发
        if self.t % self.beat == 1 then
            for i = 1, self.n do
                local nd = self.nodes[i]
                if IsValid(nd) then
                    for k = 1, 5 do
                        fly(star_small, 2, nd.x, nd.y, self.v, (k - 3) * 14 + base)._r = 255
                    end
                end
            end
            PlaySound("tan00", 0.06, 0, true)
        end
    end,
    render = function(self)
        if not IsValid(self.master) then
            return
        end
        for i = 1, self.n do
            local nd = self.nodes[i]
            if IsValid(nd) then
                local a = self.t * self.spin + (i - 1) * 360 / self.n
                thin_line(self.master.x, self.master.y,
                        self.master.x + cos(a) * 150, self.master.y + sin(a) * 150,
                        30, 255, 210, 150, 0.04)
            end
        end
    end,
}, true)

---第三只眼：绕 boss 慢慢转，**瞄的是自机 45 帧前的位置**（觉的「读心」）
class["thirdeye"] = Class(object, {
    init = function(self, master, o)
        o = o or {}
        self.master = master
        self.eye = attach(master, New(class["hitter"], master, 0, -110, {
            r = 226, g = 200, b = 255, size = 1.25, grow = 50, sway = 0.5,
            a = 22, b = 22,
        }))
        self.v = o.v or 2.6
        self.n = o.n or 7
        self.gap = o.gap or 70
        self.delay = o.delay or 45
        self.t = 0
        self.trace = {}
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 40
        self.bound, self.colli = false, false
        if IsValid(master) then
            object.Connect(master, self, 0, true)
        end
    end,
    frame = function(self)
        self.t = self.t + 1
        if not IsValid(self.master) then
            object.RawDel(self)
            return
        end
        --记录自机轨迹
        self.trace[#self.trace + 1] = { player.x, player.y }
        if #self.trace > self.delay + 4 then
            table.remove(self.trace, 1)
        end
        if self.t % self.gap ~= 1 then
            return
        end
        --瞄「45 帧前」的坐标 —— 读心读的是你刚才在哪，站桩会被打
        local p = self.trace[1] or { player.x, player.y }
        local ex = IsValid(self.eye) and self.eye.x or self.master.x
        local ey = IsValid(self.eye) and self.eye.y or self.master.y
        local a0 = Angle(ex, ey, p[1], p[2])
        for k = 1, self.n do
            fly(ellipse, 12, ex, ey, self.v,
                    a0 + (k - (self.n + 1) / 2) * 9)._r = 226
        end
        PlaySound("tan00", 0.05, 0, true)
    end,
    render = function(self)
        if IsValid(self.master) and #self.trace > 0 then
            local p = self.trace[1]
            --把「读到的那个点」画出来，玩家看得见它在读哪里
            arc(p[1], p[2], 26, 0, 360, 16, 140, 226, 200, 255, 0.06)
        end
    end,
}, true)

---十八节点格：3 圈 × 6 个绕 boss 转，子弹全从节点出来（燐，照 SR 的 5746）
class["lattice"] = Class(object, {
    init = function(self, master, o)
        o = o or {}
        self.master = master
        self.nodes = {}
        self.t = 0
        self.da = 0
        self.dda = -0.25
        self.v = o.v or 2.6
        self.gap = o.gap or 90
        if IsValid(master) then
            object.Connect(master, self, 0, true)
        end
        for ring = 1, 3 do
            for k = 1, 6 do
                local a = (ring - 1) * 30 + (k - 1) * 60
                local d = ring * 30
                self.nodes[#self.nodes + 1] = attach(master,
                        New(class["hitter"], master, cos(a) * d, sin(a) * d, {
                            r = 255, g = 178, b = 150, size = 0.7, grow = 40 + ring * 6,
                            a = 14, b = 14,
                        }))
            end
        end
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 40
        self.bound, self.colli = false, false
    end,
    frame = function(self)
        self.t = self.t + 1
        if not IsValid(self.master) then
            object.RawDel(self)
            return
        end
        --整格绕 boss 转，角速度从负慢慢转正
        self.dda = self.dda + 0.002
        self.da = self.da + self.dda
        local i = 1
        for ring = 1, 3 do
            for k = 1, 6 do
                local a = (ring - 1) * 30 + (k - 1) * 60 + self.da
                local d = ring * 30
                local nd = self.nodes[i]
                if IsValid(nd) then
                    nd.xx, nd.yy = cos(a) * d, sin(a) * d
                    nd.sc = max(nd.sc, 0.999)
                end
                i = i + 1
            end
        end
        --每 gap 帧：所有节点各吐一路朝外，圈数递增
        if self.t % self.gap == 1 then
            local n = min(3, 1 + int(self.t / self.gap) % 3)
            for _, nd in ipairs(self.nodes) do
                if IsValid(nd) then
                    for k = 1, n do
                        fly(ball_mid, 4, nd.x, nd.y, self.v,
                                Angle(self.master, nd) + (k - (n + 1) / 2) * 16)._r = 255
                    end
                end
            end
            PlaySound("tan00", 0.06, 0, true)
        end
    end,
}, true)

---核融合球：Nuclear1（白心）+ Nuclear2（等离子）同轴叠层，绕 boss 公转并脉动
---  （仓库里就有 Nuclear1.png / Nuclear2.png，th11.lua:1286 的原作就是两层叠）
class["nuclear"] = Class(object, {
    init = function(self, master, o)
        o = o or {}
        self.master = master
        self.a = o.a or 0
        self.d = o.d or 110
        self.spin = o.spin or 0.7
        self.t = 0
        self.alpha = 0
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 40
        self.bound, self.colli = false, false
        if IsValid(master) then
            object.Connect(master, self, 0, true)
        end
    end,
    frame = function(self)
        self.t = self.t + 1
        if not IsValid(self.master) then
            object.RawDel(self)
            return
        end
        self.alpha = min(self.alpha + 0.03, 1)
        self.a = self.a + self.spin
        self.x = self.master.x + cos(self.a) * self.d
        self.y = self.master.y + sin(self.a) * self.d
        --每 5 帧朝外吐一对「镜像」的弹（th11 的原作：a 与 180-a 互为镜像）
        if self.t % 5 == 1 then
            local ang = Angle(self.master, self)
            for _, dd in ipairs({ 0, 180 }) do
                fly(ball_big, 6, self.x, self.y, 2.4, ang + dd)._r = 255
            end
        end
    end,
    render = function(self)
        local s = 0.95 + 0.05 * sin(self.t * 4)
        SetImageState("Nuclear2", "mul+add", self.alpha * 255, 255, 190, 120)
        Render("Nuclear2", self.x, self.y, self.t * 2, self.alpha * s * 1.4, self.alpha * s * 1.4)
        SetImageState("Nuclear1", "mul+add", self.alpha * 224, 255, 255, 255)
        Render("Nuclear1", self.x, self.y, -self.t * 2, self.alpha * s, self.alpha * s)
    end,
}, true)

---玫瑰阵：8 片花瓣绕 boss 张缩，每片在最大时吐心弹（恋）
class["rose"] = Class(object, {
    init = function(self, master, o)
        o = o or {}
        self.master = master
        self.n = o.n or 8
        self.r0, self.r1 = o.r0 or 40, o.r1 or 150
        self.period = o.period or 180
        self.t = 0
        self.rot = 0
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 40
        self.bound, self.colli = false, false
        if IsValid(master) then
            object.Connect(master, self, 0, true)
        end
    end,
    frame = function(self)
        self.t = self.t + 1
        if not IsValid(self.master) then
            object.RawDel(self)
            return
        end
        self.rot = self.rot + 0.5
        if self.t % self.period == int(self.period * 0.5) then
            --张到最大：8 片花瓣各吐一路
            for i = 1, self.n do
                local a = self.rot + (i - 1) * 360 / self.n
                fly(heart, 12, self.master.x + cos(a) * self.r1,
                        self.master.y + sin(a) * self.r1, 2.2, a)._r = 235
            end
            PlaySound("tan00", 0.07, 0, true)
        end
    end,
    render = function(self)
        local k = 0.5 + 0.5 * sin(self.t * (360 / self.period) + 270)
        local r = self.r0 + (self.r1 - self.r0) * k
        for i = 1, self.n do
            local a = self.rot + (i - 1) * 360 / self.n
            draw_petal(self.master.x + cos(a) * r, self.master.y + sin(a) * r,
                    a + 90, 0.5, 120, 235, 170, 255)
            draw_petal(self.master.x + cos(a) * r * 0.55,
                    self.master.y + sin(a) * r * 0.55, a, 0.34, 80, 200, 150, 255)
        end
        draw_orb(self.master.x, self.master.y, 0.3, 0.85, 255, 210, 255)
    end,
}, true)

--============================
--通用：密度层
--  按「形状」分几种，每张卡换一种，别一张抄十遍。
--  ⚠ 参数**每轮都变**（不显脏四规则），不要一次写死。
--============================

---同心环 + 层间速度差：同一帧打 L 个环，每环相位差 1°、速度差 (v1-v0)/L
---  → 环在**径向上自己拉开**，玩家穿的是「环与环之间的径向缝」。
---  （照 `th15.lua:1249` 「料得年年肠断处，明月夜，短松冈」）
---  ⚠ **速度差不够大 = 没有缝。** 这一层环是 L 层叠着打出去的，
---    相邻两层在 T 帧后拉开 `T*(v1-v0)/L` px。原来我给的是 v0=2.0 v1=3.0（L=12）
---    → 每层差 0.083 px/帧 → 150 帧后才拉开 12 px，整圈糊成**一个实心环**，
---    玩家没有一条径向缝可穿 —— 死局就是这么来的。
---    这里强制一个下限：每层至少差 0.20 px/帧（150 帧 → 30 px 缝，够穿）。
local function spread_v(L, v0, v1)
    local need = L * 0.20
    if v1 - v0 < need then
        v1 = v0 + need
    end
    return v1
end

local function ring_layer(self, o)
    task.New(self, function()
        local d = 1
        task.Wait(o.delay or 90)
        while true do
            local L, n = o.layers or 12, o.n or 15
            local v0 = o.v0 or 1.6
            local v1 = spread_v(L, v0, o.v1 or 3.4)
            for c = 1, L do
                for i = 1, n do
                    local a = (i - 1) * 360 / n + c * d
                    local v = v0 + (v1 - v0) * c / L
                    local b = fly(o.style or ball_mid, o.col or 6, self.x, self.y, v, a)
                    b._r, b._g, b._b = o.r or 226, o.g or 200, o.b or 255
                end
            end
            PlaySound("tan00", 0.05, 0, true)
            task.Wait(o.gap or 65)
            d = (o.reverse ~= false) and -d or d
        end
    end)
end

---冻结环 → 解冻外射：先 v=0 冻在场上，等 w 帧再加速射出。
---  整屏是弹，但「哪些已激活」的波前在推进，安全区就是这个波前。
---  （SR 的 `4p0-wait`，卡 5092）
local function freeze_layer(self, o)
    task.New(self, function()
        task.Wait(o.delay or 100)
        while true do
            local w, d = o.w0 or 30, o.d0 or 90
            for step = 1, o.steps or 20 do
                local a0 = ran:Float(0, 360)
                for i = 1, o.n or 20 do
                    local a = a0 + (i - 1) * 360 / (o.n or 20)
                    local b = fly(o.style or grain_b, o.col or 4,
                            self.x + cos(a) * d, self.y + sin(a) * d, 0, a)
                    b._r, b._g, b._b = o.r or 255, o.g or 170, o.b or 170
                    --冻结 w 帧 → 30 帧把速度从 0 加到 v
                    --⚠ 引擎调的是 `self.frame_other(self)` —— **只有一个参数**
                    --  （`THlib/bullet/bullet.lua:251-252`）。原来我写成 `function(bb, t)`，
                    --  `t` 永远是 nil → `t > w` 就是
                    --  「attempt to compare nil with number」—— 真机上这张卡第一颗弹就崩。
                    --  计时要自己读 `bb.timer`（引擎每帧替所有弹 +1）。
                    --  自检原来也从不调 frame_other，所以两边一起漏了这个错。
                    --  （原作全都写 `function(self)`，见 `th07.lua:812`、`th13.lua:671`）
                    b.frame_other = function(bb)
                        local t = bb.timer
                        if t == w then
                            bb.group = GROUP.ENEMY_BULLET
                        end
                        if t > w and t <= w + 30 then
                            object.SetV(bb, (o.v or 5) * (t - w) / 30, bb.rot, true)
                        end
                    end
                end
                task.Wait(2)
                w = w + 6
                d = max(d - 3, 6)
            end
            task.Wait(o.rest or 260)
        end
    end)
end

---双螺旋：正反两股，半径递减 + 相位每层推进
---  ⚠ 同样受 `spread_v` 约束（层间速度差不够 → 螺旋糊成一个实心盘）
local function spiral_layer(self, o)
    task.New(self, function()
        task.Wait(o.delay or 130)
        while true do
            local rot = ran:Float(0, 360)
            local d = 1
            local L, n = o.layers or 12, o.n or 14
            local v0 = o.v0 or 1.5
            local v1 = spread_v(L, v0, o.v1 or 3.6)
            for _ = 1, o.turns or 3 do
                for v = 1, L do
                    for i = 1, n do
                        local a = rot + i * 360 / n + v * 10 * d
                        local b = fly(o.style or ball_small, o.col or 12,
                                self.x + cos(a) * (o.r or 40), self.y + sin(a) * (o.r or 40),
                                v0 + (v1 - v0) * v / L, a)
                        b._r, b._g, b._b = o.r2 or 220, o.g2 or 170, o.b2 or 255
                    end
                    task.Wait(o.step or 5)
                end
                d = -d
            end
            task.Wait(o.gap or 40)
        end
    end)
end

--============================
--★ 底色帘（base）
---  每一张卡都要**先有一层底**：不管这张卡在演什么花招，
---  屏幕上始终有一帘弹在走。这不是装饰，是可读性 ——
---  屏幕上没弹的时候，玩家读不出这卡在干什么，「形状」也就无从谈起。
---  原作的每一张卡都有这么一层（底帘 + 招式两层叠起来才是它的密度）。
---  ⚠ 我第一版漏了这一层，于是 13 张卡同屏弹数比原版低一个数量级 —— 空的。
---  形状按卡换（见 AGENTS.md §7.3），**别一张抄十遍**：
---    "ring"   同心环 + 层间速度差（环在径向自己拉开）
---    "fan"    玩家方向扇 + 每波翻转 + 相位递增
---    "spiral" 正反双螺旋
---    "rain"   顶部垂帘 + 横向滑动的缝
---  每波至少改一个量（d 翻转 / 相位重掷 / 半径步进），否则会显脏。
--============================
local function base(self, o)
    o = o or {}
    local kind = o.kind or "ring"
    local col = o.col or 6
    local style = o.style or ball_small
    local r, g, b = o.r or 226, o.g or 200, o.b or 255
    task.New(self, function()
        task.Wait(o.delay or 90)
        local wave = 0
        while true do
            wave = wave + 1
            local flip = (wave % 2 == 0) and -1 or 1

            if kind == "ring" then
                --同心环：同一波打 L 层，每层相位差 1°、速度差 (v1-v0)/L
                local L, n = o.layers or 6, o.n or 16
                local v0, v1 = o.v0 or 1.6, o.v1 or 3.4
                local rot0 = ran:Float(0, 360)
                for c = 1, L do
                    for i = 1, n do
                        local a = rot0 + (i - 1) * 360 / n + c * flip
                        local bb = fly(style, col, self.x, self.y,
                                v0 + (v1 - v0) * c / L, a)
                        bb._r, bb._g, bb._b = r, g, b
                    end
                    task.Wait(o.step or 4)
                end
                task.Wait(o.gap or 40)

            elseif kind == "fan" then
                --玩家方向扇：路数随波数递增，速度三档
                local n = (o.n or 12) + (wave % 5) * 2
                local a0 = Angle(self.x, self.y, player.x, player.y) + flip * (o.tilt or 8)
                for k = 1, 3 do
                    for i = 1, n do
                        local a = a0 + (i - 1) * 360 / n + k * 3
                        local bb = fly(style, col, self.x, self.y,
                                (o.v0 or 1.8) + k * (o.dv or 0.7), a)
                        bb._r, bb._g, bb._b = r, g, b
                    end
                    task.Wait(o.step or 6)
                end
                task.Wait(o.gap or 44)

            elseif kind == "spiral" then
                --正反双螺旋：半径递减 + 相位每层推进
                local d = flip
                local rot0 = ran:Float(0, 360)
                local L, n = o.layers or 14, o.n or 14
                local v0, v1 = o.v0 or 1.5, o.v1 or 3.6
                for v = 1, L do
                    for i = 1, n do
                        local a = rot0 + i * 360 / n + v * 9 * d
                        local bb = fly(style, col,
                                self.x + cos(a) * (o.rad or 30),
                                self.y + sin(a) * (o.rad or 30),
                                v0 + (v1 - v0) * v / L, a)
                        bb._r, bb._g, bb._b = r, g, b
                    end
                    task.Wait(o.step or 4)
                end
                task.Wait(o.gap or 40)

            elseif kind == "rain" then
                --顶部垂帘：缝**在滑动**（固定的缝 = 墙，两道墙夹起来就是死局 —— AGENTS.md §7.8）
                local gapx = ran:Float(-150, 150)
                local dir = flip
                local half = (o.gapw or 52) + (wave % 3) * 10
                local rows = o.rows or 3
                for rep = 1, o.reps or 26 do
                    for row = 1, rows do
                        for i = 1, o.n or 18 do
                            local x = -180 + 360 * (i - 1) / ((o.n or 18) - 1)
                            if abs(x - gapx) > half then
                                local bb = fly(style, col, x,
                                        lstg.world.t + 10 + row * 24,
                                        (o.v0 or 2.2) + row * 0.5, -90)
                                bb._r, bb._g, bb._b = r, g, b
                            end
                        end
                    end
                    gapx = Forbid(gapx + dir * (o.gapspeed or 5), -170, 170)
                    if gapx <= -170 or gapx >= 170 then dir = -dir end
                    task.Wait(o.step or 2)
                end
                task.Wait(o.gap or 30)
            end
        end
    end)
end



--============================
--[1-1] 非符「蛛糸」
--  结构：8 个节点 + 链子连回 boss（`class["web"]`）
--  约束：节点本身会撞人（`hitter` 是 `GROUP.ENEMY`），链子只是画面
--  弹幕：紫色 grain 沿链子从节点爬到 boss；蓝环从 boss 出
--============================
do
    local CARD_HP = 800
    local card = boss.card.New("", 1, 1, 60, CARD_HP)
    boss.card.add({ { card, "1a" } }, 26, "第一回合", 296)

    function card:before()
        self.__web = attach(self, New(class["web"], self))
        task.New(self, function()
            task.MoveToPlayer(90, -60, 60, 100, 132, 24, 40, 12, 24,
                    VALUE_SET.DECEL, WANDER_MODE.RANDOM)
        end)
    end

    function card:init()
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 226, 190, 255)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 226, 190, 255)
            while true do
                --① 蓝环：60 发，速度 1.5/1.7 交替
                for i = 1, 60 do
                    local a = ran:Float(0, 360) + i * 6
                    local b = fly(ball_mid, 4, self.x, self.y, 1.5 + 0.2 * (i % 2), a)
                    b._r, b._g, b._b = 190, 200, 255
                end
                PlaySound("tan00", 0.08, 0, true)
                --② 紫色 grain 沿链子从节点爬到 boss
                task.New(self, function()
                    local sc, dsc = 1 / 15, 1 / 15
                    local v = 2.5
                    for _ = 1, 15 do
                        local web = self.__web
                        if IsValid(web) then
                            for _, ch in ipairs(web.chains) do
                                if IsValid(ch) and IsValid(ch.o1) then
                                    fly(grain_a, 8, self.x + (ch.o1.x - self.x) * sc,
                                            self.y + (ch.o1.y - self.y) * sc, v, 90)._r = 230
                                end
                            end
                        end
                        v = v + 0.2
                        sc = sc - dsc
                        task.Wait(3)
                    end
                end)
                task.Wait(75)
            end
        end)
    end
end

--============================
--[1-2] 非符「土蜘蛛」
--  约束：从地下钻出的土柱（节点从下往上长出来），柱子之间就是路
--  弹幕：柱子顶端炸成 6 向
--============================
do
    local PILLAR_N = 6
    local CYCLE = 150
    local card = boss.card.New("", 1, 1, 60, 780)
    boss.card.add({ { card, "1a" } }, 26, "第一回合", 297)

    function card:before()
        task.New(self, function()
            while true do
                task.MoveToPlayer(80, -70, 70, 96, 140, 20, 40, 14, 28,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        --底色帘（见 base() 的注释：每张卡都必须有这一层）
        base(self, { kind = "ring", col = 8, r = 226, g = 178, b = 130, layers = 6, n = 16, v0 = 1.6, v1 = 3.4, style = ball_small })
        self.__pillars = {}
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 220, 180, 255)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 220, 180, 255)
            while true do
                --一轮：从下半场随机位置长出 6 根土柱
                local ys = { -170, -120, -70, -20, 30, 80 }
                for i = 1, PILLAR_N do
                    local x = ran:Float(-150, 150)
                    local p = attach(self, New(class["hitter"], self, x, ys[i], {
                        r = 226, g = 178, b = 130, size = 0.9, grow = 40,
                        a = 20, b = 20,
                    }))
                    --柱子是「长出来」的，sc 用 45 帧从 0 到 1
                    p.sc = 0
                    self.__pillars[#self.__pillars + 1] = p
                    --到顶炸 6 向
                    task.New(p, function()
                        task.Wait(45)
                        for k = 1, 6 do
                            fly(ball_mid, 8, p.x, p.y, 2.4, (k - 1) * 60 + i * 12)._r = 214
                        end
                        PlaySound("tan00", 0.06, p.x / 256, true)
                    end)
                end
                task.Wait(CYCLE)
                --清掉上一轮
                for _, p in ipairs(self.__pillars) do
                    if IsValid(p) then
                        object.RawDel(p)
                    end
                end
                self.__pillars = {}
            end
        end)
        --装饰层：上方的土尘带（自绘）
        attach(self, New(class["th20_dust"], self))
    end
end

--============================
--[1-3] 罠符「土蜘蛛の網」
--  约束：蛛网收紧 —— 节点整体朝 boss 收（半径缩小），缝越来越窄
--  弹幕：网上每节链子吐一颗（沿链子方向）
--============================
do
    local CYCLE = 220
    local card = boss.card.New("罠符「土蜘蛛の網」", 1, 1, 60, 900)
    boss.card.add({ { card, "1a" } }, 26, "罠符「土蜘蛛の網」", 298)

    function card:before()
        task.New(self, function()
            task.MoveTo(0, 112, 60, VALUE_SET.DECEL)
            while true do
                task.MoveToPlayer(120, -80, 80, 96, 140, 24, 48, 16, 32,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        --底色帘（见 base() 的注释：每张卡都必须有这一层）
        base(self, { kind = "spiral", col = 6, r = 200, g = 170, b = 255, layers = 12, n = 14, v0 = 1.5, v1 = 3.4 })
        --结构：一圈 8 个节点 + 链
        self.__ring = {}
        for i = 1, 8 do
            local a = (i - 1) * 45
            local nd = attach(self, New(class["hitter"], self, cos(a) * 150, sin(a) * 150, {
                r = 226, g = 190, b = 255, size = 0.95, grow = 40 + i * 2, a = 18, b = 18,
            }))
            self.__ring[i] = nd
            for k = 1, 6 do
                New(class["chain"], nd, self, k / 7,
                        { r = 226, g = 190, b = 255, pulse = 4 })
            end
        end
        task.New(self, function()
            task.Wait(80)
            Newcharge_in(self.x, self.y, 226, 190, 255)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 226, 190, 255)
            while true do
                --收紧 → 放开，每轮转 15°
                local turn = ran:Float(0, 360)
                for step = 1, 2 do
                    local r0, r1 = (step == 1) and { 165, 60 } or { 60, 165 }
                    for k = 0, 30 do
                        local r = r0[1] + (r0[2] - r0[1]) * k / 30
                        for i = 1, 8 do
                            local nd = self.__ring[i]
                            if IsValid(nd) then
                                local a = turn + (i - 1) * 45 + k * 1.5
                                nd.xx, nd.yy = cos(a) * r, sin(a) * r
                            end
                        end
                        if k % 6 == 0 then
                            for i = 1, 8 do
                                local nd = self.__ring[i]
                                if IsValid(nd) then
                                    fly(ball_mid, 4, nd.x, nd.y, 2.0,
                                            Angle(self, nd) + 180)._r = 226
                                end
                            end
                            PlaySound("tan00", 0.04, 0, true)
                        end
                        task.Wait(3)
                    end
                end
                task.Wait(20)
            end
        end)
    end
end

--============================
--[1-4] 瘴符「フィルドミアズマ」
--  约束：无（靠密度 + boss 贴身）
--  弹幕：同心环层间速度差 + 冻结核
--============================
do
    local card = boss.card.New("瘴符「フィルドミアズマ」", 1, 1, 60, 950)
    boss.card.add({ { card, "1a" } }, 26, "瘴符「フィルドミアズマ」", 299)

    function card:before()
        task.New(self, function()
            while true do
                task.MoveToPlayer(100, -80, 80, 90, 140, 20, 44, 16, 32,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        ring_layer(self, { layers = 12, n = 15, v0 = 2.0, v1 = 3.0, gap = 65,
                col = 10, r = 190, g = 240, b = 200, delay = 90 })
        freeze_layer(self, { steps = 16, n = 18, d0 = 120, w0 = 40, v = 4.2,
                delay = 140, rest = 260, col = 10, r = 170, g = 255, b = 200 })
    end
end

--============================
--[1-5] 蜘蛛「土蜘蛛の宴」
--  约束：4 条从 boss 拉出去的蛛丝（节点在远端），末端各挂一个吐弹的巢
--  弹幕：螺旋 + 巢吐扇
--============================
do
    local card = boss.card.New("蜘蛛「土蜘蛛の宴」", 1, 1, 60, 1000)
    boss.card.add({ { card, "1a" } }, 26, "蜘蛛「土蜘蛛の宴」", 300)

    function card:before()
        task.New(self, function()
            task.MoveTo(0, 112, 60, VALUE_SET.DECEL)
            while true do
                task.MoveToPlayer(140, -100, 100, 90, 150, 28, 56, 20, 40,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        --4 条蛛丝的远端节点
        self.__far = {}
        for i = 1, 4 do
            local a = (i - 1) * 90
            local nd = attach(self, New(class["hitter"], self, cos(a) * 175, sin(a) * 175, {
                r = 226, g = 190, b = 255, size = 1.1, grow = 45, a = 20, b = 20,
                sway = 0.9, ph = i * 90,
            }))
            self.__far[i] = nd
            for k = 1, 8 do
                New(class["chain"], nd, self, k / 9,
                        { r = 226, g = 190, b = 255, pulse = 5 })
            end
        end
        spiral_layer(self, { layers = 14, n = 12, v0 = 1.4, v1 = 2.6, turns = 2,
                gap = 50, r2 = 226, g2 = 200, b2 = 255, delay = 160 })
        --巢：每个远端节点每 70 帧吐 5 路朝内
        task.New(self, function()
            task.Wait(160)
            while true do
                for i = 1, 4 do
                    local nd = self.__far[i]
                    if IsValid(nd) then
                        for k = 1, 5 do
                            fly(ball_mid, 4, nd.x, nd.y, 2.2,
                                    Angle(nd, self) + (k - 3) * 13)._r = 255
                        end
                    end
                end
                PlaySound("tan00", 0.06, 0, true)
                task.Wait(70)
            end
        end)
    end
end

--============================
--[2] 水桥帕露西 —— 桥姬。结构：两盏探照灯 + 镜面对称
--============================

--============================
--[2-1] 非符「睨み」
--  结构：两盏探照灯绕 boss 李萨如公转，各自扫出光束
--============================
do
    local card = boss.card.New("", 1, 1, 60, 800)
    boss.card.add({ { card, "2a" } }, 26, "第一回合", 301)

    function card:before()
        attach(self, New(class["cctv"], self, { dx = 96, dy = 60, a0 = 0, sa = -90,
                spin = 3.2, sweep = 3, gap = 7, v = 2.0, n = 3, col = 4 }))
        attach(self, New(class["cctv"], self, { dx = 96, dy = 60, a0 = 180, sa = 90,
                spin = -3.2, sweep = -3, gap = 7, v = 2.0, n = 3, col = 4 }))
        task.New(self, function()
            task.MoveTo(0, 112, 60, VALUE_SET.DECEL)
            while true do
                task.MoveToPlayer(110, -70, 70, 96, 140, 20, 40, 14, 28,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        task.New(self, function()
            task.Wait(110)
            Newcharge_in(self.x, self.y, 180, 255, 210)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 180, 255, 210)
            while true do
                --镜像的整圈：左半原样、右半镜像（这张卡的主题）
                for i = 1, 24 do
                    local a = (i - 1) * 15
                    local b = fly(ball_mid, 4, self.x + cos(a) * 40,
                            self.y + sin(a) * 40, 2.2, a)
                    b._r, b._g, b._b = 190, 255, 210
                    local b2 = fly(ball_mid, 4, self.x - cos(a) * 40,
                            self.y + sin(a) * 40, 2.2, 180 - a)
                    b2._r, b2._g, b2._b = 190, 255, 210
                end
                PlaySound("tan00", 0.05, 0, true)
                task.Wait(80)
            end
        end)
        attach(self, New(class["th20_mirror"], self))
    end
end

--============================
--[2-2] 非符「橋姫の橋」
--  约束：桥面 —— 两条平行的弹带夹出一条通道，通道会横向平移
--  弹幕：带子上的弹 + 通道里的自机狙
--============================
do
    local card = boss.card.New("", 1, 1, 60, 780)
    boss.card.add({ { card, "2a" } }, 26, "第一回合", 302)

    function card:before()
        task.New(self, function()
            while true do
                task.MoveToPlayer(90, 0, 0, 90, 150, 16, 32, 20, 40,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        --底色帘（见 base() 的注释：每张卡都必须有这一层）
        base(self, { kind = "spiral", col = 10, r = 190, g = 255, b = 225, layers = 10, n = 14, v0 = 1.4, v1 = 3.6 })
        self.__shift = 0
        self.__dir = 1
        task.New(self, function()
            task.Wait(70)
            Newcharge_in(self.x, self.y, 170, 240, 220)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 170, 240, 220)
            while true do
                for step = 0, 30 do
                    local x = -180 + 360 * step / 30
                    local d = x - self.__shift
                    --通道宽 56 px
                    if abs(d) > 28 then
                        fly(ball_small, 10, x, lstg.world.t + 10, 2.4, -90)._r = 170
                    end
                    task.Wait(2)
                end
            end
        end)
        --通道会横向平移，方向每轮换
        task.New(self, function()
            while true do
                for _ = 1, 60 do
                    self.__shift = self.__shift + self.__dir * 2.4
                    self.__shift = Forbid(self.__shift, -120, 120)
                    task.Wait()
                end
                self.__dir = -self.__dir
            end
        end)
    end

    function card:render()
        --画出桥面的通道（预警：玩家看得见通道在哪）
        local sx = (self.__shift or 0)
        SetImageState("white", "mul+add", 40, 170, 240, 220)
        RenderRect("white", sx - 28, sx + 28, 0, lstg.world.t)
    end
end

--============================
--[2-3] 嫉符「ジェラシーグラス」
--  结构：两盏灯一左一右镜像，扫出的光束永远对称
--  弹幕：镜像的双螺旋
--============================
do
    local card = boss.card.New("嫉符「ジェラシーグラス」", 1, 1, 60, 880)
    boss.card.add({ { card, "2a" } }, 26, "嫉符「ジェラシーグラス」", 303)

    function card:before()
        attach(self, New(class["cctv"], self, { dx = 130, dy = 0, a0 = 0, sa = 0,
                spin = 2.6, sweep = 4, gap = 9, v = 2.2, n = 4, col = 4 }))
        attach(self, New(class["cctv"], self, { dx = 130, dy = 0, a0 = 180, sa = 180,
                spin = 2.6, sweep = -4, gap = 9, v = 2.2, n = 4, col = 4 }))
        task.New(self, function()
            task.MoveTo(0, 112, 60, VALUE_SET.DECEL)
            while true do
                task.MoveToPlayer(120, -60, 60, 100, 140, 20, 40, 16, 32,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        --镜像双螺旋：两股反向，且右半是左半的镜像
        --⚠ 层间速度差原来只有 0.12/层（1.6→3.04）→ 150 帧后才拉开 18 px，
        --  12 层糊成一个实心盘，死局 3%。拉到 0.22/层（33 px 缝）才穿得过去。
        task.New(self, function()
            task.Wait(130)
            Newcharge_in(self.x, self.y, 180, 255, 210)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 180, 255, 210)
            while true do
                local rot = ran:Float(0, 360)
                for d = -1, 1, 2 do
                    for v = 1, 12 do
                        for i = 1, 14 do
                            local a = rot + i * 360 / 14 + v * 12 * d
                            local vv = 1.4 + v * 0.22
                            local x1, y1 = self.x + cos(a) * 36, self.y + sin(a) * 36
                            local b = fly(ball_small, 12, x1, y1, vv, a)
                            b._r, b._g, b._b = 200, 255, 220
                            local b2 = fly(ball_small, 12, self.x - (x1 - self.x), y1,
                                    vv, 180 - a)
                            b2._r, b2._g, b2._b = 200, 255, 220
                        end
                        task.Wait(5)
                    end
                end
                task.Wait(60)
            end
        end)
        attach(self, New(class["th20_mirror"], self))
    end
end

--============================
--[2-4] 恨符「丑三つ時の藪睨み」
--  约束：四盏灯轮流点亮，只有被点亮的那一侧危险
--============================
do
    local card = boss.card.New("恨符「丑三つ時の藪睨み」", 1, 1, 60, 950)
    boss.card.add({ { card, "2a" } }, 26, "恨符「丑三つ時の藪睨み」", 304)

    function card:before()
        self.__lamps = {}
        for i = 1, 4 do
            self.__lamps[i] = attach(self, New(class["cctv"], self, {
                dx = 0, dy = 0, a0 = (i - 1) * 90, sa = (i - 1) * 90,
                spin = 0, sweep = 0, gap = 12, v = 2.6, n = 5, col = 4,
            }))
            --四个「灯位」：上下左右，半径 90
            self.__lamps[i].dx = cos((i - 1) * 90) * 90
            self.__lamps[i].dy = sin((i - 1) * 90) * 90
        end
        task.New(self, function()
            while true do
                task.MoveToPlayer(120, -70, 70, 96, 140, 24, 44, 16, 32,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        --⚠ 这一张原来死局 4.8%：4 盏灯（每 6 帧 5 路 = 3.3 发/帧）+ 中心 10 层环，
        --  两套约束都是「从中心往外」→ 叠起来自机无处可去。把两边都放宽：
        --  环降到 10 路、间隔 105；灯放慢到 12 帧。
        ring_layer(self, { layers = 10, n = 10, v0 = 1.8, v1 = 3.8, gap = 105,
                col = 4, r = 180, g = 255, b = 210, delay = 120 })
    end

    function card:render()
        --指示当前「最危险」的那盏灯
        if not self.__lamps then
            return
        end
        local t = (self.ani or 0)
        local idx = int(t / 90) % 4 + 1
        local p = self.__lamps[idx]
        if IsValid(p) then
            arc(p.x, p.y, 70 + 20 * sin(t * 3), 0, 360, 24, 120, 190, 255, 210, 0.07)
        end
    end
end

--============================
--[2-5] 呪花「カースドブルーフラワー」
--  约束：无
--  弹幕：镜面对称的花瓣绽放 + 冻结核
--============================
do
    local card = boss.card.New("呪花「カースドブルーフラワー」", 1, 1, 60, 1000)
    boss.card.add({ { card, "2a" } }, 26, "呪花「カースドブルーフラワー」", 305)

    function card:before()
        task.New(self, function()
            while true do
                task.MoveToPlayer(110, -70, 70, 90, 140, 22, 44, 16, 32,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        --底色帘（见 base() 的注释：每张卡都必须有这一层）
        base(self, { kind = "spiral", col = 12, r = 150, g = 255, b = 190, layers = 12, n = 14, v0 = 1.4, v1 = 3.2 })
        task.New(self, function()
            task.Wait(90)
            Newcharge_in(self.x, self.y, 160, 255, 210)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 160, 255, 210)
            while true do
                --8 瓣，每瓣到外圈再裂成 3；镜像同步
                local rot = ran:Float(0, 360)
                for layer = 1, 3 do
                    local n = 8 + (layer - 1) * 4
                    local v = 1.4 + layer * 0.5
                    for i = 1, n do
                        local a = rot + (i - 1) * 360 / n + layer * 7
                        local b = fly(ball_mid, 12, self.x, self.y, v, a)
                        b._r, b._g, b._b = 150, 255, 190
                        local b2 = fly(ball_mid, 12, self.x, self.y, v, 180 - a)
                        b2._r, b2._g, b2._b = 150, 255, 190
                    end
                    task.Wait(35)
                end
                task.Wait(40)
            end
        end)
    end
end

--============================
--[3] 星熊勇仪 —— 鬼。结构：星阵（4 节点公转 + 张缩）
--============================

--============================
--[3-1] 非符「怪力」
--  结构：星阵（4 节点绕 boss 一张一缩）
--============================
do
    local card = boss.card.New("", 1, 1, 60, 820)
    boss.card.add({ { card, "3a" } }, 26, "第一回合", 306)

    function card:before()
        attach(self, New(class["starring"], self, { n = 4, r0 = 54, r1 = 140,
                spin = 1.6, beat = 26, v = 2.4 }))
        task.New(self, function()
            task.MoveTo(0, 112, 60, VALUE_SET.DECEL)
            while true do
                task.MoveToPlayer(110, -80, 80, 96, 140, 20, 44, 16, 32,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        ring_layer(self, { layers = 8, n = 9, v0 = 2.6, v1 = 3.4, gap = 95,
                col = 2, r = 255, g = 210, b = 150, delay = 110 })
    end
end

--============================
--[3-2] 非符「大江山颪」
--  约束：从下往上顶的冲击波（节点自下而上长出来），把自机挤到上半场
--  ⚠ **不碰自机坐标**：靠 node 本身的判定 + 上方的针
--============================
do
    local CYCLE = 240
    local card = boss.card.New("", 1, 1, 60, 800)
    boss.card.add({ { card, "3a" } }, 26, "第一回合", 307)

    function card:before()
        task.New(self, function()
            while true do
                task.MoveToPlayer(90, -60, 60, 100, 140, 18, 36, 16, 32,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        --底色帘（见 base() 的注释：每张卡都必须有这一层）
        base(self, { kind = "ring", col = 12, r = 255, g = 200, b = 130, layers = 7, n = 14, v0 = 1.5, v1 = 3.3, step = 4, gap = 42 })
        --冲击波：一排节点从屏幕底「长」到顶，长的过程就是波
        task.New(self, function()
            task.Wait(70)
            while true do
                local row = {}
                for i = 1, 9 do
                    local x = -176 + 44 * (i - 1)
                    local nd = attach(self, New(class["hitter"], self, x, -240, {
                        r = 255, g = 190, b = 150, size = 0.8, grow = 30,
                        a = 16, b = 16,
                    }))
                    nd.sc = 1
                    row[i] = nd
                end
                for k = 0, 60 do
                    local y = -240 + 400 * k / 60
                    for i = 1, 9 do
                        local nd = row[i]
                        if IsValid(nd) then
                            nd.yy = y
                        end
                    end
                    task.Wait(3)
                end
                for _, nd in ipairs(row) do
                    if IsValid(nd) then
                        object.RawDel(nd)
                    end
                end
                task.Wait(CYCLE)
            end
        end)
        --上方的落针
        task.New(self, function()
            while true do
                for i = 1, 3 do
                    fly(knife, 4, ran:Float(-170, 170), lstg.world.t + 20, 2.8, -90)._r = 255
                end
                task.Wait(84)
            end
        end)
    end
end

--============================
--[3-3] 鬼符「ミッシングパワー」
--  约束：无（靠密度 + 贴身）
--  弹幕：大玉慢速扇 + 冻结环
--============================
do
    local card = boss.card.New("鬼符「ミッシングパワー」", 1, 1, 60, 900)
    boss.card.add({ { card, "3a" } }, 26, "鬼符「ミッシングパワー」", 308)

    function card:before()
        task.New(self, function()
            task.MoveTo(0, 112, 60, VALUE_SET.DECEL)
            while true do
                task.MoveToPlayer(130, -90, 90, 90, 150, 24, 52, 18, 36,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        task.New(self, function()
            task.Wait(100)
            Newcharge_in(self.x, self.y, 255, 190, 150)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 255, 190, 150)
            while true do
                local a0 = ran:Float(0, 360)
                for k = 1, 9 do
                    local b = fly(ball_big, 2, self.x, self.y, 1.7, a0 + (k - 1) * 40)
                    b._r, b._g, b._b = 255, 186, 140
                end
                PlaySound("tan00", 0.09, 0, true)
                task.Wait(96)
            end
        end)
        freeze_layer(self, { steps = 14, n = 16, d0 = 100, w0 = 36, v = 4.0,
                delay = 150, rest = 280, col = 2, r = 255, g = 200, b = 140 })
    end
end

--============================
--[3-4] 星熊「三歩必殺」
--  约束：三个星阵节点各在一角，boss 每「走一步」换一个节点激活
--============================
do
    local card = boss.card.New("星熊「三歩必殺」", 1, 1, 60, 1000)
    boss.card.add({ { card, "3a" } }, 26, "星熊「三歩必殺」", 309)

    function card:before()
        self.__step = 1
        self.__nodes = {}
        for i = 1, 3 do
            local a = (i - 1) * 120 + 60
            self.__nodes[i] = attach(self, New(class["hitter"], self,
                    cos(a) * 130, sin(a) * 130, {
                        r = 255, g = 200, b = 140, size = 1.05, grow = 45,
                        a = 20, b = 20, sway = 0.8, ph = i * 120,
                    }))
        end
        task.New(self, function()
            while true do
                task.MoveToPlayer(100, -60, 60, 96, 140, 20, 40, 16, 32,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        --底色帘（见 base() 的注释：每张卡都必须有这一层）
        base(self, { kind = "ring", col = 2, r = 255, g = 200, b = 140, layers = 7, n = 18, v0 = 1.7, v1 = 3.6, step = 4, gap = 34 })
        task.New(self, function()
            task.Wait(140)
            Newcharge_in(self.x, self.y, 255, 200, 150)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 255, 200, 150)
            while true do
                --当前这一步的节点：密集的星弹，另外两个安静
                for round = 1, 3 do
                    local nd = self.__nodes[self.__step]
                    if IsValid(nd) then
                        for k = 1, 24 do
                            local a = (k - 1) * 15 + round * 8
                            fly(star_small, 2, nd.x, nd.y, 1.8 + round * 0.3, a)._r = 255
                        end
                        PlaySound("tan00", 0.07, nd.x / 256, true)
                    end
                    task.Wait(34)
                end
                self.__step = self.__step % 3 + 1
                task.Wait(40)
            end
        end)
    end

    function card:render()
        --把「当前这一步」的节点圈出来
        if not self.__nodes then
            return
        end
        local nd = self.__nodes[self.__step or 1]
        if IsValid(nd) then
            arc(nd.x, nd.y, 52 + 8 * sin((self.ani or 0) * 6), 0, 360, 20,
                    160, 255, 220, 160, 0.07)
        end
    end
end

--============================
--[3-5] 鬼符「怪力乱神」
--  约束：星阵 + 从星阵拉出的四条链
--  弹幕：星形的弹（沿星形线排）
--============================
do
    local card = boss.card.New("鬼符「怪力乱神」", 1, 1, 60, 1050)
    boss.card.add({ { card, "3a" } }, 26, "鬼符「怪力乱神」", 310)

    function card:before()
        attach(self, New(class["starring"], self, { n = 5, r0 = 60, r1 = 160,
                spin = 2.0, beat = 20, v = 2.8 }))
        task.New(self, function()
            task.MoveTo(0, 112, 60, VALUE_SET.DECEL)
            while true do
                task.MoveToPlayer(120, -90, 90, 96, 150, 24, 48, 18, 36,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        --星形弹：沿五角星的线排（不是圆）
        task.New(self, function()
            task.Wait(140)
            Newcharge_in(self.x, self.y, 255, 200, 150)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 255, 200, 150)
            while true do
                local rot = ran:Float(0, 360)
                local R = 150
                for k = 1, 30 do
                    local t = k / 30 * 5
                    local a = rot + t * 144
                    local r = R * (1 - (t % 1) * 0.6)
                    fly(star_small, 2, self.x + cos(a) * r, self.y + sin(a) * r,
                            2.2, a)._r = 255
                    task.Wait(1)
                end
                PlaySound("tan00", 0.08, 0, true)
                task.Wait(70)
            end
        end)
        spiral_layer(self, { layers = 12, n = 10, v0 = 1.4, v1 = 2.4, turns = 2,
                gap = 46, r2 = 255, g2 = 220, b2 = 170, delay = 180 })
    end
end

--============================
--[4] 古明地觉 —— 读心。结构：第三只眼（瞄「你刚才在哪」）
--============================

--============================
--[4-1] 非符「読心」
--  结构：一只眼绕 boss 转，瞄的是自机 45 帧前的坐标
--============================
do
    local card = boss.card.New("", 1, 1, 60, 800)
    boss.card.add({ { card, "4a" } }, 26, "第一回合", 311)

    function card:before()
        attach(self, New(class["thirdeye"], self, { v = 2.6, n = 7, gap = 70, delay = 45 }))
        task.New(self, function()
            task.MoveTo(0, 112, 60, VALUE_SET.DECEL)
            while true do
                task.MoveToPlayer(100, -70, 70, 96, 140, 20, 40, 16, 32,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        ring_layer(self, { layers = 9, n = 12, v0 = 1.8, v1 = 2.6, gap = 85,
                col = 12, r = 226, g = 200, b = 255, delay = 120 })
    end
end

--============================
--[4-2] 非符「第三の眼」
--  结构：三只眼分三个角，逐个睁开
--============================
do
    local card = boss.card.New("", 1, 1, 60, 820)
    boss.card.add({ { card, "4a" } }, 26, "第一回合", 312)

    function card:before()
        self.__eyes = {}
        for i = 1, 3 do
            local a = (i - 1) * 120
            self.__eyes[i] = attach(self, New(class["hitter"], self,
                    cos(a) * 120, sin(a) * 120, {
                        r = 226, g = 200, b = 255, size = 1.2, grow = 50,
                        a = 22, b = 22, sway = 0.6, ph = i * 120,
                    }))
        end
        task.New(self, function()
            while true do
                task.MoveToPlayer(110, -80, 80, 96, 140, 22, 44, 16, 32,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        --底色帘（见 base() 的注释：每张卡都必须有这一层）
        base(self, { kind = "spiral", col = 6, r = 200, g = 170, b = 255, layers = 12, n = 15, v0 = 1.5, v1 = 3.5 })
        task.New(self, function()
            task.Wait(140)
            Newcharge_in(self.x, self.y, 226, 200, 255)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 226, 200, 255)
            while true do
                --三只眼逐个吐椭圆环
                for i = 1, 3 do
                    local e = self.__eyes[i]
                    if IsValid(e) then
                        for k = 1, 18 do
                            local a = (k - 1) * 20 + i * 12
                            fly(ellipse, 12, e.x, e.y, 2.0, a)._r = 226
                        end
                        PlaySound("tan00", 0.06, e.x / 256, true)
                    end
                    task.Wait(46)
                end
                task.Wait(60)
            end
        end)
    end
end

--============================
--[4-3] 想起「テリブルスーヴニール」
--  结构：眼 + 「读到的轨迹」可视化
--  弹幕：沿自机 45 帧前的轨迹撒（读心读的是你刚才在哪）
--============================
do
    local card = boss.card.New("想起「テリブルスーヴニール」", 1, 1, 60, 900)
    boss.card.add({ { card, "4a" } }, 26, "想起「テリブルスーヴニール」", 313)

    function card:before()
        attach(self, New(class["thirdeye"], self, { v = 3.0, n = 9, gap = 60, delay = 45 }))
        task.New(self, function()
            while true do
                task.MoveToPlayer(120, -80, 80, 90, 140, 22, 44, 16, 32,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        --底色帘（见 base() 的注释：每张卡都必须有这一层）
        base(self, { kind = "ring", col = 3, r = 220, g = 160, b = 255, layers = 6, n = 18, v0 = 1.6, v1 = 3.5 })
        self.__trace = {}
        task.New(self, function()
            while true do
                self.__trace[#self.__trace + 1] = { player.x, player.y }
                if #self.__trace > 50 then
                    table.remove(self.__trace, 1)
                end
                task.Wait()
            end
        end)
        task.New(self, function()
            task.Wait(140)
            Newcharge_in(self.x, self.y, 226, 190, 255)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 226, 190, 255)
            while true do
                --沿「45 帧前」的轨迹撒 —— 弹落在你背后，不是你脸上
                local tr = self.__trace or {}
                local back = max(1, #tr - 45)
                for i = 1, back, 4 do
                    local p = tr[i]
                    local a = ran:Float(0, 360)
                    fly(ball_mid, 12, p[1], p[2], 2.6, a)._r = 226
                end
                PlaySound("tan00", 0.06, 0, true)
                task.Wait(90)
            end
        end)
    end

    function card:render()
        local tr = self.__trace or {}
        for i = 2, #tr do
            thin_line(tr[i - 1][1], tr[i - 1][2], tr[i][1], tr[i][2],
                    50, 210, 170, 255, 0.06)
        end
    end
end

--============================
--[4-4] 想起「恋心マスタースパーク」
--  约束：一道自绘的粗光（有判定的版本用弹排）
--============================
do
    local card = boss.card.New("想起「恋心マスタースパーク」", 1, 1, 60, 950)
    boss.card.add({ { card, "4a" } }, 26, "想起「恋心マスタースパーク」", 314)

    function card:before()
        self.__brot = 0
        attach(self, New(class["th20_beam"], self))
        task.New(self, function()
            task.MoveTo(0, 112, 60, VALUE_SET.DECEL)
            while true do
                task.MoveToPlayer(110, -60, 60, 100, 140, 20, 40, 16, 32,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        spiral_layer(self, { layers = 12, n = 12, v0 = 1.6, v1 = 2.6, turns = 2,
                gap = 44, r2 = 255, g2 = 200, b2 = 240, delay = 150 })
    end
end

--============================
--[4-5] 想起「プリンセスウンディネ」
--  约束：无
--  弹幕：同心环层间速度差 + 水滴
--============================
do
    local card = boss.card.New("想起「プリンセスウンディネ」", 1, 1, 60, 1000)
    boss.card.add({ { card, "4a" } }, 26, "想起「プリンセスウンディネ」", 315)

    function card:before()
        task.New(self, function()
            while true do
                task.MoveToPlayer(100, -70, 70, 90, 140, 20, 44, 16, 32,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        ring_layer(self, { layers = 16, n = 15, v0 = 2.0, v1 = 3.0, gap = 65,
                col = 10, r = 180, g = 240, b = 255, delay = 100 })
        task.New(self, function()
            task.Wait(150)
            while true do
                for i = 1, 6 do
                    local a = (i - 1) * 60 + ran:Float(-10, 10)
                    fly(water_drop, 10, self.x, self.y, 2.4, a)._r = 180
                end
                task.Wait(90)
            end
        end)
    end
end

--============================
--[5] 火焰猫燐 —— 火车。结构：3 圈 × 6 节点格（照 SR 的 5746）
--============================

--============================
--[5-1] 非符「猫だまし」
--  约束：四角各一个节点，boss 在它们之间跳
--============================
do
    local card = boss.card.New("", 1, 1, 60, 820)
    boss.card.add({ { card, "5a" } }, 26, "第一回合", 316)

    function card:before()
        for i = 1, 4 do
            local a = (i - 1) * 90 + 45
            attach(self, New(class["hitter"], self, cos(a) * 120, sin(a) * 120, {
                r = 255, g = 178, b = 150, size = 0.9, grow = 40 + i * 4,
                a = 18, b = 18, sway = 1.2, ph = i * 90,
            }))
        end
        task.New(self, function()
            while true do
                task.MoveToPlayer(70, -80, 80, 90, 140, 20, 40, 16, 32,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        --底色帘（见 base() 的注释：每张卡都必须有这一层）
        base(self, { kind = "ring", col = 4, r = 255, g = 190, b = 190, layers = 6, n = 14, v0 = 1.5, v1 = 3.1, step = 4, gap = 44 })
        task.New(self, function()
            task.Wait(80)
            Newcharge_in(self.x, self.y, 255, 190, 150)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 255, 190, 150)
            while true do
                local a0 = Angle(self, player)
                for k = 1, 9 do
                    fly(butterfly, 10, self.x, self.y, 3.0,
                            a0 + (k - 5) * 9)._r = 255
                end
                PlaySound("tan00", 0.07, 0, true)
                task.Wait(72)
            end
        end)
    end
end

--============================
--[5-2] 非符「怨霊」
--  约束：无
--  弹幕：怨灵从下浮上 + 冻结环
--============================
do
    local card = boss.card.New("", 1, 1, 60, 800)
    boss.card.add({ { card, "5a" } }, 26, "第一回合", 317)

    function card:before()
        task.New(self, function()
            while true do
                task.MoveToPlayer(110, -70, 70, 96, 140, 22, 44, 16, 32,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        --底色帘
        base(self, { kind = "spiral", col = 6, r = 200, g = 170, b = 255, layers = 10, n = 14, v0 = 1.5, v1 = 3.5 })
        task.New(self, function()
            while true do
                for i = 1, 3 do
                    local x = ran:Float(-170, 170)
                    local b = fly(ball_light, 12, x, lstg.world.b - 20, 1.9, 90)
                    b._r, b._g, b._b = 200, 190, 255
                end
                task.Wait(38)
            end
        end)
        --⚠ 原来 steps=12×n=16 挤在 24 帧里，冻结在半径 110 上 →
        --  自机周围 60px 内平均 29 发（原版标准档是 5~14）。摊开、放少。
        freeze_layer(self, { steps = 7, n = 10, d0 = 140, w0 = 50, v = 3.6,
                delay = 130, rest = 250, col = 12, r = 200, g = 190, b = 255 })
    end
end

--============================
--[5-3] 猫符「キャットランページ」
--  结构：18 节点格（3 圈 × 6）
--============================
do
    local card = boss.card.New("猫符「キャットランページ」", 1, 1, 60, 950)
    boss.card.add({ { card, "5a" } }, 26, "猫符「キャットランページ」", 318)

    function card:before()
        attach(self, New(class["lattice"], self, { v = 2.6, gap = 90 }))
        task.New(self, function()
            task.MoveTo(0, 112, 60, VALUE_SET.DECEL)
            while true do
                task.MoveToPlayer(120, -90, 90, 96, 150, 24, 48, 18, 36,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        ring_layer(self, { layers = 8, n = 10, v0 = 2.0, v1 = 2.8, gap = 88,
                col = 10, r = 255, g = 200, b = 236, delay = 130 })
    end
end

--============================
--[5-4] 死符「ゴーストタウン」
--  约束：**每边只有一股流，那股流沿着边来回扫** —— 缝就是另外三条边。
--  亡魂从四边飘进来，落脚点在边上滑动，玩家绕着四股流走。
--  ⚠ 我前两版都写错了方向：
--    · 第一版：四边各 14 发 = **一堵墙**，只留一个旋转的门 →
--      「限位层」，AGENTS.md §7.1/§7.8 明令禁止，死局 4.5%；
--    · 第二版：四边各 5 股 + 旋转楔形 → 20 个股，缝只剩 30 px，死局 70%。
--    正确的做法是**让流本身稀疏**：每股是一条连续的线，四条线之间的空隙
--    就是通路 —— 约束是图案的副产品，不是外加的一层。
--============================
do
    local card = boss.card.New("死符「ゴーストタウン」", 1, 1, 60, 1000)
    boss.card.add({ { card, "5a" } }, 26, "死符「ゴーストタウン」", 319)

    function card:before()
        task.New(self, function()
            while true do
                task.MoveToPlayer(100, -70, 70, 90, 140, 20, 40, 16, 32,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        --底色帘：轻的一层，别和卡自己的四股流叠成墙
        base(self, { kind = "ring", col = 6, r = 190, g = 190, b = 255,
                layers = 6, n = 14, v0 = 1.4, v1 = 3.2, step = 5, gap = 55 })
        task.New(self, function()
            task.Wait(90)
            Newcharge_in(self.x, self.y, 200, 190, 255)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 200, 190, 255)
            while true do
                local w = lstg.world
                --四个落脚点，每条边一个；每轮换方向、换起点（不显脏）
                local ph = ran:Float(0, 1)
                local dir = ran:Sign()
                for t = 0, 119 do
                    --0→1→0 来回扫（三角波）：四条流一起荡
                    local u = (ph + dir * t / 130) % 2
                    if u > 1 then u = 2 - u end
                    for side = 1, 4 do
                        --每条边的相位错开 1/4，于是四条流是**错位**的
                        local f = (u + (side - 1) * 0.25) % 1
                        local x, y, a
                        if side == 1 then
                            x, y, a = w.l - 20, w.b + (w.t - w.b) * f, 0
                        elseif side == 2 then
                            x, y, a = w.r + 20, w.b + (w.t - w.b) * f, 180
                        elseif side == 3 then
                            x, y, a = w.l + (w.r - w.l) * f, w.b - 20, 90
                        else
                            x, y, a = w.l + (w.r - w.l) * f, w.t + 20, -90
                        end
                        --⚠ 每股流是**一串连续的弹**：弹与弹的间隔 = v × 帧距。
                        --  原来 v=1.9 / 每 3 帧 → 间隔 5.7 px，比弹还小 →
                        --  这一股就是一条**过不去的活动墙**，四股一扫就把自机夹死（死局 19%）。
                        --  拉到 18 px 间隔，玩家能从弹与弹之间钻过去。
                        fly(ball_light, 12, x, y, 3.0, a)._r = 190
                    end
                    task.Wait(6)
                end
                task.Wait(45)
            end
        end)
    end
end

--============================
--[5-5] 火車「死体ツアー」
--  结构：一节「车厢」= 一排节点，横穿屏幕
--============================
do
    local CARS, CAR_GAP, PER_CAR = 3, 130, 5
    local CYCLE = 420
    local card = boss.card.New("火車「死体ツアー」", 1, 1, 60, 1100)
    boss.card.add({ { card, "5a" } }, 26, "火車「死体ツアー」", 320)

    function card:before()
        task.New(self, function()
            task.MoveTo(0, 112, 60, VALUE_SET.DECEL)
            while true do
                task.MoveToPlayer(130, -90, 90, 96, 150, 24, 48, 18, 36,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        --底色帘（见 base() 的注释：每张卡都必须有这一层）
        base(self, { kind = "spiral", col = 2, r = 255, g = 178, b = 130, layers = 12, n = 14, v0 = 1.6, v1 = 3.6 })
        --火车：每节车厢 = 5 个节点排一竖列，整列从右往左走
        task.New(self, function()
            task.Wait(90)
            while true do
                local cars = {}
                for c = 1, CARS do
                    local row = {}
                    for i = 1, PER_CAR do
                        local nd = New(class["hitter"], self, 0, 0, {
                            r = 255, g = 178, b = 130, size = 0.75, grow = 1,
                            a = 15, b = 15,
                        })
                        nd.sc = 1
                        nd.yy = -140 + 70 * (i - 1)
                        nd.free = true       -- 不跟 boss，自己走（见 hitter.frame）
                        row[i] = nd
                    end
                    cars[c] = row
                end
                for k = 0, 200 do
                    local x = 260 - 2.6 * k
                    for c = 1, CARS do
                        for i = 1, PER_CAR do
                            local nd = cars[c][i]
                            if IsValid(nd) then
                                nd.xx = x - (c - 1) * CAR_GAP
                                nd.x, nd.y = nd.xx, nd.yy
                            end
                        end
                    end
                    task.Wait(2)
                end
                for c = 1, CARS do
                    for i = 1, PER_CAR do
                        if IsValid(cars[c][i]) then
                            object.RawDel(cars[c][i])
                        end
                    end
                end
                task.Wait(CYCLE)
            end
        end)
        ring_layer(self, { layers = 8, n = 10, v0 = 2.2, v1 = 3.0, gap = 92,
                col = 2, r = 255, g = 200, b = 160, delay = 140 })
    end
end

--============================
--[6] 灵乌路火 —— 核融合。结构：Nuclear 双层球
--============================

--============================
--[6-1] 非符「核熱」
--  结构：两颗核融合球绕 boss 公转
--============================
do
    local card = boss.card.New("", 1, 1, 60, 850)
    boss.card.add({ { card, "6a" } }, 26, "第一回合", 321)

    function card:before()
        attach(self, New(class["nuclear"], self, { a = 0, d = 110, spin = 0.8 }))
        attach(self, New(class["nuclear"], self, { a = 180, d = 110, spin = 0.8 }))
        task.New(self, function()
            task.MoveTo(0, 112, 60, VALUE_SET.DECEL)
            while true do
                task.MoveToPlayer(110, -70, 70, 96, 140, 22, 44, 16, 32,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        ring_layer(self, { layers = 10, n = 14, v0 = 2.2, v1 = 3.0, gap = 78,
                col = 2, r = 255, g = 200, b = 120, delay = 110 })
    end
end

--============================
--[6-2] 非符「八咫烏」
--  结构：三条「腿」= 三个节点，绕 boss 公转
--============================
do
    local card = boss.card.New("", 1, 1, 60, 830)
    boss.card.add({ { card, "6a" } }, 26, "第一回合", 322)

    function card:before()
        attach(self, New(class["starring"], self, { n = 3, r0 = 70, r1 = 170,
                spin = 1.0, beat = 22, v = 2.6 }))
        task.New(self, function()
            task.MoveTo(0, 112, 60, VALUE_SET.DECEL)
            while true do
                task.MoveToPlayer(120, -80, 80, 96, 140, 22, 44, 16, 32,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        spiral_layer(self, { layers = 10, n = 10, v0 = 1.6, v1 = 2.8, turns = 2,
                step = 11, gap = 70, r2 = 255, g2 = 210, b2 = 140, delay = 140 })
    end
end

--============================
--[6-3] 爆符「ギガフレア」
--  约束：无（核融合球本身会撞人）
--  弹幕：大玉 + 冻结环
--============================
do
    local card = boss.card.New("爆符「ギガフレア」", 1, 1, 60, 1000)
    boss.card.add({ { card, "6a" } }, 26, "爆符「ギガフレア」", 323)

    function card:before()
        attach(self, New(class["nuclear"], self, { a = 0, d = 90, spin = 1.2 }))
        attach(self, New(class["nuclear"], self, { a = 120, d = 90, spin = 1.2 }))
        attach(self, New(class["nuclear"], self, { a = 240, d = 90, spin = 1.2 }))
        task.New(self, function()
            task.MoveTo(0, 112, 60, VALUE_SET.DECEL)
            while true do
                task.MoveToPlayer(130, -90, 90, 90, 150, 24, 52, 18, 36,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        freeze_layer(self, { steps = 18, n = 18, d0 = 130, w0 = 36, v = 4.6,
                delay = 120, rest = 280, col = 2, r = 255, g = 190, b = 100 })
        ring_layer(self, { layers = 8, n = 10, v0 = 2.4, v1 = 3.2, gap = 100,
                col = 2, r = 255, g = 210, b = 130, delay = 150 })
    end
end

--============================
--[6-4] 焔星「十凶星」
--  结构：10 个节点绕 boss 公转
--============================
do
    local card = boss.card.New("焔星「十凶星」", 1, 1, 60, 1100)
    boss.card.add({ { card, "6a" } }, 26, "焔星「十凶星」", 324)

    function card:before()
        attach(self, New(class["starring"], self, { n = 10, r0 = 90, r1 = 175,
                spin = 0.7, beat = 18, v = 2.8 }))
        task.New(self, function()
            task.MoveTo(0, 112, 60, VALUE_SET.DECEL)
            while true do
                task.MoveToPlayer(120, -80, 80, 96, 150, 22, 48, 18, 36,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        ring_layer(self, { layers = 12, n = 14, v0 = 2.0, v1 = 3.0, gap = 72,
                col = 2, r = 255, g = 196, b = 120, delay = 130 })
    end
end

--============================
--[6-5] 地獄「地獄の人工太陽」
--  结构：中心的巨大核（钉在场地中心）
--  弹幕：由外向内的壁（子弹从边界朝内飞）+ 核本身会撞人
--============================
do
    local RAYS = 26
    local V = 1.15
    local GAP = 26
    local CYCLE = 1500
    local card = boss.card.New("地獄「地獄の人工太陽」", 1, 1, 60, 1200)
    boss.card.add({ { card, "6a" } }, 26, "地獄「地獄の人工太陽」", 325)

    function card:before()
        --太阳钉在场地中心（不跟 boss），boss 在旁边飘
        self.__sun = New(class["th20_sun"], self)
        task.New(self, function()
            task.MoveTo(0, 130, 60, VALUE_SET.DECEL)
            while true do
                task.MoveToPlayer(140, -110, 110, 70, 150, 28, 56, 20, 40,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        --由外向内的壁：沿矩形边界生成，朝内飞
        task.New(self, function()
            task.Wait(240)
            while true do
                for k = 1, RAYS do
                    local s = (k - 1) / RAYS
                    local px, py
                    --沿 ±220/±252 的矩形边界
                    if s < 0.25 then
                        px, py = -220 + 8 * 220 * s, 252
                    elseif s < 0.5 then
                        px, py = 220, 252 - 8 * 252 * (s - 0.25)
                    elseif s < 0.75 then
                        px, py = 220 - 8 * 220 * (s - 0.5), -252
                    else
                        px, py = -220, -252 + 8 * 252 * (s - 0.75)
                    end
                    fly(ball_small, 4, px, py, V, Angle(0, 0, px, py) + 180)._r = 255
                end
                PlaySound("tan00", 0.05, 0, true)
                task.Wait(GAP)
            end
        end)
        ring_layer(self, { layers = 10, n = 12, v0 = 2.2, v1 = 3.0, gap = 88,
                col = 2, r = 255, g = 200, b = 120, delay = 200 })
    end
end

--============================
--[7] 古明地恋 —— 无意识。结构：玫瑰阵
--============================

--============================
--[7-1] 非符「無意識」
--  约束：无（弹从随机位置出现，逼你一直动）
--============================
do
    local card = boss.card.New("", 1, 1, 60, 850)
    boss.card.add({ { card, "7a" } }, 26, "第一回合", 326)

    function card:before()
        task.New(self, function()
            task.MoveTo(0, 112, 60, VALUE_SET.DECEL)
            while true do
                task.MoveToPlayer(120, -90, 90, 96, 150, 22, 48, 18, 36,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        --底色帘（见 base() 的注释：每张卡都必须有这一层）
        base(self, { kind = "ring", col = 7, r = 235, g = 170, b = 255, layers = 6, n = 16, v0 = 1.7, v1 = 3.4 })
        task.New(self, function()
            task.Wait(70)
            Newcharge_in(self.x, self.y, 220, 170, 255)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 220, 170, 255)
            while true do
                for i = 1, 4 do
                    local px = ran:Float(lstg.world.l + 20, lstg.world.r - 20)
                    local py = ran:Float(lstg.world.b + 20, lstg.world.t - 20)
                    local a = ran:Float(0, 360)
                    --先亮一个点再起飞（预警）
                    local mark = New(class["th20_mark"], px, py)
                    task.New(mark, function()
                        task.Wait(36)
                        fly(heart, 12, px, py, 3.0, a)._r = 230
                        object.RawDel(mark)
                    end)
                end
                task.Wait(46)
            end
        end)
    end
end

--============================
--[7-2] 非符「薔薇」
--  约束：无
--  弹幕：玫瑰阵 8 瓣张缩 + 心弹
--============================
do
    local card = boss.card.New("", 1, 1, 60, 820)
    boss.card.add({ { card, "7a" } }, 26, "第一回合", 327)

    function card:before()
        attach(self, New(class["rose"], self, { n = 8, r0 = 40, r1 = 155,
                period = 170 }))
        task.New(self, function()
            task.MoveTo(0, 112, 60, VALUE_SET.DECEL)
            while true do
                task.MoveToPlayer(110, -70, 70, 96, 140, 22, 44, 16, 32,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        ring_layer(self, { layers = 9, n = 11, v0 = 2.0, v1 = 2.8, gap = 84,
                col = 12, r = 220, g = 170, b = 255, delay = 120 })
    end
end

--============================
--[7-3] 本能「フロウディアン」
--  约束：玫瑰阵张缩
--  弹幕：双螺旋（正反两股）
--============================
do
    local card = boss.card.New("本能「フロウディアン」", 1, 1, 60, 950)
    boss.card.add({ { card, "7a" } }, 26, "本能「フロウディアン」", 328)

    function card:before()
        attach(self, New(class["rose"], self, { n = 10, r0 = 50, r1 = 175,
                period = 200 }))
        task.New(self, function()
            task.MoveTo(0, 112, 60, VALUE_SET.DECEL)
            while true do
                task.MoveToPlayer(120, -80, 80, 96, 150, 22, 48, 18, 36,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        spiral_layer(self, { layers = 16, n = 12, v0 = 1.5, v1 = 2.6, turns = 3,
                gap = 44, r2 = 235, g2 = 170, b2 = 255, delay = 140 })
    end
end

--============================
--[7-4] 抑制「スーパーエゴ」
--  约束：一圈「玫瑰环」节点，边转边张缩
--============================
do
    local card = boss.card.New("抑制「スーパーエゴ」", 1, 1, 60, 1050)
    boss.card.add({ { card, "7a" } }, 26, "抑制「スーパーエゴ」", 329)

    function card:before()
        self.__ring = {}
        for i = 1, 12 do
            local a = (i - 1) * 30
            self.__ring[i] = attach(self, New(class["hitter"], self,
                    cos(a) * 130, sin(a) * 130, {
                        r = 220, g = 170, b = 255, size = 0.85, grow = 42 + i * 2,
                        a = 16, b = 16,
                    }))
        end
        task.New(self, function()
            while true do
                task.MoveToPlayer(110, -70, 70, 90, 140, 20, 40, 16, 32,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        --底色帘（见 base() 的注释：每张卡都必须有这一层）
        base(self, { kind = "ring", col = 5, r = 210, g = 200, b = 255, layers = 6, n = 14, v0 = 1.5, v1 = 3.1, step = 4, gap = 44 })
        task.New(self, function()
            task.Wait(120)
            Newcharge_in(self.x, self.y, 220, 170, 255)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 220, 170, 255)
            while true do
                local turn = ran:Float(0, 360)
                for k = 0, 40 do
                    local ph = k / 40
                    local r = 60 + 110 * (0.5 + 0.5 * sin(ph * 180))
                    for i = 1, 12 do
                        local nd = self.__ring[i]
                        if IsValid(nd) then
                            local a = turn + (i - 1) * 30 + k * 2
                            nd.xx, nd.yy = cos(a) * r, sin(a) * r
                        end
                    end
                    if k % 8 == 0 then
                        for i = 1, 12 do
                            local nd = self.__ring[i]
                            if IsValid(nd) then
                                fly(heart, 12, nd.x, nd.y, 2.2,
                                        Angle(self, nd) + 180)._r = 235
                            end
                        end
                    end
                    task.Wait(4)
                end
            end
        end)
    end
end

--============================
--[7-5] 「サブタレイニアンローズ」 —— 终符
--  约束：三层玫瑰阵（不同转速/半径/个数 —— 不显脏规则第 2 条）
--  弹幕：血量驱动 3 阶段
--============================
do
    local CARD_HP = 1400
    local card = boss.card.New("「サブタレイニアンローズ」", 1, 1, 60, CARD_HP)
    boss.card.add({ { card, "7a" } }, 26, "「サブタレイニアンローズ」", 330)

    function card:before()
        --三层：个数、半径、角速度**三项都不同** → 相对相位一直漂，不会看出重复
        attach(self, New(class["rose"], self, { n = 6, r0 = 40, r1 = 100,
                period = 150 }))
        attach(self, New(class["rose"], self, { n = 10, r0 = 90, r1 = 160,
                period = 190 }))
        attach(self, New(class["rose"], self, { n = 14, r0 = 140, r1 = 220,
                period = 230 }))
        task.New(self, function()
            task.MoveTo(0, 112, 60, VALUE_SET.DECEL)
            while true do
                task.MoveToPlayer(120, -90, 90, 96, 150, 22, 48, 18, 36,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        self.__phase = 1
        ring_layer(self, { layers = 10, n = 12, v0 = 2.0, v1 = 2.8, gap = 80,
                col = 12, r = 235, g = 170, b = 255, delay = 130 })
        --阶段 2：加双螺旋
        task.New(self, function()
            task.Wait(60 * 18)
            self.__phase = max(self.__phase or 1, 2)
        end)
        spiral_layer(self, { layers = 14, n = 12, v0 = 1.6, v1 = 2.6, turns = 3,
                gap = 46, r2 = 200, g2 = 150, b2 = 255, delay = 60 * 18 })
        --阶段 3：加冻结核
        task.New(self, function()
            task.Wait(60 * 34)
            self.__phase = max(self.__phase or 1, 3)
        end)
        freeze_layer(self, { steps = 14, n = 16, d0 = 120, w0 = 44, v = 4.0,
                delay = 60 * 34, rest = 260, col = 12, r = 220, g = 160, b = 255 })
        --阶段阈值必须在血量之内
        local sys = self._bosssys
        if sys and sys.addAutoSPPoint then
            sys:addAutoSPPoint(int(CARD_HP * 0.30), 60 * 18, true)
            sys:addAutoSPPoint(int(CARD_HP * 0.60), 60 * 34, true)
        end
    end
end

--============================
--下面这些是各张卡共用的自绘 / 运动小类
--  一律 `bound = false`：必须在 frame 里自己 RawDel
--============================

---道中飘的火星（无判定）
class["th20_emberbg"] = Class(object, {
    init = function(self)
        local w = lstg.world
        self.x = ran:Float(w.l, w.r)
        self.y = w.b - 20
        self.v = ran:Float(0.5, 1.6)
        self.s = ran:Float(0.15, 0.45)
        self.a = ran:Float(120, 220)
        self.sway = ran:Float(6, 26)
        self.ph = ran:Float(0, 360)
        self.t = 0
        self.group, self.layer = GROUP.GHOST, LAYER.TOP
        self.bound, self.colli = false, false
    end,
    frame = function(self)
        self.t = self.t + 1
        self.y = self.y + self.v
        if self.y > lstg.world.t + 30 then
            object.RawDel(self)
        end
    end,
    render = function(self)
        local x = self.x + sin(self.t * 1.4 + self.ph) * self.sway * 0.2
        local k = min(1, min(self.t / 20, (lstg.world.t + 30 - self.y) / 40))
        draw_petal(x, self.y, self.t * 3 + self.ph, self.s, self.a * k, 255, 176, 96)
    end,
}, true)

---上方的土尘带（山女卡 1-2 的装饰）
class["th20_dust"] = Class(object, {
    init = function(self, master)
        self.master = master
        self.t = 0
        self.group, self.layer = GROUP.GHOST, LAYER.TOP
        self.bound, self.colli = false, false
        if IsValid(master) then
            object.Connect(master, self, 0, true)
        end
    end,
    frame = function(self)
        self.t = self.t + 1
        if not IsValid(self.master) then
            object.RawDel(self)
            return
        end
    end,
    render = function(self)
        local w = lstg.world
        for i = 1, 14 do
            local a = self.t * 7 + (i - 1) * 360 / 14
            local x = cos(a) * 180
            local y = w.t - 30 + sin(a) * 26
            draw_petal(x, y, a, 0.18, 90, 200, 168, 130)
        end
    end,
}, true)

---镜面（帕露西的主题装饰）：竖在场地正中，一直画着
class["th20_mirror"] = Class(object, {
    init = function(self, master)
        self.master = master
        self.t = 0
        self.group, self.layer = GROUP.GHOST, LAYER.TOP
        self.bound, self.colli = false, false
        if IsValid(master) then
            object.Connect(master, self, 0, true)
        end
    end,
    frame = function(self)
        self.t = self.t + 1
        if not IsValid(self.master) then
            object.RawDel(self)
            return
        end
    end,
    render = function(self)
        local a = 40 + 20 * sin(self.t * 1.5)
        SetImageState("white", "mul+add", a, 140, 255, 200)
        RenderRect("white", -2, 2, -230, 230)
    end,
}, true)

---粗光束（觉的 4-4）：自绘两条对向的光 + 有判定的核心
class["th20_beam"] = Class(object, {
    init = function(self, master)
        self.master = master
        self.t = 0
        self.rot = 0
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 40
        self.bound, self.colli = false, false
        if IsValid(master) then
            object.Connect(master, self, 0, true)
        end
    end,
    frame = function(self)
        self.t = self.t + 1
        if not IsValid(self.master) then
            object.RawDel(self)
            return
        end
        self.x, self.y = self.master.x, self.master.y
        --前 90 帧只画预警，之后才转
        if self.t < 90 then
            return
        end
        self.rot = self.rot + 0.9
        if (self.t - 90) % 3 == 1 then
            for k = 0, 1 do
                local a = self.rot + k * 180
                for i = 1, 22 do
                    local f = i / 22
                    local rr = 300 * f
                    fly(knife, 4, cos(a) * rr, sin(a) * rr, 4.5 + 3.0 * f, a)._r = 255
                end
            end
        end
    end,
    render = function(self)
        local a
        if self.t < 90 then
            a = 40 + 160 * (self.t / 90)
        else
            a = 170
        end
        for k = 0, 1 do
            local base = self.rot + k * 180
            thin_line(0, 0, cos(base) * 300, sin(base) * 300, a * 0.5, 255, 200, 240, 0.06)
        end
    end,
}, true)

---钉在场地中心的太阳（空的 6-5）
class["th20_sun"] = Class(object, {
    init = function(self, master)
        self.master = master
        self.t = 0
        self.rot = 0
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 40
        self.bound, self.colli = false, false
        if IsValid(master) then
            object.Connect(master, self, 0, true)
        end
    end,
    frame = function(self)
        self.t = self.t + 1
        if not IsValid(self.master) then
            object.RawDel(self)
            return
        end
        --钉在场地正中（画面画在 0,0，就不该跟着 boss 跑）
        self.x, self.y = 0, 0
        self.rot = (self.rot + 0.5) % 360
    end,
    render = function(self)
        local pulse = 1 + 0.08 * sin(self.t * 4)
        draw_orb(0, 0, 1.1 * pulse, 1, 255, 210, 130)
        for j = 1, 3 do
            local rr = 150 + j * 55
            arc(0, 0, rr, 0, 360, 44, 40, 255, 180, 110, 0.05)
            local a = self.t * (0.8 + j * 0.3)
            draw_orb(cos(a) * rr, sin(a) * rr, 0.15, 0.8, 255, 220, 160)
        end
    end,
}, true)

---「无意识」的预警点（恋的 7-1）：先亮一下再起飞
class["th20_mark"] = Class(object, {
    init = function(self, x, y)
        self.x, self.y = x, y
        self.t = 0
        self.group, self.layer = GROUP.GHOST, LAYER.TOP
        self.bound, self.colli = false, false
    end,
    frame = function(self)
        self.t = self.t + 1
        if self.t > 60 then
            object.RawDel(self)
        end
    end,
    render = function(self)
        local k = min(self.t / 36, 1)
        draw_orb(self.x, self.y, 0.12 + 0.12 * k, k, 230, 190, 255)
        arc(self.x, self.y, 30 * (1 - k) + 6, 0, 360, 14, 180 * k, 230, 190, 255, 0.06)
    end,
}, true)
