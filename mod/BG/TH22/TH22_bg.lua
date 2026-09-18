---=====================================
---TH22 关卡背景：西行庭·千樱夜宴
---  纯 2D 世界视图背景，不加载额外资源；
---  静态底色 + 远景结界 + 三层落樱视差。
---=====================================

local SetViewMode = SetViewMode
local SetImageState = SetImageState
local RenderRect = RenderRect
local Render = Render
local background = background
local lstg = lstg
local sin, cos, int, max = sin, cos, int, max

TH22_bg = Class(background)

local HORIZON = -64
local PETAL_LAYERS = {
    { n = 84, spd = 0.20, s0 = 0.28, s1 = 0.48, a0 = 64,  a1 = 122, sway = 9 },
    { n = 52, spd = 0.50, s0 = 0.44, s1 = 0.72, a0 = 112, a1 = 180, sway = 16 },
    { n = 28, spd = 0.90, s0 = 0.70, s1 = 1.12, a0 = 160, a1 = 246, sway = 24 },
}

function TH22_bg:init()
    background.init(self, false)
    local w = lstg.world
    self.stars = {}
    for i = 1, 88 do
        self.stars[i] = {
            x = background.RanFloat(self, w.l, w.r),
            y = background.RanFloat(self, HORIZON, w.t),
            r = background.RanFloat(self, 0.5, 1.5),
            p = background.RanFloat(self, 0, 360),
            k = background.RanFloat(self, 0.5, 2.2),
        }
    end
    self.petals = {}
    for li, L in ipairs(PETAL_LAYERS) do
        local petals = {}
        for i = 1, L.n do
            petals[i] = {
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
        self.petals[li] = petals
    end
end

function TH22_bg:frame()
    local w = lstg.world
    for li, L in ipairs(PETAL_LAYERS) do
        for _, p in ipairs(self.petals[li]) do
            p.y = p.y - L.spd
            p.x = p.x + sin(self.timer * 0.012 * p.k + p.p) * L.sway * 0.06
            p.rot = p.rot + p.spin
            if p.y < w.b - 12 then
                p.y = w.t + background.RanFloat(self, 6, 40)
                p.x = background.RanFloat(self, w.l - 20, w.r + 20)
            end
        end
    end
end

function TH22_bg:render()
    SetViewMode 'world'
    local w = lstg.world
    local t = self.timer

    local bands = 16
    local band_h = (w.t - HORIZON) / bands
    for i = 1, bands do
        local f = (i - 1) / (bands - 1)
        SetImageState("white", "", 255,
                int(10 + 12 * f), int(7 + 6 * f), int(28 + 20 * f))
        RenderRect("white", w.l, w.r, HORIZON + (i - 1) * band_h, HORIZON + i * band_h)
    end

    SetImageState("white", "mul+add", 54 + 14 * sin(t * 0.013), 76, 54, 96)
    RenderRect("white", w.l, w.r, HORIZON - 48, HORIZON + 12)

    for _, s in ipairs(self.stars) do
        local a = 40 + 84 * (0.5 + 0.5 * sin(t * 0.03 * s.k + s.p))
        SetImageState("white", "mul+add", a, 225, 210, 255)
        Render("ball_mid6", s.x, s.y, 0, s.r * 0.20, s.r * 0.20)
    end

    local cx, cy = (w.l + w.r) * 0.5, -14
    for i = 1, 3 do
        local r = 90 + i * 52
        local a = 22 + i * 8
        SetImageState("white", "mul+add", a, 255, 172, 208)
        local px = cx + r
        local py = cy
        for k = 1, 72 do
            local x, y = sp.math.EllipsePoint(cx, cy, r, r * 0.58, k * 5, t * 0.10 * (i % 2 == 0 and 1 or -1))
            SetImageState("white", "mul+add", a, 255, 172, 208)
            RenderRect("white", min(x, px) - 0.5, max(x, px) + 0.5,
                    min(y, py) - 0.5, max(y, py) + 0.5)
            px, py = x, y
        end
    end

    for li, L in ipairs(PETAL_LAYERS) do
        for _, p in ipairs(self.petals[li]) do
            SetImageState("ellipse6", "mul+add", p.a, 255, 190, 214)
            Render("ellipse6", p.x, p.y, p.rot, p.s * 1.5, p.s)
        end
    end

    SetImageState("white", "", 130, 12, 8, 18)
    RenderRect("white", w.l, w.r, w.b, HORIZON)
end
