local SetImageState = SetImageState
local SetViewMode = SetViewMode
local Color = Color
local Render4V = Render4V
local Set3D = Set3D
local table = table
local cos, sin = cos, sin
local background = background

TH07_bg = Class(background)
function TH07_bg:init()
    local path = "mod\\BG\\TH07\\TH07_bg_"
    LoadTexture('sth', path .. 'tex.png')
    LoadImageGroup("stair", "sth", 0, 256, 256, 64, 1, 4)
    LoadImage("floor", "sth", 0, 0, 256, 256)
    LoadImageGroup("stair2", "sth", 0, 256, 64, 256, 4, 1)
    background.init(self, false)
    --


    Set3D('eye', 0, 4, -1.2)
    Set3D('at', 0, 0.5, 8.5)
    Set3D('up', 0, 1, 0)
    Set3D('fovy', 1.15)
    Set3D('z', 0.1, 50)
    Set3D('fog', 2.6, 10, Color(255, 108, 70, 80))
    --
    self.os = 0
    self.os2 = 0
    self.fos = 0
    self.leaf = {}
    self.speed = 0.005
    for i = 25, 3, -0.6 do
        table.insert(self.leaf,
                { x = background:RanFloat(-2, 2), y = background:RanFloat(i - 1, i + 1), z = background:RanFloat(i - 1, i + 1),
                  prot = { background:RanFloat(0, 360), 30, 90 },
                  pomiga = { background:RanFloat(self.speed / 0.04, self.speed / 0.02) * background:RanSign(), background:RanFloat(self.speed / 0.04, self.speed / 0.02) * background:RanSign(), background:RanFloat(self.speed / 0.04, self.speed / 0.02) * background:RanSign() },
                  vx = background:RanFloat(-0.002, 0.002), vy = -background:RanFloat(self.speed * 0.3, self.speed * 0.8), vz = -background:RanFloat(self.speed * 0.3, self.speed * 0.8) }
        )
    end
    self.set_col = function(img, a, r, g, b)
        for i = 1, 4 do
            SetImageState(img .. i, "", a, r, g, b)
        end
    end
    task.New(self, function()
        task.Wait(180)
        for i = 1, 270 do
            self.speed = 0.005 + 0.1 * sin(i / 3)
            task.Wait()
        end
    end)
end

function TH07_bg:frame()
    task.Do(self)
    self.os = self.os - self.speed
    self.os2 = self.os2 - self.speed
    self.fos = self.fos - self.speed
    if self.timer % 5 == 0 then
        table.insert(self.leaf, {
            x = background:RanFloat(-0.5, 0.5),
            y = background:RanFloat(26, 24),
            z = background:RanFloat(26, 24),
            prot = { background:RanFloat(0, 360), 30, 90 },
            pomiga = {
                background:RanFloat(self.speed / 0.04, self.speed / 0.02) * background:RanSign(),
                background:RanFloat(self.speed / 0.04, self.speed / 0.02) * background:RanSign(),
                background:RanFloat(self.speed / 0.04, self.speed / 0.02) * background:RanSign()
            },
            vx = background:RanFloat(-0.002, 0.002),
            vy = -background:RanFloat(self.speed * 0.3, self.speed * 0.8),
            vz = -background:RanFloat(self.speed * 0.3, self.speed * 0.8)
        })
    end
    local l
    for i = #self.leaf, 1, -1 do
        l = self.leaf[i]
        l.x = l.x + l.vx
        l.y = l.y + l.vy
        l.z = l.z + l.vz
        l.prot[1] = l.prot[1] + l.pomiga[1]
        l.prot[2] = l.prot[2] + l.pomiga[2]
        l.prot[3] = l.prot[3] + l.pomiga[3]
        if l.y < -1 then
            table.remove(self.leaf, i)
        end
    end
end

