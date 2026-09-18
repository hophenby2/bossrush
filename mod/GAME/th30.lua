---=====================================
---TH30  冥府：西行寺幽幽子 · 第三版
---  （按《什么是好的弹设.md》重写；主题锚点见下面的「主题词汇表」）
---
---  为什么要重写：第一、二版是按「限位层 = 带缺口的墙」写的 —— 那是**被否定的**
---  做法（AGENTS.md §7.1：没有「限位层」这个东西），而且直接夹 `player.x/y`。
---  第一版的十张卡实测（`tools/threat.lua`）：
---    3.66 / 0.89 / 1.38 / 3.24 / 5.22 / 0.62 / 4.56 / 1.20 / 9.37 / 2.59
---    10 张里 6 张威胁度超标；#9 同时有 **6 组**威胁（文档上限 2）= 墙；
---    #8 的限位完全没有（安全区 0 px 移动）。
---
---  这一版按文档的框架重来：
---   · 一张卡 = **1 个限位组 + 1~2 个威胁组**，判定的东西只有这两样。
---       限位（§四）：用子弹的位置/疏密/速度分布，让安全区**周期性出现**，
---                     或成一个**随时间收缩**的单一安全区。
---       威胁（§一）：对安全区内的自机**有实际躲避要求**的子弹。
---   · 文档 §六：弹幕要符合**符卡锚点** —— 从**子弹类型**和**子弹形成的形状**
---     两个方向契合。所以每种元素配一种弹样式：
---       蝶 → `butterfly`（8 色）   樱 → `sakura`（`cherry_bullet`，th07 的幽幽子自己就用它）
---       扇 → `knife`（扇骨）+ `fan.png` 自绘扇   死/幽 → `knife`、`grain_*`   亡灵 → `ball_light`
---   · 规范（§五）：总威胁度 **0.5~1.5**，同时作用威胁组数 **1~2**。两个数实测：
---
---     #1 1.17  #2 0.73  #3 0.64  #4 0.61  #5 0.79
---     #6 1.15  #7 0.70  #8 0.59  #9 1.36  #10 1.27      ← 十张全部在区间内
---
---  回收规则：NewSimpleBullet 造的弹引擎自己收；自己 Class(object, ...) 造的
---  只要把 bound 关掉了（装饰蝶/花瓣就是），就必须在 frame 里自己 RawDel。
---  ⚠ 自定义速度**不要叫 `vx`/`vy`** —— 引擎每帧会替所有对象做 `x += vx`、`y += vy`，
---    再自己算一遍就是两倍；方向相反时正好抵消，物件永远停在原地（这版踩过）。
---=====================================

local class = {}
_editor_class["TH30"] = class

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

class["SCBG1"] = Class(_SC_BG)
class["SCBG1"].init = function(self)
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th04_0", true, 0, 0, 0, 0, -0.05, 0, "", 1, 1, function(l)
        --符卡背景：一层偏绯红的暮色
        l.r, l.g, l.b = 236, 138, 150
    end)
end

boss.Define("1a", "西行寺幽幽子", "TH04_0", TH04_bg, { 0, 300 }, class["SCBG1"], "Yuyuko", 28)

--============================
--公用小工具（自绘，不生成对象 → 没有判定）
--============================

local function thin_line(x1, y1, x2, y2, a, r, g, b, w)
    local len = Dist(x1, y1, x2, y2)
    if a <= 0 or len < 1 then
        return
    end
    SetImageState("white", "mul+add", a, r, g, b)
    Render("white", (x1 + x2) * 0.5, (y1 + y2) * 0.5, Angle(x1, y1, x2, y2), len / 16, w or 0.2)
end

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

local function draw_petal(x, y, rot, size, a, r, g, b)
    if a <= 0 or size <= 0 then
        return
    end
    SetImageState("ellipse6", "mul+add", a, r, g, b)
    Render("ellipse6", x, y, rot, size * 1.55, size)
end

local function draw_butterfly(x, y, rot, size, a, flap, col)
    if a <= 0 then
        return
    end
    local img = "butterfly" .. (Forbid(col or 2, 1, 8))
    local k = 0.55 + 0.45 * abs(sin(flap))
    SetImageState(img, "mul+add", a, 255, 200, 236)
    Render(img, x, y, rot, size * 2.2, size * 2.2 * k)
end

---一只扇（自绘，`fan.png`，没有判定）—— 蝶/扇是幽幽子的母题，纯装饰
local function draw_fan(x, y, rot, size, a, r, g, b)
    if a <= 0 or size <= 0 then
        return
    end
    SetImageState("fan", "mul+add", a, r, g, b)
    Render("fan", x, y, rot, size, size)
end

---出膛即走的一发弹
local function fly(style, col, x, y, v, a, omiga)
    local o = NewSimpleBullet(style, col, x, y, v, a, false, omiga or 0, false)
    return o
end

---自机狙：`a` 是**相对自机方向**的偏角（引擎里 aim=true 会加上 Angle(self,player)）
local function fly_aim(style, col, x, y, v, a, omiga)
    return NewSimpleBullet(style, col, x, y, v, a, true, omiga or 0, false)
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
        self.spd = ran:Float(0.5, 1.5)   -- 不叫 vy：见下面 th04_bfly 的注释
        self.sway = ran:Float(0, 360)
        self.sway_v = ran:Float(4, 13) * ran:Sign()
        self.size = ran:Float(0.35, 0.9)
        self.a = ran:Int(60, 150)
        self.k = 0
    end,
    frame = function(self)
        self.y = self.y + self.spd
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
--★★★★ 主题词汇表（《什么是好的弹设.md》§六：弹幕要符合符卡锚点 ——
--     从**子弹类型**和**子弹形成的形状**两个方向契合）
--   幽幽子 / 白玉楼的元素只有五样，每种元素配一种弹样式：
--     蝶    → `butterfly`（只有 8 色）
--     樱    → `sakura`（`cherry_bullet` 贴图，th07 的幽幽子自己就用它）/ `flower2`
--     扇    → `knife`（扇骨）+ `fan.png` 的自绘扇
--     死/幽 → `knife`（栅栏/刀刃）、`grain_*`
--     亡灵  → `ball_light`
--   ⚠ 上一版我把图案全换成了通用球弹（ball_mid/ball_small）的墙和环 ——
--     卡名写着蝶符/樱符，画面里却没有蝶、没有花瓣。那是只看了数字没看主题。
--============================

