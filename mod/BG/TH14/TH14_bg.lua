local stage_1, stage_2, stage_3, stage_4, stage_5, stage_6 = {}, {}, {}, {}, {}, {}

local SetViewMode = SetViewMode
local RenderTexture = RenderTexture
local Color = Color
local Set3D = Set3D
local table = table
local cos, sin = cos, sin
local background = background
local SetImageState = SetImageState
local Render4V = Render4V
local Render = Render

TH14_bg = Class(background)

function TH14_bg:init()
    --背景资源太多不在这里加载


    background.init(self, false)
    self.float = background.RanFloat
    self.int = background.RanInt
    self.sign = background.RanSign
    Set3D('eye', 0, 1, -1)
    Set3D('at', 0, 0, 0)
    Set3D('up', 0, 1, 0)
    Set3D('z', 0.1, 50)
    Set3D('fovy', 1)
    Set3D('fog', 0, 0.1, Color(100, 0, 0, 0))
    TH14_bg.fall_leaf = true
    self.white = 0
    self.color = { 255, 255, 255 }
    self.bright = {}
    local lstg = lstg
    task.New(self, function()
        local Move3D = background.Move3Dcamera
        local t, s = 0, 0
        while true do
            Set3D('eye', 0, 1, -1)
            Set3D('at', 0, 0, 0)
            Set3D('up', 0, 1, 0)
            Set3D('z', 0.1, 50)
            Set3D('fovy', 1)
            Set3D('fog', 0, 0.1, Color(100, 0, 0, 0))
            self.white = 0
            self.color = { 255, 255, 255 }
            do
                self.scene = stage_1
                self.scene:init(0.0005, 0.3)
                task.Wait(60)
                Move3D(self, "fog", 1, 7, 90, 1)
                Move3D(self, "fog", 2, 20, 90, 1)
                Move3D(self, "eye", 2, 2, 240, 3)
                Move3D(self, "eye", 3, -1, 360, 3)
                for _ = 1, 120 do
                    stage_1.speed = stage_1.speed + 0.0001
                    task.Wait()
                end
                task.Wait(389 - 120 - 60)
                Move3D(self, "eye", 2, 1.5, 90, 3)
                task.New(self, function()
                    for _ = 1, 120 do
                        stage_1.speed = stage_1.speed + 0.0001
                        task.Wait()
                    end
                    task.Wait(2166 - 120 - 389)
                    stage_1.scale = 0.01
                    for _ = 1, 60 do
                        stage_1.speed = stage_1.speed + 0.0009
                        task.Wait()
                    end
                    task.Wait(177 - 60)
                    for i = 1, 160 do
                        stage_1.speed = stage_1.speed + 0.0005
                        self.white = 255 * i / 160
                        task.Wait()
                    end
                    task.Wait(17)
                    self.scene = stage_2
                    self.scene:init(0.005)
                    for i = 19, 0, -1 do
                        self.white = 255 * i / 20
                        task.Wait()
                    end
                end)
                s, t = 0, 0
                while self.scene == stage_1 do
                    lstg.view3d.eye[1] = sin(t / 4)
                    lstg.view3d.at[1] = sin(t / 4)
                    lstg.view3d.up[1] = sin(t / 3) * 0.2
                    t = t + sin(s)
                    s = min(s + 1, 90)
                    task.Wait()
                end
            end--1
            do
                Set3D('eye', -0.6, 0.5, -0.6)
                Set3D('at', -0.6, 0, 1)
                Set3D('up', -0.1, 1, 0)
                Set3D('fog', 1.5, 3, Color(100, 100, 182, 151))--70,82,71
                Set3D('fovy', 0.9)
                task.New(self, function()
                    Move3D(self, "eye", 2, 1.6, 240, 2)
                    Move3D(self, "eye", 1, 0.8, 240, 2)
                    Move3D(self, "at", 1, 0.4, 240, 2, true)
                    Move3D(self, "eye", 1, -0.6, 240, 3)
                    Move3D(self, "at", 1, -0.6, 360, 3, true)
                    Move3D(self, "at", 2, -5, 240, 3)
                    Move3D(self, "eye", 2, -2.9, 240, 3)
                    Move3D(self, "up", 3, -1, 120, 3)
                end)
                task.New(self, function()
                    s, t = 0, 0
                    while self.scene == stage_2 do
                        lstg.view3d.up[1] = -0.1 + sin(t / 3) * 0.1
                        t = t + sin(s)
                        s = min(s + 1, 90)
                        task.Wait()
                    end
                end)
                for _ = 1, 160 do
                    stage_2.speed = stage_2.speed + 0.005 / 160
                    task.Wait()
                end
                for i = 1, 500 do
                    i = sin(i / 500 * 90)
                    lstg.view3d.fog[3] = Color(100, 100 - 30 * i, 182 - 100 * i, 151 - 80 * i)
                    task.Wait()
                end
                while lstg.view3d.eye[2] > 0 do
                    task.Wait()
                end
            end--2
            do
                task.Clear(self, true)
                task.Wait()
                self.scene = stage_3
                self.scene:init(0.03)
                Set3D('eye', 0, 1.7, -4)
                Set3D('at', 0, 0, 0)
                Set3D('up', 1, 0, 0)
                Set3D('fog', 1.6, 6, Color(100, 0, 0, 0))
                Set3D('fovy', 0.6)
                task.New(self, function()
                    s, t = 0, 0
                    while self.scene == stage_3 do
                        lstg.view3d.eye[1] = sin(t) * 0.3
                        lstg.view3d.at[1] = sin(t / 2) * 0.3
                        t = t + sin(s)
                        s = min(s + 1, 90)
                        task.Wait()
                    end
                end)
                Move3D(self, "up", 1, 0, 160, 3)
                Move3D(self, "up", 2, 1, 160, 3)
                for i = 1, 160 do
                    i = i / 160
                    i = (i * 1.5 - i * i * sin(i * 90)) / 0.5
                    lstg.view3d.eye[2] = 2 - 0.8 * i
                    task.Wait()
                end
                Move3D(self, "at", 2, 5, 500, 3)
                for i = 1, 460 do
                    i = sin(i / 460 * 90)
                    lstg.view3d.fog[3] = Color(100, 140 * i, 50 * i, 60 * i)
                    task.Wait()
                end
                for i = 1, 83 do
                    i = i / 83
                    i = i * i
                    Set3D('fovy', 0.6 - 0.59 * i)
                    task.Wait()
                end
            end--3
            do
                self.scene = stage_4
                self.scene:init()
                Set3D('eye', 0, 3, 0)
                Set3D('at', 0, 2, 2.5)
                Set3D('up', 0, 1, 0)
                Set3D('z', 0.1, 24)
                Set3D('fovy', 0.7)
                Set3D('fog', 10, 20, Color(150, 50, 50, 50))
                task.New(self, function()
                    while true do
                        task.Wait(60)
                        lstg.view3d.fog[3] = Color(100, 255, 227, 132)
                        task.Wait(3)
                        lstg.view3d.fog[3] = Color(100, 50, 50, 50)
                        task.Wait(3)
                        for i = 1, 60 do
                            i = i / 60
                            lstg.view3d.fog[3] = Color(100, 255 - 205 * i, 227 - 177 * i, 132 - 82 * i)
                            task.Wait()
                        end
                        task.Wait(60)
                    end
                end)
                Move3D(self, "eye", 2, 6, 240, 2)
                task.New(self, function()
                    t, s = 0, 0
                    while self.scene == stage_4 do
                        lstg.view3d.eye[1] = sin(t / 2)
                        lstg.view3d.at[1] = sin(t / 6)
                        lstg.view3d.up[1] = sin(t / 3) * 0.5
                        t = t + sin(s)
                        s = min(s + 1, 90)
                        task.Wait()
                    end
                end)
                self.color = { 140, 50, 60 }
                for i = 30, 0, -1 do
                    self.white = 255 * i / 30
                    task.Wait()
                end
                task.Wait(350 - 30)
                Move3D(self, "at", 3, 0.1, 300, 3, true)
                for i = 1, 54 do
                    i = i / 54
                    i = i * i
                    Set3D('fovy', 0.7 - 0.69 * i)
                    task.Wait()
                end
            end--4
            do
                task.Clear(self, true)
                task.Wait()
                self.color = { 50, 50, 50 }
                self.scene = stage_5
                self.scene:init(0, 0)
                Set3D('eye', 0, 0.4, -1.5)
                Set3D('at', 0.8, 0, 0)
                Set3D('up', 0, 1, 0)
                Set3D('z', 0.1, 50)
                Set3D('fovy', 0.8)
                Set3D('fog', 1, 5, Color(150, 70, 20, 60))
                Move3D(self, "eye", 3, -2.5, 180, 2)
                Move3D(self, "eye", 1, -0.8, 360, 2)
                task.New(self, function()
                    for i = 30, 0, -1 do
                        self.white = 255 * i / 30
                        task.Wait()
                    end
                    self.color = { 255, 255, 255 }
                end)
                task.New(self, function()
                    for i = 1, 90 do
                        stage_5.yspeed = -0.005 * sin(i)
                        task.Wait()
                    end
                    task.Wait(270)
                    Move3D(self, "eye", 3, -1, 180, 3)
                    Move3D(self, "eye", 2, 1, 180, 3)
                    for i = 89, 0, -1 do
                        stage_5.yspeed = -0.005 * sin(i)
                        task.Wait()
                    end
                    task.Wait(90)
                    while self.scene == stage_5 do
                        stage_5.zspeed = stage_5.zspeed + 0.03 / 128
                        self.white = self.white + 1
                        task.Wait()
                    end
                end)

                s, t = 0, 0
                for _ = 1, 4 * 173 do
                    Set3D('up', sin(t), cos(t), 0)
                    t = t + sin(s)
                    s = min(s + 1, 90)
                    task.Wait()
                end
            end--5
            do
                self.scene = stage_6
                self.scene:init(0.03, stage_5.zos, stage_5.yos % 2)
                task.New(self, function()
                    for i = 30, 0, -1 do
                        self.white = 255 * i / 30
                        task.Wait()
                    end
                end)
                Set3D('fog', 2.4, 5, Color(150, 135, 206, 235))
                Move3D(self, "up", 1, 0, 360, 2)
                --Move3D(self, "up", 2, 1, 360, 2)
                Move3D(self, "eye", 2, 1.6, 180, 2)
                Move3D(self, "at", 2, 0.7, 180, 2)
                Move3D(self, "eye", 3, -0.8, 180, 2)
                task.New(self, function()
                    task.Wait(1402)
                    task.New(self, function()
                        for i = 30, 0, -1 do
                            self.white = 255 * i / 30
                            task.Wait()
                        end
                    end)
                    self.scene = stage_5
                    self.scene:init(stage_6.zspeed, 0, stage_6.zos, stage_6.yos)
                end)
                s, t = 0, 0
                while self.scene == stage_6 do
                    lstg.view3d.eye[1] = sin(t / 3.1 - 90) * 0.8
                    lstg.view3d.at[1] = sin(t / 5 + 90) * 0.8
                    lstg.view3d.up[3] = sin(t / 6) * 0.5
                    lstg.view3d.up[2] = 0.5 + sin(t / 4) * 0.4
                    t = t + sin(s)
                    s = min(s + 1, 90)
                    task.Wait()

                end
                Move3D(self, "eye", 3, -2.3, 360, 2)
                Move3D(self, "at", 1, 1.3, 200, 2)
                Set3D('fog', 1, 5, Color(150, 70, 60, 20))
                task.New(self, function()
                    local speed = stage_5.zspeed
                    for i = 1, 90 do
                        stage_5.zspeed = speed - speed * sin(i)
                        task.Wait()
                    end
                    for i = 1, 180 do
                        stage_5.yspeed = sin(i / 2) * 0.01
                        task.Wait()
                    end
                    Move3D(self, "up", 3, 0.8, 300, 3)
                    task.Wait(90)
                    Move3D(self, "up", 2, -0.8, 300, 3)
                end)
                task.New(self, function()
                    task.Wait(701)
                    for i = 1, 180 do
                        stage_5.yspeed = 0.01 + sin(i / 2) * 0.01
                        task.Wait()
                    end
                    task.Wait(703 - 180)
                    task.New(self, function()
                        for i = 30, 0, -1 do
                            self.white = 255 * i / 30
                            task.Wait()
                        end
                    end)
                    self.scene = stage_1
                    self.scene:init(stage_5.yspeed * 2)
                end)
                while self.scene == stage_5 do
                    lstg.view3d.eye[2] = 1 + sin(t / 2.5 + 90) * 0.6
                    t = t + sin(s)
                    s = min(s + 1, 90)
                    task.Wait()
                end
            end--6
            do
                Move3D(self, "up", 3, 0, 177, 2)
                Move3D(self, "up", 2, 1, 177, 2)
                Move3D(self, "eye", 1, 0, 120, 2)
                Move3D(self, "at", 2, -3, 160, 2)
                Move3D(self, "at", 1, 0, 120, 2)
                Move3D(self, "eye", 2, 1.2, 177, 1, true)
                task.New(self, function()
                    for i = 30, 0, -1 do
                        self.white = 255 * i / 30
                        task.Wait()
                    end
                end)
                self.scene = stage_2
                self.scene:init(stage_1.speed * 1.5)
                Set3D('eye', -0.3, 1.5, -3.2)
                Set3D('at', -0.1, 0, 0)
                Set3D('up', 0.5, 1, 0)
                Set3D('fog', 0.3, 3.7, Color(150, 10, 20, 20))
                Move3D(self, "eye", 1, 0.3, 177, 2)
                Move3D(self, "up", 1, 0, 177, 2)
                Move3D(self, "at", 2, -1.5, 177, 2)
                Move3D(self, "eye", 2, 0.5, 177, 2, true)
                task.New(self, function()
                    for i = 30, 0, -1 do
                        self.white = 255 * i / 30
                        task.Wait()
                    end
                end)
                self.scene = stage_3
                self.scene:init(stage_2.speed * 1.5)
                Move3D(self, "at", 2, 3, 177, 2, true)
                Set3D('eye', 0, 0, 0)
                Set3D('at', 0, 2, 2.5)
                Set3D('up', 0, 1, 0)
                Set3D('z', 0.1, 24)
                Set3D('fovy', 0.7)
                Set3D('fog', 10, 20, Color(150, 50, 50, 50))
                task.New(self, function()
                    for i = 30, 0, -1 do
                        self.white = 255 * i / 30
                        task.Wait()
                    end
                    task.Wait(60)
                    lstg.view3d.fog[3] = Color(100, 218, 112, 214)
                    task.Wait(3)
                    lstg.view3d.fog[3] = Color(100, 50, 50, 50)
                    task.Wait(3)
                    for i = 1, 60 do
                        i = i / 60
                        lstg.view3d.fog[3] = Color(100, 218 - 168 * i, 112 - 62 * i, 214 - 164 * i)
                        task.Wait()
                    end
                    task.Wait(60)
                end)
                self.scene = stage_4
                self.scene:init()
                Move3D(self, "eye", 2, 6, 177, 2, true)
            end--7
            do
                task.New(self, function()
                    self.color = { 0, 0, 0 }
                    for i = 30, 0, -1 do
                        self.white = 255 * i / 30
                        task.Wait()
                    end
                    self.color = { 255, 255, 255 }
                end)
                self.scene = stage_6
                self.scene:init(0.03)
                Set3D('eye', 0, 1.6, -1)
                Set3D('at', 0, 1.6, 0)
                Set3D('up', 0, 1, 0)
                Set3D("fovy", 0.7)
                Set3D('fog', 2.4, 5, Color(150, 0, 0, 0))
                task.New(self, function()
                    task.Wait(1402)
                    task.New(self, function()
                        for i = 30, 0, -1 do
                            self.white = 255 * i / 30
                            task.Wait()
                        end
                    end)
                    for _ = 1, 180 do
                        stage_6.zspeed = stage_6.zspeed + 0.09 / 180
                        task.Wait()
                    end
                    task.Wait(1402 - 180 - 180)
                    for i = 1, 180 do
                        self.white = sin(i / 2) * 255
                        task.Wait()
                    end
                    self.scene = stage_5
                    self.scene:init(stage_6.zspeed, 0, stage_6.zos)
                    task.New(self, function()
                        for i = 30, 0, -1 do
                            self.white = 255 * i / 30
                            task.Wait()
                        end
                    end)

                end)
                s, t = 0, 90
                local d = lstg.view3d
                while self.scene == stage_6 do
                    d.eye[1] = cos(t) * 0.9
                    d.eye[2] = 1 + sin(t) * 0.6
                    d.at[1] = d.eye[1]
                    d.at[2] = d.eye[2] * 0.6
                    d.up[1] = cos(t / 2)
                    d.up[2] = sin(t / 2)
                    for c = 1, 4 do
                        TH14_bg.CreateBright(self, cos(t - c * 30) * 0.9, 1 + sin(t + c * 60) * 0.6, 4, 0, 0, -stage_6.zspeed / 1.5,
                                500, 250, { 135, 206, 235 }, 1)
                        TH14_bg.CreateBright(self, -cos(t - c * 30) * 0.9, 1 + sin(t + c * 60) * 0.6, 4, 0, 0, -stage_6.zspeed / 1.5,
                                500, 250, { 135, 206, 235 }, 1)
                    end
                    t = t + sin(s) * 0.6
                    s = min(s + 1, 90)
                    task.Wait()
                end
                Move3D(self, "eye", 3, -2.5, 180, 2)
                Move3D(self, "eye", 1, 0, 180, 2)
                Move3D(self, "at", 1, 1, 180, 2)
                task.New(self, function()
                    s, t = 0, 0
                    while self.scene == stage_5 do
                        lstg.view3d.up[1] = 0.92 * sin(t - 90)
                        t = t + sin(s) * 0.6
                        s = min(s + 1, 90)
                        task.Wait()
                    end
                end)
                local speed = stage_5.zspeed
                for i = 1, 180 do
                    stage_5.yspeed = sin(i / 2) * sin(i / 2) * speed
                    stage_5.zspeed = speed - speed * sin(i / 2)
                    task.Wait()
                end
                task.Wait(300)
                for i = 179, 0, -1 do
                    stage_5.yspeed = sin(i / 2) * sin(i / 2) * speed
                    stage_5.zspeed = -speed + speed * sin(i / 2)
                    task.Wait()
                end
                self.color = { 0, 0, 0 }
                for i = 1, 41 do
                    lstg.view3d.fovy = 0.7 - 0.69 * sin(i / 41 * 90)
                    lstg.view3d.at[1] = lstg.view3d.at[1] - 0.02
                    task.Wait()
                end
                self.scene = stage_4
                self.scene:init(4, 6)
                Set3D('eye', 4, 6, 0)
                Set3D('at', 0, 2, 2.5)
                Set3D('up', 0, 1, 0)
                Set3D('z', 0.1, 24)
                Set3D('fovy', 0.7)
                Set3D('fog', 10, 20, Color(150, 50, 50, 50))
                task.New(self, function()
                    for i = 30, 0, -1 do
                        self.white = 255 * i / 30
                        task.Wait()
                    end
                end)
                task.New(self, function()
                    while true do
                        task.Wait(60)
                        lstg.view3d.fog[3] = Color(100, 250, 128, 114)
                        task.Wait(3)
                        lstg.view3d.fog[3] = Color(100, 50, 50, 50)
                        task.Wait(3)
                        for i = 1, 60 do
                            i = i / 60
                            lstg.view3d.fog[3] = Color(100, 250 - 200 * i, 128 - 78 * i, 114 - 64 * i)
                            task.Wait()
                        end
                        task.Wait(60)
                    end
                end)
                Move3D(self, "eye", 1, 0, 120, 2, true)
                Move3D(self, "eye", 2, 13, 600, 3)
                task.Wait(400)
                self.color = { 255, 255, 255 }
                for i = 1, 270 do
                    self.white = sin(i / 3) * 255
                    task.Wait()
                end
                task.Wait(60)
                for i = 1, 60 do
                    self.color[1] = 255 - i / 60 * 255
                    self.color[2] = self.color[1]
                    self.color[3] = self.color[1]
                    task.Wait()
                end
                task.Wait(1052 - 910 - 60 - 1)
                task.Clear(self, true)
                task.Wait()
            end
        end
    end)
