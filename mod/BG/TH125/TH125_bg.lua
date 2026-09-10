TH125_bg = Class(background)

function TH125_bg:data_init()
    TH125_bg.building = {}
    local b
    for x = -7, 7 do
        for z = -7, 7 do
            b = {}
            for _x = -4, 4 do
                for _z = -4, 4 do
                    if math.random(0, 10) == 0 then
                        table.insert(b, { x = _x, z = _z, alpha = self:float(180, 255), t = self:int(1, 360), c = self:int(2, 3) })
                    end
                end
            end
            if math.random(0, 5) == 0 then
                table.insert(TH125_bg.building, { x, z, self:float(-2, 1), self:float(0.3, 0.4), b, ColorList[self:int(1, 7)] })
            end
        end
    end
end

local SetViewMode = SetViewMode
local Color = Color
local Set3D = Set3D
local table = table
local cos, sin = cos, sin
local background = background
local SetImageState = SetImageState
local Render4V = Render4V

local t_ = {  }
local int = int
local Angle = Angle
for i = 1, 360 do
    table.insert(t_, cos(i))
end
local function Cos(t)
    t = (int(t) - 1) % 360 + 1
    return t_[t]
end
local function Sin(t)
    t = (int(t) + 90 - 1) % 360 + 1
    return t_[t]
end

function TH125_bg.rotate3D(x, y, z, ax, ay, offx, offy, offz)
    x, z = x * Cos(ay) - z * Sin(ay), z * Cos(ay) + x * Sin(ay)
    y, z = y * Cos(ax) - z * Sin(ax), z * Cos(ax) + y * Sin(ax)
    return x + offx, y + offy, z + offz
end
local rotate = TH125_bg.rotate3D
function TH125_bg:init()

    local path = "mod\\BG\\TH125\\TH125_bg_"
    LoadImageFromFile("125_building", path .. "building.png")
    LoadImageFromFile("125_cloud", path .. "cloud.png")
    LoadImageFromFile("125_sky", path .. "sky.png")
    LoadTexture("125_smoke", path .. "smoke.png")
    LoadImageGroup("125_smoke", "125_smoke", 0, 0, 16, 128, 2, 1)

    background.init(self)
    self.float = background.RanFloat
    self.int = background.RanInt
    self.sign = background.RanSign
    TH125_bg.data_init(self)
    Set3D('eye', 0.5, 4, -5.5)
    Set3D('at', -0.5, 3, 0)
    Set3D('up', 0, 1, 0)
    Set3D('z', 0.1, 100)
    Set3D('fovy', 0.7)
    Set3D('fog', 6, 12, Color(100, 10, 0, 20))
    self.speed = 0.005
    self.os = 0
    self.rocket = {}
    self.smear = {}
    self.particle = {}
    self.smoke = {}
    self.Newrocket = function(self, x, z, vy, lifetime, color)
        table.insert(self.rocket, { x = x, y = 0, z = z,
                                    vy = vy, time = lifetime, timer = 0, color = color })
    end
    self.Newsmear = function(self, x, y, z, color, size)
        table.insert(self.smear, {
            x = x, y = y, z = z,
            alpha = 255, time = 15, color = color, size = size,
            point = { {}, {}, {}, {} }
        })
    end
    local n1, n2 = 5, 5
    self.rocketBoom = function(self, x, y, z, color)
        for i = 360 / n1, 361, 360 / n1 do
            for c = 180 / n2, 181, 180 / n2 do
                table.insert(self.particle, { x = x, y = y, z = z,
                                              vx = 0.02 * Cos(i) * Sin(c) + self:float(-0.005, 0.005),
                                              vy = 0.02 * Sin(i) * Sin(c) + self:float(-0.005, 0.005),
                                              vz = 0.02 * Cos(c) + self:float(-0.005, 0.005),
                                              ay = -self:float(0.005, 0.02) / 60,
                                              time = self:int(60, 100), color = color, timer = 0, size = self:float(1, 2) })
            end
        end
    end
    task.New(self, function()
        local MC = background.Move3Dcamera
        MC(self, "eye", 3, 0.5, 180, 2)
        MC(self, "at", 3, 5.5, 180, 2)
        MC(self, "at", 1, 1, 180, 3, true)
        MC(self, "eye", 2, 7, 180, 3)
        MC(self, "at", 2, 6, 180, 3, true)
        local a = 0
        local c = 0
        local v = lstg.view3d
        while true do
            v.eye[1] = -2.5 + 3 * cos(a)
            v.eye[2] = 7 + 3 * sin(a / 3)
            v.eye[3] = 0.5 + 3 * sin(a)
            v.at[1] = 1 + 3 * sin(a / 6)
            v.at[2] = 6 - 2 * sin(a / 2)
            v.at[3] = 5.5 - 2 * sin(a / 8)
            v.up[1] = 2 * sin(a / 10)
            v.up[3] = sin(a / 15)
            task.Wait()
            a = a + sin(c) * 0.6
            if c < 90 then
                c = c + 1
            end
        end
    end)
