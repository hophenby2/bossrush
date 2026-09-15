---=====================================
---TH05 关卡背景：花园
---  按 AGENTS.md §10.10 的视觉要求写：**明亮、高对比、大面积**。
---    · 天色：鹅黄 → 暖绿 → 淡青的白天渐变（和弹幕的暖色系同族，但更淡）
---    · 远处一排大向日葵（自绘花盘 + 花瓣），缓慢左右摆，视差分层
---    · 中景草地 + 成片的小花
---    · 空中飘的花瓣（三层视差）
---    · 光斑：从上方斜射的几束光柱
---  只用引擎自带的 white / ball_* / moon 贴图，不额外加载文件。
---=====================================

local SetViewMode = SetViewMode
local SetImageState = SetImageState
local RenderRect = RenderRect
local Render = Render
local background = background
local lstg = lstg
local sin, cos, int, abs, max, min, sqrt = sin, cos, int, abs, max, min, sqrt

TH05_bg = Class(background)

---地平线（world 坐标）：这条线以上是天
local HORIZON = -96
---远、中、近三层花草的基线
local FAR_Y = HORIZON
local MID_Y = -172
local NEAR_Y = -226

---视差层：花瓣
local PETAL_LAYERS = {
    { n = 30, spd = 0.34, s0 = 0.18, s1 = 0.40, a0 = 60,  a1 = 120, sway = 16 },
    { n = 18, spd = 0.70, s0 = 0.32, s1 = 0.62, a0 = 100, a1 = 170, sway = 24 },
    { n = 10, spd = 1.20, s0 = 0.50, s1 = 0.95, a0 = 150, a1 = 220, sway = 34 },
}

---远处的大向日葵：(x, 根部 y, 大小, 相位)
local SUNS = {
    { -300, FAR_Y, 1.45, 0.0 }, { -212, FAR_Y - 6, 1.15, 0.8 },
    { -120, FAR_Y + 4, 1.60, 1.7 }, { -26,  FAR_Y - 4, 1.25, 2.4 },
    {   70, FAR_Y + 6, 1.50, 3.2 }, {  166, FAR_Y - 2, 1.30, 4.0 },
    {  262, FAR_Y + 2, 1.40, 4.9 }, {  340, FAR_Y - 8, 1.10, 5.6 },
}

---中景小花：(x, y, 大小, 色号)
local MINIS = {
    { -330, MID_Y, 0.55, 2 }, { -268, MID_Y - 12, 0.45, 6 },
    { -196, MID_Y + 8, 0.60, 12 }, { -128, MID_Y - 6, 0.50, 2 },
    {  -54, MID_Y + 10, 0.58, 6 }, {   22, MID_Y - 10, 0.46, 12 },
    {   96, MID_Y + 6, 0.62, 2 }, {  170, MID_Y - 8, 0.52, 6 },
    {  244, MID_Y + 9, 0.57, 12 }, { 316, MID_Y - 5, 0.48, 2 },
    --近景再来一排
    { -296, NEAR_Y, 0.75, 12 }, { -186, NEAR_Y - 8, 0.68, 2 },
    {  -62, NEAR_Y + 6, 0.80, 6 }, {   58, NEAR_Y - 6, 0.72, 12 },
    {  178, NEAR_Y + 8, 0.76, 2 }, {  290, NEAR_Y - 4, 0.66, 6 },
}

local MINI_RGB = {
    [2]  = { 255, 168, 200 },   --粉
    [6]  = { 150, 240, 220 },   --青
    [12] = { 255, 226, 130 },   --金
}

local function seg(ax, ay, bx, by, alpha, r, g, b, thick)
    local dx, dy = bx - ax, by - ay
    local len = sqrt(dx * dx + dy * dy)
    if len < 1 or alpha <= 0 then
        return
    end
    SetImageState("white", "mul+add", alpha, r, g, b)
    Render("white", (ax + bx) * 0.5, (ay + by) * 0.5, math.deg(math.atan2(dy, dx)), len / 16, thick)
end