end

function TH14_bg:CreateBright(x, y, z, vx, vy, vz, lifetime, alpha, color, scale)
    table.insert(self.bright, { x = x, y = y, z = z,
                                vx = vx, vy = vy, vz = vz,
                                lifetime = lifetime - 10, alpha = 0, talpha = alpha, timer = 0, color = color, scale = scale })
end

function TH14_bg:frame()
    task.Do(self)
    self.scene:frame(self.timer)
    local b
    for i = #self.bright, 1, -1 do
        b = self.bright[i]
        b.x = b.x + b.vx
        b.y = b.y + b.vy
        b.z = b.z + b.vz
        if b.timer < 10 then
            b.alpha = min(b.talpha, b.alpha + b.talpha / 10)
        else
            b.alpha = max(0, b.alpha - b.talpha * b.timer / b.lifetime)
            if b.alpha == 0 or b.z < lstg.view3d.eye[3] - 1 then
                table.remove(self.bright, i)
            end
        end
        b.timer = b.timer + 1
    end
end
local function rotate(x, y, z, ax, ay, az)
    x, y = x * cos(az) - y * sin(az), y * cos(az) + x * sin(az)
    x, z = x * cos(ay) - z * sin(ay), z * cos(ay) + x * sin(ay)
    y, z = y * cos(ax) - z * sin(ax), z * cos(ax) + y * sin(ax)
    return x, y, z
