TH17_bg = Class(background)

local SetViewMode = SetViewMode
local Color = Color
local Set3D = Set3D
local cos, sin = cos, sin
local background = background
local SetImageState = SetImageState
local Render4V = Render4V
local Forbid = Forbid
local task = task

function TH17_bg:init()
    local path = "mod\\BG\\TH17\\TH17_bg_"
    LoadImageFromFile("17_circle1", path .. "circle1.png")
    SetImageState("17_circle1", "mul+add")
    LoadImageFromFile("17_circle2", path .. "circle2.png")
    SetImageState("17_circle2", "mul+add")
    LoadImageFromFile("17_bright", path .. "bright.png")

    background.init(self, false)
    Set3D('eye', 0, 0, -1.5)
    Set3D('at', 0, 0, 0)
    Set3D('up', 0, 1, 0)
    Set3D('z', 0.1, 120)
    Set3D('fovy', 0.2)
    Set3D('fog', 0, 0.1, Color(100, 10, 10, 40))
    self.float = background.RanFloat
    self.int = background.RanInt
    self.sign = background.RanSign
    self.speed = 0.3
    self.z = 0
    self.circle = {}
    self.bright = {}
    self.building = {}
    self.rx, self.ry = 0, 0
    local AddCircle = TH17_bg.AddCircle
    local AddBright = TH17_bg.AddBright
    local AddBuilding = TH17_bg.AddBuilding

    task.New(self, function()
        task.Wait(22)
        background.Move3Dcamera(self, "fog", 1, 20, 698, 1)
        background.Move3Dcamera(self, "fog", 2, 40, 698, 1, true)
        for i = 1, 698 do
            i = task.SetMode[3](i / 698)
            Set3D('fovy', 0.2 + 0.7 * i)
            task.Wait()
        end
        task.New(self, function()
            for i = 1, 698 do
                i = task.SetMode[3](i / 698)
                Set3D('fovy', 0.9 - 0.25 * i)
                task.Wait()
            end
        end)
        background.Move3Dcamera(self, "at", 1, 0.3, 349, 3, true)
        background.Move3Dcamera(self, "at", 2, -0.3, 349, 3, true)
        background.Move3Dcamera(self, "at", 1, 0, 698, 3)
        for i = 1, 698 do
            Set3D('up', sin(i / 698 * 360) * 2 * sin(i / 698 * 180), 1, 0)
            task.Wait()
        end
        background.Move3Dcamera(self, "at", 2, 0, 698, 3)
        for i = 1, 698 do
            Set3D('eye', 0, sin(i / 698 * 360) * 0.5 * sin(i / 698 * 180), -1.5)
            task.Wait()
        end
    end)
    task.New(self, function()
        local z = -2
        local range
        local rot
        for _ = 1, 10 do
            AddCircle(self, 0, 0, z, self:int(1, 2), 2)
            range = self:float(9, 12)
            rot = self:float(0, 360)
            for i = 1, 30 do
                AddBright(self, 0, 0, z, rot + i * range, 3, 1.2, 0.07)
            end
            z = z + self.speed * 15
            range = self:float(9, 12)
            rot = self:float(0, 360)
            for i = 1, 30 do
                AddBright(self, 0, 0, z, rot + i * range, 1.9, 0.9, 0.1)
            end
            z = z + self.speed * 15
        end
        while true do
            AddCircle(self, 0, 0, z, self:int(1, 2), 2)
            range = self:float(9, 12)
            rot = self:float(0, 360)
            for i = 1, 30 do
                AddBright(self, 0, 0, z, rot + i * range, 3, 1.2, 0.07)
            end
            task.Wait(15)
            range = self:float(9, 12)
            rot = self:float(0, 360)
            for i = 1, 30 do
                AddBright(self, 0, 0, z, rot + i * range, 1.9, 0.9, 0.1)
            end
            task.Wait(15)
        end
    end)
    task.New(self, function()
        local tz = -2
        for _ = 1, 300 do
            AddBright(self, 0, 0, tz, self:float(0, 360), self:float(2.1, 5), 0.1, 0.03, 135, 206, 235)
            tz = tz + self.speed
        end
        while true do
            AddBright(self, 0, 0, tz, self:float(0, 360), self:float(2.1, 5), 0.1, 0.03, 135, 206, 235)
            task.Wait(10)
        end
    end)
    task.New(self, function()
        local z = -2
        local rot = 0
        for _ = 1, 150 do
            AddBright(self, 0, 0, z, self:float(0, 360), 2, 1.2, 0.05)
            AddBright(self, 0, 0, z, self:float(0, 360), 2, 2.3, 0.1)
            for a = 1, 2 do
                AddBright(self, 0, 0, z, a * 180 + rot, 2.3, 1.5, 0.15)
            end
            rot = rot + 13
            z = z + self.speed * 2
        end
        while true do
            AddBright(self, 0, 0, z, self:float(0, 360), 2, 1.2, 0.05)
            AddBright(self, 0, 0, z, self:float(0, 360), 2, 2.3, 0.1)
            AddBright(self, 0, 0, z, self:float(0, 360), self:float(2.1, 5), 0.1, 0.03, 135, 206, 235)
            for a = 1, 2 do
                AddBright(self, 0, 0, z, a * 180 + rot, 2.3, 1.5, 0.15)
            end
            rot = rot + 13
            task.Wait(2)
        end
    end)
    task.New(self, function()
        local z = -2
        for _ = 1, 2 do
            AddBuilding(self, self:float(2, 4) * self:sign(), self:float(-4, -3), z,
                    self:float(1.5, 3.5), self:float(0.08, 0.12),
                    self:float(-45, 45), self:float(0, 360), self:sign() * 0.3, 0.2, 135, 206, 235)
            z = z + self.speed * 150
        end
        while true do
            AddBuilding(self, self:float(2, 4) * self:sign(), self:float(-4, -3), z,
                    self:float(1.5, 3.5), self:float(0.08, 0.12),
                    self:float(-45, 45), self:float(0, 360), self:sign() * 0.3, 0.2, 135, 206, 235)
            task.Wait(150)
        end
    end)
