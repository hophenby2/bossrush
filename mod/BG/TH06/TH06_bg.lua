local SetImageState = SetImageState
local SetViewMode = SetViewMode
local Render = Render
local RenderTexture = RenderTexture
local Color = Color
local background = background

TH06_bg = Class(background)

function TH06_bg:init()
    local path = "mod\\BG\\TH06\\TH06_bg_"
    LoadTexture2('06_mask', path .. 'mask.png')
    LoadImageFromFile('06_moon', path .. 'moon.png')

    SetImageState("06_moon", "", 150, 255, 255, 255)
    background.init(self, false)
end

function TH06_bg:render()
    SetViewMode 'world'
    Render("06_moon", 32, 64)
    local t = self.timer
    local c
    c = Color(150, 250, 128, 114)
    local uv1, uv2, uv3, uv4 = { [3] = 0.5 }, { [3] = 0.5 }, { [3] = 0.5 }, { [3] = 0.5 }
    uv1[6], uv2[6], uv3[6], uv4[6] = c, c, c, c

    uv1[1], uv1[2], uv1[4], uv1[5] = 750, -750, 0 - t / 2, 0
    uv2[1], uv2[2], uv2[4], uv2[5] = -750, -750, 768 - t / 2, 0
    uv3[1], uv3[2], uv3[4], uv3[5] = -750, 750, 768 - t / 2, 768
    uv4[1], uv4[2], uv4[4], uv4[5] = 750, 750, 0 - t / 2, 768
    RenderTexture("06_mask", "mul+add", uv1, uv2, uv3, uv4)
    c = Color(80, 230, 240, 235)
    uv1[6], uv2[6], uv3[6], uv4[6] = c, c, c, c

    uv1[1], uv1[2], uv1[4], uv1[5] = 800, -800, 0 - t - 50, 0
    uv2[1], uv2[2], uv2[4], uv2[5] = -800, -800, 768 - t - 50, 0
    uv3[1], uv3[2], uv3[4], uv3[5] = -800, 800, 768 - t - 50, 768
    uv4[1], uv4[2], uv4[4], uv4[5] = 800, 800, 0 - t - 50, 768
    RenderTexture("06_mask", "mul+add", uv1, uv2, uv3, uv4)
end
