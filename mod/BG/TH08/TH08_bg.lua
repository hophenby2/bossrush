local t_ = {  }
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
local SetImageState = SetImageState
local SetViewMode = SetViewMode
local Render = Render
local Render4V = Render4V
local Color = Color
local Set3D = Set3D
local table = table
local cos, sin = cos, sin
local background = background
TH08_bg = Class(background)
function TH08_bg:init()
    local path = "mod\\BG\\TH08\\TH08_bg_"
    LoadTexture("stg6bg", path .. "stg6bg.png")
    LoadImage("stg6bg_wall1", "stg6bg", 0, 0, 256, 255)
    LoadImage("stg6bg_wall2", "stg6bg", 257, 256, 256, 256)
    LoadImage("stg6bg_floor", "stg6bg", 256, 0, 256, 256)
    SetImageState("stg6bg_wall1", "", 255, 255, 255, 255)
    SetImageState("stg6bg_wall2", "", 255, 255, 255, 255)
    SetImageState("stg6bg_floor", "", 255, 255, 255, 255)
    LoadImageFromFile("stg6bg2", path .. "stg6bg2.png")

    background.init(self, false)

    Set3D('eye', -0.7, 1, 0)
    Set3D('at', 0.5, 0.9, 3)
    Set3D('up', 0, 1, 0)
    Set3D('z', 0.1, 20)
    Set3D('fovy', 0.7)
    Set3D('fog', 5, 10, Color(255, 0, 0, 0))
    self.speed = 0.008
    self.zos = 0
    self.leaf = {}
    self.lcol = 0
    self.aura_alpha = 0
    self.angle = { 0, 0, 0 }
    self.cherry = { open = false, alpha = 0, scene = 1, point = {} }
    self.float = background.RanFloat
    self.int = background.RanInt
    for z = 21, 0, -0.9 do
        table.insert(self.leaf,
                { x = self:float(-0.8, 0.8), y = self:float(-1.6, 1.6), z = self:float(z - 1, z + 1),
                  prot = { self:float(0, 360), self:float(0, 360), self:float(0, 360) },
                  pomiga = { self:float(self.speed / 0.008, self.speed / 0.004) * background:RanSign(),
                             self:float(self.speed / 0.008, self.speed / 0.004) * background:RanSign(),
                             self:float(self.speed / 0.008, self.speed / 0.004) * background:RanSign() },
                  vx = self:float(-0.002, 0.002), vy = self:float(-0.002, 0.002), vz = -self:float(self.speed * 3, self.speed * 6) })
    end
    task.New(self, function()
        for i = 1, 90 do
            self.cherry.alpha = sin(i)
            task.Wait()
        end
        self.light = {}
        self.lightp = {}
        self.leaf = {}
        self.speed = 0.008
        for y = 10, 0, -0.2 do
            table.insert(self.leaf,
                    { x = 0, z = 0, a = self:float(0, 360), y = self:float(y - 1, y + 1), r = self:float(1, 2), rs = self:float(-1, 1),
                      prot = { self:float(0, 360), self:float(0, 360), self:float(0, 360) },
                      pomiga = { self:float(self.speed / 0.008, self.speed / 0.004) * background:RanSign(),
                                 self:float(self.speed / 0.008, self.speed / 0.004) * background:RanSign(),
                                 self:float(self.speed / 0.008, self.speed / 0.004) * background:RanSign() },
                      vy = self:float(-self.speed, -self.speed / 2), timer = self:int(1, 360), alpha = 150 }
            )
        end
        Set3D('eye', 10, 6, -0.1)
        Set3D('at', 0, 0, 0)
        Set3D('up', 1, 1, 0)
        Set3D('fog', 5, 8, Color(255, 28, 12, 24))
        self.cherry.scene = 2
        task.New(self, function()
            for i = 1, 180 do
                lstg.view3d.eye[1] = 10 - 10 * sin(i / 2)
                lstg.view3d.eye[3] = sin(i) * 0.5
                task.Wait()
            end
            for i = 1, _infinite do
                lstg.view3d.eye[1] = sin(i / 3) * sin(min(i, 90))
                lstg.view3d.eye[2] = lstg.view3d.eye[2] + 0.008 * sin(i / 2) * sin(min(i, 90))
                lstg.view3d.eye[3] = sin(i) * 0.5 * sin(min(i, 90))
                task.Wait()
            end
        end)

        task.Wait(45)
        for i = 89, 0, -1 do
            self.cherry.alpha = sin(i)
            task.Wait()
        end
    end)
