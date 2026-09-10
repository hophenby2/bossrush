local SetViewMode = SetViewMode
local RenderTexture = RenderTexture

local Color = Color
local Set3D = Set3D
local table = table
local cos, sin = cos, sin
local background = background

TH11_bg = Class(background)
TH11_bg.FloorAdd = {}
do
    local n = 40
    local da, h, _h, height, r1, r2, texl, tex
    local texW, texH = 256, 256
    local color, rot = Color(255, 255, 255, 255), 0
    for i = 0, 8 do
        r1 = r2 or 0
        r2 = 1 + i * i
        texl = math.ceil(9 + i * i / 4)
        tex = i % 2 + 1
        da = 360 / n
        h = 0
        _h = texW / n * texl
        height = texH
        for _ = 1, n do
            table.insert(TH11_bg.FloorAdd, { tex = tex, pos = {
                { r1 * cos(rot), 0, r1 * sin(rot), h, 0, color },
                { r1 * cos(rot - da), 0, r1 * sin(rot - da), h + _h, 0, color },
                { r2 * cos(rot - da), 0, r2 * sin(rot - da), h + _h, height, color },
                { r2 * cos(rot), 0, r2 * sin(rot), h, height, color } } })
            rot = rot - da
            h = h + _h
        end
    end

    da = 360 / n
    h = 0
    _h = texW / n * texl
    height = texH
    local r = 65
    local y = 0
    local _r, _y
    for i = 1, 20 do
        texl = math.ceil(40 - i * 1.5)
        tex = i % 2 + 1
        da = 360 / n
        h = 0
        _h = texW / n * texl
        _r = -5 * sin(i * 4.5)
        _y = 10 * sin(90 - i * 4.5)
        height = texH
        for _ = 1, n do
            table.insert(TH11_bg.FloorAdd, { tex = tex, pos = {
                { r * cos(rot), y, r * sin(rot), h, 0, color },
                { r * cos(rot - da), y, r * sin(rot - da), h + _h, 0, color },
                { (r + _r) * cos(rot - da), y + _y, (r + _r) * sin(rot - da), h + _h, height, color },
                { (r + _r) * cos(rot), y + _y, (r + _r) * sin(rot), h, height, color } } })
            rot = rot - da
            h = h + _h
        end
        r = r + _r
        y = y + _y
    end
end