end
function TH14_bg:render()
    SetViewMode '3d'
    background.ClearToFogColor()
    self.scene:render(self.timer)
    local ax, ay
    local p0, p1, p2, p3 = {}, {}, {}, {}
    local eye = lstg.view3d.eye
    local scale
    for _, b in ipairs(self.bright) do
        SetImageState("bright", "mul+add", b.alpha, unpack(b.color))
        ay = Angle(-b.z, b.x, -eye[3], eye[1])
        ax = Angle(-b.z * cos(ay) + b.x * sin(ay), b.y, -eye[3] * cos(ay) + eye[1] * sin(ay), eye[2])
        scale = 0.05 * b.scale
        p0[1], p0[2], p0[3] = rotate(-scale, scale, 0, ax, ay, 0)
        p1[1], p1[2], p1[3] = rotate(scale, scale, 0, ax, ay, 0)
        p2[1], p2[2], p2[3] = rotate(scale, -scale, 0, ax, ay, 0)
        p3[1], p3[2], p3[3] = rotate(-scale, -scale, 0, ax, ay, 0)
        Render4V("bright",
                b.x + p0[1], b.y + p0[2], b.z + p0[3], b.x + p1[1], b.y + p1[2], b.z + p1[3],
                b.x + p2[1], b.y + p2[2], b.z + p2[3], b.x + p3[1], b.y + p3[2], b.z + p3[3])

    end
    SetViewMode 'world'
    if self.white > 0 then
        SetImageState("white", "", self.white, unpack(self.color))
        RenderRect("white", lstg.world.l, lstg.world.r, lstg.world.b, lstg.world.t)
    end
