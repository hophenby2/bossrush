local SetImageState = SetImageState
local SetViewMode = SetViewMode
local Render4V = Render4V
local Color = Color
local Set3D = Set3D
local table = table
local cos, sin = cos, sin
local background = background

TH10_bg = Class(background)
function TH10_bg:init()
    CopyImage("water_fog", "suika_fog")
    local path = "mod\\BG\\TH10\\TH10_bg_"
    LoadImageFromFile("river", path .. "river.png")
    SetImageState('river', '', Color(64, 255, 255, 255))
    LoadImageFromFile("lake", path .. "lake.png")
    LoadImageFromFile("lakefog", path .. "lakefog.png")
    LoadImageFromFile("riverback", path .. "riverback.png")
    LoadImageFromFile("waterfall", path .. "waterfall.png")
    SetImageState('waterfall', '', Color(150, 255, 255, 255))
    LoadImageFromFile("waterfallback", path .. "waterfallback.png")
    SetImageState('waterfallback', '', Color(255, 64, 64, 64))
    LoadImageFromFile("10_pillar", path .. "pillar.png")
    SetImageState("10_pillar", "", Color(255, 0, 0, 0))
    LoadImageFromFile("10_wire", path .. "wire.png")

    background.init(self, false)

    Set3D('eye', 0, 4, -3)
    Set3D('at', 0, 0.5, 0)
    Set3D('up', 1, 1, 0)
    Set3D('fovy', 1)
    Set3D('z', 0.1, 24)
    Set3D('fog', 0, 0.1, Color(255, 135, 206, 235))
    task.New(self, function()
        for i = 1, 180 do
            Set3D('up', 1 - 1 * sin(i / 2), 1, 0)
            Set3D('eye', 0, 4 + 9 * sin(i / 2), -3)
            Set3D('at', 0, 0.5 + 9 * sin(i / 2), 0)
            Set3D('fog', 7 * sin(i / 2), 0.1 + 21.9 * sin(i / 2), Color(255, 135, 206, 235))
            coroutine.yield()
            if self.change then
                break
            end
        end
        for i = 1, _infinite do
            Set3D('eye', sin(i / 3) * sin(min(i, 90)), lstg.view3d.eye[2], lstg.view3d.eye[3])
            coroutine.yield()
            if self.change then
                break
            end
        end
        for i = 1, 90 do
            Set3D('fog', 7 - 7 * sin(i), 22 - 21.9 * sin(i), Color(255, 135 + 120 * sin(i), 206 + 49 * sin(i), 235 + 20 * sin(i)))
            coroutine.yield()
        end
        self.leaf = { {}, {}, {} }
        self.WaterFog = {}
        self.wave = {}
        self.pillar = { {}, {}, {} }
        self.timer = 1
        for x = -7, 7, 2.5 do
            table.insert(self.pillar[1], { x = x + background:RanFloat(-1, 1), y = 0 + background:RanFloat(-0.3, 0.3), z = -2 })
            table.insert(self.pillar[2], { x = x + background:RanFloat(-1, 1), y = 0.5 + background:RanFloat(-0.3, 0.3), z = -3 })
            table.insert(self.pillar[3], { x = x + background:RanFloat(-1, 1), y = 1 + background:RanFloat(-0.3, 0.3), z = -4 })
        end
        Set3D("eye", 1, 0, -8.5)
        Set3D("at", 0, 0, 0)
        Set3D("up", 0, 1, 0)
        SetImageState('lakefog', 'mul+add', 0, 255, 255, 255)
        self.scene = true
        task.Wait(45)
        self.speed = 0.01
        for i = 1, 180 do
            SetImageState('lakefog', 'mul+add', max(0, (15 * sin(i / 2) - 7) * 25), 255, 255, 255)
            Set3D('fog', 15 * sin(i / 2), 0.1 + 21.9 * sin(i / 2), Color(255, 255 - 255 * sin(i / 2), 255 - 255 * sin(i / 2), 255 - 255 * sin(i / 2)))
            coroutine.yield()
        end
    end)
    --
    self.zos = 0
    self.zos2 = 0
    self.zos3 = 0
    self.change = false
    self.leaf = {}
    self.WaterFog = {}
    self.speed = 0.02
    self.wave = {}
    local Cos, Sin = Cos, Sin
    self.rotate3D = function(x, y, z, ax, ay, az)
        x, y = x * Cos(az) - y * Sin(az), y * Cos(az) + x * Sin(az)
        x, z = x * Cos(ay) - z * Sin(ay), z * Cos(ay) + x * Sin(ay)
        y, z = y * Cos(ax) - z * Sin(ax), z * Cos(ax) + y * Sin(ax)
        return x, y, z
    end
    for i = -5, 25, 0.6 do
        table.insert(self.leaf, { x = background:RanFloat(-3, 3), y = background:RanFloat(0, 2), z = background:RanFloat(i - 1, i + 1),
                                  prot = { background:RanFloat(0, 360), 30, 90 },
                                  pomiga = { background:RanFloat(self.speed / 0.04, self.speed / 0.02) * background:RanSign(), background:RanFloat(self.speed / 0.04, self.speed / 0.02) * background:RanSign(), background:RanFloat(self.speed / 0.04, self.speed / 0.02) * background:RanSign() },
                                  vx = background:RanFloat(-0.002, 0.002), vy = -background:RanFloat(-0.002, 0.002), vz = -background:RanFloat(self.speed, self.speed * 2) })
    end
    for _ = 1, 20 do
        table.insert(self.WaterFog, {
            x = -background:RanFloat(1, 5), y = background:RanFloat(0, 5), z = background:RanFloat(-5, 20),
            vx = background:RanFloat(0.01, 0.02), vy = -background:RanFloat(0.02, 0.04), vz = 0,
            alpha = 0, scale = 3, timer = 1 })
        table.insert(self.WaterFog, {
            x = background:RanFloat(1, 5), y = background:RanFloat(0, 5), z = background:RanFloat(-5, 20),
            vx = -background:RanFloat(0.01, 0.02), vy = -background:RanFloat(0.02, 0.04), vz = 0,
            alpha = 0, scale = 3, timer = 1 })
    end
    local f
    for _ = 1, 5 do
        for i = #self.WaterFog, 1, -1 do
            f = self.WaterFog[i]
            f.scale = f.scale - 1 / 60
            f.x = f.x + f.vx
            f.y = f.y + f.vy
            f.z = f.z + f.vz
            if f.timer <= 20 then
                f.alpha = min(100, f.alpha + 100 / 20)
            else
                f.alpha = max(0, f.alpha - 100 / 65)
            end
            f.timer = f.timer + 1
            if f.alpha == 0 then
                table.remove(self.WaterFog, i)
            end
        end
    end