---蝶（自绘，无判定）——翅膀一开一合
local function draw_bfly(x, y, rot, size, a, flap, col)
    if a <= 0 or size <= 0 then
        return
    end
    local img = "butterfly" .. Forbid(col or 2, 1, 8)
    local k = 0.55 + 0.45 * abs(sin(flap))
    SetImageState(img, "mul+add", a, 255, 200, 236)
    Render(img, x, y, rot, size * 2.2, size * 2.2 * k)
end

---会飞会扇翅的蝶（装饰，自己回收）
class["th04_bfly"] = Class(object, {
    init = function(self, x, y, o)
        o = o or {}
        self.x, self.y = x, y
        --⚠ 别把自定义速度叫 `vy`：引擎每帧会替**所有**对象做 `y += vy`，
        --  自绘物件再自己算一遍就变成两倍（方向相反时正好抵消 —— 物件永远不动）。
        --  自定义速度一律用别的名字（AGENTS.md §9 B）。
        self.fall = o.fall or 2.2
        self.t = 0
        self.size = o.size or 0.40
        self.col = o.col or 2
        self.a = o.a or 140
        self.sway = ran:Float(0, 360)
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 6
        self.bound, self.colli = false, false
    end,
    frame = function(self)
        self.t = self.t + 1
        self.y = self.y - self.fall
        self.sway = self.sway + 5
        self.x = self.x + sin(self.sway) * 0.9
        if self.y < lstg.world.b - 30 or self.y > lstg.world.boundt + 30 then
            object.RawDel(self)
        end
    end,
    render = function(self)
        draw_bfly(self.x, self.y, 90 + sin(self.t * 3) * 18, self.size,
                self.a, self.t * 12, self.col)
    end,
}, true)

---绕着一个锚点公转的几把扇（装饰，无判定）—— 扇符那一张的门面
class["th04_fandeco"] = Class(object, {
    init = function(self, master, o)
        o = o or {}
        self.master = master
        self.t = 0
        self.n = o.n or 6
        self.r = o.r or 100
        self.spin = o.spin or 1.0
        self.size = o.size or 0.34
        self.a = o.a or 150
        self.cr, self.cg, self.cb = o.cr or 255, o.cg or 205, o.cb or 236
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET - 30
        self.bound, self.colli = false, false
        if IsValid(master) then
            object.Connect(master, self, 0, true)
        end
    end,
    frame = function(self)
        self.t = self.t + 1
        if not IsValid(self.master) then
            object.RawDel(self)
        end
    end,
    render = function(self)
        if not IsValid(self.master) then
            return
        end
        local mx, my = self.master.x, self.master.y
        for i = 1, self.n do
            local a = self.t * self.spin + (i - 1) * 360 / self.n
            draw_fan(mx + cos(a) * self.r, my + sin(a) * self.r,
                    a + 90, self.size, self.a, self.cr, self.cg, self.cb)
        end
    end,
}, true)

---会飘会转的花瓣（装饰，自己回收）
class["th04_petal"] = Class(object, {
    init = function(self, x, y, o)
        o = o or {}
        self.x, self.y = x, y
        self.fx = o.fx or ran:Float(-0.5, 0.5)
        self.fy = o.fy or ran:Float(0.8, 2.2)
        self.t = 0
        self.size = o.size or ran:Float(0.22, 0.5)
        self.spin = ran:Float(-4, 4)
        self.rot = ran:Float(0, 360)
        self.a = o.a or 150
        self.cr, self.cg, self.cb = o.r or 255, o.g or 190, o.b or 226
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 6
        self.bound, self.colli = false, false
    end,
    frame = function(self)
        self.t = self.t + 1
        self.x = self.x + self.fx + sin(self.t * 3) * 0.5
        self.y = self.y - self.fy
        self.rot = self.rot + self.spin
        if self.y < lstg.world.b - 30 or self.y > lstg.world.boundt + 30 then
            object.RawDel(self)
        end
    end,
    render = function(self)
        draw_petal(self.x, self.y, self.rot, self.size, self.a,
                self.cr, self.cg, self.cb)
    end,
}, true)

--============================
--★ 开场符卡专用：种子 / 巨藤 / 云层视差
--  云层不用真实判定弹：它是把自机“送上去再落下来”的演出层。
--  低层云慢、前景云团快，用 depth 做近大远小。
--============================
class["th30_cloud_cover"] = Class(object, {
    init = function(self)
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY - 40
        self.bound, self.colli = false, false
        self.speed, self.target_speed, self.alpha = 0, 0, 0
        self.clouds = {}
        local w = lstg.world
        for _ = 1, 26 do
            local depth = ran:Float(0.30, 0.80)
            table.insert(self.clouds, {
                x = ran:Float(w.l - 90, w.r + 90),
                y = ran:Float(w.b - 100, w.t + 100),
                depth = depth,
                size = 42 + depth * 68,
                sway = ran:Float(0, 360),
            })
        end
    end,
    frame = function(self)
        local w = lstg.world
        self.speed = self.speed + (self.target_speed - self.speed) * 0.06
        self.alpha = self.alpha + ((self.target_speed > 0 and 180 or 0) - self.alpha) * 0.05
        for _, c in ipairs(self.clouds) do
            c.y = c.y + self.speed * (0.35 + c.depth)
            c.x = c.x + sin(self.timer * 0.01 + c.sway) * 0.12
            if c.y - c.size > w.t + 120 then
                c.y = w.b - 60 - ran:Float(0, 140)
                c.x = ran:Float(w.l - 90, w.r + 90)
            end
        end
    end,
    render = function(self)
        for _, c in ipairs(self.clouds) do
            local a = self.alpha * (0.34 + c.depth * 0.45)
            SetImageState("ball_huge6", "add+alpha", int(a), 212, 206, 232)
            Render("ball_huge6", c.x, c.y, 0, c.size / 64, c.size / 96)
            SetImageState("ball_mid6", "add+alpha", int(a * 0.7), 238, 232, 250)
            Render("ball_mid6", c.x + c.size * 0.28, c.y + c.size * 0.12, 0,
                    c.size / 90, c.size / 120)
            Render("ball_mid6", c.x - c.size * 0.30, c.y - c.size * 0.08, 0,
                    c.size / 105, c.size / 140)
        end
    end,
}, true)

