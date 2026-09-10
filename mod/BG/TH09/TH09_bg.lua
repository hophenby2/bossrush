local SetImageState = SetImageState
local SetViewMode = SetViewMode
local Render = Render
local Render4V = Render4V
local Color = Color
local Set3D = Set3D
local table = table
local cos, sin = cos, sin
local background = background

TH09_bg = Class(background)

function TH09_bg:init()


    local path = "mod\\BG\\TH09\\TH09_bg_"
    LoadImageFromFile('hyz_bg1', path .. 'hyz_bg1.png')
    LoadImageFromFile('hyz_bg2', path .. 'hyz_bg2.png')
    SetImageCenter("hyz_bg2", 135, 190)
    LoadImageFromFile('hyz_bg3', path .. 'hyz_bg3.png')
    LoadTexture('hyz_bg4', path .. 'hyz_bg4.png')
    LoadImage("hyz_flower1", "hyz_bg4", 0, 0, 256, 128)
    SetImageCenter("hyz_flower1", 80, 80)
    LoadImage("hyz_flower2", "hyz_bg4", 0, 128, 256, 128)
    SetImageCenter("hyz_flower2", 80, 80)
    LoadImageFromFile('hyz_bg5', path .. 'hyz_bg5.png')



    background.init(self, false)
    --
    Set3D('eye', 0, 3, -5)
    Set3D('at', 0, 1, 0)
    Set3D('up', 0, 1, 0)
    Set3D('fovy', 1.15)
    Set3D('z', 0.1, 24)
    Set3D('fog', 2.6, 10, Color(255, 108, 70, 80))
    --
    self.zos = 0
    self.scene = 1
    self.change = false
    self.leaf = {}
    self.flower = {}
    self.speed = 0.02
    for i = -5, 25, 0.6 do
        table.insert(self.leaf, { x = background:RanFloat(-3, 3), y = background:RanFloat(0, 2), z = background:RanFloat(i - 1, i + 1),
                                  prot = { background:RanFloat(0, 360), 30, 90 },
                                  pomiga = { background:RanFloat(self.speed / 0.04, self.speed / 0.02) * background:RanSign(),
                                             background:RanFloat(self.speed / 0.04, self.speed / 0.02) * background:RanSign(),
                                             background:RanFloat(self.speed / 0.04, self.speed / 0.02) * background:RanSign() },
                                  vx = background:RanFloat(-0.002, 0.002),
                                  vy = -background:RanFloat(-0.002, 0.002),
                                  vz = -background:RanFloat(self.speed, self.speed * 2) })
        table.insert(self.flower, { x = background:RanFloat(-3, 3), y = 0, z = background:RanFloat(i - 1, i + 1),
                                    rot = background:RanFloat(-12, 12), scale = background:RanFloat(0.2, 0.4), img = background:RanInt(1, 2) })
    end
    task.New(self, function()
        for i = 1, 180 do
            Set3D('fog', 2.6 - 2.6 * sin(i / 2), 10 - 9.9 * sin(i / 2), Color(255, 108, 70, 80))
            task.Wait()
        end
        for _ = 1, 20 do
            table.insert(self.flower, {
                x = background:RanFloat(-5, 5), y = 0, z = background:RanFloat(-5, 10),
                rot = background:RanFloat(-12, 12), scale = background:RanFloat(0.2, 0.4), img = background:RanInt(1, 2) })
        end
        self.scene = 2
        for i = 1, 90 do
            Set3D('eye', 0, 3 + sin(i), -5 - 1 * sin(i))
            Set3D('at', 0, 1 + sin(i), 0)
            Set3D('fog', 0, 0.1, Color(255, 108, 70 - 30 * sin(i), 80 - 30 * sin(i)))
            task.Wait()
        end
        task.New(self, function()
            for i = 1, _infinite do
                Set3D('eye', 0, 4 + sin(i / 3) * 2, -6)
                Set3D('at', 0, 2 + sin(i / 4), 0)
                Set3D('up', sin(i / 6) * 0.3, 1, 0)
                task.Wait()
            end
        end)
        for i = 1, 90 do
            Set3D('fog', 2.6 * sin(i), 0.1 + 9.9 * sin(i), Color(255, 108, 40, 50))
            task.Wait()
        end
    end)
end