end
function TH125_bg:frame()
    task.Do(self)
    self.os = self.os + self.speed
    local ax, ay
    local eye = lstg.view3d.eye
    local at = lstg.view3d.at
    do
        if self.timer % 8 == 0 then
            table.insert(self.smoke, { img = self:int(1, 2),
                                       x = int(eye[1]) + self:int(2, 6) * sign(at[1] - eye[1]) + self:sign() * 0.5,
                                       y1 = -1, y2 = self:float(-6, -15),
                                       z = int(eye[3]) + self:int(2, 6) * sign(at[3] - eye[3]) + self:sign() * 0.5, timer = 0, alpha = 0 })
        end
        local m
        for i = #self.smoke, 1, -1 do
            m = self.smoke[i]
            m.y1 = m.y1 + 0.02
            m.y2 = m.y2 + 0.02
            m.ay = Angle(-m.z, m.x, -eye[3], eye[1])
            if m.timer <= 10 then
                m.alpha = min(255, m.alpha + 255 / 10)
            else
                m.alpha = max(0, m.alpha - 0.5)
            end
            m.timer = m.timer + 1
            if m.alpha == 0 then
                table.remove(self.smoke, i)
            end
        end
    end--烟雾

    do
        if self.timer % 60 == 0 then
            self:Newrocket(int(eye[1]) + self:int(2, 5) * sign(at[1] - eye[1]) + self:sign() * 0.5,
                    int(eye[3]) + self:int(2, 5) * sign(at[3] - eye[3]) + self:sign() * 0.5,
                    self:float(0.03, 0.06), self:int(100, 180), ColorList[ran:Int(1, 7)])
        end
        local r
        for i = #self.rocket, 1, -1 do
            r = self.rocket[i]
            self:Newsmear(r.x, r.y, r.z, r.color, 3)
            r.y = r.y + r.vy
            r.timer = r.timer + 1
            if r.timer >= r.time then
                table.remove(self.rocket, i)
                self:rocketBoom(r.x, r.y, r.z, r.color)
            end
        end
        for i = #self.particle, 1, -1 do
            r = self.particle[i]
            self:Newsmear(r.x, r.y, r.z, r.color, r.size)
            r.x = r.x + r.vx
            r.y = r.y + r.vy
            r.z = r.z + r.vz
            r.vy = r.vy + r.ay
            r.timer = r.timer + 1
            if r.timer >= r.time then
                table.remove(self.particle, i)
            end
        end

        for i = #self.smear, 1, -1 do
            r = self.smear[i]
            if not r.malpha then
                r.malpha = r.alpha
            end
            ay = Angle(-r.z, r.x, -eye[3], eye[1])
            ax = Angle(-r.z * Cos(ay) + r.x * Sin(ay), r.y, -eye[3] * Cos(ay) + eye[1] * Sin(ay), eye[2])
            local p = r.point
            p[1][1], p[1][2], p[1][3] = rotate(-0.02 * r.size, 0.02 * r.size, 0, ax, ay, r.x, r.y, r.z)
            p[2][1], p[2][2], p[2][3] = rotate(0.02 * r.size, 0.02 * r.size, 0, ax, ay, r.x, r.y, r.z)
            p[3][1], p[3][2], p[3][3] = rotate(0.02 * r.size, -0.02 * r.size, 0, ax, ay, r.x, r.y, r.z)
            p[4][1], p[4][2], p[4][3] = rotate(-0.02 * r.size, -0.02 * r.size, 0, ax, ay, r.x, r.y, r.z)
            r.alpha = max(0, r.alpha - r.malpha / r.time)
            if r.alpha == 0 then
                table.remove(self.smear, i)
            end
        end
    end--烟花
