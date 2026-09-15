---=====================================
---TH04 关卡背景：彼岸
---  静态循环背景，不参与弹幕逻辑，全部在 world 视图下 2D 绘制：
---    · 天色：从深紫到血红的黄昏渐变
---    · 地平线上半沉的一轮红日
---    · 三途川：横贯画面的水带 + 水面碎光 + 日影
---    · 两岸成片的彼岸花（细红线攒成的花簇，花心一点亮）
---    · 缓缓上浮的魂火
---  只依赖引擎自带的 white / ball_* / moon 贴图，不额外加载文件。
---=====================================

local SetViewMode = SetViewMode
local SetImageState = SetImageState
local RenderRect = RenderRect
local Render = Render
local background = background
local lstg = lstg
local sin, cos, int, abs, max, min, sqrt = sin, cos, int, abs, max, min, sqrt

TH04_bg = Class(background)

---对岸线（world 坐标）：这条线以上是天
local HORIZON = -52
---三途川的远岸、近岸
local FAR_BANK = HORIZON
local NEAR_BANK = -186
---半沉的红日
local SUN_X, SUN_Y = -104, HORIZON + 26
---魂火视差层
local WISP_LAYERS = {
    { n = 26, spd = 0.30, s0 = 0.20, s1 = 0.42, a0 = 50,  a1 = 100, sway = 14 },
    { n = 16, spd = 0.62, s0 = 0.34, s1 = 0.66, a0 = 90,  a1 = 160, sway = 22 },
    { n = 9,  spd = 1.10, s0 = 0.55, s1 = 0.95, a0 = 140, a1 = 230, sway = 30 },
}
---彼岸花的分布（x, 根部 y, 簇大小）
local FLOWERS = {
    { -300, -30, 1.05 }, { -262, -46, 0.85 }, { -218, -22, 0.95 }, { -176, -54, 0.78 },
    { -132, -34, 1.00 }, { -86,  -48, 0.82 }, { -40,  -26, 0.92 }, {   6,  -50, 0.80 },
    {  52,  -30, 1.02 }, {  98,  -46, 0.86 }, { 144,  -24, 0.94 }, { 190,  -52, 0.79 },
    { 236,  -32, 0.98 }, { 282,  -44, 0.88 }, { 318,  -28, 0.90 },
    -- 近岸也来一排，靠画面下方
    { -284, -206, 1.25 }, { -178, -216, 1.05 }, { -70, -200, 1.15 },
    {  38, -212, 1.10 }, { 146, -202, 1.20 }, { 254, -214, 1.00 },
}

---一段加算细线（画花瓣用）
local function lily_seg(ax, ay, bx, by, alpha, thick)
    local dx, dy = bx - ax, by - ay
    local len = sqrt(dx * dx + dy * dy)
    if len < 1 or alpha <= 0 then
        return
    end
    SetImageState("white", "mul+add", alpha, 210, 26, 40)
    Render("white", (ax + bx) * 0.5, (ay + by) * 0.5, math.deg(math.atan2(dy, dx)), len / 16, thick)
end

---画一朵彼岸花：一圈向后翻卷的细花瓣 + 一点花心
local function draw_spider_lily(x, y, s, a, t)
    if a <= 0 or s <= 0 then
        return
    end
    for i = 1, 6 do
        --每片花瓣往后翻：起点在花心附近，末端向外向上翘，用两段折线近似弯瓣
        local base = -90 + (i - 1) * 60 + sin(t * 0.02 + i) * 4
        local x0 = x + cos(base + 150) * 1.6 * s
        local y0 = y + sin(base + 150) * 1.6 * s
        local x1 = x + cos(base) * 15 * s
        local y1 = y + sin(base) * 15 * s
        local x2 = x + cos(base + 26) * 26 * s
        local y2 = y + sin(base + 26) * 26 * s
        lily_seg(x0, y0, x1, y1, 150 * a, 0.10 * s)
        lily_seg(x1, y1, x2, y2, 96 * a, 0.10 * s)
    end
    --花心：一点亮
    SetImageState("ball_mid6", "mul+add", 200 * a, 255, 180, 170)
    Render("ball_mid6", x, y, 0, 0.16 * s, 0.16 * s)
    --花茎
    SetImageState("white", "", 220 * a, 32, 30, 26)
    RenderRect("white", x - 0.7 * s, x + 0.7 * s, y, y + 26 * s)
