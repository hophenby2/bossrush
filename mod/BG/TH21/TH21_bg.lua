---=====================================
---TH21 关卡背景：西行庭（白玉楼的庭园，夜色）
---  压暗、高饱和的紫红调：弹幕层要比背景亮得多才好读。
---  只用引擎自带的 white / ball_* / ellipse 贴图，不额外加载文件。
---=====================================

local SetImageState = SetImageState
local RenderRect = RenderRect
local Render = Render
local background = background
local lstg = lstg
local sin, cos, int, abs, max, min = sin, cos, int, abs, max, min

TH21_bg = Class(background)

---石灯笼的位置（自绘，三层视差）
local LANTERNS = {
    { -300, -60, 0.55 }, { -140, -70, 0.68 }, { 60, -64, 0.62 },
    { 240, -72, 0.58 },  { 340, -58, 0.50 },
}

---飘落的花瓣层：(数量, 下落速度, 大小, 亮度)
local PETAL_LAYERS = {
    { n = 26, spd = 0.5, s = 0.16, a = 90 },
    { n = 14, spd = 1.1, s = 0.26, a = 140 },
    { n = 8,  spd = 1.9, s = 0.38, a = 190 },
}

local function seg(ax, ay, bx, by, alpha, r, g, b, thick)
    if alpha <= 0 then return end
    local dx, dy = bx - ax, by - ay
    local len = max(abs(dx), abs(dy))
    if len < 1 then return end
    SetImageState("white", "mul+add", alpha, r, g, b)
    Render("white", (ax + bx) * 0.5, (ay + by) * 0.5, Angle(ax, ay, bx, by), len / 16, thick or 0.5)
end

---一座石灯笼：柱子 + 顶 + 一点暖光
local function draw_lantern(x, y, bright, t, ph)
    local f = 0.75 + 0.25 * sin(t * 2 + ph * 40)
    seg(x, y, x, y + 70, 60 * bright, 120, 96, 128, 0.9)
    seg(x - 16, y + 70, x + 16, y + 70, 48 * bright, 120, 96, 128, 0.7)
    SetImageState("ball_huge6", "mul+add", 40 * bright * f, 200, 150, 90)
    Render("ball_huge6", x, y + 40, 0, 1.5, 1.5)
    SetImageState("ball_mid6", "mul+add", 150 * bright * f, 255, 215, 150)
    Render("ball_mid6", x, y + 40, 0, 0.35, 0.35)
end

function TH21_bg:init()
    --⚠ 必须先调基类 init：它负责设 group / layer，并把 lstg.tmpvar.bg 指过来。
    --  漏掉这一句，背景会被画在自机和 boss 上面（屏幕上只剩背景）。
    background.init(self, false)
    self.timer = 0
    self.petals = {}
    for _, L in ipairs(PETAL_LAYERS) do
        for _ = 1, L.n do
            self.petals[#self.petals + 1] = {
                x = ran:Float(lstg.world.l - 40, lstg.world.r + 40),
                y = ran:Float(lstg.world.b, lstg.world.t),
                spd = L.spd * ran:Float(0.7, 1.3),
                s = L.s * ran:Float(0.7, 1.4),
                a = L.a * ran:Float(0.7, 1.2),
                sway = ran:Float(0, 360),
                spin = ran:Float(-3, 3),
                rot = ran:Float(0, 360),
            }
        end
    end
end

function TH21_bg:frame()
    self.timer = self.timer + 1
    local t = self.timer
    local b, tp = lstg.world.b, lstg.world.t
    for _, p in ipairs(self.petals) do
        p.y = p.y - p.spd
        p.sway = p.sway + 3
        p.rot = p.rot + p.spin
        p.x = p.x + sin(p.sway) * 0.5
        if p.y < b - 30 then
            p.y = tp + 30
            p.x = ran:Float(lstg.world.l - 40, lstg.world.r + 40)
        end
    end
end

function TH21_bg:render()
    local t = self.timer
    local w = lstg.world

    --① 底色：上方紫黑 → 下方暗红（冥界的夜色）
    local BANDS = 20
    local y0 = w.b
    local step = (w.t - w.b) / BANDS
    for i = 0, BANDS - 1 do
        local f = i / (BANDS - 1)
        SetImageState("white", "", 255, 22 + 46 * f, 10 + 18 * f, 30 + 44 * f)
        RenderRect("white", w.l, w.r, y0 + step * i, y0 + step * (i + 1) + 1)
    end

    --② 远处的一轮月（西行妖的庭园挂着一轮冷月）
    SetImageState("ball_huge6", "mul+add", 34, 180, 190, 255)
    Render("ball_huge6", 120, 150, 0, 5.5, 5.5)
    SetImageState("ball_big6", "mul+add", 130, 226, 232, 255)
    Render("ball_big6", 120, 150, 0, 0.85, 0.85)

    --③ 石灯笼（自绘，带一点暖光）
    for i, L in ipairs(LANTERNS) do
        draw_lantern(L[1], L[2], L[3], t, i)
    end

    --④ 飘落的花瓣
    for _, p in ipairs(self.petals) do
        SetImageState("ellipse6", "mul+add", p.a, 255, 190, 226)
        Render("ellipse6", p.x, p.y, p.rot, p.s * 1.6, p.s)
    end

    --⑤ 底部压边
    SetImageState("white", "", 140, 12, 6, 18)
    RenderRect("white", w.l, w.r, w.b, w.b + 50)
end