class["th30_cloud_puff"] = Class(object, {
    init = function(self, x, y, o)
        o = o or {}
        self.x, self.y = x, y
        self.depth = ran:Float(0.95, 1.80)
        self.rise = (o.speed or 8.0) * self.depth
        self.life = o.life or 420
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET - 20
        self.bound, self.colli = false, false
        self.puffs = {}
        for _ = 1, ran:Int(4, 6) do
            table.insert(self.puffs, {
                dx = ran:Float(-40, 40),
                dy = ran:Float(-14, 14),
                size = ran:Float(26, 54),
                sway = ran:Float(0, 360),
            })
        end
    end,
    frame = function(self)
        self.t = (self.t or 0) + 1
        self.y = self.y + self.rise
        self.x = self.x + sin(self.t * 0.04) * 0.4
        if self.y > lstg.world.t + 100 or self.life <= 0 then
            object.RawDel(self)
        end
        self.life = self.life - 1
    end,
    render = function(self)
        for _, p in ipairs(self.puffs) do
            SetImageState("ball_huge6", "add+alpha", 115, 240, 236, 252)
            Render("ball_huge6", self.x + p.dx, self.y + p.dy, 0,
                    p.size / 56, p.size / 84)
        end
    end,
}, true)

class["th30_seed"] = Class(object, {
    init = function(self, x, y)
        self.x, self.y = x, y
        self.t = 0
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY - 10
        self.bound, self.colli = false, false
    end,
    frame = function(self)
        self.t = self.t + 1
        self.y = self.y - 4.2
        self.x = self.x + sin(self.t * 0.14) * 0.6
        if self.y < lstg.world.b + 8 then
            object.RawDel(self)
        end
    end,
    render = function(self)
        SetImageState("ball_mid6", "mul+add", 200, 130, 240, 150)
        Render("ball_mid6", self.x, self.y, 0, 0.45, 0.65)
        SetImageState("ball_huge6", "add+alpha", 90, 190, 255, 180)
        Render("ball_huge6", self.x, self.y, 0, 0.55, 0.75)
    end,
}, true)

class["th30_vine"] = Class(object, {
    init = function(self, x)
        self.x = x
        self.t = 0
        self.growth = 0
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY - 20
        self.bound, self.colli = false, false
    end,
    frame = function(self)
        self.t = self.t + 1
        self.growth = min(1, self.growth + 1 / 90)
    end,
    render = function(self)
        local w = lstg.world
        local bottom = w.b - 10
        local top = bottom + (w.t - bottom + 90) * self.growth
        local segs = max(4, int((top - bottom) / 28))
        local py, px = bottom, self.x
        for i = 1, segs do
            local y = bottom + (top - bottom) * i / segs
            local x = self.x + sin(y * 0.012 + self.t * 0.025) * 14
            thin_line(px, py, x, y, 220, 74, 178, 104, 1.6)
            thin_line(px, py, x, y, 70, 38, 100, 58, 2.4)
            if i % 5 == 2 then
                draw_petal(x + 16, y, 35 + self.t * 0.2, 0.36, 180, 104, 214, 122)
                draw_petal(x - 16, y, 215 - self.t * 0.2, 0.30, 170, 82, 190, 104)
            end
            px, py = x, y
        end
        if self.growth >= 1 then
            SetImageState("ball_huge6", "add+alpha", 105, 150, 235, 160)
            Render("ball_huge6", px, py, 0, 1.35, 1.55)
        end
    end,
}, true)

--============================
--★★ 威胁组（《什么是好的弹设.md》§一、§五）
--============================

---【威胁】蝶弹偶数狙：`n` 路，扇面 `spread` 度，以自机方向为中心。
---  ⚠ 扇面必须收窄到 40~50°。铺满 360° 的偶数路，最近的一发离自机也有 180/n 度，
---    按 v=2.4 飞过去时自机早就挪开了 —— 实测被弹帧 0，那不是威胁。
local function threat_bfly_aim(self, o)
    task.New(self, function()
        task.Wait(o.delay or 90)
        local d = 1
        while true do
            local n = o.n or 4
            local spread = o.spread or 30
            local off = (o.tilt or 0) * d
            for i = 1, n do
                local a = off + ((i - 0.5) / n - 0.5) * spread
                local b = fly_aim(o.style or butterfly, o.col or 2, self.x, self.y,
                        o.v or 2.4, a)
                b._r, b._g, b._b = o.r or 255, o.g or 200, o.b or 236
            end
            PlaySound("tan00", 0.06, 0, true)
            task.Wait((o.gap or 60) + ran:Int(-6, 6))
            if o.flip ~= false then d = -d end
        end
    end)
end

