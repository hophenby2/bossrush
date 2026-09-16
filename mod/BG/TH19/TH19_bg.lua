---=====================================
---TH19 关卡背景：地底（地灵殿全员）
---  按 AGENTS.md §10.10 的视觉要求写：**大面积、高对比、配色明亮**。
---  地底的调子比花园暗，但**弹幕层要比背景亮得多**才好读，所以背景压到低亮度、
---  高饱和的暖色（岩浆橙 / 鬼火青），只在几处点亮 —— 不要一片死黑。
---    · 底色：从旧地狱的红褐（上）渐到地底湖的青黑（下）
---    · 远景：一排石笋/钟乳（自绘，左中右三层视差）
---    · 岩浆：底部几条缓慢明灭的岩浆河，是画面里最亮的暖色
---    · 鬼火：一批上浮的青绿色光点（不具威胁的装饰）
---    · 前景：飘落的火星（三层视差，向上逆流）
---  只用引擎自带的 white / ball_* / moon / ellipse 贴图，不额外加载文件。
---=====================================

local SetImageState = SetImageState
local RenderRect = RenderRect
local Render = Render
local background = background
local lstg = lstg
local sin, cos, int, abs, max, min = sin, cos, int, abs, max, min

TH19_bg = Class(background)

---底色渐变的分界（world 坐标，+y 向上）
local SKY_Y = 60          -- 这条线以上是「旧地狱的天」
---石笋的基线
local FAR_Y = -40
local MID_Y = -150
local NEAR_Y = -226

---石笋：(x, 根部 y, 半宽, 高, 明度)
local PILLARS = {
    { -330, FAR_Y, 62, 250, 0.55 }, { -240, FAR_Y - 8, 48, 210, 0.65 },
    { -150, FAR_Y + 6, 74, 290, 0.50 }, { -52, FAR_Y - 4, 44, 190, 0.70 },
    {   40, FAR_Y + 8, 68, 270, 0.52 }, {  140, FAR_Y - 6, 52, 230, 0.62 },
    {  250, FAR_Y + 4, 80, 300, 0.48 }, {  344, FAR_Y - 2, 46, 200, 0.68 },
    { -300, MID_Y, 96, 190, 0.85 }, { -120, MID_Y + 6, 110, 220, 0.80 },
    {   90, MID_Y - 6, 88, 175, 0.88 }, {  300, MID_Y + 4, 104, 205, 0.82 },
}

---岩浆河：(y, 振幅, 相位, 亮度的基准)
local LAVA = {
    { -252, 22, 0.0, 130 }, { -262, 16, 2.1, 96 }, { -244, 28, 4.2, 78 },
}

---鬼火层：(数量, 上浮速度, 半径, 亮度)
local WISP_LAYERS = {
    { n = 26, spd = 0.30, r = 0.16, a = 70 },
    { n = 16, spd = 0.62, r = 0.26, a = 110 },
    { n =  9, spd = 1.05, r = 0.40, a = 150 },
}

---火星层：(数量, 速度, 大小, 亮度, 横向摆幅)
local EMBER_LAYERS = {
    { n = 30, spd = 0.55, s = 0.14, a = 120, sway = 10 },
    { n = 18, spd = 1.10, s = 0.22, a = 170, sway = 18 },
    { n = 10, spd = 1.90, s = 0.34, a = 220, sway = 28 },
}

local function seg(ax, ay, bx, by, alpha, r, g, b, thick)
    if alpha <= 0 then
        return
    end
    local dx, dy = bx - ax, by - ay
    local len = max(abs(dx), abs(dy))
    if len < 1 then
        return
    end
    SetImageState("white", "mul+add", alpha, r, g, b)
    Render("white", (ax + bx) * 0.5, (ay + by) * 0.5, Angle(ax, ay, bx, by),
            len / 16, thick or 0.5)
end

---一根石笋：上尖下宽的多边形，加一条高光边
local function draw_pillar(x, y, hw, h, bright, t, ph)
    local sway = sin(t * 0.6 + ph * 57) * 3
    local tipx = x + sway
    --主体（从暗到亮三层，做出体积）
    for k = 1, 3 do
        local w = hw * (1 - (k - 1) * 0.26)
        local hh = h * (1 - (k - 1) * 0.10)
        SetImageState("white", "mul+add", 26 * bright,
                150 * bright, 96 * bright, 118 * bright)
        Render("white", x + sway * (k - 1) / 2, y + hh * 0.5, 0, w / 8, hh / 16)
    end
    --高光边（左侧受光）
    seg(tipx - hw * 0.5, y + h, x - hw * 0.5, y, 34 * bright, 255, 190, 210, 0.4)
end