end

do
    function stage_1:init(speed, scale)
        self.cloud = {}
        self.speed = speed or 0.01
        self.zos = 0
        self.x, self.y, self.z = unpack(lstg.view3d.eye)
        self.scale = scale or 0.3
        local f = background.RanFloat
        for _ = 1, 13 do
            self:create_cloud(self.x + f(self, -3, 3),
                    f(self, 0.3, 0.8),
                    self.z + f(self, -3, 3), f(self, 120, 180))
        end
        self.leaf = CreateFallLeaf({ { -3, 3 }, { 1.5, 2.5 }, { 3, 5 }, { 1, 2 }, { -0.002, 0.002 }, { -0.005, -0.01 }, { -0.005, -0.01 } },
                10, 0.1, "mul+add", 100, { 100, 255, 100 },
                "small_leaf", function(self)
                    return self.y < -1 or self.z < lstg.view3d.eye[3] - 1
                end, { count = 13, xRange = { -3, 3 }, yRange = { 0, 2.5 }, zRange = { -3, 3 } }, true)
    end
    function stage_1:create_cloud(x, y, z, alpha)
        table.insert(self.cloud, { x = x, y = y, z = z, alpha = 0, talpha = alpha })
    end
    function stage_1:frame(timer)
        self.x, self.y, self.z = unpack(lstg.view3d.eye)
        self.zos = self.zos - self.speed * 100
        if timer % math.ceil(self.scale / self.speed) == 0 then
            local f = background.RanFloat
            self:create_cloud(self.x + f(self, -3, 3),
                    f(self, 0.3, 0.8),
                    self.z + f(self, 3, 5), f(self, 120, 180))
        end
        local c
        for i = #self.cloud, 1, -1 do
            c = self.cloud[i]
            c.z = c.z - self.speed * 0.5
            c.alpha = min(c.talpha, c.alpha + c.talpha / 20)
            if c.z < self.z - 1 then
                c.alpha = max(0, c.alpha - c.talpha / 10)
                if c.alpha == 0 then
                    table.remove(self.cloud, i)
                end
            end
        end
        if TH14_bg.fall_leaf then
            self.leaf.speed = self.speed * 100
            self.leaf:frame()
        end
    end
    function stage_1:render()
        do
            local uv1, uv2, uv3, uv4 = {}, {}, {}, {}
            local color
            local z = self.zos
            local size = 2048
            uv1[1], uv1[2], uv1[3] = -4, 0, 10
            uv2[1], uv2[2], uv2[3] = 4, 0, 10
            uv3[1], uv3[2], uv3[3] = 4, 0, -6
            uv4[1], uv4[2], uv4[3] = -4, 0, -6

            uv1[4], uv1[5] = 0, z
            uv2[4], uv2[5] = size, z
            uv3[4], uv3[5] = size, size * 2 + z
            uv4[4], uv4[5] = 0, size * 2 + z
            color = Color(190, 255, 255, 255)
            uv1[6], uv2[6], uv3[6], uv4[6] = color, color, color, color
            RenderTexture("14_12", "", uv1, uv2, uv3, uv4)

            color = Color(100, 255, 255, 255)
            uv1[6], uv2[6], uv3[6], uv4[6] = color, color, color, color
            RenderTexture("14_11", "", uv1, uv2, uv3, uv4)

            uv1[4], uv1[5] = -z * 0.3, z
            uv2[4], uv2[5] = size - z * 0.3, z
            uv3[4], uv3[5] = size - z * 0.3, size * 2 + z
            uv4[4], uv4[5] = -z * 0.3, size * 2 + z
            color = Color(50, 255, 255, 255)
            uv1[6], uv2[6], uv3[6], uv4[6] = color, color, color, color
            RenderTexture("14_11", "", uv1, uv2, uv3, uv4)

            color = Color(150, 255, 255, 255)
            uv1[6], uv2[6], uv3[6], uv4[6] = color, color, color, color
            uv1[4], uv1[5] = 0, z
            uv2[4], uv2[5] = size, z
            uv3[4], uv3[5] = size, size * 2 + z
            uv4[4], uv4[5] = 0, size * 2 + z
            uv1[2] = 0.2
            uv2[2] = 0.2
            uv3[2] = 0.2
            uv4[2] = 0.2
            RenderTexture("14_14", "", uv1, uv2, uv3, uv4)
            uv1[2] = 0.4
            uv2[2] = 0.4
            uv3[2] = 0.4
            uv4[2] = 0.4
            RenderTexture("14_13", "", uv1, uv2, uv3, uv4)
        end
        self.leaf:render()
        for _, c in ipairs(self.cloud) do
            SetImageState("14_15", "", c.alpha, 255, 255, 255)
            Render4V("14_15", c.x - 1, c.y, c.z + 1, c.x + 1, c.y, c.z + 1, c.x + 1, c.y, c.z - 1, c.x - 1, c.y, c.z - 1)
        end
    end