---【威胁】泛狙 = 自机狙 + 一个小随机偏移（文档 §零），速度三档拉开层次。
local function threat_spray(self, o)
    task.New(self, function()
        task.Wait(o.delay or 110)
        while true do
            local n = o.n or 5
            local spread = o.spread or 52
            for k = 1, o.ways or 3 do
                for i = 1, n do
                    local a = ((i - 0.5) / n - 0.5) * spread + k * 5
                            + ran:Float(-(o.jitter or 6), (o.jitter or 6))
                    local b = fly_aim(o.style or sakura, o.col or 2, self.x, self.y,
                            (o.v0 or 1.8) + k * (o.dv or 0.7), a)
                    b._r, b._g, b._b = o.r or 255, o.g or 200, o.b or 226
                end
                task.Wait(o.step or 5)
            end
            task.Wait(o.gap or 50)
        end
    end)
end

--============================
--★★ 限位组（《什么是好的弹设.md》§四：安全区周期性出现 / 单调收缩）
--   每一条都**用这个主题自己的形状**把自机逼走，而不是外加一层墙。
--============================

---【限位·樱符】墨染之川：一条**花瓣**组成的川往下流，缝在川上来回扫。
---  「墨染」= 花瓣的颜色由白渐深、再淡回来。
local function flower_boat(self, o)
    task.New(self, function()
        task.Wait(o.delay or 70)
        local gapx = ran:Float(-110, 110)
        local d = (gapx < 0) and 1 or -1
        local ink = 0
        while true do
            local half = o.gapw or 64
            for rep = 1, o.reps or 26 do
                local w = lstg.world
                for i = 1, o.n or 15 do
                    local x = w.l + 6 + (w.r - w.l - 12) * (i - 1) / ((o.n or 15) - 1)
                    if abs(x - gapx) > half then
                        --墨染：颜色沿着川由浅入深
                        local b = fly(butterfly, o.col or 16, x, w.t + 14,
                                o.v or 2.3+ran:Float(-0.5, 0.5), -90+ran:Float(-11, 11))
                        local hue = ran:Float(o.hue_min or 270, o.hue_max or 330)
                        local saturation = ran:Float(o.s_min or 0.70, o.s_max or 1.0)
                        local lightness = ran:Float(o.l_min or 0.82, o.l_max or 0.94)
                        b._r, b._g, b._b = sp:HSLtoRGB(hue, saturation, lightness)
                    end
                end
                gapx = Forbid(gapx + d * (o.speed or 4.0), -140, 140)
                if gapx <= -140 or gapx >= 140 then d = -d end
                task.Wait(o.step or 3+ran:Int(-1,1))
                ink = ink + 1
            end
            task.Wait(o.rest or 30)
        end
    end)
end
---【限位·蝶符】胡蝶之栅：一排**蝶**横扫过去，缝在墙上、左右交替。
---  安全区 = 缝所在的竖条，周期性左→右→左。墙上另骑一排真蝶（自绘）。
local function limit_bfly_fence(self, o)
    task.New(self, function()
        task.Wait(o.delay or 70)
        local side = ran:Sign()
        while true do
            local w = lstg.world
            local n = o.n or 14
            local gapx = (o.gapx or 0.5) * side * (w.r - w.l) * 0.5
            local half = o.gapw or 62
            for i = 1, n do
                local x = w.l + 8 + (w.r - w.l - 16) * (i - 1) / (n - 1)
                if abs(x - gapx) > half then
                    local b = fly(butterfly, o.col or 2, x, w.t + 14, o.v or 2.4, -90)
                    b._r, b._g, b._b = o.r or 255, o.g or 200, o.b or 236
                end
            end
            -- 缝的两侧各放一只真蝶：玩家看得见「栅的门在哪」
            for k = -1, 1, 2 do
                New(class["th04_bfly"], gapx + k * (half + 16), w.t + 6,
                        { fall = o.v or 2.4, col = o.col or 2, size = 0.46, a = 150 })
            end
            PlaySound("tan00", 0.06, 0, true)
            task.Wait(o.gap or 76)
            if o.alternate ~= false then side = -side end
        end
    end)
end

---【限位·樱符】墨染之川：一条**花瓣**组成的川往下流，缝在川上来回扫。
---  「墨染」= 花瓣的颜色由白渐深、再淡回来。
local function limit_petal_river(self, o)
    task.New(self, function()
        task.Wait(o.delay or 70)
        local gapx = ran:Float(-110, 110)
        local d = (gapx < 0) and 1 or -1
        local ink = 0
        while true do
            local half = o.gapw or 64
            for rep = 1, o.reps or 26 do
                local w = lstg.world
                for i = 1, o.n or 15 do
                    local x = w.l + 6 + (w.r - w.l - 12) * (i - 1) / ((o.n or 15) - 1)
                    if abs(x - gapx) > half then
                        --墨染：颜色沿着川由浅入深
                        local col = 1 + int((ink + i * 2) % 16)
                        local b = fly(sakura, col, x, w.t + 14, o.v or 2.3, -90)
                        b._r, b._g, b._b = o.r or 255, o.g or 205, o.b or 232
                    end
                end
                gapx = Forbid(gapx + d * (o.speed or 4.0), -140, 140)
                if gapx <= -140 or gapx >= 140 then d = -d end
                task.Wait(o.step or 3)
                ink = ink + 1
            end
            task.Wait(o.rest or 30)
        end
    end)
end

---【限位·扇符】扇骨：`n` 把扇绕 boss 公转，吐弹时**沿着扇骨**（knife）射出去。
---  扇的朝向一轮转一截 → 骨与骨之间的缝（安全区）跟着转。
local function limit_fan_ribs(self, o)
    local n = o.n or 6
    local ang = {}
    for i = 1, n do ang[i] = (i - 1) * 360 / n end
    New(class["th04_fandeco"], self, { n = n, r = o.orbit or 100,
            spin = (o.spin or 1.0), a = 150, size = o.size or 0.34 })
    task.New(self, function()
        task.Wait(o.delay or 90)
        local dir = 1
        while true do
            for rib = 0, (o.ribs or 5) - 1 do
                for i = 1, n do
                    local base = ang[i] + (rib - 2) * (o.ribdeg or 11)
                    local b = fly(knife, o.col or 4,
                            self.x + cos(base) * 34, self.y + sin(base) * 34,
                            o.v or 2.2, base)
                    b._r, b._g, b._b = o.r or 255, o.g or 205, o.b or 236
                end
                task.Wait(o.step or 6)
            end
            for i = 1, n do ang[i] = ang[i] + dir * (o.turn or 32) end
            dir = -dir
            task.Wait(o.gap or 56)
        end
    end)
