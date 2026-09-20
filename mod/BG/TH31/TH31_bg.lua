---=====================================
---TH31 关卡背景：永夜 Last Word
---纯 2D 世界视图背景，不加载额外文件；
---暗紫底色 + 远景星点 + 三层红白色粒子上浮。
---=====================================

local SetViewMode = SetViewMode
local SetImageState = SetImageState
local RenderRect = RenderRect
local Render = Render
local background = background
local lstg = lstg
local sin, cos, int, max, min = sin, cos, int, max, min

TH31_bg = Class(background)

local HORIZON = -96
local MOTE_LAYERS = {
    { n = 58, spd = 0.18, s0 = 0.16, s1 = 0.28, a0 = 38, a1 = 74, sway = 7, color = { 190, 150, 255 } },
    { n = 36, spd = 0.42, s0 = 0.26, s1 = 0.44, a0 = 68, a1 = 122, sway = 13, color = { 235, 170, 210 } },
    { n = 18, spd = 0.78, s0 = 0.38, s1 = 0.66, a0 = 96, a1 = 170, sway = 20, color = { 255, 220, 225 } },
}

function TH31_bg:init()
    background.init(self, false)
    local w = lstg.world
    self.stars = {}
    for i = 1, 82 do
        self.stars[i] = {
            x = background.RanFloat(self, w.l, w.r),
            y = background.RanFloat(self, HORIZON, w.t),
            r = background.RanFloat(self, 0.5, 1.7),
            p = background.RanFloat(self, 0, 360),
            k = background.RanFloat(self, 0.45, 2.1),
        }
    end
    self.motes = {}
    for li, layer in ipairs(MOTE_LAYERS) do
        local motes = {}
        for i = 1, layer.n do
            motes[i] = {
                x = background.RanFloat(self, w.l - 24, w.r + 24),
                y = background.RanFloat(self, w.b, w.t + 30),
                s = background.RanFloat(self, layer.s0, layer.s1),
                a = background.RanInt(self, layer.a0, layer.a1),
                p = background.RanFloat(self, 0, 360),
                k = background.RanFloat(self, 0.6, 1.8),
                rot = background.RanFloat(self, 0, 360),
                spin = background.RanFloat(self, -1.7, 1.7),
            }
        end
        self.motes[li] = motes
    end
end

function TH31_bg:frame()
    local w = lstg.world
    for li, layer in ipairs(MOTE_LAYERS) do
        for _, mote in ipairs(self.motes[li]) do
            mote.y = mote.y + layer.spd
            mote.x = mote.x + sin(self.timer * 0.012 * mote.k + mote.p) * layer.sway * 0.06
            mote.rot = mote.rot + mote.spin
            if mote.y > w.t + 16 then
                mote.y = w.b - background.RanFloat(self, 4, 36)
                mote.x = background.RanFloat(self, w.l - 24, w.r + 24)
            end
        end
    end
end

function TH31_bg:render()
    SetViewMode "world"
    local w = lstg.world
    local t = self.timer

    local bands = 20
    local band_h = (w.t - HORIZON) / bands
    for i = 1, bands do
        local f = (i - 1) / (bands - 1)
        SetImageState("white", "", 255,
                int(24 + 32 * f), int(6 + 10 * f), int(34 + 52 * f))
        RenderRect("white", w.l, w.r, HORIZON + (i - 1) * band_h, HORIZON + i * band_h)
    end

    SetImageState("white", "mul+add", 48 + 16 * sin(t * 0.011), 120, 46, 150)
    RenderRect("white", w.l, w.r, HORIZON - 64, HORIZON + 18)

    for _, star in ipairs(self.stars) do
        local a = 36 + 76 * (0.5 + 0.5 * sin(t * 0.03 * star.k + star.p))
        SetImageState("white", "mul+add", a, 205, 185, 255)
        Render("ball_mid6", star.x, star.y, 0, star.r * 0.20, star.r * 0.20)
    end

    local cx, cy = 0, HORIZON + 48
    for i = 1, 2 do
        local r = 112 + i * 64
        local a = 16 + i * 7
        local px, py = cx + r, cy
        for k = 1, 64 do
            local x, y = sp.math.EllipsePoint(cx, cy, r, r * 0.46, k * 5.625,
                    t * 0.09 * (i % 2 == 0 and 1 or -1))
            SetImageState("white", "mul+add", a, 255, 132, 188)
            RenderRect("white", min(x, px) - 0.5, max(x, px) + 0.5,
                    min(y, py) - 0.5, max(y, py) + 0.5)
            px, py = x, y
        end
    end

    for li, layer in ipairs(MOTE_LAYERS) do
        for _, mote in ipairs(self.motes[li]) do
            local color = layer.color
            SetImageState("ellipse6", "mul+add", mote.a, color[1], color[2], color[3])
            Render("ellipse6", mote.x, mote.y, mote.rot, mote.s * 1.5, mote.s)
        end
    end

    SetImageState("white", "", 132, 16, 7, 20)
    RenderRect("white", w.l, w.r, w.b, HORIZON)
end