end

function TH125_bg:render()
    SetViewMode '3d'
    background.ClearToFogColor()
    ClearZBuffer()
    SetZBufferEnable(1)
    SetImageState('white', '', 255, 7, 7, 7)
    local bg = TH125_bg
    local unpack = unpack
    for _, p in ipairs(bg.building) do
        bg.draw_pillar(unpack(p))
    end
    local size = 3
    local j = self.os % size
    local y = 2
    Render4V("125_sky", -13, 0, 13, 13, 0, 13, 13, 0, -13, -13, 0, -13)
    SetImageState('125_cloud', '', 120, 120, 120, 120)
    for x = -19, 19, size do
        for z = -19, 19, size do
            Render4V("125_cloud",
                    x - size / 2, y, z + size / 2 + j, x + size / 2, y, z + size / 2 + j,
                    x + size / 2, y, z - size / 2 + j, x - size / 2, y, z - size / 2 + j)
        end
    end

    SetZBufferEnable(0)

    for _, s in ipairs(self.smear) do
        SetImageState("bright", "mul+add", s.alpha, unpack(s.color))
        if s.point then
            Render4V("bright",
                    s.point[1][1], s.point[1][2], s.point[1][3],
                    s.point[2][1], s.point[2][2], s.point[2][3],
                    s.point[3][1], s.point[3][2], s.point[3][3],
                    s.point[4][1], s.point[4][2], s.point[4][3])
        end
    end
    --烟
    for _, m in ipairs(self.smoke) do
        if m.ay then
            SetImageState("125_smoke" .. m.img, 'mul+add', m.alpha, 255, 255, 255)
            Render4V("125_smoke" .. m.img,
                    m.x - 0.1 * Cos(m.ay), m.y1, m.z + 0.1 * Sin(m.ay),
                    m.x + 0.1 * Cos(m.ay), m.y1, m.z - 0.1 * Sin(m.ay),
                    m.x + 0.1 * Cos(m.ay), m.y2, m.z - 0.1 * Sin(m.ay),
                    m.x - 0.1 * Cos(m.ay), m.y2, m.z + 0.1 * Sin(m.ay))
        end
    end

    SetViewMode 'world'
end

function TH125_bg.draw_pillar(x, z, y1, r, bright, color)
    local y2 = y1 + 4
    local d = r * Cos(45)
    local d2 = d * d
    local eye = lstg.view3d.eye
    Render4V("white", x - d, y2, z + d, x + d, y2, z + d, x + d, y2, z - d, x - d, y2, z - d)
    local _x, _z
    local _r = d / 6
    for _, b in ipairs(bright) do
        b.t = b.t + b.c
        SetImageState("bright", "mul+add", b.alpha / 2 + Sin(b.t) * b.alpha / 2, unpack(color))
        _x, _z = x + b.x * _r, z + b.z * _r
        Render4V("bright",
                _x - _r, y2 + 0.01, _z + _r,
                _x + _r, y2 + 0.01, _z + _r,
                _x + _r, y2 + 0.01, _z - _r,
                _x - _r, y2 + 0.01, _z - _r)
    end
    SetImageState("125_building", "", 255, unpack(color))
    if d * (eye[1] - x) - d2 > 0 then
        Render4V('125_building', x + d, y1, z - d, x + d, y1, z + d, x + d, y2, z + d, x + d, y2, z - d)
    end
    if d * (eye[3] - z) - d2 > 0 then
        Render4V('125_building', x + d, y1, z + d, x - d, y1, z + d, x - d, y2, z + d, x + d, y2, z + d)
    end
    if -d * (eye[1] - x) - d2 > 0 then
        Render4V('125_building', x - d, y1, z + d, x - d, y1, z - d, x - d, y2, z - d, x - d, y2, z + d)
    end
    if -d * (eye[3] - z) - d2 > 0 then
        Render4V('125_building', x - d, y1, z - d, x + d, y1, z - d, x + d, y2, z - d, x - d, y2, z - d)
    end

end