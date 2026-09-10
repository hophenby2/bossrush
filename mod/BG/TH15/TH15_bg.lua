TH15_bg = Class(background)

local SetViewMode = SetViewMode
local RenderTexture = RenderTexture
local Color = Color
local Set3D = Set3D
local cos, sin = cos, sin
local background = background
local SetImageState = SetImageState
local Render = Render

function TH15_bg:init()
    local path = "mod\\BG\\TH15\\TH15_bg_"

    LoadTexture2("15_moon", path .. "moon.png")
    LoadImageFromFile("15_earth", path .. "earth.png")
    LoadTexture2("15_sea1", path .. "sea1.png")
    LoadTexture2("15_sea2", path .. "sea2.png")
    LoadTexture2("15_wave", path .. "wave.png")

    background.init(self, false)
    self.float = background.RanFloat
    self.int = background.RanInt
    self.sign = background.RanSign
    self.class = TH15_bg
    Set3D('eye', 0, 7, 0)
    Set3D('at', 0, 1, 2.5)
    Set3D('up', 0, 1, 0)
    Set3D('z', 0.1, 50)
    Set3D('fovy', 1)
    Set3D('fog', 0, 0.1, Color(100, 0, 0, 0))
    self.speed = 0.8
    self.zos = 0
    self.alpha = 0
    task.New(self, function()
        local Move3Dcamera = background.Move3Dcamera
        task.Wait(60)
        Move3Dcamera(self, "fog", 1, 3, 600, 2)
        Move3Dcamera(self, "fog", 2, 12, 300, 2)
        Move3Dcamera(self, "eye", 2, 3, 600, 3, true)
        task.Wait(600)
        Move3Dcamera(self, "at", 2, 2, 600, 3)
        task.Wait(300)
        for i = 1, 300 do
            self.alpha = 255 * task.SetMode[1](i / 300)
            task.Wait()
        end
    end)
    task.New(self, function()
        local a, c = 0, 0
        while true do
            if c < 90 then
                c = c + 1
            end
            a = a + sin(c) * 0.3
            lstg.view3d.up[1] = sin(a / 3) * 0.3
            lstg.view3d.eye[1] = sin(a / 5) * 0.6
            task.Wait()
        end
    end)
end
function TH15_bg:frame()
    task.Do(self)
    self.zos = self.zos - self.speed
end

function TH15_bg:render()
    SetViewMode '3d'
    background.ClearToFogColor()
    local color
    local z = self.zos
    local uv1, uv2, uv3, uv4 = {}, {}, {}, {}
    uv1[1], uv1[3] = -8, 18
    uv2[1], uv2[3] = 8, 18
    uv3[1], uv3[3] = 8, -2
    uv4[1], uv4[3] = -8, -2
    color = Color(255, 255, 255, 255)
    uv1[6], uv2[6], uv3[6], uv4[6] = color, color, color, color
    uv1[2], uv2[2], uv3[2], uv4[2] = 0, 0, 0, 0

    uv1[4], uv1[5] = 0, z
    uv2[4], uv2[5] = 2048, z
    uv3[4], uv3[5] = 2048, z + 2560
    uv4[4], uv4[5] = 0, z + 2560
    RenderTexture("15_moon", "", uv1, uv2, uv3, uv4)
    color = Color(220 + 30 * sin(self.timer / 4), 255, 255, 255)
    uv1[6], uv2[6], uv3[6], uv4[6] = color, color, color, color
    uv1[2], uv2[2], uv3[2], uv4[2] = 0.1, 0.1, 0.1, 0.1
    RenderTexture("15_sea1", "", uv1, uv2, uv3, uv4)
    color = Color(220 + 30 * cos(self.timer / 4), 255, 120, 120)
    uv1[6], uv2[6], uv3[6], uv4[6] = color, color, color, color
    uv1[2], uv2[2], uv3[2], uv4[2] = 0.1, 0.1, 0.1, 0.1
    uv1[4], uv1[5] = 256 - z * 0.1, 256 + z * 1.2
    uv2[4], uv2[5] = 2048 + 256 - z * 0.1, 256 + z * 1.2
    uv3[4], uv3[5] = 2048 + 256 - z * 0.1, 2816 + z * 1.2
    uv4[4], uv4[5] = 256 - z * 0.1, 2816 + z * 1.2
    RenderTexture("15_sea2", "mul+add", uv1, uv2, uv3, uv4)
    SetViewMode("world")
    if self.alpha > 0 then
        SetImageState("15_earth", "mul+add", self.alpha, 255, 255, 255)
        Render("15_earth", 70, -30)
        misc.PolarCoordinatesRender("15_wave", 0, 170, 0, 500, 0, 128,
                1, -self.timer * 1.2, "mul+add",
                Color(self.alpha / 1.3, 255, 255, 255), Color(0, 255, 255, 255))
    end
    SetViewMode 'world'
end