end
function TH08_bg:frame()
    if self.cherry.open then
        task.Do(self)
    end
    if self.cherry.scene == 1 then
        self.zos = self.zos - self.speed
        if self.timer % 11 == 0 and self.speed > 0 then
            table.insert(self.leaf,
                    { x = self:float(-0.8, 0.8), y = self:float(-1.6, 1.6), z = self:float(20, 22),
                      prot = { self:float(0, 360), self:float(0, 360), self:float(0, 360) },
                      pomiga = { self:float(self.speed / 0.008, self.speed / 0.004) * background:RanSign(),
                                 self:float(self.speed / 0.008, self.speed / 0.004) * background:RanSign(),
                                 self:float(self.speed / 0.008, self.speed / 0.004) * background:RanSign() },
                      vx = self:float(-0.002, 0.002), vy = self:float(-0.002, 0.002), vz = -self:float(self.speed * 3, self.speed * 6) }
            )
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
            if l.z <= -1 then
                table.remove(self.leaf, i)
            end
        end
    end
    if self.cherry.scene == 2 then
        if self.timer % 11 == 0 and self.speed > 0 then
            table.insert(self.leaf,
                    { x = 0, z = 0, a = self:float(0, 360), y = self:float(9, 16), r = self:float(1, 2), rs = self:float(-1, 1),
                      prot = { self:float(0, 360), self:float(0, 360), self:float(0, 360) },
                      pomiga = { self:float(self.speed / 0.008, self.speed / 0.004) * background:RanSign(),
                                 self:float(self.speed / 0.008, self.speed / 0.004) * background:RanSign(),
                                 self:float(self.speed / 0.008, self.speed / 0.004) * background:RanSign() },
                      vy = self:float(-self.speed * 2, -self.speed), timer = self:int(1, 360), alpha = 150 }
            )
        end
        local l
        for i = #self.leaf, 1, -1 do
            l = self.leaf[i]
            l.y = l.y + l.vy
            l.a = l.a + l.rs
            l.x = cos(l.a) * l.r
            l.z = sin(l.a) * l.r
            l.prot[1] = 15 + (25 * sin(l.timer / 2))
            l.prot[2] = 15 + (25 * cos(l.timer / 2))
            l.prot[3] = l.timer
            l.timer = l.timer + 1
            if l.y < 0 then
                l.alpha = max(0, l.alpha - 5)
            end
            if l.alpha <= 0 then
                table.remove(self.leaf, i)
            end
        end
    end
end
function TH08_bg:rotate3D(x, y, z, ax, ay, offx, offy, offz)
    x, z = x * Cos(ay) - z * Sin(ay), z * Cos(ay) + x * Sin(ay)
    y, z = y * Cos(ax) - z * Sin(ax), z * Cos(ax) + y * Sin(ax)
    return { x + offx, y + offy, z + offz }