end

function TH17_bg:AddCircle(x, y, z, img, r)
    table.insert(self.circle, { x = x, y = y, z = z, r = r, vz = -self.speed, rz = self:float(0, 360),
                                img = "17_circle" .. img, omiga = self:float(0.3, 0.5) * background:RanSign() })
end
function TH17_bg:AddBright(x, y, z, a, r, speed, size, R, G, B)
    table.insert(self.bright, { x = x + cos(a) * r, y = y + sin(a) * r, z = z, vz = -self.speed * speed,
                                img = "17_bright", s = size, r = R or 135, g = G or 206, b = B or 235 })
end
function TH17_bg:AddBuilding(x, y, z, radius, width, rz, rot, omiga, speed, r, g, b)
    table.insert(self.building, { x = x, y = y, z = z, vz = -self.speed * speed, rz = rz,
                                  radius = radius, width = width, rot = rot, omiga = omiga, r = r, g = g, b = b })
end
local SQRT2 = SQRT2
local function draw_circle(x, y, z, radius, width, rz, rot, a, r, g, b)
    local a1 = 30
    local a2 = a1 / 8
    local ang
    for u = 1, 8 do
        SetImageState("14_43" .. u, "mul+add", a, r, g, b)
    end
    local radius2 = radius - width * 2
    local radius3 = radius - width * 5
    local radius4 = radius3 - width * 2
    local cosrz, sinrz = cos(rz), sin(rz)
    local cosang, sinang, cosang2, sinang2
    for n = 1, 12 do
        for m = 1, 8 do
            ang = n * a1 + a2 * m + rot
            cosang, sinang = cos(ang), sin(ang)
            cosang2, sinang2 = cos(ang + a2), sin(ang + a2)
            Render4V("14_43" .. m,
                    x + cosang * radius * cosrz, y - cosang * radius * sinrz, z + sinang * radius,
                    x + cosang2 * radius * cosrz, y - cosang2 * radius * sinrz, z + sinang2 * radius,
                    x + cosang2 * radius2 * cosrz, y - cosang2 * radius2 * sinrz, z + sinang2 * radius2,
                    x + cosang * radius2 * cosrz, y - cosang * radius2 * sinrz, z + sinang * radius2)
            ang = n * a1 + a2 * m - rot
            cosang, sinang = cos(ang), sin(ang)
            cosang2, sinang2 = cos(ang + a2), sin(ang + a2)
            Render4V("14_43" .. m,
                    x + cosang * radius3 * cosrz, y - cosang * radius3 * sinrz, z + sinang * radius3,
                    x + cosang2 * radius3 * cosrz, y - cosang2 * radius3 * sinrz, z + sinang2 * radius3,
                    x + cosang2 * radius4 * cosrz, y - cosang2 * radius4 * sinrz, z + sinang2 * radius4,
                    x + cosang * radius4 * cosrz, y - cosang * radius4 * sinrz, z + sinang * radius4)
        end
    end
    radius = radius3 - width * 8
    radius = radius * SQRT2
    local rcosr, rsinr = radius * cos(rot), radius * sin(rot)
    SetImageState("17_circle1", "mul+add", a, r, g, b)
    Render4V("17_circle1",
            x + (-rcosr + rsinr) * cosrz, y - (-rcosr + rsinr) * sinrz, z - rcosr - rsinr,
            x + (rcosr + rsinr) * cosrz, y - (rcosr + rsinr) * sinrz, z - rcosr + rsinr,
            x + (rcosr - rsinr) * cosrz, y - (rcosr - rsinr) * sinrz, z + rcosr + rsinr,
            x + (-rcosr - rsinr) * cosrz, y - (-rcosr - rsinr) * sinrz, z + rcosr - rsinr)
    radius = radius - width * 8
    SetImageState("17_circle2", "mul+add", a, r, g, b)
    rcosr, rsinr = radius * cos(-rot), radius * sin(-rot)
    Render4V("17_circle2",
            x + (-rcosr + rsinr) * cosrz, y - (-rcosr + rsinr) * sinrz, z - rcosr - rsinr,
            x + (rcosr + rsinr) * cosrz, y - (rcosr + rsinr) * sinrz, z - rcosr + rsinr,
            x + (rcosr - rsinr) * cosrz, y - (rcosr - rsinr) * sinrz, z + rcosr + rsinr,
            x + (-rcosr - rsinr) * cosrz, y - (-rcosr - rsinr) * sinrz, z + rcosr - rsinr)