end

---【限位·死符】无寿之栏：两排竖直的**刀刃**从左右向内收，中间的缝越来越窄；
---  收到下限后重置 —— 文档 §四明写允许「仅存在一个随时间缩小的安全区」。
local function limit_death_bars(self, o)
    task.New(self, function()
        task.Wait(o.delay or 80)
        local hw = o.hwmax or 170
        while true do
            local w = lstg.world
            local n = o.n or 11
            for i = 1, n do
                local y = w.b + 10 + (w.t - w.b - 20) * (i - 1) / (n - 1)
                local b1 = fly(knife, o.col or 4, -hw, y, o.v or 2.2, 0)
                b1._r, b1._g, b1._b = o.r or 226, o.g or 190, o.b or 255
                local b2 = fly(knife, o.col or 4, hw, y, o.v or 2.2, 180)
                b2._r, b2._g, b2._b = o.r or 226, o.g or 190, o.b or 255
            end
            PlaySound("tan00", 0.05, 0, true)
            task.Wait(o.gap or 34)
            hw = hw - (o.step or 12)
            if hw < (o.hwmin or 60) then
                hw = o.hwmax or 170
                task.Wait(o.rest or 56)
            end
        end
    end)
end

---【限位·幽符】西行妖：一棵樱花树。五根枝条是**沿半径排成一线的 sakura**拼出来的，
---  整棵树缓慢左右转 → 枝与枝之间的缝跟着转；枝端不断落花。
local function limit_youkai_tree(self, o)
    task.New(self, function()
        task.Wait(o.delay or 90)
        local rot = ran:Float(0, 360)
        local dir = 1
        while true do
            for br = 1, o.branches or 5 do
                local ba = rot + (br - 1) * 72 + (br % 2) * 14
                local len = (o.len or 210) + (br % 3) * 24
                for i = 1, o.n or 12 do
                    local f = i / (o.n or 12)
                    local rr = len * f
                    local xx = cos(ba) * rr
                    local yy = sin(ba) * rr - (o.root or 180)
                    --花瓣沿枝条往外飘，同时往下掉（落花）
                    local b = fly(sakura, o.col or 2, xx, yy, o.v or 1.6,
                            ba + 90 * dir)
                    b._r, b._g, b._b = o.r or 255, o.g or 200, o.b or 230
                    if (br + i) % 3 == 0 then
                        New(class["th04_petal"], xx, yy,
                                { fy = 1.4, fx = 0, size = 0.34, a = 130 })
                    end
                end
                task.Wait(o.step or 7)
            end
            rot = rot + dir * (o.turn or 13)
            dir = -dir
            task.Wait(o.gap or 54)
        end
    end)
end

---【限位·灵符】亡灵之渡：四条边上各有一船亡灵，落脚点沿边滑动 ——
---  安全区是其余三条边。
local function limit_ghost_ferry(self, o)
    task.New(self, function()
        task.Wait(o.delay or 80)
        while true do
            local w = lstg.world
            local ph = ran:Float(0, 1)
            local dir = ran:Sign()
            for t = 0, o.reps or 110 do
                local u = (ph + dir * t / (o.reps or 110)) % 2
                if u > 1 then u = 2 - u end
                for side = 1, 4 do
                    local f = (u + (side - 1) * 0.25) % 1
                    local x, y, a
                    if side == 1 then
                        x, y, a = w.l - 18, w.b + (w.t - w.b) * f, 0
                    elseif side == 2 then
                        x, y, a = w.r + 18, w.b + (w.t - w.b) * f, 180
                    elseif side == 3 then
                        x, y, a = w.l + (w.r - w.l) * f, w.b - 18, 90
                    else
                        x, y, a = w.l + (w.r - w.l) * f, w.t + 18, -90
                    end
                    local b = fly(ball_light, o.col or 6, x, y, o.v or 2.5, a)
                    b._r, b._g, b._b = o.r or 190, o.g or 200, o.b or 255
                end
                task.Wait(o.step or 7)
            end
            task.Wait(o.rest or 36)
        end
    end)
end

---【限位·结界】生死之境：两层**结界线**（六边形，弹沿边排成一列）反向转、周期张缩。
---  安全区 = 两层缺口的交集，绕着场地走。
local function limit_barrier(self, o)
    task.New(self, function()
        task.Wait(o.delay or 100)
        local rot = o.a0 or 0
        local open = ran:Int(1, 6)
        local t = 0
        while true do
            t = t + 1
            --半径一张一缩：安全区的**大小**也在变
            local R = (o.r0 or 200) + (o.pulse or 55) * sin(t * 2.2)
            for s = 1, 6 do
                if s ~= open then
                    local ax, ay = cos(rot + (s - 1) * 60) * R, sin(rot + (s - 1) * 60) * R
                    local bx, by = cos(rot + s * 60) * R, sin(rot + s * 60) * R
                    for i = 0, (o.n or 8) do
                        local f = i / (o.n or 8)
                        local x = ax + (bx - ax) * f
                        local y = ay + (by - ay) * f
                        --沿边排成一列的结界线（弹朝内收）
                        local b = fly(knife, o.col or 6, x, y, o.v or 1.8,
                                Angle(0, 0, x, y) + 180)
                        b._r, b._g, b._b = o.r or 255, o.g or 190, o.b or 236
                    end
                end
            end
            PlaySound("tan00", 0.05, 0, true)
            rot = rot + (o.spin or 0.9)
            open = open % 6 + 1
            task.Wait(o.gap or 46)
        end
    end)
end