function TH11_bg:init()
    local path = "mod\\BG\\TH11\\TH11_bg_"
    LoadTexture2("11_floor1", path .. "floor1.png")
    LoadTexture2("11_floor2", path .. "floor2.png")

    background.init(self, false)
    Set3D('eye', 0, 50, -10)
    Set3D('at', 0, 3, -5)
    Set3D('up', 0, 1, 0)
    Set3D('fovy', 1)
    Set3D('z', 0.1, 100)
    Set3D('fog', 20, 40, Color(255, 0, 0, 0))
    self.floor = TH11_bg.FloorAdd
    task.New(self, function()
        local Move3Dcamera = background.Move3Dcamera
        task.Wait(60)
        while true do
            Set3D('eye', 0, 50, -10)
            Set3D('at', 0, 3, -5)
            Set3D('up', 0, 1, 0)
            Set3D('fovy', 1)
            Set3D('z', 0.1, 100)
            Set3D('fog', 20, 40, Color(255, 0, 0, 0))
            Move3Dcamera(self, "eye", 2, 10, 360, 2)
            Move3Dcamera(self, "eye", 3, -3, 486, 3)
            Move3Dcamera(self, "at", 3, 10, 486, 3, true)
            --Set3D('eye', 0, 10, -3)
            --Set3D('at', 0, 3, 10)
            Move3Dcamera(self, "eye", 1, 5, 300, 3)
            Move3Dcamera(self, "at", 2, 10, 300, 3)
            Move3Dcamera(self, "eye", 3, 10, 486, 3)
            Move3Dcamera(self, "at", 3, 20, 486, 3, true)
            --Set3D('eye', 5, 10, 10)
            --Set3D('at', 0, 10, 20)
            Move3Dcamera(self, "fog", 1, 60, 300, 3)
            Move3Dcamera(self, "fog", 2, 100, 300, 3)
            Move3Dcamera(self, "at", 2, 60, 243, 3, true)
            Move3Dcamera(self, "eye", 2, 61, 243, 3, true)
            --Set3D('eye', 5, 61, 10)
            --Set3D('at', 0, 60, 20)
            Move3Dcamera(self, "eye", 2, 50, 486, 3)
            Move3Dcamera(self, "at", 1, 10, 243, 3, true)
            Move3Dcamera(self, "up", 1, 10, 243, 1, true)
            Move3Dcamera(self, "up", 1, 0, 646, 2)
            Move3Dcamera(self, "eye", 2, 10, 646, 3)
            Move3Dcamera(self, "at", 1, 0, 646, 3)
            Move3Dcamera(self, "fog", 1, 40, 970, 3)
            Move3Dcamera(self, "fog", 2, 90, 970, 3)
            Move3Dcamera(self, "at", 2, 10, 646, 3, true)
            --Set3D('eye',5.00,10.00,10.00)
            --Set3D('at',0.00,10.00,20.00)
            local a = 90
            Move3Dcamera(self, "at", 1, 58 * cos(a + 20), 324, 3)
            Move3Dcamera(self, "at", 3, 58 * sin(a + 20), 324, 3)
            Move3Dcamera(self, "eye", 1, 58 * cos(a), 324, 3)
            Move3Dcamera(self, "eye", 3, 58 * sin(a), 324, 3, true)
            --10.78
            local c = 0
            local b = 0
            for i = 1, 646 do
                b = i / 646 * 360
                c = sin(b) * 16
                a = a + sin(i / 646 * 180) * 2
                Set3D("eye", 58 * cos(a), 10 + sin(b), 58 * sin(a))
                Set3D("at", 58 * cos(a + 20 + c), 10, 58 * sin(a + 20 + c))
                Set3D("up", sin(b) * 0.7, 1, 0)

                coroutine.yield()
            end
            a = -180
            local r = 50
            Move3Dcamera(self, "at", 1, 0, 162, 3)
            Move3Dcamera(self, "at", 3, 0, 162, 3)
            Move3Dcamera(self, "eye", 2, 26, 162, 3)
            Move3Dcamera(self, "at", 2, 35, 646, 3)
            Move3Dcamera(self, "eye", 1, r * cos(a), 324, 3)
            Move3Dcamera(self, "eye", 3, r * sin(a), 324, 3, true)
            Move3Dcamera(self, "at", 1, r * cos(a - 40), 322, 3)
            Move3Dcamera(self, "at", 3, r * sin(a - 40), 322, 3, true)
            for i = 1, 646 do
                b = i / 646 * 360
                c = i / 646 * 40
                r = 50 - c / 2
                a = a - sin(i / 646 * 180) * 2
                Set3D("eye", r * cos(a), 26 + sin(b), r * sin(a))
                Set3D("at", r * cos(a - 40 - c), 35 + c, r * sin(a - 40 - c))
                Set3D("up", sin(b) * 0.3, 1, 0)

                coroutine.yield()
            end
            Move3Dcamera(self, "eye", 2, 100, 162, 3)
            Move3Dcamera(self, "eye", 1, -15, 162, 3)
            Move3Dcamera(self, "at", 2, 50, 162, 3)
            Move3Dcamera(self, "eye", 1, 0, 162, 3)
            Move3Dcamera(self, "eye", 3, 0, 324, 3)
            Move3Dcamera(self, "at", 1, 0, 324, 3)
            Move3Dcamera(self, "at", 3, 0, 324, 3, true)
            New(WhiteScreen, LAYER.BG + 1)
            Move3Dcamera(self, "eye", 2, 30, 324, 2)
            Move3Dcamera(self, "at", 2, 10, 324, 2, true)
            New(WhiteScreen, LAYER.BG + 1)
            task.New(self, function()
                local t = 0
                for i = 1, 8 do
                    Move3Dcamera(self, "up", 1, LineNum(i * 45) * 5, 60, 2, true)
                    t = t + 0.6
                    if t > 0 then
                        task.Wait(t)
                        t = t - int(t)
                    end
                end
            end)
            Move3Dcamera(self, "eye", 3, -15, 242, 3, true)
            Move3Dcamera(self, "at", 3, 15, 242, 3, true)
            task.New(self, function()
                local t = 0
                for i = 1, 8 do
                    Move3Dcamera(self, "up", 3, LineNum(i * 45) * 5, 60, 2, true)
                    t = t + 0.6
                    if t > 0 then
                        task.Wait(t)
                        t = t - int(t)
                    end
                end
            end)
            local c2 = cos(45) * 15
            Move3Dcamera(self, "eye", 1, -c2, 242, 3, true)
            Move3Dcamera(self, "at", 1, c2, 242, 3, true)
            Move3Dcamera(self, "at", 2, 50, 323, 3)
            task.Wait(156)
            Move3Dcamera(self, "eye", 2, 80, 323, 3)
            task.Wait(156)
            Move3Dcamera(self, "eye", 3, c2, 323, 3)
            Move3Dcamera(self, "at", 3, -c2, 323, 3, true)
            a = 135
            for i = 1, 646 do
                a = a - sin(i / 646 * 180) * 2
                b = i / 646 * 360
                lstg.view3d.eye[1] = cos(a) * 15
                lstg.view3d.eye[3] = sin(a) * 15
                lstg.view3d.at[1] = cos(a + 180) * 15
                lstg.view3d.at[3] = sin(a + 180) * 15
                Set3D("up", 0, cos(b), sin(b))

                coroutine.yield()
            end
            for j = 1, 4 do
                Move3Dcamera(self, "eye", 2, 80 - j * 15, 162, 3)
                Move3Dcamera(self, "at", 2, 50 - j * 10, 162, 3)
                for i = 1, 162 do
                    lstg.view3d.eye[1] = cos(a) * 15
                    lstg.view3d.eye[3] = sin(a) * 15
                    lstg.view3d.at[1] = cos(a + 180) * 15
                    lstg.view3d.at[3] = sin(a + 180) * 15
                    a = a + sin(i / 162 * 180) * j
                    coroutine.yield()
                end
            end
            a = 45
            r = 30
            Move3Dcamera(self, "up", 1, 0, 81, 3)
            Move3Dcamera(self, "up", 2, 1, 81, 3)
            Move3Dcamera(self, "up", 3, 0, 81, 3)
            Move3Dcamera(self, "eye", 2, 21, 81, 3)
            Move3Dcamera(self, "at", 2, 20, 81, 3)
            Move3Dcamera(self, "eye", 1, r * cos(a), 81, 3)
            Move3Dcamera(self, "eye", 3, r * sin(a), 81, 3)
            Move3Dcamera(self, "at", 1, r * cos(a - 40), 81, 3)
            Move3Dcamera(self, "at", 3, r * sin(a - 40), 81, 3, true)
            for i = 1, 646 do
                b = i / 646 * 360
                c2 = -i / 646 * 280
                r = 30 + i / 646 * 20
                a = a - sin(i / 646 * 180) * 2
                Set3D("eye", r * cos(a), 21, r * sin(a))
                Set3D("at", r * cos(a - 40 + c2), 20, r * sin(a - 40 + c2))
                Set3D("up", sin(b) * 0.7, 1, 0)
                coroutine.yield()
            end
            for i = 1, 646 do
                b = i / 646 * 270
                c2 = i / 646 * 50
                r = 50 + sin(i / 646 * 360) * 10
                a = a + sin(i / 646 * 180) * 2
                Set3D("eye", r * cos(a), 21 + c2, r * sin(a))
                Set3D("at", r * cos(a + 40), 20 + c2, r * sin(a + 40))
                Set3D("up", sin(b) * 3, 1, 0)
                coroutine.yield()
            end
            for i = 1, 646 do
                b = -3 + i / 646 * 1.5
                c2 = i / 646 * 440
                r = 50 - i / 646 * 10
                a = a + sin(i / 646 * 180) * 2
                Set3D("eye", r * cos(a), 71, r * sin(a))
                Set3D("at", r * cos(a + 40 + c2), 70, r * sin(a + 40 + c2))
                Set3D("up", b, 1, 0)
                coroutine.yield()
            end
            Move3Dcamera(self, "fog", 2, 60, 646, 3)
            for i = 1, 646 do
                b = -1.5 + i / 646 * 1.5
                c2 = i / 646 * 20
                r = 40 - i / 646 * 40
                a = a - sin(i / 646 * 180) * 2
                Set3D("eye", r * cos(a), 71 + c2, r * sin(a))
                Set3D("at", r * cos(a + 120), 70 - c2, r * sin(a + 120))
                Set3D("up", b, 1, 0)

                coroutine.yield()
            end
            task.Wait(10)
        end
    end)
end
function TH11_bg:frame()
    task.Do(self)
end
function TH11_bg:render()
    SetViewMode '3d'
    background.ClearToFogColor()
    local pos
    for _, f in ipairs(self.floor) do
        pos = f.pos
        RenderTexture("11_floor" .. f.tex, "mul+add", pos[1], pos[2], pos[3], pos[4])
    end--]]
    SetViewMode 'world'
end