end

function TH17_bg:frame()
    task.Do(self)
    self.z = self.z - self.speed
    local c
    for i = #self.circle, 1, -1 do
        c = self.circle[i]
        task.Do(c)
        c.rz = c.rz + c.omiga
        c.z = c.z + c.vz
        if c.z < -5 then
            table.remove(self.circle, i)
        end
    end
    for i = #self.bright, 1, -1 do
        c = self.bright[i]
        task.Do(c)
        c.z = c.z + c.vz
        if c.z < -5 then
            table.remove(self.bright, i)
        end
    end
    for i = #self.building, 1, -1 do
        c = self.building[i]
        task.Do(c)
        c.z = c.z + c.vz
        c.rot = c.rot + c.omiga
        if c.z < -5 - c.radius then
            table.remove(self.building, i)
        end
    end
end

function TH17_bg:render()
    SetViewMode '3d'
    background.ClearToFogColor()
    local r, cosrz, sinrz
    for _, c in ipairs(self.circle) do
        r = c.r
        cosrz = cos(c.rz)
        sinrz = sin(c.rz)
        SetImageState(c.img, "mul+add", Forbid(45 - c.z, 0, 20) / 20 * 200, 135, 206, 235)
        Render4V(c.img,
                c.x - r * cosrz - r * sinrz, c.y + r * cosrz - r * sinrz, c.z,
                c.x + r * cosrz - r * sinrz, c.y + r * cosrz + r * sinrz, c.z,
                c.x + r * cosrz + r * sinrz, c.y - r * cosrz + r * sinrz, c.z,
                c.x - r * cosrz + r * sinrz, c.y - r * cosrz - r * sinrz, c.z)
    end
    for _, c in ipairs(self.bright) do
        r = c.s
        SetImageState(c.img, "mul+add", Forbid(45 - c.z, 0, 20) / 20 * 200, c.r, c.g, c.b)
        Render4V(c.img, c.x - r, c.y + r, c.z, c.x + r, c.y + r, c.z, c.x + r, c.y - r, c.z, c.x - r, c.y - r, c.z)
    end
    --[[
    for _, c in ipairs(self.building) do
        draw_circle(c.x, c.y, c.z, c.radius, c.width, c.rz, c.rot, Forbid(45 - c.z, 0, 20) / 20 * 120, c.r, c.g, c.b)
    end--]]

    SetViewMode 'world'
    --加个暗幕
    SetImageState("white", "", 95, 0, 0, 0)
    local w = lstg.world
    RenderRect("white", w.l, w.r, w.b, w.t)
end