---=====================================
---TH02 关卡背景：深空 · 星舰视点
---  静态循环背景，不参与弹幕逻辑，全部在 world 视图下 2D 绘制：
---    · 三层视差星：越远越小越暗、漂移越慢
---    · 缓慢流动的星云（几个大光斑叠加）
---    · 远处一颗带环的行星，自身自转、随时间缓慢横移
---    · 偶尔划过的彗星
---  只依赖引擎自带的 white / ball_* 贴图，不额外加载文件。
---=====================================

local SetViewMode = SetViewMode
local SetImageState = SetImageState
local RenderRect = RenderRect
local Render = Render
local background = background
local lstg = lstg
local sin, cos, int = sin, cos, int

TH02_bg = Class(background)

---视差层：{数量, 漂移速度, 尺寸范围, 亮度}
local LAYERS = {
    { n = 70,  spd = 0.10, r0 = 0.5, r1 = 1.0, a0 = 60,  a1 = 120 },
    { n = 46,  spd = 0.26, r0 = 0.8, r1 = 1.7, a0 = 110, a1 = 190 },
    { n = 26,  spd = 0.55, r0 = 1.2, r1 = 2.6, a0 = 170, a1 = 255 },
}
---星云光斑
local NEBULA = {
    { x = -150, y = 120,  s = 5.2, r = 96,  g = 74,  b = 168, a = 34, spd = 0.045 },
    { x = 120,  y = -60,  s = 6.0, r = 62,  g = 118, b = 190, a = 26, spd = 0.030 },
    { x = 30,   y = 190,  s = 4.4, r = 150, g = 96,  b = 200, a = 22, spd = 0.060 },
    { x = -60,  y = -170, s = 5.6, r = 74,  g = 150, b = 214, a = 20, spd = 0.038 },
}
---远处的带环行星
local PLANET_X, PLANET_Y, PLANET_S = 118, 132, 1.05

function TH02_bg:init()
    background.init(self, false)
    local w = lstg.world
    self.stars = {}
    for li = 1, #LAYERS do
        local L = LAYERS[li]
        local t = {}
        for i = 1, L.n do
            t[i] = {
                x = background.RanFloat(self, w.l, w.r),
                y = background.RanFloat(self, w.b, w.t),
                r = background.RanFloat(self, L.r0, L.r1),
                p = background.RanFloat(self, 0, 360),
                k = background.RanFloat(self, 0.5, 2.4),
                a = background.RanInt(self, L.a0, L.a1),
            }
        end
        self.stars[li] = t
    end
    self.neb = {}
    for i = 1, #NEBULA do
        local n = NEBULA[i]
        self.neb[i] = { x = n.x, y = n.y, s = n.s, p = background.RanFloat(self, 0, 360) }
    end
end

function TH02_bg:frame()
    local w = lstg.world
    for li = 1, #LAYERS do
        local L, t = LAYERS[li], self.stars[li]
        for i = 1, #t do
            local s = t[i]
            s.y = s.y - L.spd
            if s.y < w.b - 4 then
                s.y = w.t + 4
                s.x = background.RanFloat(self, w.l, w.r)
            end
        end
    end
    for i = 1, #self.neb do
        local n, d = self.neb[i], NEBULA[i]
        n.x = n.x - d.spd
        if n.x < w.l - 200 then
            n.x = w.r + 200
            n.y = background.RanFloat(self, w.b + 40, w.t - 40)
        end
    end
end

function TH02_bg:render()
    SetViewMode 'world'
    local w = lstg.world
    local t = self.timer

    ------------------------------------------------------------------
    --底色：上深下略亮的深空
    ------------------------------------------------------------------
    local SN = 10
    local sh = (w.t - w.b) / SN
    for i = 1, SN do
        local f = (i - 1) / (SN - 1)
        SetImageState("white", "", 255, int(4 + 5 * f), int(6 + 12 * f), int(20 + 30 * f))
        RenderRect("white", w.l, w.r, w.b + (i - 1) * sh, w.b + i * sh)
    end

    ------------------------------------------------------------------
    --星云：几个大光斑缓慢呼吸、漂移
    ------------------------------------------------------------------
    for i = 1, #self.neb do
        local n, d = self.neb[i], NEBULA[i]
        local k = 0.72 + 0.28 * sin(t * 0.015 + n.p)
        SetImageState("ball_huge6", "mul+add", d.a * k, d.r, d.g, d.b)
        Render("ball_huge6", n.x, n.y, 0, n.s, n.s)
        SetImageState("ball_light5", "mul+add", d.a * 0.5 * k, d.r + 40, d.g + 30, d.b)
        Render("ball_light5", n.x, n.y, 0, n.s * 0.32, n.s * 0.32)
    end

    ------------------------------------------------------------------
    --远处带环的行星
    ------------------------------------------------------------------
    SetImageState("ball_huge6", "mul+add", 26, 120, 150, 220)
    Render("ball_huge6", PLANET_X, PLANET_Y, 0, PLANET_S * 3.1, PLANET_S * 3.1)
    --行星本体
    SetImageState("ball_huge6", "", 255, 40, 58, 104)
    Render("ball_huge6", PLANET_X, PLANET_Y, 0, PLANET_S * 1.55, PLANET_S * 1.55)
    --受光面
    SetImageState("ball_big6", "", 200, 120, 158, 214)
    Render("ball_big6", PLANET_X + 9 * PLANET_S, PLANET_Y + 7 * PLANET_S, 0, PLANET_S * 0.95, PLANET_S * 0.95)
    --环：用几段随自转周期呼吸的短横线拼出透视
    local spin = t * 0.35
    for i = -6, 6 do
        local f = i / 6
        local y = PLANET_Y - 12 * PLANET_S + 4 * PLANET_S * cos(spin + f * 120)
        local half = sqrt(max(0, 1 - f * f)) * 62 * PLANET_S
        if half > 1 then
            local a = 150 * (0.35 + 0.65 * abs(cos(spin * 0.5 + f * 1.4)))
            SetImageState("white", "mul+add", a, 210, 196, 236)
            RenderRect("white", PLANET_X - half, PLANET_X + half, y - 0.8, y + 0.8)
        end
    end

    ------------------------------------------------------------------
    --三层视差星
    ------------------------------------------------------------------
    for li = 1, #LAYERS do
        local t2 = self.stars[li]
        for i = 1, #t2 do
            local s = t2[i]
            local a = s.a * (0.55 + 0.45 * sin(t * 0.04 * s.k + s.p))
            SetImageState("white", "mul+add", a, 214, 230, 255)
            local r = s.r * 0.85
            RenderRect("white", s.x - r, s.x + r, s.y - r, s.y + r)
        end
    end

    ------------------------------------------------------------------
    --偶尔划过的彗星（纯装饰：一段越拖越淡的短划线）
    ------------------------------------------------------------------
    local cd = t % 420
    if cd < 90 then
        local k = cd / 90
        local cx = w.l - 40 + (w.r - w.l + 160) * k
        local cy = w.t * 0.35 - 90 * k
        for i = 0, 9 do
            local f = i / 9
            SetImageState("white", "mul+add", int(150 * (1 - f) * sin(k * 180)), 200, 226, 255)
            RenderRect("white", cx - 14 * f - 3, cx - 14 * f + 3, cy + 5 * f - 0.8, cy + 5 * f + 0.8)
        end
    end
end
