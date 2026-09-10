TH16_bg = Class(background)
local spring, summer, autumn, winter = {}, {}, {}, {}
local SetViewMode = SetViewMode
local RenderTexture = RenderTexture
local Color = Color
local Set3D = Set3D
local cos, sin = cos, sin
local min, max = min, max
local background = background
local Render4V = Render4V

function TH16_bg:init()
    --背景资源太多不在这里加载

    background.init(self, false)
    self.float = background.RanFloat
    self.int = background.RanInt
    self.sign = background.RanSign
    Set3D('eye', 0, 3, 0)
    Set3D('at', 0, 1, 2.5)
    Set3D('up', 0, 1, 0)
    Set3D('z', 0.1, 50)
    Set3D('fovy', 1)
    Set3D('fog', 2, 10, Color(100, 30, 0, 0))
    self.speed = 1
    self.zos = 0
    self.white = 0
    self.color = { 255, 255, 255 }
    self.leaf = CreateFallLeaf({ { -4, 4 }, { -3, -1 }, { 1, 7 }, { 1, 2 }, { -0.002, 0.002 }, { 0.01, 0.025 }, { -0.01, -0.005 } },
            18, 0.06, "mul+add", 100, { 200, 100, 100 },
            "small_leaf", function(self)
                return self.z < -1
            end, { count = 20, xRange = { -4, 4 }, yRange = { -3, 5 }, zRange = { 1, 7 } }, true)
    self.scene = nil
    self.door = {}
    self.tu = { 1, 4 }
    if scoredata.UnlockAya then
        table.insert(self.tu, 2, 3)
    end
    if scoredata.UnlockChiruno then
        table.insert(self.tu, 2, 2)
    end
    task.New(self, function()
        task.Wait(90)
        background.Move3Dcamera(self, "at", 3, 4.5, 360, 3)
        task.SmoothSetValueTo("speed", 2.2, 360, 3)
        local t, s = 0, 0
        while true do
            s = s + sin(t)
            lstg.view3d.eye[2] = 3 + sin(s / 2) * 0.8
            lstg.view3d.at[1] = sin(s / 3) * 0.8
            lstg.view3d.up[1] = sin(s / 5) * 0.3
            t = min(t + 1, 90)
            task.Wait()
        end
    end)

    --New(camera_setter)
