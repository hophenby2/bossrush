---=====================================
---TH03 关卡背景：白玉楼
---  静态循环背景，不参与弹幕逻辑，全部在 world 视图下 2D 绘制：
---    · 夜色天幕：深靛蓝 → 地平线附近偏紫的渐变
---    · 高悬的淡月
---    · 远处的楼阁剪影（白玉楼本体，几层屋檐 + 塔尖）
---    · 西行妖：一棵巨大的樱树，树干 + 一整片泛粉光的树冠
---    · 三层视差的落樱（越近的越大越亮、飘得越快）
---    · 底部的冥界之雾
---  只依赖引擎自带的 white / ball_* / moon 贴图，不额外加载文件。
---=====================================

local SetViewMode = SetViewMode
local SetImageState = SetImageState
local RenderRect = RenderRect
local Render = Render
local background = background
local lstg = lstg
local sin, cos, int, abs, sqrt, max = sin, cos, int, abs, sqrt, max

TH03_bg = Class(background)

---地平面（world 坐标）：这一条线以下是冥界的地面
local HORIZON = -46
---那轮淡月
local MOON_X, MOON_Y = -196, 166
---西行妖的树干底部位置
local TREE_X = -46
---树冠中心与半径
local TREE_CY, TREE_R = 96, 132
---远处楼阁的水平位置
local PAGODA_X = 168

---落樱视差层：{数量, 下落速度, 尺寸范围, 亮度范围, 横向摆幅}
local PETAL_LAYERS = {
    { n = 96, spd = 0.22, s0 = 0.30, s1 = 0.52, a0 = 70,  a1 = 130, sway = 10 },
    { n = 58, spd = 0.52, s0 = 0.46, s1 = 0.80, a0 = 120, a1 = 190, sway = 17 },
    { n = 30, spd = 1.00, s0 = 0.72, s1 = 1.20, a0 = 170, a1 = 255, sway = 26 },
}

---树冠上那几团最亮的花簇（相对树冠中心的偏移与大小）
local BLOSSOM = {
    { -0.62, 0.10, 0.62 }, { -0.34, 0.44, 0.54 }, { 0.00, 0.56, 0.60 },
    { 0.36, 0.42, 0.52 }, { 0.64, 0.08, 0.58 }, { -0.30, -0.22, 0.66 },
    { 0.10, -0.34, 0.72 }, { 0.44, -0.16, 0.56 }, { -0.06, 0.16, 0.86 },
}

---楼阁的剪影色
local SIL = 26

---画一层向上收的屋檐：几条横带堆出来，越往上越窄
local function roof(cx, cy, half, h)
    for k = 0, 4 do
        local f = k / 4
        local hw = half * (1 - f * 0.62)
        local yy = cy + h * f
        SetImageState("white", "", 255, SIL, SIL, int(SIL * 1.5))
        RenderRect("white", cx - hw, cx + hw, yy, yy + h * 0.26 + 1)
    end
end

---剪影用的一笔实心矩形
local function sil_rect(x1, x2, y1, y2)
    SetImageState("white", "", 255, SIL, SIL, int(SIL * 1.5))
    RenderRect("white", x1, x2, y1, y2)
end

function TH03_bg:init()
    background.init(self, false)
    local w = lstg.world
    self.stars = {}
    for i = 1, 110 do
        self.stars[i] = {
            x = background.RanFloat(self, w.l, w.r),
            y = background.RanFloat(self, HORIZON + 6, w.t),
            r = background.RanFloat(self, 0.5, 1.6),
            p = background.RanFloat(self, 0, 360),
            k = background.RanFloat(self, 0.5, 2.4),
        }
    end
    self.petals = {}
    for li = 1, #PETAL_LAYERS do
        local L = PETAL_LAYERS[li]
        local t = {}
        for i = 1, L.n do
            t[i] = {
                x = background.RanFloat(self, w.l - 20, w.r + 20),
                y = background.RanFloat(self, w.b, w.t + 30),
                s = background.RanFloat(self, L.s0, L.s1),
                a = background.RanInt(self, L.a0, L.a1),
                p = background.RanFloat(self, 0, 360),
                k = background.RanFloat(self, 0.6, 1.8),
                rot = background.RanFloat(self, 0, 360),
                spin = background.RanFloat(self, -1.6, 1.6),
            }
        end
        self.petals[li] = t
    end
end

function TH03_bg:frame()
    local w = lstg.world
    --落樱：往下飘，同时横向慢慢摆
    for li = 1, #PETAL_LAYERS do
        local L, t = PETAL_LAYERS[li], self.petals[li]
        for i = 1, #t do
            local s = t[i]
            s.y = s.y - L.spd
            s.x = s.x + sin(self.timer * 0.012 * s.k + s.p) * L.sway * 0.06
            s.rot = s.rot + s.spin
            if s.y < w.b - 12 then
                s.y = w.t + background.RanFloat(self, 6, 40)
                s.x = background.RanFloat(self, w.l - 20, w.r + 20)
            end
        end
    end
end