end

function TH10_bg:frame()
    task.Do(self)
    self.zos = (self.zos - self.speed) % 2
    if not self.scene then
        self.zos3 = (self.zos3 - self.speed) % 16
        self.zos2 = (self.zos2 - self.speed * 5) % 8
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

        for _, l in ipairs(self.leaf) do
            l.x = l.x + l.vx
            l.y = l.y + l.vy
            l.z = l.z + l.vz
            l.prot[1] = l.prot[1] + l.pomiga[1]
            l.prot[2] = l.prot[2] + l.pomiga[2]
            l.prot[3] = l.prot[3] + l.pomiga[3]
        end
        for i = #self.leaf, 1, -1 do
            if self.leaf[i].z <= -10 then
                table.remove(self.leaf, i)
            end
        end
        for _ = 1, 3 do
            table.insert(self.WaterFog, {
                x = -background:RanFloat(1, 5), y = background:RanFloat(0, 5), z = background:RanFloat(-5, 20),
                vx = background:RanFloat(0.01, 0.02), vy = background:RanFloat(-0.04, 0.04), vz = 0,
                alpha = 0, scale = 3, timer = 1 })
            table.insert(self.WaterFog, {
                x = background:RanFloat(1, 5), y = background:RanFloat(0, 5), z = background:RanFloat(-5, 20),
                vx = -background:RanFloat(0.01, 0.02), vy = background:RanFloat(-0.04, 0.04), vz = 0,
                alpha = 0, scale = 3, timer = 1 })
        end
        if self.timer % 22 == 0 then
            table.insert(self.wave, { r = 0,
                                      x = background:RanFloat(-4, 4), y = 0, z = background:RanFloat(-5, 15),
                                      s = background:RanFloat(0.01, 0.03), alpha = 150 })
        end
        local f, w
        for i = #self.WaterFog, 1, -1 do
            f = self.WaterFog[i]
            f.scale = f.scale - 1 / 60
            f.x = f.x + f.vx
            f.y = f.y + f.vy
            f.z = f.z + f.vz
            if f.timer <= 20 then
                f.alpha = min(100, f.alpha + 100 / 20)
            else
                f.alpha = max(0, f.alpha - 100 / 65)
            end
            f.timer = f.timer + 1
            if f.alpha == 0 then
                table.remove(self.WaterFog, i)
            end
        end
        for i = #self.wave, 1, -1 do
            w = self.wave[i]
            w.r = w.r + w.s
            w.alpha = max(0, w.alpha - 3)
            if w.r > 2 then
                table.remove(self.wave, i)
            end
        end
    else
        local p
        if self.timer % (2.5 / (self.speed / 2)) == 0 then
            table.insert(self.pillar[1], { x = 7 + background:RanFloat(-1, 1), y = 0 + background:RanFloat(-0.3, 0.3), z = -2 })
            table.insert(self.pillar[2], { x = 7 + background:RanFloat(-1, 1), y = 0.5 + background:RanFloat(-0.3, 0.3), z = -3 })
            table.insert(self.pillar[3], { x = 7 + background:RanFloat(-1, 1), y = 1 + background:RanFloat(-0.3, 0.3), z = -4 })
        end
        for j = 1, 3 do
            for i = #self.pillar[j], 1, -1 do
                p = self.pillar[j][i]
                p.x = p.x - self.speed / 2
                if p.x < -10 then
                    table.remove(self.pillar[j], i)
                end
            end
        end
        if self.timer % 7 == 0 then
            local l = background:RanInt(1, 3)
            local t = { { -1, -1.8 }, { -2.2, -2.8 }, { -3.2, -5 } }
            table.insert(self.leaf[l], {
                x = background:RanFloat(6, 7),
                y = background:RanFloat(4, 5),
                z = background:RanFloat(unpack(t[l])),
                vx = -background:RanFloat(0.005, 0.02), vy = -background:RanFloat(0.005, 0.02), vz = 0,
                rot = background:RanFloat(0, 360), omiga = background:RanSign() * background:RanFloat(2, 4) })
        end
        local l
        for j = 1, 3 do
            for i = #self.leaf[j], 1, -1 do
                l = self.leaf[j][i]
                l.x = l.x + l.vx
                l.y = l.y + l.vy
                l.z = l.z + l.vz
                l.rot = l.rot + l.omiga
                if l.y < -4 then
                    table.remove(self.leaf[j], i)
                end
            end
        end
    end