--============================
--[符卡0] 藤符「冥府的种子」
--  演出：种子落到底部 → 巨藤长成 → 藤蔓抬自机穿云 → 云层上卷模拟下坠
--  全程锁自机；卡片结束时还原锁、云层速度和演出对象。
--============================
do
    local name = "藤符「冥府的种子」"
    local card = boss.card.New(name, 4, 6, 16, 900)
    boss.card.add({ { card, "1a" } }, 28, name, 339)

    function card:init()
        if IsValid(player) then
            self._th30_locked_player = player.lock ~= true
            player.lock = true
        end
        self.th30_cloud_cover = New(class["th30_cloud_cover"])

        task.New(self, function()
            task.Wait(30)
            task.MoveTo(0, -80, 90, 4)
            task.Wait(30)
            New(class["th30_seed"], self.x, self.y)
            task.Wait(40)
            New(class["th30_vine"], self.x)
            task.Wait(90)

            --藤蔓把自机送出云层；这里直接做受控位移，避免和玩家移动系统抢位置。
            local w = lstg.world
            local sx, sy = player.x, player.y
            local target_x = self.x
            local target_y = w.t + 70
            for i = 1, 120 do
                local f = i / 120
                player.x = sx + (target_x - sx) * f
                player.y = sy + (target_y - sy) * f * f
                task.Wait()
            end

            --自机越过云层后开始下坠；背景云和前景云团向上卷。
            local cover = self.th30_cloud_cover
            if IsValid(cover) then
                cover.target_speed = 4.2
            end
            self.th30_cloud_phase = true
            for i = 1, 180 do
                local f = i / 180
                if IsValid(cover) then
                    cover.target_speed = 4.2 + f * 3.6
                end
                player.y = player.y - (1.2 + f * 3.0)
                task.Wait()
            end

            player.y = w.pb + 16
            self.th30_cloud_phase = false
            if IsValid(cover) then
                cover.target_speed = 0
            end
            player.lock = nil
            self._th30_locked_player = nil
        end)

        task.New(self, function()
            while not self.th30_cloud_phase do
                task.Wait()
            end
            task.MoveTo(self.x, lstg.world.b + 28, 40, 4)
            local side = ran:Sign()
            while self.th30_cloud_phase do
                local target_x = side * ran:Float(110, 170)
                for i = 1, 70 do
                    self.x = self.x + (target_x - self.x) * 0.045
                    self.y = lstg.world.b + 28 + sin(self.timer * 0.05) * 8
                    if i % 9 == 0 then
                        New(class["th30_cloud_puff"], self.x + ran:Float(-34, 34),
                                self.y + ran:Float(0, 18), { speed = 8.2 })
                    end
                    task.Wait()
                end
                side = -side
            end
        end)
    end

    function card:del()
        self.th30_cloud_phase = false
        if IsValid(self.th30_cloud_cover) then
            object.RawDel(self.th30_cloud_cover)
        end
        self.th30_cloud_cover = nil
        if self._th30_locked_player and IsValid(player) then
            player.lock = nil
        end
        self._th30_locked_player = nil
    end
end

--============================
--[符卡1] 「冥府的花笺」
--  
--  
--  
--============================
do
    local name = "冥府的花笺"
    local card = boss.card.New(name, 1, 2, 50, 780)
    boss.card.add({ { card, "1a" } }, 28, name, 340)

    function card:before()
        task.New(self, function()
            while true do
                task.MoveToPlayer(120, -90, 90, 90, 150, 26, 52, 20, 40,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 255, 205, 232)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 255, 205, 232)
        end)
        flower_boat(self, { n = 15, gapw = 62, speed = 4.0, step = 5,
                reps = 26, rest = 0, v = 2.3, delay = 120 })

    end
end

--============================
--[符卡2] 蝶符「胡蝶之栅」
--  锚点：蝶 ·「栅」= 一排蝶结成的一道墙
--  限位：一排 butterfly 横扫，缝左右交替（缝的两侧各站一只真蝶）
--  威胁：蝶弹偶数狙 6 路、扇面 30°
--============================
do
    local name = "蝶符「胡蝶之栅」"
    local card = boss.card.New(name, 1, 2, 50, 800)
    boss.card.add({ { card, "1a" } }, 28, name, 341)

    function card:before()
        task.New(self, function()
            while true do
                task.MoveToPlayer(110, -80, 80, 96, 140, 24, 48, 18, 36,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 255, 190, 236)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 255, 190, 236)
        end)
        limit_bfly_fence(self, { n = 14, gapw = 62, gapx = 0.55, v = 2.4,
                gap = 30, col = 2, r = 255, g = 200, b = 236, delay = 120 })
        threat_bfly_aim(self, { n = 6, v = 2.4, gap = 30, tilt = 12, spread = 30,
                style = butterfly, col = 2, r = 255, g = 200, b = 236, delay = 150 })
    end
end

--============================
--[符卡3] 樱符「墨染之川」
--  锚点：樱 ·「墨染」= 花瓣的颜色由白渐深
--  限位：一条 sakura 组成的川往下流，缝在川上来回扫
--  威胁：花瓣泛狙
--============================
do
    local name = "樱符「墨染之川」"
    local card = boss.card.New(name, 1, 2, 50, 780)
    boss.card.add({ { card, "1a" } }, 28, name, 342)

    function card:before()
        task.New(self, function()
            while true do
                task.MoveToPlayer(120, -90, 90, 90, 150, 26, 52, 20, 40,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 255, 205, 232)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 255, 205, 232)
        end)
        limit_petal_river(self, { n = 15, gapw = 62, speed = 4.0, step = 3,
                reps = 26, rest = 30, v = 2.3, delay = 120 })
        threat_spray(self, { ways = 4, n = 6, v0 = 1.7, dv = 0.7, jitter = 9,
                spread = 52, style = sakura, col = 2,
                r = 255, g = 205, b = 232, delay = 170, gap = 40 })
    end
end