function TH07_bg:render()
    SetViewMode '3d'
    background.ClearToFogColor()

    local s = 3
    local j = 1
    self.fos = self.fos % (s * 10)

    for i = -10, 10 do
        j = 1
        for x = -3, 3 do
            Render4V("floor",
                    -s * 0.5 * j + x * s, 2, -s * 0.5 + (i + self.fos / s / 10 * 3) * s,
                    s * 0.5 * j + x * s, 2, -s * 0.5 + (i + self.fos / s / 10 * 3) * s,
                    s * 0.5 * j + x * s, 2, s * 0.5 + (i + self.fos / s / 10 * 3) * s,
                    -s * 0.5 * j + x * s, 2, s * 0.5 + (i + self.fos / s / 10 * 3) * s)
            j = -j
        end
    end
    local scale = 4
    local y = 6
    for i = 10, -10, -1 do
        Render4V("hyz_bg5",
                scale, y + scale, (i + self.fos / s / 10 * 3),
                -scale, y + scale, (i + self.fos / s / 10 * 3),
                -scale, y - scale, (i + self.fos / s / 10 * 3),
                scale, y - scale, (i + self.fos / s / 10 * 3))
    end
    ClearZBuffer()
    SetZBufferEnable(1)

    self.os = self.os % 4
    self.os2 = self.os2 % 10
    local scale2 = 0.3
    local offy = 0.3

    self.set_col("stair2", 255, 50, 50, 50)
    for i = -3, 3 do
        Render4V("stair23",
                -scale2 * 5, scale2 + (i + self.os2 / 10) * scale2 * 10 + offy, scale2 + (i + self.os2 / 10) * scale2 * 10,
                -scale2 * 5, scale2 + (i + self.os2 / 10) * scale2 * 10 - scale2, scale2 + (i + self.os2 / 10) * scale2 * 10,
                -scale2 * 5, scale2 * 11 + (i + self.os2 / 10) * scale2 * 10 - scale2, scale2 * 11 + (i + self.os2 / 10) * scale2 * 10,
                -scale2 * 5, scale2 * 11 + (i + self.os2 / 10) * scale2 * 10 + offy, scale2 * 11 + (i + self.os2 / 10) * scale2 * 10)
        Render4V("stair21",
                -scale2 * 6, scale2 + (i + self.os2 / 10) * scale2 * 10 + offy, scale2 + (i + self.os2 / 10) * scale2 * 10,
                -scale2 * 6, scale2 + (i + self.os2 / 10) * scale2 * 10 - scale2, scale2 + (i + self.os2 / 10) * scale2 * 10,
                -scale2 * 6, scale2 * 11 + (i + self.os2 / 10) * scale2 * 10 - scale2, scale2 * 11 + (i + self.os2 / 10) * scale2 * 10,
                -scale2 * 6, scale2 * 11 + (i + self.os2 / 10) * scale2 * 10 + offy, scale2 * 11 + (i + self.os2 / 10) * scale2 * 10)
        Render4V("stair22",
                scale2 * 5, scale2 + (i + self.os2 / 10) * scale2 * 10 + offy, scale2 + (i + self.os2 / 10) * scale2 * 10,
                scale2 * 5, scale2 + (i + self.os2 / 10) * scale2 * 10 - scale2, scale2 + (i + self.os2 / 10) * scale2 * 10,
                scale2 * 5, scale2 * 11 + (i + self.os2 / 10) * scale2 * 10 - scale2, scale2 * 11 + (i + self.os2 / 10) * scale2 * 10,
                scale2 * 5, scale2 * 11 + (i + self.os2 / 10) * scale2 * 10 + offy, scale2 * 11 + (i + self.os2 / 10) * scale2 * 10)
        Render4V("stair24",
                scale2 * 6, scale2 + (i + self.os2 / 10) * scale2 * 10 + offy, scale2 + (i + self.os2 / 10) * scale2 * 10,
                scale2 * 6, scale2 + (i + self.os2 / 10) * scale2 * 10 - scale2, scale2 + (i + self.os2 / 10) * scale2 * 10,
                scale2 * 6, scale2 * 11 + (i + self.os2 / 10) * scale2 * 10 - scale2, scale2 * 11 + (i + self.os2 / 10) * scale2 * 10,
                scale2 * 6, scale2 * 11 + (i + self.os2 / 10) * scale2 * 10 + offy, scale2 * 11 + (i + self.os2 / 10) * scale2 * 10)
    end

    self.set_col("stair", 255, 255, 255, 255)

    local gr = { 2, 4, 1, 3 }
    for i = -10, 30 do
        Render4V("stair" .. gr[i % 4 + 1],
                -scale2 * 5, (i + self.os) * scale2, scale2 * 0.5 + (i + self.os) * scale2,
                scale2 * 5, (i + self.os) * scale2, scale2 * 0.5 + (i + self.os) * scale2,
                scale2 * 5, (i + self.os) * scale2, -scale2 * 0.5 + (i + self.os) * scale2,
                -scale2 * 5, (i + self.os) * scale2, -scale2 * 0.5 + (i + self.os) * scale2)
    end
    self.set_col("stair", 255, 60, 60, 60)

    for i = -10, 30 do
        Render4V("stair" .. gr[(i + 1) % 4 + 1],
                -scale2 * 5, scale2 + (i + self.os) * scale2, scale2 * 0.5 + (i + self.os) * scale2,
                scale2 * 5, scale2 + (i + self.os) * scale2, scale2 * 0.5 + (i + self.os) * scale2,
                scale2 * 5, (i + self.os) * scale2, scale2 * 0.5 + (i + self.os) * scale2,
                -scale2 * 5, (i + self.os) * scale2, scale2 * 0.5 + (i + self.os) * scale2)
    end
    self.set_col("stair2", 255, 255, 255, 255)

    for i = -3, 3 do
        Render4V("stair22",
                -scale2 * 5, scale2 + (i + self.os2 / 10) * scale2 * 10 + offy, scale2 + (i + self.os2 / 10) * scale2 * 10,
                -scale2 * 6, scale2 + (i + self.os2 / 10) * scale2 * 10 + offy, scale2 + (i + self.os2 / 10) * scale2 * 10,
                -scale2 * 6, scale2 * 11 + (i + self.os2 / 10) * scale2 * 10 + offy, scale2 * 11 + (i + self.os2 / 10) * scale2 * 10,
                -scale2 * 5, scale2 * 11 + (i + self.os2 / 10) * scale2 * 10 + offy, scale2 * 11 + (i + self.os2 / 10) * scale2 * 10)
        Render4V("stair23",
                scale2 * 5, scale2 + (i + self.os2 / 10) * scale2 * 10 + offy, scale2 + (i + self.os2 / 10) * scale2 * 10,
                scale2 * 6, scale2 + (i + self.os2 / 10) * scale2 * 10 + offy, scale2 + (i + self.os2 / 10) * scale2 * 10,
                scale2 * 6, scale2 * 11 + (i + self.os2 / 10) * scale2 * 10 + offy, scale2 * 11 + (i + self.os2 / 10) * scale2 * 10,
                scale2 * 5, scale2 * 11 + (i + self.os2 / 10) * scale2 * 10 + offy, scale2 * 11 + (i + self.os2 / 10) * scale2 * 10)
    end

    SetImageState("small_leaf", "mul+add", 128, 250, 128, 114)
    for _, l in ipairs(self.leaf) do
        Render4V("small_leaf",
                l.x - cos(l.prot[1]) * 0.1 - cos(l.prot[3]) * 0.1, l.y - sin(l.prot[1]) * 0.1 - cos(l.prot[2]) * 0.1, l.z - sin(l.prot[2]) * 0.1 - sin(l.prot[3]) * 0.1,
                l.x - sin(l.prot[1]) * 0.1 - sin(l.prot[3]) * 0.1, l.y + cos(l.prot[1]) * 0.1 - sin(l.prot[2]) * 0.1, l.z + cos(l.prot[2]) * 0.1 + cos(l.prot[3]) * 0.1,
                l.x + cos(l.prot[1]) * 0.1 + cos(l.prot[3]) * 0.1, l.y + sin(l.prot[1]) * 0.1 + cos(l.prot[2]) * 0.1, l.z + sin(l.prot[2]) * 0.1 + sin(l.prot[3]) * 0.1,
                l.x + sin(l.prot[1]) * 0.1 + sin(l.prot[3]) * 0.1, l.y - cos(l.prot[1]) * 0.1 + sin(l.prot[2]) * 0.1, l.z - cos(l.prot[2]) * 0.1 - cos(l.prot[3]) * 0.1)
    end
    SetZBufferEnable(0)
    SetViewMode 'world'
end