end
function TH08_bg:render()
    SetViewMode '3d'
    background.ClearToFogColor()
    if self.cherry.scene == 1 then
        SetViewMode 'world'
        Render("stg6bg2", 0, 0)
        SetViewMode '3d'

        ClearZBuffer()
        SetZBufferEnable(1)
        SetImageState("white", "", 255, 0, 0, 0)
        Render4V("white", -1, 2, 10, 1, 2, 10, 1, -2, 10, -1, -2, 10)
        self.zos = self.zos % 4
        for z = -6, 22, 4 do
            Render4V("stg6bg_floor",
                    -1, 0, 2 + z + self.zos,
                    1, 0, 2 + z + self.zos,
                    1, 0, -2 + z + self.zos,
                    -1, 0, -2 + z + self.zos)
            Render4V("stg6bg_floor",
                    -1, 2, 2 + z + self.zos,
                    1, 2, 2 + z + self.zos,
                    1, 2, -2 + z + self.zos,
                    -1, 2, -2 + z + self.zos)
        end
        for z = -6, 22, 4 do
            Render4V("stg6bg_wall1",
                    -1, 0, -1 + z + self.zos,
                    -1, 2, -1 + z + self.zos,
                    -1, 2, 1 + z + self.zos,
                    -1, 0, 1 + z + self.zos)
            Render4V("stg6bg_wall2",
                    -1, 0, 1 + z + self.zos,
                    -1, 2, 1 + z + self.zos,
                    -1, 2, 3 + z + self.zos,
                    -1, 0, 3 + z + self.zos)
            Render4V("stg6bg_wall1",
                    1, 0, -1 + z + self.zos,
                    1, 2, -1 + z + self.zos,
                    1, 2, 1 + z + self.zos,
                    1, 0, 1 + z + self.zos)
            Render4V("stg6bg_wall2",
                    1, 0, 1 + z + self.zos,
                    1, 2, 1 + z + self.zos,
                    1, 2, 3 + z + self.zos,
                    1, 0, 3 + z + self.zos)
        end
        SetImageState("small_leaf", "mul+add", 128 + self.lcol, 218, 112, 214)
        for _, l in ipairs(self.leaf) do
            Render4V("small_leaf",
                    l.x - Cos(l.prot[1]) * 0.1 - Cos(l.prot[3]) * 0.1, l.y - Sin(l.prot[1]) * 0.1 - Cos(l.prot[2]) * 0.1, l.z - Sin(l.prot[2]) * 0.1 - Sin(l.prot[3]) * 0.1,
                    l.x - Sin(l.prot[1]) * 0.1 - Sin(l.prot[3]) * 0.1, l.y + Cos(l.prot[1]) * 0.1 - Sin(l.prot[2]) * 0.1, l.z + Cos(l.prot[2]) * 0.1 + Cos(l.prot[3]) * 0.1,
                    l.x + Cos(l.prot[1]) * 0.1 + Cos(l.prot[3]) * 0.1, l.y + Sin(l.prot[1]) * 0.1 + Cos(l.prot[2]) * 0.1, l.z + Sin(l.prot[2]) * 0.1 + Sin(l.prot[3]) * 0.1,
                    l.x + Sin(l.prot[1]) * 0.1 + Sin(l.prot[3]) * 0.1, l.y - Cos(l.prot[1]) * 0.1 + Sin(l.prot[2]) * 0.1, l.z - Cos(l.prot[2]) * 0.1 - Cos(l.prot[3]) * 0.1)
        end
        SetZBufferEnable(0)
    end

    if self.cherry.scene == 2 then
        SetViewMode 'world'
        local c = 185 + 50 * sin(self.timer / 2)
        SetImageState("stg6bg2", "", 255, c, c, c)
        Render("stg6bg2", sin(self.timer / 9) * 50, 0)
        SetViewMode '3d'
        for _, l in ipairs(self.leaf) do
            SetImageState("cherry_bullet", "mul+add", l.alpha, 255, 255, 255)
            Render4V("cherry_bullet",
                    l.x - Cos(l.prot[1]) * 0.1 - Cos(l.prot[3]) * 0.1, l.y - Sin(l.prot[1]) * 0.1 - Cos(l.prot[2]) * 0.1, l.z - Sin(l.prot[2]) * 0.1 - Sin(l.prot[3]) * 0.1,
                    l.x - Sin(l.prot[1]) * 0.1 - Sin(l.prot[3]) * 0.1, l.y + Cos(l.prot[1]) * 0.1 - Sin(l.prot[2]) * 0.1, l.z + Cos(l.prot[2]) * 0.1 + Cos(l.prot[3]) * 0.1,
                    l.x + Cos(l.prot[1]) * 0.1 + Cos(l.prot[3]) * 0.1, l.y + Sin(l.prot[1]) * 0.1 + Cos(l.prot[2]) * 0.1, l.z + Sin(l.prot[2]) * 0.1 + Sin(l.prot[3]) * 0.1,
                    l.x + Sin(l.prot[1]) * 0.1 + Sin(l.prot[3]) * 0.1, l.y - Cos(l.prot[1]) * 0.1 + Sin(l.prot[2]) * 0.1, l.z - Cos(l.prot[2]) * 0.1 - Cos(l.prot[3]) * 0.1)
        end
    end

    SetViewMode 'world'
    if self.cherry.alpha > 0 then
        SetImageState("white", "", self.cherry.alpha * 255, 255, 255, 255)
        RenderRect("white", lstg.world.l, lstg.world.r, lstg.world.b, lstg.world.t)
    end
end