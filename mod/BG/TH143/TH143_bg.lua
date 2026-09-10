TH143_bg = Class(background)
local SetViewMode = SetViewMode
local RenderTexture = RenderTexture
local Color = Color
local Set3D = Set3D
local cos, sin = cos, sin
local task = task
local background = background

function TH143_bg:init()
    local path = "mod\\BG\\TH143\\TH143_bg_"
    LoadTexture2("143_1", path .. "1.png")

    background.init(self, false)
    self.float = background.RanFloat
    self.int = background.RanInt
    self.sign = background.RanSign
    self.class = TH143_bg
    --New(camera_setter)
    Set3D('eye', 0, 23, 0)
    Set3D('at', 0, 1.8, 3)
    Set3D('up', 0, 1, 0)
    Set3D('z', 0.1, 50)
    Set3D('fovy', 1)
    Set3D('fog', 18, 29, Color(100, 0, 0, 0))
    self.class:SetAngle(0, 0, 0)
    self.px = 0
    self.py = 0
    self.pz = 0
    self.speed = 0
    task.New(self, function()
        task.New(self, function()
            for i = 1, 270 do
                i = task.SetMode[3](i / 270)
                self.py = i * 4
                self.pz = i * 8
                task.Wait()
            end
        end)
        while true do
            task.Wait(180)
            for i = 1, 180 do
                self.class:SetAngle(0, -task.SetMode[3](i / 180) * 90, 0)
                task.Wait()
            end
            self.py, self.pz = 0, 0
            self.class:SetAngle(0, 0, 0)
            task.New(self, function()
                for i = 1, 270 do
                    i = task.SetMode[3](i / 270)
                    self.py = i * 4
                    self.pz = i * 8
                    task.Wait()
                end
            end)
        end
    end)
    self.x = player.x
    self.y = player.y
    self._r, self._g, self._b = 200, 200, 200
    self.leaf = CreateFallLeaf({ { -3, 3 }, { 7, 15 }, { 7, 10 }, { 1, 2 }, { -0.002, 0.002 }, { -0.01, -0.025 }, { -0.01, -0.02 } },
            6, 0.1, "mul+add", 100, { 200, 200, 200 },
            "small_leaf", function(self)
                return self.y < 0
            end, { count = 20, xRange = { -3, 3 }, yRange = { 1, 7 }, zRange = { -3, 7 } }, true)
end
local function rotate(x, y, z, ax, ay, az)
    local Cos, Sin = cos, sin
    x, y = x * Cos(az) - y * Sin(az), y * Cos(az) + x * Sin(az)
    x, z = x * Cos(ay) - z * Sin(ay), z * Cos(ay) + x * Sin(ay)
    y, z = y * Cos(ax) - z * Sin(ax), z * Cos(ax) + y * Sin(ax)
    return { x, y, z }
end
function TH143_bg:frame()
    task.Do(self)
    local t = self.timer
    self.x = self.x + (player.x - self.x) * 0.05
    self.y = self.y + (player.y - self.y) * 0.05
    Set3D("at", sin(t / 5) * 0.6, 1.8 + sin(t / 6), 3)
    Set3D("eye", self.x / 170, 5 + self.y / 150, 0)
    Set3D("up", sin(t / 5) * 0.3, 0.5 + 0.3 * sin(t / 3), sin(t / 7) * 0.1)
    self._r = sin(t / 3) * 50 + 150
    self._g = sin(t / 4) * 30 + 170
    self._b = sin(t / 5) * 10 + 190
    self.leaf:frame()
end

TH143_bg.rx = 0
TH143_bg.ry = 0
TH143_bg.rz = 0
function TH143_bg:SetAngle(x, y, z)
    self.rx = x or self.rx
    self.ry = y or self.ry
    self.rz = z or self.rz
end
local unpack = unpack
function TH143_bg:RenderTexture(tex, blend, col, p1, p2, p3, p4, uv1, uv2, uv3, uv4, oX, oY, oZ, aX, aY, aZ)
    oX, oY, oZ = unpack(rotate(oX, oY, oZ, self.rx, self.ry, self.rz))
    p1 = rotate(p1[1], p1[2], p1[3], self.rx, self.ry, self.rz)
    p2 = rotate(p2[1], p2[2], p2[3], self.rx, self.ry, self.rz)
    p3 = rotate(p3[1], p3[2], p3[3], self.rx, self.ry, self.rz)
    p4 = rotate(p4[1], p4[2], p4[3], self.rx, self.ry, self.rz)
    p1 = rotate(p1[1], p1[2], p1[3], aX, aY, aZ)
    p2 = rotate(p2[1], p2[2], p2[3], aX, aY, aZ)
    p3 = rotate(p3[1], p3[2], p3[3], aX, aY, aZ)
    p4 = rotate(p4[1], p4[2], p4[3], aX, aY, aZ)
    RenderTexture(tex, blend,
            { oX + p1[1], oY + p1[2], oZ + p1[3], uv1[1], uv1[2], col },
            { oX + p2[1], oY + p2[2], oZ + p2[3], uv2[1], uv2[2], col },
            { oX + p3[1], oY + p3[2], oZ + p3[3], uv3[1], uv3[2], col },
            { oX + p4[1], oY + p4[2], oZ + p4[3], uv4[1], uv4[2], col })