end

do
    function stage_2:init(speed)
        self.wicker = {}
        self.speed = speed or 0.01
        self.zos = 0
        self.lakeos = 0
        self.scale = 0.3
        self.x, self.y, self.z = unpack(lstg.view3d.eye)
        local f = background.RanFloat
        for _ = 1, 13 do
            self:create_wicker(f(self, 0, 3), self.z + f(self, -5, 5), f(self, 180, 230))
        end
        self.leaf = CreateFallLeaf({ { -3, 3 }, { 1.5, 2.5 }, { 3, 5 }, { 1, 2 }, { -0.002, 0.002 }, { -0.005, -0.01 }, { -0.01, -0.02 } },
                8, 0.1, "mul+add", 100, { 80, 200, 80 },
                "small_leaf", function(self)
                    return self.y < -1 or self.z < lstg.view3d.eye[3] - 1
                end, { count = 20, xRange = { -3, 3 }, yRange = { 0, 2.5 }, zRange = { -3, 5 } }, true)
    end
    function stage_2:create_wicker(x, z, alpha)
        table.insert(self.wicker, { x = x, y = 1.8, z = z, alpha = 0, talpha = alpha, rot = { -20, -20, -20, -20 }, timer = 0 })
    end
    function stage_2:frame(timer)
        self.x, self.y, self.z = unpack(lstg.view3d.eye)
        self.zos = self.zos - self.speed * 100
        self.lakeos = self.lakeos - 1
        if timer % math.ceil(self.scale / self.speed) == 0 then
            local f = background.RanFloat
            self:create_wicker(f(self, 0, 3), self.z + f(self, 3, 5), f(self, 180, 230))
        end
        local w
        for i = #self.wicker, 1, -1 do
            w = self.wicker[i]
            w.z = w.z - self.speed
            w.alpha = min(w.talpha, w.alpha + w.talpha / 20)
            for j = 2, 4 do
                w.rot[j] = w.rot[j] + (-w.rot[j] + w.rot[j - 1]) * 0.06
            end
            w.rot[1] = -20 + 10 * sin(w.timer) * self.speed * 50
            w.timer = w.timer + 1
            if w.z < self.z - 1 then
                w.alpha = max(0, w.alpha - w.talpha / 10)
                if w.alpha == 0 then
                    table.remove(self.wicker, i)
                end
            end
        end
        if TH14_bg.fall_leaf then
            self.leaf.speed = self.speed * 100
            self.leaf:frame()
        end
    end
    function stage_2:render()
        do
            local color, size
            local z = self.zos
            local z2 = self.lakeos
            size = 2048
            color = Color(255, 255, 255, 255)
            local uv1, uv2, uv3, uv4 = {}, {}, {}, {}
            uv1[6], uv2[6], uv3[6], uv4[6] = color, color, color, color

            uv1[1], uv1[2], uv1[3], uv1[4], uv1[5] = -4, 0, 8, 0, z2 + 100
            uv2[1], uv2[2], uv2[3], uv2[4], uv2[5] = 2, 0, 8, size, z2 + 100
            uv3[1], uv3[2], uv3[3], uv3[4], uv3[5] = 2, 0, -4, size, size * 2 + z2 + 100
            uv4[1], uv4[2], uv4[3], uv4[4], uv4[5] = -4, 0, -4, 0, size * 2 + z2 + 100
            RenderTexture("14_26", "", uv1, uv2, uv3, uv4)

            color = Color(80, 255, 255, 255)
            uv1[6], uv2[6], uv3[6], uv4[6] = color, color, color, color
            uv1[4] = -z2 * 0.2
            uv2[4] = size - z2 * 0.2
            uv3[4] = size - z2 * 0.2
            uv4[4] = -z2 * 0.2
            RenderTexture("14_24", "", uv1, uv2, uv3, uv4)
            uv1[4] = z2 * 0.2
            uv2[4] = size + z2 * 0.2
            uv3[4] = size + z2 * 0.2
            uv4[4] = z2 * 0.2
            uv1[5] = z2
            uv2[5] = z2
            uv3[5] = size * 2 + z2
            uv4[5] = size * 2 + z2
            RenderTexture("14_24", "", uv1, uv2, uv3, uv4)
            color = Color(255, 255, 255, 255)
            size = 256 * 6
            uv1[6], uv2[6], uv3[6], uv4[6] = color, color, color, color

            uv1[1], uv1[2], uv1[3], uv1[4], uv1[5] = -0.2, 0.1, 8, 1, z
            uv2[1], uv2[2], uv2[3], uv2[4], uv2[5] = 0.3, 0.1, 8, size / 24, z
            uv3[1], uv3[2], uv3[3], uv3[4], uv3[5] = 0.3, 0.1, -4, size / 24, size * 2 + z
            uv4[1], uv4[2], uv4[3], uv4[4], uv4[5] = -0.2, 0.1, -4, 1, size * 2 + z
            RenderTexture("14_25", "", uv1, uv2, uv3, uv4)
            uv1[1], uv1[2], uv1[3], uv1[4], uv1[5] = 0, 0.1, 8, 1, z
            uv2[1], uv2[2], uv2[3], uv2[4], uv2[5] = 1, 0.1, 8, size / 6 - 1, z
            uv3[1], uv3[2], uv3[3], uv3[4], uv3[5] = 1, 0.1, -4, size / 6 - 1, size * 2 + z
            uv4[1], uv4[2], uv4[3], uv4[4], uv4[5] = 0, 0.1, -4, 1, size * 2 + z
            RenderTexture("14_22", "", uv1, uv2, uv3, uv4)
            uv1[1] = 1
            uv2[1] = 2
            uv3[1] = 2
            uv4[1] = 1
            RenderTexture("14_23", "", uv1, uv2, uv3, uv4)
        end
        self.leaf:render()
        local color, x, y, h, rot
        local size = 0.05
        local uv1, uv2, uv3, uv4 = {}, {}, {}, {}
        local cosr, sinr
        uv1[4], uv2[4], uv3[4], uv4[4] = 0, 16, 16, 0
        for _, w in ipairs(self.wicker) do
            color = Color(w.alpha, 255, 255, 255)
            uv1[6], uv2[6], uv3[6], uv4[6] = color, color, color, color
            x, y, h = w.x, w.y, 0
            for z = 1, 4 do
                rot = w.rot[z] + sin(w.timer * 3 + z * 90) * 2
                cosr, sinr = cos(rot), sin(rot)
                uv1[1], uv1[2], uv1[3], uv1[5] = x - size * cosr, y - size * sinr, w.z, h
                uv2[1], uv2[2], uv2[3], uv2[5] = x + size * cosr, y + size * sinr, w.z, h
                uv3[1], uv3[2], uv3[3], uv3[5] = x + size * cosr + size * 8 * sinr, y - size * 8 * cosr + size * sinr, w.z, h + 64
                uv4[1], uv4[2], uv4[3], uv4[5] = x - size * cosr + size * 8 * sinr, y - size * 8 * cosr - size * sinr, w.z, h + 64
                RenderTexture("14_21", "", uv1, uv2, uv3, uv4)
                h = h + 64
                x = x + size * 8 * sin(rot)
                y = y - size * 8 * cos(rot)
            end
        end
    end