--============================
--[符卡4] 扇符「胡蝶扇舞」
--  锚点：扇 · 六把扇绕 boss 公转，吐弹沿着扇骨
--  限位：骨与骨之间的缝随扇的朝向转动
--  威胁：蝶弹偶数狙（扇舞中飞出的蝶）
--============================
do
    local name = "扇符「胡蝶扇舞」"
    local card = boss.card.New(name, 1, 2, 50, 850)
    boss.card.add({ { card, "1a" } }, 28, name, 343)

    function card:before()
        task.New(self, function()
            while true do
                task.MoveToPlayer(130, -70, 70, 100, 150, 24, 48, 18, 36,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 255, 200, 236)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 255, 200, 236)
        end)
        limit_fan_ribs(self, { n = 6, ribs = 5, ribdeg = 11, orbit = 100,
                spin = 0.9, turn = 32, step = 6, gap = 56, v = 2.2, col = 4,
                r = 255, g = 205, b = 236, delay = 130 })
        threat_bfly_aim(self, { n = 6, v = 2.6, gap = 34, tilt = 18, spread = 30,
                style = butterfly, col = 4, r = 236, g = 180, b = 255, delay = 160 })
    end
end

--============================
--[符卡5] 死符「无寿之栏」
--  锚点：死 ·「栏」= 两排刀刃做的栅栏
--  限位：两排 knife 从左右向内收，缝越来越窄，收到下限重置
--  威胁：蝶弹偶数狙
--============================
do
    local name = "死符「无寿之栏」"
    local card = boss.card.New(name, 1, 2, 50, 800)
    boss.card.add({ { card, "1a" } }, 28, name, 344)

    function card:before()
        task.New(self, function()
            task.MoveTo(0, 120, 60, VALUE_SET.DECEL)
            while true do
                task.MoveToPlayer(120, -60, 60, 90, 140, 20, 40, 16, 32,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 255, 190, 255)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 255, 190, 255)
        end)
        limit_death_bars(self, { n = 11, hwmax = 168, hwmin = 62, step = 12,
                gap = 34, rest = 56, v = 2.2, col = 4,
                r = 226, g = 190, b = 255, delay = 130 })
        threat_bfly_aim(self, { n = 4, v = 2.5, gap = 60, tilt = 14, spread = 30,
                style = butterfly, col = 4, r = 226, g = 190, b = 255, delay = 170 })
    end
end

--============================
--[符卡6] 幽符「西行妖」
--  锚点：幽 · 西行妖 = 一棵会转的樱花树
--  限位：五根枝条是沿半径排成一线的 sakura 拼出来的，整棵树左右转，枝端落花
--  威胁：花瓣泛狙
--============================
do
    local name = "幽符「西行妖」"
    local card = boss.card.New(name, 1, 2, 50, 820)
    boss.card.add({ { card, "1a" } }, 28, name, 345)

    function card:before()
        task.New(self, function()
            while true do
                task.MoveToPlayer(120, -90, 90, 94, 146, 24, 48, 18, 36,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 255, 200, 230)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 255, 200, 230)
        end)
        limit_youkai_tree(self, { branches = 5, n = 12, len = 205, root = 180,
                step = 7, gap = 54, turn = 13, v = 1.6, col = 2,
                r = 255, g = 200, b = 230, delay = 130 })
        threat_spray(self, { ways = 3, n = 6, v0 = 1.8, dv = 0.7, jitter = 9,
                spread = 52, style = sakura, col = 2,
                r = 255, g = 200, b = 230, delay = 180, gap = 56 })
    end
end

--============================
--[符卡7] 蝶符「凤蝶圆舞」
--  锚点：蝶 · 凤蝶成对圆舞
--  限位：两只蝶在中心两侧反向公转，各放一股蝶弹螺旋，交错处是通道
--  威胁：蝶弹偶数狙
--============================
do
    local name = "蝶符「凤蝶圆舞」"
    local card = boss.card.New(name, 1, 2, 50, 820)
    boss.card.add({ { card, "1a" } }, 28, name, 346)

    function card:before()
        task.New(self, function()
            while true do
                task.MoveToPlayer(120, -70, 70, 96, 142, 24, 48, 18, 36,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 236, 200, 255)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 236, 200, 255)
        end)
        --两只蝶：一只在左、一只在右，各自成螺旋；蝶本身是自绘的
        for k = 0, 1 do
            local dir = (k == 0) and 1 or -1
            local bx = 0
            New(class["th04_bfly"], k == 0 and -30 or 30, 40,
                    { fall = 0, col = 6, size = 0.6, a = 200 })
            task.New(self, function()
                task.Wait(130)
                local ph = k * 180
                while true do
                    local rot = ph + ran:Float(0, 60)
                    for v = 1, 10 do
                        for i = 1, 8 do
                            local a = rot + i * 45 + v * 13 * dir
                            local b = fly(butterfly, 6,
                                    cos(ph) * 55 + cos(a) * 26,
                                    sin(ph) * 55 + sin(a) * 26,
                                    1.5 + v * 0.20, a)
                            b._r, b._g, b._b = 236, 200, 255
                        end
                        task.Wait(6)
                    end
                    task.Wait(64)
                end
            end)
        end
        threat_bfly_aim(self, { n = 4, v = 2.5, gap = 62, tilt = 16, spread = 30,
                style = butterfly, col = 6, r = 236, g = 200, b = 255, delay = 175 })
    end
end