---一朵大向日葵：花盘（加算光玉）+ 一圈花瓣 + 茎 + 两片叶
local function draw_sunflower(x, y, s, a, t, ph)
    if a <= 0 or s <= 0 then
        return
    end
    local sway = sin(t * 0.012 + ph) * 4
    local hx, hy = x + sway, y + 92 * s        --花头
    --茎
    seg(x, y - 6 * s, hx, hy, 200 * a, 96, 168, 62, 2.4 * s)
    --叶
    seg(x, y + 22 * s, x - 30 * s + sway, y + 40 * s, 170 * a, 120, 200, 80, 1.6 * s)
    seg(x, y + 22 * s, x + 30 * s + sway, y + 40 * s, 170 * a, 120, 200, 80, 1.6 * s)
    --花瓣（两圈，交错）
    for ring = 0, 1 do
        local n = 12
        local rr = (30 - ring * 8) * s
        for i = 1, n do
            local ang = 90 + (i - 1) * 360 / n + ring * 15 + sway * 0.6
            local px = hx + cos(ang) * rr
            local py = hy + sin(ang) * rr
            SetImageState("ellipse6", "mul+add", 210 * a, 255, 218, 96)
            Render("ellipse6", px, py, ang, 15 * s, 7 * s)
        end
    end
    --花盘：暗心 + 亮边
    SetImageState("ball_big6", "", 235 * a, 122, 82, 34)
    Render("ball_big6", hx, hy, 0, 0.42 * s, 0.42 * s)
    SetImageState("ball_mid6", "mul+add", 120 * a, 255, 200, 120)
    Render("ball_mid6", hx, hy, 0, 0.18 * s, 0.18 * s)
end

---一朵中景小花：四片花瓣 + 白心
local function draw_mini(x, y, s, a, col, t, ph)
    if a <= 0 or s <= 0 then
        return
    end
    local rgb = MINI_RGB[col] or MINI_RGB[12]
    local sway = sin(t * 0.02 + ph) * 2
    seg(x, y - 10 * s, x + sway, y + 16 * s, 170 * a, 110, 186, 76, 1.0 * s)
    for i = 1, 5 do
        local ang = 90 + (i - 1) * 72
        SetImageState("ellipse6", "mul+add", 200 * a, rgb[1], rgb[2], rgb[3])
        Render("ellipse6", x + sway + cos(ang) * 8 * s, y + sway * 0.3 + sin(ang) * 8 * s,
                ang, 10 * s, 6 * s)
    end
    SetImageState("ball_mid6", "mul+add", 230 * a, 255, 255, 245)
    Render("ball_mid6", x + sway, y, 0, 0.14 * s, 0.14 * s)
end

function TH05_bg:init()
    background.init(self, false)
    local w = lstg.world
    --光斑
    self.motes = {}
    for i = 1, 46 do
        self.motes[i] = {
            x = background.RanFloat(self, w.l, w.r),
            y = background.RanFloat(self, HORIZON, w.t),
            s = background.RanFloat(self, 0.12, 0.42),
            a = background.RanInt(self, 40, 130),
            p = background.RanFloat(self, 0, 360),
            k = background.RanFloat(self, 0.5, 1.8),
        }
    end
    --草叶（近景）
    self.grass = {}
    for i = 1, 90 do
        self.grass[i] = {
            x = background.RanFloat(self, w.l - 10, w.r + 10),
            y = background.RanFloat(self, w.b, NEAR_Y + 40),
            h = background.RanFloat(self, 10, 30),
            p = background.RanFloat(self, 0, 360),
        }
    end
end

function TH05_bg:frame()
    for i = 1, #self.motes do
        local m = self.motes[i]
        m.x = m.x + 0.22
        m.y = m.y + 0.12
        if m.x > lstg.world.r + 8 then
            m.x = lstg.world.l - 8
            m.y = background.RanFloat(self, HORIZON, lstg.world.t)
        end
    end
end