end

do
    local f = background
    function stage_3:init(speed)
        self.bamboo = {}
        self.leaf = {}
        self.speed = speed or 0.01
        self.zos = 0
        self.scale = 0.4
        self.x, self.y, self.z = unpack(lstg.view3d.eye)
        for _ = 1, 13 do
            self:create_bamboo(f:RanFloat(0.5, 1.5), f:RanFloat(-5, 5), f:RanSign(), f:RanFloat(180, 230))
        end
        self.leaf2 = CreateFallLeaf({ { -3, 3 }, { 0, 5 }, { 3, 7 }, { 1, 2 }, { -0.002, 0.002 }, { -0.02, -0.03 }, { -0.03, -0.042 } },
                12, 0.1, "mul+add", 100, { 200, 100, 100 },
                "leaf", function(self)
                    return self.y < -1 or self.z < lstg.view3d.eye[3] - 1
                end, { count = 30, xRange = { -3, 3 }, yRange = { 0, 5 }, zRange = { -3, 7 } }, true)
    end
    function stage_3:create_bamboo(x, z, d, alpha)
        local rot = f:RanFloat(-4, 4)
        table.insert(self.bamboo, { x = x * d, y = -0.1, z = z, alpha = 0, talpha = alpha, rot = rot })
        local y
        local s
        for _ = 1, f:RanInt(1, 6) do
            y = f:RanFloat(0.5, 15)
            s = f:RanFloat(0.6, 1)
            table.insert(self.leaf, { x = x * d + tan(rot) * y, y = -0.1 + y, z = z, alpha = 0, talpha = alpha,
                                      rot = rot, t = f:RanInt(1, 2), rotate = f:RanFloat(-60, 60), scale = s })
            table.insert(self.leaf, { x = x * d + tan(rot) * y, y = -0.1 + y, z = z, alpha = 0, talpha = alpha,
                                      rot = rot, t = f:RanInt(1, 2), rotate = 180 + f:RanFloat(-60, 60), scale = s })
        end
        table.sort(self.leaf, function(a, b)
            if a.z and b.z then
                if a.z == b.z then
                    return b.rotate < a.rotate
                else
                    return b.z < a.z
                end
            else
                return false
            end
        end)
    end
    function stage_3:frame(timer)
        self.x, self.y, self.z = unpack(lstg.view3d.eye)
        self.zos = self.zos - self.speed
        if timer % math.ceil(self.scale / self.speed) == 0 then
            self:create_bamboo(f:RanFloat(0.5, 1.5), self.z + f:RanFloat(7, 9), f:RanSign(), f:RanFloat(180, 230))
        end
        local b
        for i = #self.bamboo, 1, -1 do
            b = self.bamboo[i]
            b.z = b.z - self.speed
            b.alpha = min(b.talpha, b.alpha + b.talpha / 20)
            if b.z < self.z - 1 then
                b.alpha = max(0, b.alpha - b.talpha / 10)
                if b.alpha == 0 then
                    table.remove(self.bamboo, i)
                end
            end
        end
        for i = #self.leaf, 1, -1 do
            b = self.leaf[i]
            b.z = b.z - self.speed
            b.alpha = min(b.talpha, b.alpha + b.talpha / 20)
            if b.z < self.z - 1 then
                b.alpha = max(0, b.alpha - b.talpha / 10)
                if b.alpha == 0 then
                    table.remove(self.leaf, i)
                end
            end
        end
        if TH14_bg.fall_leaf then
            self.leaf2.speed = self.speed * 100 / 2
            self.leaf2:frame()
        end
    end
    function stage_3:render()
        ClearZBuffer()
        SetZBufferEnable(1)
        local p0, p1, p2, p3 = {}, {}, {}, {}
        local eye = lstg.view3d.eye
        local x, y, z = 0, 5, 0
        local ax, ay, az

        ay = Angle(-z, x, -eye[3], eye[1])
        ax = Angle(-z * cos(ay) + x * sin(ay), y, -eye[3] * cos(ay) + eye[1] * sin(ay), eye[2])
        az = 0
        p0[1], p0[2], p0[3] = rotate(-1.5, 1.5, 0, ax, ay, az)
        p1[1], p1[2], p1[3] = rotate(1.5, 1.5, 0, ax, ay, az)
        p2[1], p2[2], p2[3] = rotate(1.5, -1.5, 0, ax, ay, az)
        p3[1], p3[2], p3[3] = rotate(-1.5, -1.5, 0, ax, ay, az)
        Render4V("14_35",
                x + p0[1], y + p0[2], z + p0[3], x + p1[1], y + p1[2], z + p1[3],
                x + p2[1], y + p2[2], z + p2[3], x + p3[1], y + p3[2], z + p3[3])
        ax = 0
        for _, b in ipairs(self.bamboo) do
            ay = Angle(-b.z, b.x, -eye[3], eye[1])
            az = b.rot
            p0[1], p0[2], p0[3] = rotate(-0.08, 15, 0, ax, ay, az)
            p1[1], p1[2], p1[3] = rotate(0.08, 15, 0, ax, ay, az)
            p2[1], p2[2], p2[3] = rotate(0.08, 0, 0, ax, ay, az)
            p3[1], p3[2], p3[3] = rotate(-0.08, 0, 0, ax, ay, az)
            SetImageState("14_33", "", b.alpha, 255, 255, 255)
            Render4V("14_33",
                    b.x + p0[1], b.y + p0[2], b.z + p0[3], b.x + p1[1], b.y + p1[2], b.z + p1[3],
                    b.x + p2[1], b.y + p2[2], b.z + p2[3], b.x + p3[1], b.y + p3[2], b.z + p3[3])
        end

        do
            local color
            local size = 2
            local _Z = self.zos % size
            color = Color(255, 255, 255, 255)
            for X = -4, 4, size do
                for z2 = -6, 10, size do
                    Render4V("14_31",
                            X - size / 2, 0, z2 + size / 2 + _Z,
                            X + size / 2, 0, z2 + size / 2 + _Z,
                            X + size / 2, 0, z2 - size / 2 + _Z,
                            X - size / 2, 0, z2 - size / 2 + _Z)
                end
            end
            size = 1024
            _Z = self.zos * 100
            local uv1, uv2, uv3, uv4 = {}, {}, {}, {}
            color = Color(255, 135, 206, 235)
            uv1[6], uv2[6], uv3[6], uv4[6] = color, color, color, color
            uv1[1], uv1[2], uv1[3] = -4, 0.1, 10
            uv2[1], uv2[2], uv2[3] = 4, 0.1, 10
            uv3[1], uv3[2], uv3[3] = 4, 0.1, -6
            uv4[1], uv4[2], uv4[3] = -4, 0.1, -6

            uv1[4], uv1[5] = -_Z * 0.2, _Z
            uv2[4], uv2[5] = size - _Z * 0.2, _Z
            uv3[4], uv3[5] = size - _Z * 0.2, size * 2 + _Z
            uv4[4], uv4[5] = -_Z * 0.2, size * 2 + _Z
            RenderTexture("14_34", "", uv1, uv2, uv3, uv4)

            uv1[4], uv1[5] = _Z * 0.2, _Z + 100
            uv2[4], uv2[5] = size + _Z * 0.2, _Z + 100
            uv3[4], uv3[5] = size + _Z * 0.2, size * 2 + _Z + 100
            uv4[4], uv4[5] = _Z * 0.2, size * 2 + _Z + 100
            RenderTexture("14_34", "", uv1, uv2, uv3, uv4)
        end
        for _, b in ipairs(self.leaf) do
            if b.alpha > 50 then
                ax = b.rotate * sin(b.rot)
                ay = b.rotate * cos(b.rot)
                az = b.rot
                p0[1], p0[2], p0[3] = rotate(0, b.scale, 0, ax, ay, az)
                p1[1], p1[2], p1[3] = rotate(b.scale * 2, b.scale, 0, ax, ay, az)
                p2[1], p2[2], p2[3] = rotate(b.scale * 2, -b.scale, 0, ax, ay, az)
                p3[1], p3[2], p3[3] = rotate(0, -b.scale, 0, ax, ay, az)
                SetImageState("14_32" .. b.t, "", b.alpha, 255, 255, 255)
                Render4V("14_32" .. b.t,
                        b.x + p0[1], b.y + p0[2], b.z + p0[3], b.x + p1[1], b.y + p1[2], b.z + p1[3],
                        b.x + p2[1], b.y + p2[2], b.z + p2[3], b.x + p3[1], b.y + p3[2], b.z + p3[3])
            end
        end
        SetZBufferEnable(0)
        self.leaf2:render()
    end