end

function TH10_bg:render()
    SetViewMode '3d'
    background.ClearToFogColor()
    if not self.scene then
        local j = 1
        for y = -2, 14, 8 do
            j = 1
            for z = -23, 25, 8 do
                Render4V("waterfallback",
                        -4, 4 + y, -4 * j + z + self.zos3,
                        -4, 4 + y, 4 * j + z + self.zos3,
                        -4, -4 + y, 4 * j + z + self.zos3,
                        -4, -4 + y, -4 * j + z + self.zos3)
                Render4V("waterfallback",
                        4, 4 + y, -4 * j + z + self.zos3,
                        4, 4 + y, 4 * j + z + self.zos3,
                        4, -4 + y, 4 * j + z + self.zos3,
                        4, -4 + y, -4 * j + z + self.zos3)
                j = -j
            end
        end
        for y = -10, 14, 8 do
            j = 1
            for z = -23, 25, 8 do
                Render4V("waterfall",
                        -4, 4 + y + self.zos2, -4 * j + z + self.zos3,
                        -4, 4 + y + self.zos2, 4 * j + z + self.zos3,
                        -4, -4 + y + self.zos2, 4 * j + z + self.zos3,
                        -4, -4 + y + self.zos2, -4 * j + z + self.zos3)
                Render4V("waterfall",
                        4, 4 + y + self.zos2, -4 * j + z + self.zos3,
                        4, 4 + y + self.zos2, 4 * j + z + self.zos3,
                        4, -4 + y + self.zos2, 4 * j + z + self.zos3,
                        4, -4 + y + self.zos2, -4 * j + z + self.zos3)
                j = -j
            end
        end
        j = 1
        for x = -3, 3, 2 do
            for z = -15, 21, 2 do
                Render4V("riverback",
                        -j + x, 0, 1 + z + self.zos,
                        j + x, 0, 1 + z + self.zos,
                        j + x, 0, -1 + z + self.zos,
                        -j + x, 0, -1 + z + self.zos)
                Render4V("river",
                        -j + x, 0, 1 + z + self.zos,
                        j + x, 0, 1 + z + self.zos,
                        j + x, 0, -1 + z + self.zos,
                        -j + x, 0, -1 + z + self.zos)
            end
            j = -j
        end

        local l, d, f, w
        local ax, ay, az
        local ang, r1, r2 = 9
        for i = #self.wave, 1, -1 do
            w = self.wave[i]
            r1, r2 = w.r * 0.95, w.r
            for angle = 18, 360, 18 do
                SetImageState("white", "mul+add", w.alpha, 135, 206, 235)
                Render4V('white',
                        w.x + r2 * cos(angle + ang), w.y, w.z + r2 * sin(angle + ang),
                        w.x + r1 * cos(angle + ang), w.y, w.z + r1 * sin(angle + ang),
                        w.x + r1 * cos(angle - ang), w.y, w.z + r1 * sin(angle - ang),
                        w.x + r2 * cos(angle - ang), w.y, w.z + r2 * sin(angle - ang)
                )
            end
        end
        for i = #self.leaf, 1, -1 do
            l = self.leaf[i]
            d = Dist(lstg.view3d.eye[1], lstg.view3d.eye[3], l.x, l.z)
            SetImageState("small_leaf", "mul+add", 128 * sin(max(0, 9 - d) * 10), 135, 206, 235)

            Render4V("small_leaf",
                    l.x - cos(l.prot[1]) * 0.1 - cos(l.prot[3]) * 0.1, l.y - sin(l.prot[1]) * 0.1 - cos(l.prot[2]) * 0.1, l.z - sin(l.prot[2]) * 0.1 - sin(l.prot[3]) * 0.1,
                    l.x - sin(l.prot[1]) * 0.1 - sin(l.prot[3]) * 0.1, l.y + cos(l.prot[1]) * 0.1 - sin(l.prot[2]) * 0.1, l.z + cos(l.prot[2]) * 0.1 + cos(l.prot[3]) * 0.1,
                    l.x + cos(l.prot[1]) * 0.1 + cos(l.prot[3]) * 0.1, l.y + sin(l.prot[1]) * 0.1 + cos(l.prot[2]) * 0.1, l.z + sin(l.prot[2]) * 0.1 + sin(l.prot[3]) * 0.1,
                    l.x + sin(l.prot[1]) * 0.1 + sin(l.prot[3]) * 0.1, l.y - cos(l.prot[1]) * 0.1 + sin(l.prot[2]) * 0.1, l.z - cos(l.prot[2]) * 0.1 - cos(l.prot[3]) * 0.1)
        end
        local p1, p2, p3, p4 = {}, {}, {}, {}
        for i = #self.WaterFog, 1, -1 do
            f = self.WaterFog[i]
            ax = -40
            ay = 0
            az = 0
            p1[1], p1[2], p1[3] = self.rotate3D(-0.5, 0.5, 0, ax, ay, az)
            p2[1], p2[2], p2[3] = self.rotate3D(0.5, 0.5, 0, ax, ay, az)
            p3[1], p3[2], p3[3] = self.rotate3D(0.5, -0.5, 0, ax, ay, az)
            p4[1], p4[2], p4[3] = self.rotate3D(-0.5, -0.5, 0, ax, ay, az)
            SetImageState("water_fog", "add+alpha", f.alpha, 160, 160, 200)
            Render4V("water_fog",
                    f.x + p1[1] * f.scale, f.y + p1[2] * f.scale, f.z + p1[3] * f.scale,
                    f.x + p2[1] * f.scale, f.y + p2[2] * f.scale, f.z + p2[3] * f.scale,
                    f.x + p3[1] * f.scale, f.y + p3[2] * f.scale, f.z + p3[3] * f.scale,
                    f.x + p4[1] * f.scale, f.y + p4[2] * f.scale, f.z + p4[3] * f.scale)
        end
    else
        RenderClearViewMode(Color(255, 0, 0, 0))
        Render4V("lake", -7, 5.1, 0, 7, 5.1, 0, 7, -5, 0, -7, -5, 0)
        for x = -10, 10, 2 do
            Render4V("lakefog",
                    x - 2 + self.zos, 5.5, 0,
                    x + 2 + self.zos, 5.5, 0,
                    x + 2 + self.zos, 1.5, 0,
                    x - 2 + self.zos, 1.5, 0)
        end
        local r = 0.2
        SetImageState("leaf", "mul+add", 70, 255, 227, 132)
        for i = 1, 3 do

            for _, l in ipairs(self.leaf[i]) do
                Render4V("leaf",
                        l.x - 0.1 * cos(l.rot) - 0.1 * sin(l.rot), l.y + 0.1 * cos(l.rot) - 0.1 * sin(l.rot), l.z,
                        l.x + 0.1 * cos(l.rot) - 0.1 * sin(l.rot), l.y + 0.1 * cos(l.rot) + 0.1 * sin(l.rot), l.z,
                        l.x + 0.1 * cos(l.rot) + 0.1 * sin(l.rot), l.y - 0.1 * cos(l.rot) + 0.1 * sin(l.rot), l.z,
                        l.x - 0.1 * cos(l.rot) + 0.1 * sin(l.rot), l.y - 0.1 * cos(l.rot) - 0.1 * sin(l.rot), l.z)
            end
            for _, p in ipairs(self.pillar[i]) do
                for t = 1, 6 do
                    Render4V("10_pillar",
                            p.x + cos(t * 60 + 30) * r, p.y, p.z + sin(t * 60 + 30) * r,
                            p.x + cos(t * 60 - 30) * r, p.y, p.z + sin(t * 60 - 30) * r,
                            p.x + cos(t * 60 - 30) * r, -4, p.z + sin(t * 60 - 30) * r,
                            p.x + cos(t * 60 + 30) * r, -4, p.z + sin(t * 60 + 30) * r)
                    Render4V("10_wire",
                            p.x + cos(t * 60 + 30) * r, p.y, p.z + sin(t * 60 + 30) * r,
                            p.x + cos(t * 60 + 30) * r * 2, p.y, p.z + sin(t * 60 + 30) * r * 2,
                            p.x + cos(t * 60 + 30) * r * 2, p.y - 1, p.z + sin(t * 60 + 30) * r * 2,
                            p.x + cos(t * 60 + 30) * r, p.y - 1, p.z + sin(t * 60 + 30) * r)
                end
            end
        end


    end
    SetViewMode 'world'
end