end

function TH04_bg:init()
    background.init(self, false)
    local w = lstg.world
    self.stars = {}
    for i = 1, 70 do
        self.stars[i] = {
            x = background.RanFloat(self, w.l, w.r),
            y = background.RanFloat(self, HORIZON + 10, w.t),
            r = background.RanFloat(self, 0.5, 1.5),
            p = background.RanFloat(self, 0, 360),
            k = background.RanFloat(self, 0.5, 2.2),
        }
    end
    --水面碎光
    self.glints = {}
    for i = 1, 30 do
        self.glints[i] = {
            x = background.RanFloat(self, w.l, w.r),
            y = background.RanFloat(self, NEAR_BANK, FAR_BANK),
            len = background.RanFloat(self, 16, 74),
            a = background.RanInt(self, 16, 52),
            spd = background.RanFloat(self, 0.10, 0.34),
            p = background.RanFloat(self, 0, 360),
        }
    end
    --魂火
    self.wisps = {}
    for li = 1, #WISP_LAYERS do
        local L = WISP_LAYERS[li]
        local t = {}
        for i = 1, L.n do
            t[i] = {
                x = background.RanFloat(self, w.l - 20, w.r + 20),
                y = background.RanFloat(self, w.b - 20, w.t + 30),
                s = background.RanFloat(self, L.s0, L.s1),
                a = background.RanInt(self, L.a0, L.a1),
                p = background.RanFloat(self, 0, 360),
                k = background.RanFloat(self, 0.6, 1.7),
            }
        end
        self.wisps[li] = t
    end
end

function TH04_bg:frame()
    local w = lstg.world
    --水面碎光横着漂
    for i = 1, #self.glints do
        local g = self.glints[i]
        g.x = g.x + g.spd
        if g.x - g.len > w.r then
            g.x = w.l - g.len
            g.y = background.RanFloat(self, NEAR_BANK, FAR_BANK)
        end
    end
    --魂火向上飘
    for li = 1, #WISP_LAYERS do
        local L, t = WISP_LAYERS[li], self.wisps[li]
        for i = 1, #t do
            local s = t[i]
            s.y = s.y + L.spd
            s.x = s.x + sin(self.timer * 0.014 * s.k + s.p) * L.sway * 0.05
            if s.y > w.t + 16 then
                s.y = w.b - background.RanFloat(self, 10, 60)
                s.x = background.RanFloat(self, w.l - 20, w.r + 20)
            end
        end
    end
end