function TH09_bg:frame()
    if self.change then
        task.Do(self)
    end
    self.zos = self.zos - self.speed
    if self.timer % 26 == 0 then
        table.insert(self.leaf,
                { x = background:RanFloat(-3, 3), y = background:RanFloat(0, 2), z = background:RanFloat(26, 24),
                  prot = { background:RanFloat(0, 360), background:RanFloat(0, 360), background:RanFloat(0, 360) },
                  pomiga = { background:RanFloat(self.speed * 10, self.speed * 50) * background:RanSign(),
                             background:RanFloat(self.speed * 10, self.speed * 50) * background:RanSign(),
                             background:RanFloat(self.speed * 10, self.speed * 50) * background:RanSign() },
                  vx = background:RanFloat(-0.002, 0.002), vy = background:RanFloat(-0.002, 0.002), vz = -background:RanFloat(self.speed, self.speed * 2) }
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
        if l.z <= -10 then
            table.remove(self.leaf, i)
        end
    end

    if self.scene == 1 then
        if self.timer % 20 == 0 then
            table.insert(self.flower, {
                x = background:RanFloat(-3, 3),
                y = 0,
                z = background:RanFloat(25, 26),
                rot = background:RanFloat(-12, 12),
                scale = background:RanFloat(0.2, 0.4),
                img = background:RanInt(1, 2) })
        end
        local f
        for i = #self.flower, 1, -1 do
            f = self.flower[i]
            f.z = f.z - self.speed
            if f.z <= -10 then
                table.remove(self.flower, i)
            end
        end
    end
end

function TH09_bg:render()
    SetViewMode '3d'
    background.ClearToFogColor()

    self.zos = self.zos % 2
    if self.scene == 1 then
        for x = -8, 8, 2 do
            for z = -10, 10, 2 do
                Render4V("hyz_bg1",
                        -1 + x, 0, 1 + z + self.zos,
                        1 + x, 0, 1 + z + self.zos,
                        1 + x, 0, -1 + z + self.zos,
                        -1 + x, 0, -1 + z + self.zos)
            end
        end
        local f
        for i = #self.flower, 1, -1 do
            f = self.flower[i]
            Render("hyz_bg2", f.x, f.y, f.rot, f.scale, f.scale, f.z)
        end
    end
    if self.scene == 2 then
        for x = -8, 8, 2 do
            for z = -10, 10, 2 do
                Render4V("hyz_bg3",
                        -1 + x, 0, 1 + z,
                        1 + x, 0, 1 + z,
                        1 + x, 0, -1 + z,
                        -1 + x, 0, -1 + z)
            end
        end
        local f
        for i = #self.flower, 1, -1 do
            f = self.flower[i]
            Render4V("hyz_flower" .. f.img, f.x - 2, f.y + 1.2, f.z, f.x + 2, f.y + 1.2, f.z, f.x + 2, f.y - 1.2, f.z, f.x - 2, f.y - 1.2, f.z)
        end
        local scale = 4.6
        local x, y, z
        x, y, z = 0.3, 6, 2
        Render4V("hyz_bg5", x + scale, y + scale, z, x - scale, y + scale, z, x - scale, y - scale, z, x + scale, y - scale, z)
        x, y, z = -0.3, 5, 1
        Render4V("hyz_bg5", x - scale, y + scale, z, x + scale, y + scale, z, x + scale, y - scale, z, x - scale, y - scale, z)
        x, y, z = 0, 6, 0
        Render4V("hyz_bg5", x - scale, y + scale, z, x + scale, y + scale, z, x + scale, y - scale, z, x - scale, y - scale, z)
        x, y, z = 0, 5, -0.5
        Render4V("hyz_bg5", x + scale, y + scale, z, x - scale, y + scale, z, x - scale, y - scale, z, x + scale, y - scale, z)
    end
    local d, l
    for i = #self.leaf, 1, -1 do
        l = self.leaf[i]
        d = Dist(lstg.view3d.eye[1], lstg.view3d.eye[3], l.x, l.z)
        SetImageState("small_leaf", "mul+add", 128 * sin(max(0, 9 - d) * 10), 250, 128, 114)

        Render4V("small_leaf",
                l.x - cos(l.prot[1]) * 0.1 - cos(l.prot[3]) * 0.1, l.y - sin(l.prot[1]) * 0.1 - cos(l.prot[2]) * 0.1, l.z - sin(l.prot[2]) * 0.1 - sin(l.prot[3]) * 0.1,
                l.x - sin(l.prot[1]) * 0.1 - sin(l.prot[3]) * 0.1, l.y + cos(l.prot[1]) * 0.1 - sin(l.prot[2]) * 0.1, l.z + cos(l.prot[2]) * 0.1 + cos(l.prot[3]) * 0.1,
                l.x + cos(l.prot[1]) * 0.1 + cos(l.prot[3]) * 0.1, l.y + sin(l.prot[1]) * 0.1 + cos(l.prot[2]) * 0.1, l.z + sin(l.prot[2]) * 0.1 + sin(l.prot[3]) * 0.1,
                l.x + sin(l.prot[1]) * 0.1 + sin(l.prot[3]) * 0.1, l.y - cos(l.prot[1]) * 0.1 + sin(l.prot[2]) * 0.1, l.z - cos(l.prot[2]) * 0.1 - cos(l.prot[3]) * 0.1)
    end

    SetViewMode 'world'
end