end

do
    function stage_4:init(img, speed)
        self.img = img or 2
        self.speed = speed or 1
        self.angle = 0
        self.SetState = function(color)
            for i = 1, 8 do
                SetImageState("14_43" .. i, 'mul+add', color)
            end
        end
        SetImageState('14_41', 'mul+alpha', 200, 255, 255, 255)
        SetImageState('14_42', 'mul+alpha', 100, 255, 255, 255)
        SetImageState('14_44', 'mul+alpha', 100, 255, 255, 255)
        self.leaf = CreateFallLeaf({ { -6, 6 }, { -1, 2 }, { -6, 6 }, { 1, 2 }, { -0.002, 0.002 }, { 0.02, 0.05 }, { -0.002, 0.002 } },
                20, 0.1, "mul+add", 100, { 135, 206, 235 },
                "small_leaf", function(self)
                    return self.y > 12
                end, { count = 30, xRange = { -6, 6 }, yRange = { -1, 9 }, zRange = { -6, 6 } }, true)
    end
    function stage_4:frame()
        if self.angle < -180 then
            self.angle = 0
        else
            self.angle = self.angle - 0.1
        end
        if TH14_bg.fall_leaf then
            self.leaf.speed = self.speed * 0.8
            self.leaf:frame()
        end
    end
    function stage_4.draw_circle(x, y, z, r, R, N, rot, fa, fr)
        local a1 = 360 / N
        local a2 = a1 / 8
        for n = 1, N do
            for m = 1, 8 do
                Render4V("14_43" .. m,
                        x + r * cos(n * a1 + a2 * m + rot), y + fr * cos(n * a1 + a2 * m + rot + fa), z + r * sin(n * a1 + a2 * m + rot),
                        x + R * cos(n * a1 + a2 * m + rot), y + fr * cos(n * a1 + a2 * m + rot + fa), z + R * sin(n * a1 + a2 * m + rot),
                        x + R * cos(n * a1 + a2 * (m + 1) + rot), y + fr * cos(n * a1 + a2 * (m + 1) + rot + fa), z + R * sin(n * a1 + a2 * (m + 1) + rot),
                        x + r * cos(n * a1 + a2 * (m + 1) + rot), y + fr * cos(n * a1 + a2 * (m + 1) + rot + fa), z + r * sin(n * a1 + a2 * (m + 1) + rot))
            end
        end
    end
    function stage_4:render(timer)
        timer = timer * self.speed
        local R = 6
        for i = 1, 12 do
            for j = 1, 12 do
                Render4V('14_41',
                        R * cos(30 * i), -24 + R * (j + 1), R * sin(30 * i),
                        R * cos(30 * i), -24 + R * j, R * sin(30 * i),
                        R * cos(30 * (i + 1)), -24 + R * j, R * sin(30 * (i + 1)),
                        R * cos(30 * (i + 1)), -24 + R * (j + 1), R * sin(30 * (i + 1)))
            end
        end
        R = 5
        for i = 1, 12 do
            for j = 1, 12 do
                Render4V('14_4' .. self.img,
                        R * cos(self.angle + 30 * i), -20 + R * (j + 1), R * sin(self.angle + 30 * i),
                        R * cos(self.angle + 30 * i), -20 + R * j, R * sin(self.angle + 30 * i),
                        R * cos(self.angle + 30 * (i + 1)), -20 + R * j, R * sin(self.angle + 30 * (i + 1)),
                        R * cos(self.angle + 30 * (i + 1)), -20 + R * (j + 1), R * sin(self.angle + 30 * (i + 1)))
            end
        end

        local k = 0.5
        local n = 12
        local a3 = timer * 0.1
        self.SetState(Color(100, 255, 255, 255))
        self.draw_circle(0.5, 0.75, 1, 2, 2.25, n, a3, timer * 0.05, k)
        self.draw_circle(0.5, 0.75, 1, 2.5, 2.75, n, a3, timer * 0.05, k)
        self.SetState(Color(100, 200, 60, 100))
        self.draw_circle(-0.5, 2.75, 1, 3, 2.75, n, a3, timer * 0.08 + 90, k)
        self.draw_circle(-0.5, 2.75, 1, 2.5, 2.25, n, a3, timer * 0.08 + 90, k)
        self.SetState(Color(100, 60, 60, 200))
        self.draw_circle(1, 2.75, 1, 3, 2.75, n, a3, timer * 0.08 - 90, k)
        self.draw_circle(1, 2.75, 1, 2.5, 2.25, n, a3, timer * 0.08 - 90, k)
        self.leaf:render()
    end
end