end
function TH16_bg:frame()
    task.Do(self)
    if self.scene then
        self.scene:frame(self.timer)
    else
        self.zos = self.zos - self.speed
        self.leaf:frame()
        if self.timer % 100 == 0 then
            table.insert(self.door, {
                x = self:sign() * self:float(1, 1.5), y = self:float(1, 3), z = self:float(12, 13),
                season = self.tu[self:int(1, #self.tu)], size = self:float(0.7, 0.9), _angle = 0, angle = 0, offo = self:float(1.5, 3),
                ry = self:float(-10, 10)
            })
            table.sort(self.door, function(a, b)
                return a.z > b.z
            end)
        end
        local d
        for i = #self.door, 1, -1 do
            d = self.door[i]
            d.z = d.z - self.speed / 100
            d._angle = min(120, 90 / abs(d.z - lstg.view3d.eye[3] - d.offo))
            d.angle = d.angle + (-d.angle + d._angle) * 0.05
            if d.z < -1 then
                table.remove(self.door, i)
            end
        end
    end
end
function TH16_bg:render()
    SetViewMode '3d'
    background.ClearToFogColor()
    if self.scene then
        self.scene:render(self.timer)
    else
        local color
        local z = self.zos
        color = Color(255, 255, 255, 255)
        RenderTexture("16_floor", "",
                { -8, 0, 18, 0, z, color },
                { 8, 0, 18, 1024, z, color },
                { 8, 0, -2, 1024, 1280 + z, color },
                { -8, 0, -2, 0, 1280 + z, color })
        local s, cosr, sinr, offs
        local cosry, sinry
        local off = 10 / 81
        for _, d in ipairs(self.door) do
            s = d.size
            offs = off * s
            cosr, sinr = cos(d.angle), sin(d.angle)
            cosry, sinry = cos(d.ry), sin(d.ry)
            Render4V("16_door" .. d.season,
                    d.x - s * cosry, d.y + s, d.z + s * sinry,
                    d.x + s * cosry, d.y + s, d.z - s * sinry,
                    d.x + s * cosry, d.y - s, d.z - s * sinry,
                    d.x - s * cosry, d.y - s, d.z + s * sinry)
            Render4V("16_door",
                    d.x - (s - offs) * cosry, d.y + s - offs, d.z + (s - offs) * sinry,
                    d.x - (s - offs) * cosry + (s - offs) * cosr, d.y + s - offs, d.z + (s - offs) * sinry - (s - offs) * sinr,
                    d.x - (s - offs) * cosry + (s - offs) * cosr, d.y - s + offs, d.z + (s - offs) * sinry - (s - offs) * sinr,
                    d.x - (s - offs) * cosry, d.y - s + offs, d.z + (s - offs) * sinry)
            Render4V("16_door",
                    d.x + (s - offs) * cosry, d.y + s - offs, d.z - (s - offs) * sinry,
                    d.x + (s - offs) * cosry - (s - offs) * cosr, d.y + s - offs, d.z - (s - offs) * sinry - (s - offs) * sinr,
                    d.x + (s - offs) * cosry - (s - offs) * cosr, d.y - s + offs, d.z - (s - offs) * sinry - (s - offs) * sinr,
                    d.x + (s - offs) * cosry, d.y - s + offs, d.z - (s - offs) * sinry)
        end
        self.leaf:render()
    end
    SetViewMode 'world'
    if self.white > 0 then
        SetImageState("white", "", self.white, unpack(self.color))
        RenderRect("white", lstg.world.l, lstg.world.r, lstg.world.b, lstg.world.t)
    end
end
function TH16_bg:ToSpring()
    task.New(self, function()
        for i = 1, 90 do
            self.white = 255 * i / 90
            task.Wait()
        end
        PlaySound("release")
        PlaySound("big")
        Set3D('eye', 0, 10, 0)
        Set3D('at', 2, 1, 4)
        Set3D('up', 0, 1, 0)
        Set3D('fovy', 0.8)
        Set3D('fog', 2, 10, Color(100, 40, 10, 30))
        task.Clear(self, true)
        self.scene = spring
        self.scene:init()
        background.Move3Dcamera(self, 'eye', 2, 4, 180, 5)
        background.Move3Dcamera(self, 'at', 1, 0, 180, 2)
        for i = 29, 0, -1 do
            self.white = 255 * i / 30
            task.Wait()
        end

        task.Wait()
        task.New(self, function()
            local t, s = 0, 0
            while true do
                s = s + sin(t)
                lstg.view3d.eye[1] = sin(s / 4) * 2
                lstg.view3d.at[3] = 4 + sin(s / 3) * 0.5
                lstg.view3d.up[1] = sin(s / 5) * 0.2
                t = min(t + 1, 90)
                task.Wait()
            end
        end)
        task.Wait(676)
        for _ = 1, 120 do
            spring.speed = spring.speed + 0.0001
            task.Wait()
        end
    end)
end
function TH16_bg:ToSummer()
    task.New(self, function()
        for i = 1, 90 do
            self.white = 255 * i / 90
            task.Wait()
        end
        PlaySound("release")
        PlaySound("big")
        Set3D('eye', 0, 3, 0)
        Set3D('at', 0, 3.5, 4)
        Set3D('up', 0, 1, 0)
        Set3D('z', 0.1, 24)
        Set3D('fovy', 0.1)
        Set3D('fog', 4, 5, Color(100, 31, 173, 206))
        self.scene = summer
        self.scene:init()

        task.Clear(self, true)
        background.Move3Dcamera(self, 'at', 2, 1.5, 180, 2)
        task.New(self, function()
            for i = 1, 90 do
                lstg.view3d.fovy = 0.1 + 0.9 * sin(i)
                task.Wait()
            end
        end)
        task.New(self, function()
            local t, s = 0, 0
            while true do
                s = s + sin(t)
                lstg.view3d.eye[1] = -sin(s / 4)
                lstg.view3d.at[3] = 4 + sin(s / 3) * 0.5
                lstg.view3d.up[1] = sin(s / 5) * 0.2
                t = min(t + 1, 90)
                task.Wait()
            end
        end)
        for i = 29, 0, -1 do
            self.white = 255 * i / 30
            task.Wait()
        end

    end)
end
function TH16_bg:ToAutumn()
    task.New(self, function()
        for i = 1, 90 do
            self.white = 255 * i / 90
            task.Wait()
        end
        PlaySound("release")
        PlaySound("big")
        Set3D('eye', 0, 3, 0)
        Set3D('at', 0, 1, 4)
        Set3D('up', 0, 1, 1)
        Set3D('z', 0.1, 24)
        Set3D('fovy', 0.1)
        Set3D('fog', 4, 5, Color(100, 239, 80, 3))
        self.scene = autumn
        self.scene:init()

        task.Clear(self, true)
        background.Move3Dcamera(self, 'up', 3, 0, 180, 2)
        task.New(self, function()
            for i = 1, 90 do
                lstg.view3d.fovy = 0.1 + 0.9 * sin(i)
                task.Wait()
            end
        end)
        task.New(self, function()
            local t, s = 0, 0
            while true do
                s = s + sin(t)
                lstg.view3d.eye[1] = -sin(s / 5)
                lstg.view3d.at[3] = 4 + sin(s / 3) * 0.5
                lstg.view3d.up[1] = sin(s / 2) * 0.1
                t = min(t + 1, 90)
                task.Wait()
            end
        end)
        for i = 29, 0, -1 do
            self.white = 255 * i / 30
            task.Wait()
        end

    end)
end
function TH16_bg:ToWinter()
    task.New(self, function()
        for i = 1, 90 do
            self.white = 255 * i / 90
            task.Wait()
        end
        PlaySound("release")
        PlaySound("big")
        Set3D('eye', 0, 5.6, -1)
        Set3D('at', 0, 0, 3)
        Set3D('up', 1, 0, 0)
        Set3D('fovy', 0.8)
        Set3D('fog', 2, 8, Color(100, 20, 60, 100))
        task.Clear(self, true)
        background.Move3Dcamera(self, 'eye', 2, 3.8, 180, 5)
        background.Move3Dcamera(self, 'up', 1, 0, 180, 2)
        background.Move3Dcamera(self, 'up', 2, 1, 180, 2)
        background.Move3Dcamera(self, 'at', 2, 1, 180, 2)
        self.scene = winter
        self.scene:init()
        task.New(self, function()
            local t, s = 0, 0
            while true do
                s = s + sin(t)
                lstg.view3d.eye[1] = sin(s / 4)
                lstg.view3d.at[3] = 3 + sin(s / 3) * 0.5
                t = min(t + 1, 90)
                task.Wait()
            end
        end)
        for i = 29, 0, -1 do
            self.white = 255 * i / 30
            task.Wait()
        end

    end)
end
function TH16_bg:ToDefault()
    task.New(self, function()
        for i = 1, 90 do
            self.white = 255 * i / 90
            task.Wait()
        end
        self.scene = nil
        task.Clear(self, true)
        task.New(self, function()
            for i = 29, 0, -1 do
                self.white = 255 * i / 30
                task.Wait()
            end
        end)
        self.speed = 2.3
        Set3D('eye', 0, 3, 0)
        Set3D('at', 0, 1, 4.5)
        Set3D('up', 0, 1, 0)
        Set3D('z', 0.1, 50)
        Set3D('fovy', 1)
        Set3D('fog', 2, 10, Color(100, 30, 0, 0))
        local s, t = 0, 0
        while true do
            s = s + sin(t)
            lstg.view3d.eye[2] = 3 + sin(s / 2) * 0.8
            lstg.view3d.at[1] = sin(s / 3) * 0.8
            lstg.view3d.up[1] = sin(s / 5) * 0.3
            t = min(t + 1, 90)
            task.Wait()
        end
    end)
end

function spring:init(speed)
    self.speed = speed or 0.01
    self.zos = 0
    self.leaf = CreateFallLeaf({ { -4, 3 }, { 0, 2.5 }, { 7, 9 }, { 0.5, 1 }, { -0.002, 0.002 }, { -0.002, -0.002 }, { -0.01, -0.02 } },
            16, 0.3, "mul+add", 200, { 250, 250, 250 },
            "cherry_bullet", function(self)
                return self.z < lstg.view3d.eye[3] - 1
            end, { count = 30, xRange = { -4, 4 }, yRange = { 0, 2.5 }, zRange = { -1, 7 } }, true)
    --New(camera_setter)
end
function spring:frame()
    self.zos = self.zos - self.speed * 100
    self.leaf.speed = self.speed * 100
    self.leaf:frame()
end
function spring:render()
    ClearZBuffer()
    SetZBufferEnable(1)
    local color
    local z = self.zos
    local uv1, uv2, uv3, uv4 = {}, {}, {}, {}
    color = Color(255, 255, 255, 255)
    uv1[6], uv2[6], uv3[6], uv4[6] = color, color, color, color
    uv1[1], uv1[2], uv1[3], uv1[4], uv1[5] = -4, 0, 14, 0, z
    uv2[1], uv2[2], uv2[3], uv2[4], uv2[5] = 0, 0, 14, 511, z
    uv3[1], uv3[2], uv3[3], uv3[4], uv3[5] = 0, 0, -6, 511, 2560 + z
    uv4[1], uv4[2], uv4[3], uv4[4], uv4[5] = -4, 0, -6, 0, 2560 + z
    RenderTexture("16_spring1", "", uv1, uv2, uv3, uv4)
    uv1[1], uv1[2], uv1[3], uv1[4], uv1[5] = 4, 0, 14, 0, z
    uv2[1], uv2[2], uv2[3], uv2[4], uv2[5] = 0, 0, 14, 511, z
    uv3[1], uv3[2], uv3[3], uv3[4], uv3[5] = 0, 0, -6, 511, 2560 + z
    uv4[1], uv4[2], uv4[3], uv4[4], uv4[5] = 4, 0, -6, 0, 2560 + z
    RenderTexture("16_spring1", "", uv1, uv2, uv3, uv4)

    for i = 2, 4 do
        local img = "16_spring" .. i
        uv1[1], uv1[2], uv1[3], uv1[4], uv1[5] = -4, 0.2 * i, 14, 0, z + 512
        uv2[1], uv2[2], uv2[3], uv2[4], uv2[5] = 0, 0.2 * i, 14, 511, z + 512
        uv3[1], uv3[2], uv3[3], uv3[4], uv3[5] = 0, 0.2 * i, -6, 511, 2560 + z + 512
        uv4[1], uv4[2], uv4[3], uv4[4], uv4[5] = -4, 0.2 * i, -6, 0, 2560 + z + 512
        RenderTexture(img, "", uv1, uv2, uv3, uv4)
        uv1[1], uv1[2], uv1[3], uv1[4], uv1[5] = -4, 1 + 0.2 * i, 14, 0, z
        uv2[1], uv2[2], uv2[3], uv2[4], uv2[5] = 0, 1 + 0.2 * i, 14, 511, z
        uv3[1], uv3[2], uv3[3], uv3[4], uv3[5] = 0, 1 + 0.2 * i, -6, 511, 2560 + z
        uv4[1], uv4[2], uv4[3], uv4[4], uv4[5] = -4, 1 + 0.2 * i, -6, 0, 2560 + z
        RenderTexture(img, "", uv1, uv2, uv3, uv4)
        uv1[1], uv1[2], uv1[3], uv1[4], uv1[5] = -4, 0.2 * i, 14, 0, z + 512
        uv2[1], uv2[2], uv2[3], uv2[4], uv2[5] = -8, 0.2 * i, 14, 511, z + 512
        uv3[1], uv3[2], uv3[3], uv3[4], uv3[5] = -8, 0.2 * i, -6, 511, 2560 + z + 512
        uv4[1], uv4[2], uv4[3], uv4[4], uv4[5] = -4, 0.2 * i, -6, 0, 2560 + z + 512
        RenderTexture(img, "", uv1, uv2, uv3, uv4)
        uv1[1], uv1[2], uv1[3], uv1[4], uv1[5] = -4, 1 + 0.2 * i, 14, 0, z
        uv2[1], uv2[2], uv2[3], uv2[4], uv2[5] = -8, 1 + 0.2 * i, 14, 511, z
        uv3[1], uv3[2], uv3[3], uv3[4], uv3[5] = -8, 1 + 0.2 * i, -6, 511, 2560 + z
        uv4[1], uv4[2], uv4[3], uv4[4], uv4[5] = -4, 1 + 0.2 * i, -6, 0, 2560 + z
        RenderTexture(img, "", uv1, uv2, uv3, uv4)
        uv1[1], uv1[2], uv1[3], uv1[4], uv1[5] = 4, 0.2 * i, 14, 0, z
        uv2[1], uv2[2], uv2[3], uv2[4], uv2[5] = 0, 0.2 * i, 14, 511, z
        uv3[1], uv3[2], uv3[3], uv3[4], uv3[5] = 0, 0.2 * i, -6, 511, 2560 + z
        uv4[1], uv4[2], uv4[3], uv4[4], uv4[5] = 4, 0.2 * i, -6, 0, 2560 + z
        RenderTexture(img, "", uv1, uv2, uv3, uv4)
        uv1[1], uv1[2], uv1[3], uv1[4], uv1[5] = 4, 1 + 0.2 * i, 14, 0, z + 512
        uv2[1], uv2[2], uv2[3], uv2[4], uv2[5] = 0, 1 + 0.2 * i, 14, 511, z + 512
        uv3[1], uv3[2], uv3[3], uv3[4], uv3[5] = 0, 1 + 0.2 * i, -6, 511, 2560 + z + 512
        uv4[1], uv4[2], uv4[3], uv4[4], uv4[5] = 4, 1 + 0.2 * i, -6, 0, 2560 + z + 512
        RenderTexture(img, "", uv1, uv2, uv3, uv4)
        uv1[1], uv1[2], uv1[3], uv1[4], uv1[5] = 4, 0.2 * i, 14, 0, z
        uv2[1], uv2[2], uv2[3], uv2[4], uv2[5] = 8, 0.2 * i, 14, 511, z
        uv3[1], uv3[2], uv3[3], uv3[4], uv3[5] = 8, 0.2 * i, -6, 511, 2560 + z
        uv4[1], uv4[2], uv4[3], uv4[4], uv4[5] = 4, 0.2 * i, -6, 0, 2560 + z
        RenderTexture(img, "", uv1, uv2, uv3, uv4)
        uv1[1], uv1[2], uv1[3], uv1[4], uv1[5] = 4, 1 + 0.2 * i, 14, 0, z + 512
        uv2[1], uv2[2], uv2[3], uv2[4], uv2[5] = 8, 1 + 0.2 * i, 14, 511, z + 512
        uv3[1], uv3[2], uv3[3], uv3[4], uv3[5] = 8, 1 + 0.2 * i, -6, 511, 2560 + z + 512
        uv4[1], uv4[2], uv4[3], uv4[4], uv4[5] = 4, 1 + 0.2 * i, -6, 0, 2560 + z + 512
        RenderTexture(img, "", uv1, uv2, uv3, uv4)
    end

    SetZBufferEnable(0)
    self.leaf:render()
end

function summer:init()
    self.zos = 0
    self.xos = 0
    self.speed = 0.008
    self.cloud = {}
    table.insert(self.cloud, {
        x = background:RanFloat(-1, 0),
        y = background:RanFloat(2.8, 3.8),
        z = background:RanFloat(3.8, 4),
        alpha = 200,
        xos = background:RanFloat(self.speed / 4, self.speed / 2),
        scale = background:RanFloat(1.6, 2.5),
        timer = 10
    })
    table.insert(self.cloud, {
        x = background:RanFloat(-1, 1),
        y = background:RanFloat(3.8, 4.5),
        z = background:RanFloat(3.8, 4),
        alpha = 200,
        xos = background:RanFloat(self.speed / 4, self.speed / 2),
        scale = background:RanFloat(1.6, 2.5),
        timer = 10
    })
    --New(camera_setter)
end
function summer:frame(timer)
    self.zos = self.zos - self.speed
    self.xos = self.xos + self.speed / 2.1
    if timer % 360 == 0 then
        table.insert(self.cloud, {
            x = background:RanFloat(-5, -3),
            y = background:RanFloat(2.8, 3.8),
            z = background:RanFloat(3.8, 4),
            alpha = 0,
            xos = background:RanFloat(self.speed / 4, self.speed / 2),
            scale = background:RanFloat(1.6, 2.5),
            timer = 1
        })
    end
    local cloud
    for i = #self.cloud, 1, -1 do
        cloud = self.cloud[i]
        cloud.x = cloud.x + cloud.xos
        if cloud.timer <= 10 then
            cloud.alpha = min(200, cloud.alpha + 200 / 10)
        end
        cloud.timer = cloud.timer + 1
        if cloud.x > 5 then
            cloud.alpha = max(0, cloud.alpha - 200 / 10)
        end
        if cloud.timer >= 60 and cloud.alpha == 0 then
            table.remove(self.cloud, i)
        end
    end
end
function summer:render()
    local color
    local z = self.zos * 100
    local x = self.xos * 100
    color = Color(255, 255, 255, 255)
    RenderTexture("16_summer1", "",
            { -4, 1, 14, x + 256, z, color },
            { 4, 1, 14, 1536 + 256 + x, z, color },
            { 4, 1, -6, 1536 + 256 + x, 3072 + z, color },
            { -4, 1, -6, x + 256, 3072 + z, color })
    Render4V("16_summer3", -4, 6, 4, 4, 6, 4, 4, 1, 4, -4, 1, 4)
    for _, cloud in ipairs(self.cloud) do
        SetImageState("16_summer2", 'mul+add', cloud.alpha, 255, 255, 255)
        Render4V("16_summer2",
                cloud.x - cloud.scale, cloud.y + cloud.scale, cloud.z,
                cloud.x + cloud.scale, cloud.y + cloud.scale, cloud.z,
                cloud.x + cloud.scale, cloud.y - cloud.scale, cloud.z,
                cloud.x - cloud.scale, cloud.y - cloud.scale, cloud.z
        )
    end
end

function autumn:init()
    self.zos = 0
    self.xos = 0
    self.speed = 0.003
    self.cloud = {}
    table.insert(self.cloud, {
        x = background:RanFloat(-1, 0),
        y = background:RanFloat(2.3, 2.8),
        z = background:RanFloat(3.8, 4),
        alpha = 200,
        xos = background:RanFloat(self.speed / 4, self.speed / 2),
        scale = background:RanFloat(2, 2.5),
        timer = 10
    })
    self.leaf = CreateFallLeaf({ { -4, 4 }, { 3, 5 }, { 1, 7 }, { 1, 2 }, { -0.002, 0.002 }, { -0.01, -0.025 }, { -0.01, -0.005 } },
            12, 0.1, "mul+add", 100, { 200, 150, 100 },
            "small_leaf", function(self)
                return self.y < -3
            end, { count = 20, xRange = { -4, 4 }, yRange = { -3, 5 }, zRange = { 1, 7 } }, true)
    --New(camera_setter)
end
function autumn:frame(timer)
    self.zos = self.zos - self.speed
    self.xos = self.xos + self.speed / 2.1
    self.leaf:frame()
    if timer % 360 == 0 then
        table.insert(self.cloud, {
            x = background:RanFloat(-5, -3),
            y = background:RanFloat(2.3, 3.5),
            z = background:RanFloat(3.8, 4),
            alpha = 0,
            xos = background:RanFloat(self.speed / 4, self.speed / 2),
            scale = background:RanFloat(2, 2.5),
            timer = 1
        })
    end
    local cloud
    for i = #self.cloud, 1, -1 do
        cloud = self.cloud[i]
        cloud.x = cloud.x + cloud.xos
        if cloud.timer <= 10 then
            cloud.alpha = min(200, cloud.alpha + 200 / 10)
        end
        cloud.timer = cloud.timer + 1
        if cloud.x > 2 then
            cloud.alpha = max(0, cloud.alpha - 200 / 10)
        end
        if cloud.timer >= 60 and cloud.alpha == 0 then
            table.remove(self.cloud, i)
        end
    end
end
function autumn:render()
    local color
    local z = self.zos * 100
    local x = self.xos * 100
    local uv1, uv2, uv3, uv4 = {}, {}, {}, {}
    color = Color(255, 255, 255, 255)
    uv1[6], uv2[6], uv3[6], uv4[6] = color, color, color, color
    uv1[1], uv1[2], uv1[3], uv1[4], uv1[5] = -4, 1, 14, x + 256, z
    uv2[1], uv2[2], uv2[3], uv2[4], uv2[5] = 4, 1, 14, 1536 + 256 + x, z
    uv3[1], uv3[2], uv3[3], uv3[4], uv3[5] = 4, 1, -6, 1536 + 256 + x, 3072 + z
    uv4[1], uv4[2], uv4[3], uv4[4], uv4[5] = -4, 1, -6, x + 256, 3072 + z
    RenderTexture("16_autumn1", "", uv1, uv2, uv3, uv4)
    color = Color(120, 255, 255, 255)
    uv1[6], uv2[6], uv3[6], uv4[6] = color, color, color, color
    uv1[1], uv1[2], uv1[3], uv1[4], uv1[5] = -4, 1, 14, x + 256, z * 1.5
    uv2[1], uv2[2], uv2[3], uv2[4], uv2[5] = 4, 1, 14, 1536 + x, z * 1.5
    uv3[1], uv3[2], uv3[3], uv3[4], uv3[5] = 4, 1, -6, 1536 + x, 3072 + z * 1.5
    uv4[1], uv4[2], uv4[3], uv4[4], uv4[5] = -4, 1, -6, x + 256, 3072 + z * 1.5
    RenderTexture("16_autumn2", "", uv1, uv2, uv3, uv4)
    Render4V("16_autumn4", -4, 4, 4, 4, 4, 4, 4, 1, 4, -4, 1, 4)
    for _, c in ipairs(self.cloud) do
        SetImageState("16_autumn3", 'mul+add', c.alpha, 255, 255, 255)
        Render4V("16_autumn3",
                c.x - c.scale, c.y + c.scale * 0.3, c.z,
                c.x + c.scale, c.y + c.scale * 0.3, c.z,
                c.x + c.scale, c.y - c.scale * 0.3, c.z,
                c.x - c.scale, c.y - c.scale * 0.3, c.z
        )
    end
    self.leaf:render()
end

function winter:init()
    self.speed = 0.025
    self.zos = 0
    self.cloud = {}
    --New(camera_setter)
    self.scale = 0.1
    local f = background.RanFloat
    for _ = 1, 60 do
        self:create_cloud(f(self, -3, 3), f(self, 2.5, 3.5), f(self, 0, 7), f(self, 30, 40))
    end
end
function winter:create_cloud(x, y, z, alpha)
    table.insert(self.cloud, { x = x, y = y, z = z, alpha = 0, talpha = alpha })
    table.sort(self.cloud, function(a, b)
        return a.z > b.z
    end)
end
function winter:frame(timer)
    if timer % math.ceil(self.scale / self.speed) == 0 then
        local f = background.RanFloat
        self:create_cloud(f(self, -3, 3), f(self, 2.5, 3.5), f(self, 7, 9), f(self, 30, 40))
    end
    local c
    for i = #self.cloud, 1, -1 do
        c = self.cloud[i]
        c.z = c.z - self.speed * 0.5
        c.alpha = min(c.talpha, c.alpha + c.talpha / 20)
        if c.z < -2 then
            c.alpha = max(0, c.alpha - c.talpha / 10)
            if c.alpha == 0 then
                table.remove(self.cloud, i)
            end
        end
    end
    self.zos = self.zos - self.speed * 100
end
function winter:render()
    local color
    local z = self.zos
    local uv1, uv2, uv3, uv4 = {}, {}, {}, {}
    color = Color(255, 255, 255, 255)
    uv1[6], uv2[6], uv3[6], uv4[6] = color, color, color, color
    uv1[1], uv1[2], uv1[3], uv1[4], uv1[5] = -8, 0, 18, 0, z * 1.5
    uv2[1], uv2[2], uv2[3], uv2[4], uv2[5] = 8, 0, 18, 2048, z * 1.5
    uv3[1], uv3[2], uv3[3], uv3[4], uv3[5] = 8, 0, -6, 2048, 3072 + z * 1.5
    uv4[1], uv4[2], uv4[3], uv4[4], uv4[5] = -8, 0, -6, 0, 3072 + z * 1.5
    RenderTexture("16_winter3", "", uv1, uv2, uv3, uv4)
    color = Color(100, 255, 255, 255)
    uv1[6], uv2[6], uv3[6], uv4[6] = color, color, color, color
    uv1[1], uv1[2], uv1[3], uv1[4], uv1[5] = -8, 1, 18, 0, z
    uv2[1], uv2[2], uv2[3], uv2[4], uv2[5] = 8, 1, 18, 2048, z
    uv3[1], uv3[2], uv3[3], uv3[4], uv3[5] = 8, 1, -6, 2048, 3072 + z
    uv4[1], uv4[2], uv4[3], uv4[4], uv4[5] = -8, 1, -6, 0, 3072 + z
    RenderTexture("16_winter1", "mul+add", uv1, uv2, uv3, uv4)
    color = Color(30, 255, 255, 255)
    uv1[6], uv2[6], uv3[6], uv4[6] = color, color, color, color
    uv1[1], uv1[2], uv1[3], uv1[4], uv1[5] = -8, 2, 18, 0 + 256, z * 0.3
    uv2[1], uv2[2], uv2[3], uv2[4], uv2[5] = 8, 2, 18, 2048 + 256, z * 0.3
    uv3[1], uv3[2], uv3[3], uv3[4], uv3[5] = 8, 2, -6, 2048 + 256, 3072 + z * 0.3
    uv4[1], uv4[2], uv4[3], uv4[4], uv4[5] = -8, 2, -6, 0 + 256, 3072 + z * 0.3
    RenderTexture("16_winter1", "mul+add", uv1, uv2, uv3, uv4)

    local v = SQRT2_2
    for _, c in ipairs(self.cloud) do
        SetImageState("16_winter2", "", c.alpha, 255, 255, 255)
        Render4V("16_winter2",
                c.x - 1, c.y + v, c.z + v,
                c.x + 1, c.y + v, c.z + v,
                c.x + 1, c.y - v, c.z - v,
                c.x - 1, c.y - v, c.z - v)
    end
end