function TH03_bg:render()
    SetViewMode 'world'
    local w = lstg.world
    local t = self.timer

    ------------------------------------------------------------------
    --夜空：越靠上越深，地平线附近转成偏紫
    ------------------------------------------------------------------
    local SN = 12
    local sh = (w.t - HORIZON) / SN
    for i = 1, SN do
        local f = (i - 1) / (SN - 1)          -- 0 = 地平线附近, 1 = 画面顶端
        SetImageState("white", "", 255, int(6 + 10 * f), int(8 + 8 * f), int(26 + 26 * f))
        RenderRect("white", w.l, w.r, HORIZON + (i - 1) * sh, HORIZON + i * sh)
    end

    ------------------------------------------------------------------
    --星点
    ------------------------------------------------------------------
    local stars = self.stars
    for i = 1, #stars do
        local s = stars[i]
        local a = 60 + 150 * (0.5 + 0.5 * sin(t * 0.03 * s.k + s.p))
        SetImageState("white", "mul+add", a, 216, 226, 255)
        local r = s.r * 0.85
        RenderRect("white", s.x - r, s.x + r, s.y - r, s.y + r)
    end

    ------------------------------------------------------------------
    --淡月
    ------------------------------------------------------------------
    SetImageState("ball_huge6", "mul+add", 40, 170, 180, 235)
    Render("ball_huge6", MOON_X, MOON_Y, 0, 1.45, 1.45)
    SetImageState("moon", "", 232, 236, 240, 255)
    Render("moon", MOON_X, MOON_Y, 0, 0.62, 0.62)
    SetImageState("ball_big6", "mul+add", 60, 210, 220, 255)
    Render("ball_big6", MOON_X, MOON_Y, 0, 0.72, 0.72)

    ------------------------------------------------------------------
    --远处的楼阁剪影：白玉楼本体（三层屋檐 + 塔尖）
    ------------------------------------------------------------------
    sil_rect(PAGODA_X - 26, PAGODA_X + 26, HORIZON, 24)
    roof(PAGODA_X, 24, 44, 26)
    sil_rect(PAGODA_X - 17, PAGODA_X + 17, 50, 78)
    roof(PAGODA_X, 78, 36, 22)
    sil_rect(PAGODA_X - 10, PAGODA_X + 10, 100, 124)
    roof(PAGODA_X, 124, 26, 18)
    sil_rect(PAGODA_X - 1.2, PAGODA_X + 1.2, 142, 158)

    ------------------------------------------------------------------
    --西行妖：树干
    ------------------------------------------------------------------
    local trunk = 22
    for k = 0, 9 do
        local f = k / 9
        local hw = trunk * (1 - f * 0.72)
        local yy = HORIZON + f * 96
        SetImageState("white", "", 255, 16, 10, 22)
        RenderRect("white", TREE_X - hw, TREE_X + hw, yy, yy + 12)
    end
    --两根主枝
    for _, br in ipairs({ { -1, 0.55 }, { 1, 0.62 } }) do
        local dir, y0 = br[1], br[2] * 96 + HORIZON
        for k = 0, 7 do
            local f = k / 7
            local x = TREE_X + dir * f * 58
            local y = y0 + f * 46
            local hw = 7 * (1 - f * 0.7)
            SetImageState("white", "", 255, 16, 10, 22)
            RenderRect("white", x - hw, x + hw, y - 5, y + 5)
        end
    end

    ------------------------------------------------------------------
    --西行妖：树冠（一大片泛粉光的花）
    ------------------------------------------------------------------
    local breathe = 0.94 + 0.06 * sin(t * 0.018)
    for i = 1, #BLOSSOM do
        local b = BLOSSOM[i]
        local bx = TREE_X + b[1] * TREE_R
        local by = TREE_CY + b[2] * TREE_R * 0.62
        local s = b[3] * TREE_R / 64 * breathe
        --外圈：偏紫的底光
        SetImageState("ball_huge6", "mul+add", 30, 150, 92, 190)
        Render("ball_huge6", bx, by, 0, s * 1.5, s * 1.35)
        --中层：粉
        SetImageState("ball_huge6", "mul+add", 44, 244, 156, 208)
        Render("ball_huge6", bx, by, 0, s, s * 0.9)
        --花心：偏白的高光
        SetImageState("ball_big6", "mul+add", 52, 255, 226, 240)
        Render("ball_big6", bx, by, 0, s * 0.5, s * 0.46)
    end
    --树冠整体再蒙一层薄光，把花簇粘成一片
    SetImageState("ball_huge6", "mul+add", 20, 216, 130, 196)
    Render("ball_huge6", TREE_X, TREE_CY, 0, TREE_R * 0.036, TREE_R * 0.028)

    ------------------------------------------------------------------
    --一层压在地平线上的紫雾，把树和楼阁的根埋进去
    ------------------------------------------------------------------
    SetImageState("ball_huge6", "mul+add", 54, 96, 52, 130)
    Render("ball_huge6", 0, HORIZON + 6, 0, 5.2, 0.7)
    SetImageState("ball_huge6", "mul+add", 30, 150, 92, 180)
    Render("ball_huge6", 0, HORIZON + 26, 0, 4.0, 0.5)

    ------------------------------------------------------------------
    --冥界的地面
    ------------------------------------------------------------------
    local GN = 5
    local gh = (HORIZON - w.b) / GN
    for i = 1, GN do
        local f = (i - 1) / (GN - 1)
        local k = 1 - f                        -- 0 = 地平线附近, 1 = 画面底端
        SetImageState("white", "", 255, int(8 + 10 * k), int(6 + 6 * k), int(20 + 16 * k))
        RenderRect("white", w.l, w.r, w.b + (i - 1) * gh, w.b + i * gh)
    end

    ------------------------------------------------------------------
    --三层视差落樱（画在地面之上、最靠近镜头）
    ------------------------------------------------------------------
    for li = 1, #PETAL_LAYERS do
        local t2 = self.petals[li]
        for i = 1, #t2 do
            local s = t2[i]
            SetImageState("ellipse6", "mul+add", s.a, 255, 190, 220)
            Render("ellipse6", s.x, s.y, s.rot, s.s * 1.5, s.s)
        end
    end
end