function TH19_bg:init()
    --⚠ **必须**先调基类 init：它负责设 `self.group = 0` / `self.layer = -700.1`，
    --  还要把 `lstg.tmpvar.bg` 指过来、`background.Capture(self)`。
    --  漏掉这一句 → 背景没有 group/layer → 它被画在**自机和 boss 上面**，
    --  而这层背景是整屏不透明 → 屏幕上只剩背景（自机和 boss 都看不见）。
    background.init(self, false)
    self.timer = 0
    self.wisps = {}
    for _, L in ipairs(WISP_LAYERS) do
        for _ = 1, L.n do
            self.wisps[#self.wisps + 1] = {
                x = ran:Float(lstg.world.l - 40, lstg.world.r + 40),
                y = ran:Float(lstg.world.b, lstg.world.t),
                spd = L.spd * ran:Float(0.7, 1.3),
                r = L.r * ran:Float(0.7, 1.4),
                a = L.a * ran:Float(0.7, 1.2),
                ph = ran:Float(0, 360),
            }
        end
    end
    self.embers = {}
    for _, L in ipairs(EMBER_LAYERS) do
        for _ = 1, L.n do
            self.embers[#self.embers + 1] = {
                x = ran:Float(lstg.world.l - 40, lstg.world.r + 40),
                y = ran:Float(lstg.world.b, lstg.world.t),
                spd = L.spd * ran:Float(0.7, 1.3),
                s = L.s * ran:Float(0.7, 1.4),
                a = L.a * ran:Float(0.7, 1.2),
                sway = L.sway,
                ph = ran:Float(0, 360),
            }
        end
    end
end

function TH19_bg:frame()
    self.timer = self.timer + 1
    local t = self.timer
    local b, tp = lstg.world.b, lstg.world.t
    for _, w in ipairs(self.wisps) do
        w.y = w.y + w.spd
        w.x = w.x + sin(t * 0.8 + w.ph) * 0.25
        if w.y > tp + 30 then
            w.y = b - 30
            w.x = ran:Float(lstg.world.l - 40, lstg.world.r + 40)
        end
    end
    for _, e in ipairs(self.embers) do
        e.y = e.y + e.spd
        if e.y > tp + 30 then
            e.y = b - 30
            e.x = ran:Float(lstg.world.l - 40, lstg.world.r + 40)
        end
    end
end

function TH19_bg:render()
    local t = self.timer
    local w = lstg.world
    local hw, hh = (w.r - w.l) * 0.5, (w.t - w.b) * 0.5
    local cx = (w.l + w.r) * 0.5

    --① 底色：旧地狱的红褐（上）→ 地底湖的青黑（下），横条渐变
    local BANDS = 24
    local y0 = w.b
    local step = (w.t - w.b) / BANDS
    for i = 0, BANDS - 1 do
        local f = i / (BANDS - 1)          -- 0=底 1=顶
        local r = 18 + 92 * f
        local g = 14 + 34 * f
        local b2 = 26 + 30 * f
        SetImageState("white", "", 255, r, g, b2)
        RenderRect("white", w.l, w.r, y0 + step * i, y0 + step * (i + 1) + 1)
    end
    --顶部一条暗红的天光
    SetImageState("white", "mul+add", 46, 180, 60, 40)
    RenderRect("white", w.l, w.r, w.t - 90, w.t)

    --② 远处的岩浆河：几层明灭的暖光带
    for i, L in ipairs(LAVA) do
        local k = 0.55 + 0.45 * sin(t * 1.1 + L[3] * 40)
        local y = L[1] + sin(t * 0.7 + L[3] * 30) * L[2]
        SetImageState("white", "mul+add", L[4] * k, 255, 120, 40)
        RenderRect("white", w.l, w.r, y - 3, y + 3)
        SetImageState("white", "mul+add", L[4] * k * 0.30, 255, 170, 80)
        RenderRect("white", w.l, w.r, y - 11, y + 11)
        --河面上投下来的反光
        SetImageState("white", "mul+add", L[4] * k * 0.10, 255, 140, 60)
        RenderRect("white", w.l, w.r, y + 3, y + 46)
    end

    --③ 石笋：远 → 中（近的那层不画，留给弹幕）
    for i, p in ipairs(PILLARS) do
        draw_pillar(p[1], p[2], p[3], p[4], p[5], t, i)
    end

    --④ 鬼火：青绿色的浮游光点
    for _, w2 in ipairs(self.wisps) do
        local a = w2.a * (0.7 + 0.3 * sin(t * 2.0 + w2.ph))
        SetImageState("ball_huge6", "mul+add", a * 0.22, 60, 200, 190)
        Render("ball_huge6", w2.x, w2.y, 0, w2.r * 5, w2.r * 5)
        SetImageState("ball_mid6", "mul+add", a, 150, 255, 240)
        Render("ball_mid6", w2.x, w2.y, 0, w2.r, w2.r)
    end

    --⑤ 火星：向上逆流（地底的热气是往上走的）
    for _, e in ipairs(self.embers) do
        local x = e.x + sin(t * 1.4 + e.ph) * e.sway * 0.2
        SetImageState("ellipse6", "mul+add", e.a, 255, 170, 90)
        Render("ellipse6", x, e.y, t * 3 + e.ph, e.s * 1.6, e.s)
    end

    --⑥ 前景压边：底部一条暗带，把画面收住
    SetImageState("white", "", 150, 10, 8, 16)
    RenderRect("white", w.l, w.r, w.b, w.b + 56)
end

---道中飘的火星（无判定，只是把屏幕填亮）
function draw_ember_bg(x, y, rot, size, a)
    if a <= 0 then
        return
    end
    SetImageState("ellipse6", "mul+add", a, 255, 176, 96)
    Render("ellipse6", x, y, rot, size * 1.7, size)
end