function TH05_bg:render()
    SetViewMode 'world'
    local w = lstg.world
    local t = self.timer

    ------------------------------------------------------------------
    --天色：下暖上青（明亮，不是夜空）
    ------------------------------------------------------------------
    local SN = 12
    local sh = (w.t - HORIZON) / SN
    for i = 1, SN do
        local f = (i - 1) / (SN - 1)       -- 0 = 靠地平线, 1 = 画面顶端
        SetImageState("white", "", 255,
                int(226 - 46 * f), int(240 - 30 * f), int(150 + 70 * f))
        RenderRect("white", w.l, w.r, HORIZON + (i - 1) * sh, HORIZON + i * sh)
    end

    ------------------------------------------------------------------
    --地平线上的一层亮霭
    ------------------------------------------------------------------
    SetImageState("ball_huge6", "mul+add", 40, 255, 236, 150)
    Render("ball_huge6", 0, HORIZON + 6, 0, 6.6, 0.7)

    ------------------------------------------------------------------
    --斜射的光柱（三束，缓慢左右摆）
    ------------------------------------------------------------------
    for i = 1, 3 do
        local bx = -150 + i * 130 + sin(t * 0.008 + i) * 26
        local k = 0.5 + 0.5 * sin(t * 0.011 + i * 2)
        SetImageState("white", "mul+add", int(14 + 12 * k), 255, 250, 200)
        RenderRect("white", bx - 34, bx + 34, HORIZON, w.t)
    end

    ------------------------------------------------------------------
    --远处的大向日葵
    ------------------------------------------------------------------
    for i = 1, #SUNS do
        local s = SUNS[i]
        draw_sunflower(s[1], s[2], s[3], 1, t, s[4])
    end

    ------------------------------------------------------------------
    --远处的草地
    ------------------------------------------------------------------
    local GN = 4
    local gh = (MID_Y - w.b) / GN
    for i = 1, GN do
        local f = (i - 1) / (GN - 1)
        local k = 1 - abs(f * 2 - 1)
        SetImageState("white", "", 255,
                int(96 + 30 * k), int(168 + 40 * k), int(70 + 26 * k))
        RenderRect("white", w.l, w.r, w.b + (i - 1) * gh, w.b + i * gh)
    end

    ------------------------------------------------------------------
    --中景 / 近景的小花
    ------------------------------------------------------------------
    for i = 1, #MINIS do
        local m = MINIS[i]
        draw_mini(m[1], m[2], m[3], 1, m[4], t, i * 1.3)
    end

    ------------------------------------------------------------------
    --草叶
    ------------------------------------------------------------------
    for i = 1, #self.grass do
        local g = self.grass[i]
        local sw = sin(t * 0.03 + g.p) * 3
        seg(g.x, g.y, g.x + sw, g.y + g.h, 150, 88, 156, 64, 0.7)
    end

    ------------------------------------------------------------------
    --飘的花瓣（三层视差）
    ------------------------------------------------------------------
    for li = 1, #PETAL_LAYERS do
        local L = PETAL_LAYERS[li]
        for i = 1, L.n do
            local p = ((i * 97 + li * 31) % 97) / 97
            local x = w.l + (w.r - w.l) * p + sin(t * 0.006 * (li + 1) + i) * L.sway
            local y = w.b + ((t * L.spd + i * 137) % (w.t - w.b + 80)) - 20
            local a = L.a0 + (L.a1 - L.a0) * (0.5 + 0.5 * sin(t * 0.02 + i))
            local s = L.s0 + (L.s1 - L.s0) * ((i * 53) % 10) / 10
            draw_petal_bg(x, y, t * 0.7 + i * 40, s, a)
        end
    end

    ------------------------------------------------------------------
    --光斑（最上层）
    ------------------------------------------------------------------
    for i = 1, #self.motes do
        local m = self.motes[i]
        local k = 0.75 + 0.25 * sin(t * 0.05 * m.k + m.p)
        SetImageState("ball_light5", "mul+add", m.a * 0.5 * k, 255, 250, 200)
        Render("ball_light5", m.x, m.y, 0, m.s * 1.1, m.s * 1.1)
        SetImageState("ball_mid6", "mul+add", m.a * k, 255, 255, 240)
        Render("ball_mid6", m.x, m.y, 0, m.s * 0.2, m.s * 0.2)
    end
end

---背景里的花瓣：用 ellipse 贴图，暖粉色，比前景弹幕淡
function draw_petal_bg(x, y, rot, size, a)
    SetImageState("ellipse6", "mul+add", a, 255, 206, 218)
    Render("ellipse6", x, y, rot, size * 1.6, size)
end