--============================
--[符卡8] 樱符「樱吹雪」
--  锚点：樱 · 吹雪 = 花瓣被风吹得横着走
--  限位：一片斜着扫的花瓣帘，缝来回扫 → 安全区在两条对角带之间
--  威胁：花瓣泛狙
--============================
do
    local name = "樱符「樱吹雪」"
    local card = boss.card.New(name, 1, 2, 50, 780)
    boss.card.add({ { card, "1a" } }, 28, name, 347)

    function card:before()
        task.New(self, function()
            while true do
                task.MoveToPlayer(130, -100, 100, 90, 140, 26, 52, 20, 40,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 255, 200, 226)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 255, 200, 226)
        end)
        --斜着吹的花瓣：缝来回扫
        task.New(self, function()
            task.Wait(120)
            local ph = ran:Float(-120, 120)
            local dir = 1
            while true do
                for rep = 1, 24 do
                    local w = lstg.world
                    for i = 1, 16 do
                        local x = w.l + 10 + (w.r - w.l - 20) * (i - 1) / 15
                        if abs(x - ph) > 70 then
                            local b = fly(sakura, 10, x, w.t + 14, 2.5, -90 + dir * 30)
                            b._r, b._g, b._b = 255, 200, 226
                        end
                    end
                    ph = Forbid(ph + dir * 5.0, -140, 140)
                    task.Wait(3)
                end
                dir = -dir
                task.Wait(30)
            end
        end)
        threat_spray(self, { ways = 4, n = 6, v0 = 1.8, dv = 0.6, jitter = 9,
                spread = 52, style = sakura, col = 10,
                r = 255, g = 210, b = 226, delay = 190, gap = 66 })
    end
end

--============================
--[符卡9] 灵符「亡灵之渡」
--  锚点：亡灵 · 渡 = 四边的亡灵船来渡你过河
--  限位：四条边上各一船亡灵，落脚点沿边滑动，安全区是其余三边
--  威胁：蝶弹偶数狙
--============================
do
    local name = "灵符「亡灵之渡」"
    local card = boss.card.New(name, 1, 2, 50, 800)
    boss.card.add({ { card, "1a" } }, 28, name, 348)

    function card:before()
        task.New(self, function()
            while true do
                task.MoveToPlayer(110, -70, 70, 92, 140, 22, 44, 16, 32,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 190, 200, 255)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 190, 200, 255)
        end)
        limit_ghost_ferry(self, { reps = 110, step = 7, rest = 36, v = 2.5,
                col = 6, r = 190, g = 200, b = 255, delay = 120 })
        threat_bfly_aim(self, { n = 4, v = 2.4, gap = 42, tilt = 12, spread = 28,
                style = butterfly, col = 6, r = 200, g = 210, b = 255, delay = 175 })
    end
end

--============================
--[符卡10] 结界「生死之境」
--  锚点：结界 · 两条结界线把场地分成「生」与「死」
--  限位：两层六边形结界线（弹沿边排成一列）反向转、周期张缩，缺口错开
--  威胁：**只有一组**偶数狙（旧版同时 6 组 = 墙）
--============================
do
    local name = "结界「生死之境」"
    local card = boss.card.New(name, 1, 2, 50, 850)
    boss.card.add({ { card, "1a" } }, 28, name, 349)

    function card:before()
        task.New(self, function()
            while true do
                task.MoveToPlayer(120, -80, 80, 94, 144, 24, 48, 18, 36,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 255, 190, 236)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 255, 190, 236)
        end)
        limit_barrier(self, { r0 = 175, pulse = 50, n = 8, spin = 0.9,
                gap = 52, v = 1.8, col = 6, a0 = 0,
                r = 255, g = 190, b = 236, delay = 130 })
        limit_barrier(self, { r0 = 265, pulse = 45, n = 9, spin = -0.6,
                gap = 68, v = 1.5, col = 3, a0 = 30,
                r = 226, g = 180, b = 255, delay = 130 })
        threat_bfly_aim(self, { n = 4, v = 2.5, gap = 300, tilt = 18, spread = 34,
                style = butterfly, col = 3, r = 255, g = 200, b = 240, delay = 180 })
    end
end

--============================
--[终符] 「彼岸无余涅槃」
--  四个阶段按掉血推进，每个阶段 = 1 个限位 + 1 个威胁，主题依次是
--  蝶 → 樱 → 亡灵 → 蝶+樱
--============================
do
    local name = "「彼岸无余涅槃」"
    local card = boss.card.New(name, 1, 2, 60, 1200)
    boss.card.add({ { card, "1a" } }, 28, name, 350)

    function card:before()
        task.New(self, function()
            while true do
                task.MoveToPlayer(130, -80, 80, 96, 146, 24, 48, 18, 36,
                        VALUE_SET.DECEL, WANDER_MODE.RANDOM)
            end
        end)
    end

    function card:init()
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 255, 200, 236)
            boss.cast(self, 60)
            task.Wait(30)
            Newcharge_out(self.x, self.y, 255, 200, 236)
        end)
        --① 蝶：一排蝶栅 + 蝶弹偶数狙
        limit_bfly_fence(self, { n = 14, gapw = 64, gapx = 0.55, v = 2.5,
                gap = 38, col = 2, r = 255, g = 200, b = 236, delay = 130 })
        threat_bfly_aim(self, { n = 4, v = 2.4, gap = 76, tilt = 12, spread = 30,
                style = butterfly, col = 2, r = 255, g = 200, b = 236, delay = 160 })
        --② 樱：墨染之川加入
        task.New(self, function()
            task.Wait(360)
            limit_petal_river(self, { n = 15, gapw = 66, speed = 4.2, step = 3,
                    reps = 24, rest = 34, v = 2.3 })
        end)
        --③ 亡灵：泛狙加入（总数到 2 组）
        task.New(self, function()
            task.Wait(720)
            threat_spray(self, { ways = 3, n = 5, v0 = 1.8, dv = 0.7, jitter = 7,
                    spread = 52, style = sakura, col = 6,
                    r = 255, g = 200, b = 230, gap = 110 })
        end)
        --④ 蝶+樱：再加一层蝶栅（两组限位复合 → 安全区变成一个小角）
        task.New(self, function()
            task.Wait(1080)
            limit_bfly_fence(self, { n = 12, gapw = 74, gapx = 0.45, v = 2.5,
                    gap = 92, col = 4, r = 236, g = 180, b = 255 })
        end)
    end
end