end
function TH143_bg:RenderStairs(tex, blend, x, y, z, stairs, white, black, Rsize, Vsize, ax, ay, az)
    local rw = Rsize * 2 / stairs
    local vw = Vsize / stairs
    for c = 1, stairs do
        self:RenderTexture(tex, blend, white,
                { -Rsize, c * rw, Rsize + c * rw },
                { Rsize, c * rw, Rsize + c * rw },
                { Rsize, c * rw, Rsize + (c - 1) * rw },
                { -Rsize, c * rw, Rsize + (c - 1) * rw },
                { 0, Vsize - (c) * vw },
                { Vsize, Vsize - (c) * vw },
                { Vsize, Vsize - (c - 1) * vw },
                { 0, Vsize - (c - 1) * vw },
                x, y, z, ax, ay, az)
        self:RenderTexture(tex, blend, black,
                { -Rsize, c * rw, Rsize + (c - 1) * rw },
                { Rsize, c * rw, Rsize + (c - 1) * rw },
                { Rsize, (c - 1) * rw, Rsize + (c - 1) * rw },
                { -Rsize, (c - 1) * rw, Rsize + (c - 1) * rw },
                { 0, Vsize - (c - 1) * vw },
                { Vsize, Vsize - (c - 1) * vw },
                { Vsize, Vsize - (c - 2) * vw },
                { 0, Vsize - (c - 2) * vw },
                x, y, z, ax, ay, az)
    end
end
function TH143_bg:RenderFloor(tex, blend, x, y, z, Rsize, Vsize, col, ax, ay, az, ht, vt)
    ht = ht or 1
    vt = vt or 1
    self:RenderTexture(tex, blend, col,
            rotate(-Rsize * ht, 0, Rsize * vt, ax, 0, az),
            rotate(Rsize * ht, 0, Rsize * vt, ax, 0, az),
            rotate(Rsize * ht, 0, -Rsize * vt, ax, 0, az),
            rotate(-Rsize * ht, 0, -Rsize * vt, ax, 0, az),
            { 0, 0 },
            { Vsize * ht, 0 },
            { Vsize * ht, Vsize * vt },
            { 0, Vsize * vt },
            x, y, z, 0, ay, 0)

end
local Cos, Sin = Cos, Sin
function TH143_bg:render()
    SetViewMode '3d'
    background.ClearToFogColor()
    local tex = "143_1"
    local blend = ""
    local white = Color(255, self._r, self._g, self._b)
    local black = Color(255, self._r / 2.3, self._g / 2.3, self._b / 2.3)
    local Rsize = 4
    local Vsize = 512
    local Rsize2 = 2
    local class = TH143_bg
    local X, Y, Z = -self.px, -self.py, -self.pz
    ClearZBuffer()
    SetZBufferEnable(1)
    class:RenderFloor(tex, blend, X, Y, Z, Rsize2, Vsize, white, 0, 0, 0)
    class:RenderStairs(tex, blend, X, Y, Z, 10, white, black, Rsize2, Vsize, 0, 0, 0)

    class:RenderFloor(tex, blend, X, Y + Rsize, Z + Rsize * 2, Rsize2, Vsize, white, 0, 90, 0)
    class:RenderStairs(tex, blend, X, Y + Rsize, Z + Rsize * 2, 10, white, black, Rsize2, Vsize, 0, 90, 0)

    class:RenderFloor(tex, blend, X - Rsize * 2, Y + Rsize * 2, Z + Rsize * 2, Rsize2, Vsize, white, 0, 180, 0)
    class:RenderStairs(tex, blend, X - Rsize * 2, Y + Rsize * 2, Z + Rsize * 2, 10, white, black, Rsize2, Vsize, 0, 180, 0)

    class:RenderFloor(tex, blend, X - Rsize * 2, Y - Rsize, Z, Rsize2, Vsize, white, 0, 270, 0)
    class:RenderStairs(tex, blend, X - Rsize * 2, Y - Rsize, Z, 10, white, black, Rsize2, Vsize, 0, 270, 0)
    class:RenderStairs(tex, blend, X - Rsize * 2, Y - Rsize * 2, Z + Rsize * 2, 10, white, black, Rsize2, Vsize, 0, 180, 0)
    local eyex, eyez = lstg.view3d.eye[1] - (X - Rsize), lstg.view3d.eye[3] - (Z + Rsize)
    local d = Rsize2 * Cos(45)
    for i = 1, 4 do
        i = i * 90
        if d * Cos(-i) * eyex + d * Sin(-i) * eyez - d * d > 0 then
            class:RenderFloor(tex, blend,
                    X - Rsize + Rsize2 * cos(i),
                    Y + Rsize2,
                    Z + Rsize + Rsize2 * sin(i),
                    Rsize2, Vsize, white, 90, 0, i + 90, 1, 8)
        end
        class:RenderFloor(tex, blend,
                X - Rsize + Rsize2 * cos(i) * 3,
                Y + Rsize2,
                Z + Rsize + Rsize2 * sin(i) * 3,
                Rsize2, Vsize, white, 90, 0, i + 90, 3, 8)
    end

    SetZBufferEnable(0)
    self.leaf:render()
    SetViewMode 'world'
end