function TH04_bg:render()
    SetViewMode 'world'
    local w = lstg.world
    local t = self.timer

    ------------------------------------------------------------------
    --天色：上深紫、下血红
    ------------------------------------------------------------------
    local SN = 12
    local sh = (w.t - HORIZON) / SN
    for i = 1, SN do
        local f = (i - 1) / (SN - 1)          -- 0 = 靠地平线, 1 = 画面顶端
        SetImageState("white", "", 255,
                int(28 + 8 * f), int(8 + 6 * f), int(22 + 26 * f))
        RenderRect("white", w.l, w.r, HORIZON + (i - 1) * sh, HORIZON + i * sh)
    end

    ------------------------------------------------------------------
    --星点（只在上半部分，靠地平线处被霞光盖掉）
    ------------------------------------------------------------------
    for i = 1, #self.stars do
        local s = self.stars[i]
        local fade = min(1, (s.y - HORIZON) / 90)
        local a = (50 + 140 * (0.5 + 0.5 * sin(t * 0.03 * s.k + s.p))) * fade
        SetImageState("white", "mul+add", a, 255, 210, 220)
        local r = s.r * 0.85
        RenderRect("white", s.x - r, s.x + r, s.y - r, s.y + r)
    end

    ------------------------------------------------------------------
    --霞光：贴着地平线的一层红
    ------------------------------------------------------------------
    SetImageState("ball_huge6", "mul+add", 46, 226, 60, 60)
    Render("ball_huge6", 0, HORIZON + 4, 0, 6.2, 0.85)
    SetImageState("ball_huge6", "mul+add", 30, 255, 120, 80)
    Render("ball_huge6", SUN_X, HORIZON + 10, 0, 2.6, 0.9)

    ------------------------------------------------------------------
    --半沉的红日
    ------------------------------------------------------------------
    --外层光晕
    SetImageState("ball_huge6", "mul+add", 54, 255, 96, 72)
    Render("ball_huge6", SUN_X, SUN_Y, 0, 1.9, 1.9)
    --本体（用 moon 贴图压成暖红）
    SetImageState("moon", "", 236, 255, 138, 96)
    Render("moon", SUN_X, SUN_Y, 0, 0.86, 0.86)
    SetImageState("ball_big6", "mul+add", 120, 255, 200, 150)
    Render("ball_big6", SUN_X, SUN_Y, 0, 0.5, 0.5)

    ------------------------------------------------------------------
    --三途川：水带
    ------------------------------------------------------------------
    local WN = 7
    local wh = (FAR_BANK - NEAR_BANK) / WN
    for i = 1, WN do
        local f = (i - 1) / (WN - 1)          -- 0 = 远岸, 1 = 近岸
        local k = 1 - abs(f * 2 - 1)          -- 中间偏亮
        SetImageState("white", "", 255,
                int(14 + 26 * k), int(6 + 10 * k), int(20 + 22 * k))
        RenderRect("white", w.l, w.r, NEAR_BANK + (i - 1) * wh, NEAR_BANK + i * wh)
    end
    --水面碎光
    for i = 1, #self.glints do
        local g = self.glints[i]
        local a = g.a * (0.55 + 0.45 * sin(t * 0.05 + g.p))
        SetImageState("white", "mul+add", a, 255, 120, 110)
        RenderRect("white", g.x - g.len * 0.5, g.x + g.len * 0.5, g.y - 0.6, g.y + 0.6)
    end
    --日影：一条竖着摇晃的碎光
    for i = 1, 16 do
        local f = i / 16
        local y = FAR_BANK - f * (FAR_BANK - NEAR_BANK)
        local wdt = (26 - 14 * f) * (0.6 + 0.4 * sin(t * 0.07 + i))
        SetImageState("white", "mul+add", int(60 * (1 - f * 0.7)), 255, 130, 90)
        RenderRect("white", SUN_X - wdt, SUN_X + wdt, y - 1.2, y + 1.2)
    end

    ------------------------------------------------------------------
    --两岸的彼岸花
    ------------------------------------------------------------------
    for i = 1, #FLOWERS do
        local fl = FLOWERS[i]
        draw_spider_lily(fl[1], fl[2], fl[3], 1, t)
    end

    ------------------------------------------------------------------
    --近岸的暗色地
    ------------------------------------------------------------------
    local GN = 4
    local gh = (NEAR_BANK - w.b) / GN
    for i = 1, GN do
        local f = (i - 1) / (GN - 1)
        local k = 1 - f
        SetImageState("white", "", 255, int(10 + 12 * k), int(6 + 6 * k), int(14 + 12 * k))
        RenderRect("white", w.l, w.r, w.b + (i - 1) * gh, w.b + i * gh)
    end

    ------------------------------------------------------------------
    --魂火（画在最上层）
    ------------------------------------------------------------------
    for li = 1, #WISP_LAYERS do
        for i = 1, #self.wisps[li] do
            local s = self.wisps[li][i]
            local k = 0.8 + 0.2 * sin(t * 0.06 + s.p)
            SetImageState("ball_light5", "mul+add", s.a * 0.55 * k, 120, 200, 255)
            Render("ball_light5", s.x, s.y, 0, s.s * 0.9, s.s * 0.9)
            SetImageState("ball_mid6", "mul+add", s.a * k, 226, 246, 255)
            Render("ball_mid6", s.x, s.y, 0, s.s * 0.22, s.s * 0.22)
        end
    end
end
