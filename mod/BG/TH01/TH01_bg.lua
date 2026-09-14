---=====================================
---TH01 关卡背景：月夜 · 水天
---  静态循环背景，不参与弹幕逻辑，全部用 world 视图下的 2D 绘制完成：
---    · 水天交界线以上：深蓝夜空 + 闪烁星点 + 一轮静止的淡月
---    · 水天交界线以下：水面 + 横向波光 + 月亮的倒影
---  只用引擎自带的 "white" 贴图与子弹贴图，不依赖额外文件。
---=====================================

local SetViewMode = SetViewMode
local SetImageState = SetImageState
local RenderRect = RenderRect
local Render = Render
local background = background
local lstg = lstg
local sin, int = sin, int

TH01_bg = Class(background)

---水天交界线（world 坐标）
local HORIZON = -60
---星点数量
local STAR_N = 120
---水面波光数量
local WAVE_N = 26
---天上那轮静止的淡月
local MOON_X, MOON_Y = 108, 158

function TH01_bg:init()
    background.init(self, false)
    local w = lstg.world
    self.stars = {}
    for i = 1, STAR_N do
        self.stars[i] = {
            x = background.RanFloat(self, w.l, w.r),
            y = background.RanFloat(self, HORIZON + 4, w.t),
            r = background.RanFloat(self, 0.5, 1.7),
            p = background.RanFloat(self, 0, 360),
            k = background.RanFloat(self, 0.6, 2.6),
        }
    end
    self.waves = {}
    for i = 1, WAVE_N do
        self.waves[i] = {
            y = background.RanFloat(self, w.b - 4, HORIZON - 6),
            x = background.RanFloat(self, w.l, w.r),
            len = background.RanFloat(self, 22, 116),
            a = background.RanInt(self, 12, 44),
            spd = background.RanFloat(self, 0.10, 0.32),
            p = background.RanFloat(self, 0, 360),
        }
    end
end

function TH01_bg:frame()
    local w = lstg.world
    local ws = self.waves
    for i = 1, #ws do
        local s = ws[i]
        s.x = s.x + s.spd
        if s.x - s.len * 0.5 > w.r then
            s.x = w.l - s.len * 0.5
            s.y = background.RanFloat(self, w.b - 4, HORIZON - 6)
        end
    end
end

function TH01_bg:render()
    SetViewMode 'world'
    local w = lstg.world
    local t = self.timer

    ------------------------------------------------------------------
    --夜空：纵向渐变（越靠上越深）
    ------------------------------------------------------------------
    local SN = 9
    local sh = (w.t - HORIZON) / SN
    for i = 1, SN do
        local f = (i - 1) / (SN - 1)          -- 0 = 地平线附近, 1 = 画面顶端
        SetImageState("white", "", 255, int(4 + 7 * f), int(9 + 19 * f), int(30 + 36 * f))
        RenderRect("white", w.l, w.r, HORIZON + (i - 1) * sh, HORIZON + i * sh)
    end

    ------------------------------------------------------------------
    --星点：每颗按自己的频率闪烁
    ------------------------------------------------------------------
    local stars = self.stars
    for i = 1, #stars do
        local s = stars[i]
        local a = 80 + 130 * (0.5 + 0.5 * sin(t * 0.035 * s.k + s.p))
        SetImageState("white", "mul+add", a, 214, 232, 255)
        local r = s.r * 0.85
        RenderRect("white", s.x - r, s.x + r, s.y - r, s.y + r)
    end

    ------------------------------------------------------------------
    --天上那轮静止的淡月
    ------------------------------------------------------------------
    SetImageState("ball_huge6", "mul+add", 46, 150, 190, 255)
    Render("ball_huge6", MOON_X, MOON_Y, 0, 1.15, 1.15)
    SetImageState("ball_huge6", "mul+add", 70, 175, 205, 255)
    Render("ball_huge6", MOON_X, MOON_Y, 0, 0.86, 0.86)
    SetImageState("ball_big6", "mul+add", 150, 225, 240, 255)
    Render("ball_big6", MOON_X, MOON_Y, 0, 0.66, 0.66)

    ------------------------------------------------------------------
    --水面：底色比天空略深，靠地平线一侧偏亮
    ------------------------------------------------------------------
    local WN = 6
    local wh = (HORIZON - w.b) / WN
    for i = 1, WN do
        local f = (i - 1) / (WN - 1)          -- 0 = 地平线附近, 1 = 画面底端
        local k = 1 - f
        SetImageState("white", "", 255, int(5 + 9 * k), int(14 + 20 * k), int(30 + 32 * k))
        RenderRect("white", w.l, w.r, w.b + (i - 1) * wh, w.b + i * wh)
    end

    ------------------------------------------------------------------
    --月亮的倒影：一列越往下越窄越暗、随波摇晃的碎光
    ------------------------------------------------------------------
    for i = 1, 14 do
        local f = i / 14
        local y = HORIZON - f * (HORIZON - w.b) * 0.92
        local wob = sin(t * 0.05 + i * 0.7) * (6 + 26 * f)
        local half = (1 - f) * 26 + 3
        SetImageState("white", "mul+add", int(70 * (1 - f) + 10), 190, 220, 255)
        RenderRect("white", MOON_X + wob - half, MOON_X + wob + half, y - 0.9, y + 0.9)
    end

    ------------------------------------------------------------------
    --波光：缓慢横向漂移的短横线
    ------------------------------------------------------------------
    local waves = self.waves
    for i = 1, #waves do
        local s = waves[i]
        local a = s.a * (0.55 + 0.45 * sin(t * 0.04 + s.p))
        SetImageState("white", "mul+add", a, 168, 208, 255)
        RenderRect("white", s.x - s.len * 0.5, s.x + s.len * 0.5, s.y - 0.7, s.y + 0.7)
    end
end