do
    function stage_5:init(zspeed, yspeed, zos, yos)
        self.zspeed = zspeed or 0.01
        self.yspeed = yspeed or 0.01
        self.zos = zos or 0
        self.yos = yos or 0
        self.leaf = CreateFallLeaf({ { -1, 1 }, { -4, 4 }, { 5, 6 }, { 1, 2 }, { -0.002, 0.002 }, { -0.002, 0.002 }, { -0.02, -0.05 } },
                10, 0.1, "mul+add", 100, { 255, 227, 132 },
                "small_leaf", function(self)
                    return self.z < -3
                end, { count = 50, xRange = { -1, 1 }, yRange = { -1, 9 }, zRange = { -1, 6 } }, true)
    end
    function stage_5:frame()
        self.zos = self.zos - self.zspeed
        self.yos = self.yos + self.yspeed
        if TH14_bg.fall_leaf then
            self.leaf:frame()
        end
    end
    function stage_5:render()
        ClearZBuffer()
        SetZBufferEnable(1)
        local color
        local size = 512 * 6
        local z = self.zos * 150
        local uv1, uv2, uv3, uv4 = {}, {}, {}, {}
        color = Color(255, 255, 255, 255)
        uv1[6], uv2[6], uv3[6], uv4[6] = color, color, color, color
        for y = -4, 4, 2 do
            y = y + self.yos % 2
            uv1[1], uv1[2], uv1[3], uv1[4], uv1[5] = -1, y, 10, 0, z
            uv2[1], uv2[2], uv2[3], uv2[4], uv2[5] = 1, y, 10, 512, z
            uv3[1], uv3[2], uv3[3], uv3[4], uv3[5] = 1, y, -2, 512, size + z
            uv4[1], uv4[2], uv4[3], uv4[4], uv4[5] = -1, y, -2, 0, size + z
            RenderTexture("14_53", "", uv1, uv2, uv3, uv4)
            uv1[1], uv1[2], uv1[3], uv1[4], uv1[5] = -1, y + 1.8, 10, 0, z
            uv2[1], uv2[2], uv2[3], uv2[4], uv2[5] = 1, y + 1.8, 10, 512, z
            uv3[1], uv3[2], uv3[3], uv3[4], uv3[5] = 1, y + 1.8, -2, 512, size + z
            uv4[1], uv4[2], uv4[3], uv4[4], uv4[5] = -1, y + 1.8, -2, 0, size + z
            RenderTexture("14_52", "", uv1, uv2, uv3, uv4)
            uv1[1], uv1[2], uv1[3], uv1[4], uv1[5] = 1, y + 1.8, 10, z, 0
            uv2[1], uv2[2], uv2[3], uv2[4], uv2[5] = 1, y + 1.8, -2, size + z, 0
            uv3[1], uv3[2], uv3[3], uv3[4], uv3[5] = 1, y, -2, size + z, 390
            uv4[1], uv4[2], uv4[3], uv4[4], uv4[5] = 1, y, 10, z, 390
            RenderTexture("14_51", "", uv1, uv2, uv3, uv4)
            uv1[1], uv1[2], uv1[3], uv1[4], uv1[5] = -1, y + 2, -2, 0, 0
            uv2[1], uv2[2], uv2[3], uv2[4], uv2[5] = 1, y + 2, -2, 512, 0
            uv3[1], uv3[2], uv3[3], uv3[4], uv3[5] = 1, y + 1.8, -2, 512, 32
            uv4[1], uv4[2], uv4[3], uv4[4], uv4[5] = -1, y + 1.8, -2, 0, 32
            RenderTexture("14_54", "", uv1, uv2, uv3, uv4)
        end
        SetZBufferEnable(0)
        self.leaf:render()
    end
end
do
    function stage_6:init(zspeed, zos, yos)
        self.zspeed = zspeed or 0.01
        self.zos = zos or 0
        self.yos = yos or 0
        self.leaf = CreateFallLeaf({ { -1, 1 }, { -4, 4 }, { 5, 6 }, { 1, 2 }, { -0.002, 0.002 }, { -0.002, 0.002 }, { -0.02, -0.05 } },
                10, 0.1, "mul+add", 100, { 100, 100, 200 },
                "small_leaf", function(self)
                    return self.z < -3
                end, { count = 50, xRange = { -1, 1 }, yRange = { -1, 9 }, zRange = { -1, 6 } }, true)
    end
    function stage_6:frame()
        self.zos = self.zos - self.zspeed
        if TH14_bg.fall_leaf then
            self.leaf.speed = self.zspeed * 50
            self.leaf:frame()
        end
    end
    function stage_6:render(timer)
        SetViewMode("ui")
        Render("14_64", 320 + sin(timer / 10) * 50, 240, 0, 0.5)

        SetViewMode("3d")

        local color
        local size = 512 * 6
        local z = self.zos * 150
        local uv1, uv2, uv3, uv4 = {}, {}, {}, {}
        color = Color(255, 255, 255, 255)
        uv1[6], uv2[6], uv3[6], uv4[6] = color, color, color, color
        local y = self.yos
        uv1[1], uv1[2], uv1[3], uv1[4], uv1[5] = -1, y, 10, 0, z
        uv2[1], uv2[2], uv2[3], uv2[4], uv2[5] = 1, y, 10, 512, z
        uv3[1], uv3[2], uv3[3], uv3[4], uv3[5] = 1, y, -2, 512, size + z
        uv4[1], uv4[2], uv4[3], uv4[4], uv4[5] = -1, y, -2, 0, size + z
        RenderTexture("14_63", "", uv1, uv2, uv3, uv4)
        uv1[1], uv1[2], uv1[3], uv1[4], uv1[5] = -1, y + 1.8, 10, 0, z
        uv2[1], uv2[2], uv2[3], uv2[4], uv2[5] = 1, y + 1.8, 10, 512, z
        uv3[1], uv3[2], uv3[3], uv3[4], uv3[5] = 1, y + 1.8, -2, 512, size + z
        uv4[1], uv4[2], uv4[3], uv4[4], uv4[5] = -1, y + 1.8, -2, 0, size + z
        RenderTexture("14_52", "", uv1, uv2, uv3, uv4)
        uv1[1], uv1[2], uv1[3], uv1[4], uv1[5] = 1, y + 1.8, 10, z, 0
        uv2[1], uv2[2], uv2[3], uv2[4], uv2[5] = 1, y + 1.8, -2, size + z, 0
        uv3[1], uv3[2], uv3[3], uv3[4], uv3[5] = 1, y, -2, size + z, 390
        uv4[1], uv4[2], uv4[3], uv4[4], uv4[5] = 1, y, 10, z, 390
        RenderTexture("14_61", "", uv1, uv2, uv3, uv4)
        uv1[1], uv1[2], uv1[3], uv1[4], uv1[5] = -1, y + 1.8, 10, z, 0
        uv2[1], uv2[2], uv2[3], uv2[4], uv2[5] = -1, y + 1.8, -2, size + z, 0
        uv3[1], uv3[2], uv3[3], uv3[4], uv3[5] = -1, y, -2, size + z, 390
        uv4[1], uv4[2], uv4[3], uv4[4], uv4[5] = -1, y, 10, z, 390
        RenderTexture("14_61", "", uv1, uv2, uv3, uv4)
        SetImageState("white", "", 255, 0, 0, 0)
        Render4V("white", -1, 1.8, 10, 1, 1.8, 10, 1, 0, 10, -1, 0, 10)
        self.leaf:render()
    end
end