---=====================================
---luastg screen
---=====================================

----------------------------------------
---api

local function setViewportAndScissorRect(l, r, b, t)
    SetViewport(l, r, b, t)
    if SetScissorRect then
        SetScissorRect(l, r, b, t)
    end
end

----------------------------------------
---screen

---@class screen
screen = {}

function ResetScreen()
    local set = setting
    local scr = screen
    local l = lstg
    if set.resx > set.resy then
        --16:9
        scr.width = 960
        scr.height = 540
        scr.hScale = set.resx / scr.width
        scr.vScale = set.resy / scr.height
        scr.resScale = set.resx / set.resy
        scr.scale = math.min(scr.hScale, scr.vScale)
        if scr.resScale >= (scr.width / scr.height) then
            scr.dx = (set.resx - scr.scale * scr.width) * 0.5
            scr.dy = 0
        else
            scr.dx = 0
            scr.dy = (set.resy - scr.scale * scr.height) * 0.5
        end
        l.scale_3d = 0.007 * scr.scale
        ResetWorld()
        ResetWorldOffset()
    else
        --用于启动器
        scr.width = 396
        scr.height = 528
        scr.scale = set.resx / scr.width
        scr.dx = 0
        scr.dy = (set.resy - scr.scale * scr.height) * 0.5
        l.scale_3d = 0.007 * scr.scale
        l.world = { l = -192, r = 192, b = -224, t = 224,
                    boundl = -224, boundr = 224, boundb = -256, boundt = 256,
                    scrl = 6, scrr = 390, scrb = 16, scrt = 464,
                    pl = -192, pr = 192, pb = -224, pt = 224 }
        SetBound(l.world.boundl, l.world.boundr, l.world.boundb, l.world.boundt)
        ResetWorldOffset()
    end
end

function ResetScreen2()
    local set = setting
    local scr = screen
    if set.resx > set.resy then
        scr.width = 640
        scr.height = 480
        scr.hScale = set.resx / scr.width
        scr.vScale = set.resy / scr.height
        scr.resScale = set.resx / set.resy
        scr.scale = math.min(scr.hScale, scr.vScale)
        if scr.resScale >= (scr.width / scr.height) then
            scr.dx = (set.resx - scr.scale * scr.width) * 0.5
            scr.dy = 0
        else
            scr.dx = 0
            scr.dy = (set.resy - scr.scale * scr.height) * 0.5
        end
        lstg.scale_3d = 0.007 * scr.scale
    else
        --用于启动器
        scr.width = 396
        scr.height = 528
        scr.scale = set.resx / scr.width
        scr.dx = 0
        scr.dy = (set.resy - scr.scale * scr.height) * 0.5
        lstg.scale_3d = 0.007 * scr.scale
    end
end
local RAW_DEFAULT_WORLD = {--默认的world参数，只读
    l = -192, r = 192, b = -224, t = 224,
    boundl = -224, boundr = 224, boundb = -256, boundt = 256,
    scrl = 288, scrr = 672, scrb = 46, scrt = 494,
    pl = -192, pr = 192, pb = -224, pt = 224,
    world = 15,
}
local DEFAULT_WORLD = {--默认的world参数，可更改
    l = -192, r = 192, b = -224, t = 224,
    boundl = -224, boundr = 224, boundb = -256, boundt = 256,
    scrl = 288, scrr = 672, scrb = 46, scrt = 494,
    pl = -192, pr = 192, pb = -224, pt = 224,
    world = 15,
}

---用于设置默认world参数
function OriginalSetDefaultWorld(l, r, b, t, bl, br, bb, bt, sl, sr, sb, st, pl, pr, pb, pt, m)
    DEFAULT_WORLD = {
        l = l, r = r, b = b, t = t,
        boundl = bl, boundr = br, boundb = bb, boundt = bt,
        scrl = sl, scrr = sr, scrb = sb, scrt = st,
        pl = pl, pr = pr, pb = pb, pt = pt,
        world = m
    }
end

function SetDefaultWorld(l, b, w, h, bound, m)
    OriginalSetDefaultWorld(-w / 2, w / 2, -h / 2, h / 2,
            -w / 2 - bound, w / 2 + bound, -h / 2 - bound, h / 2 + bound,
            l, l + w, b, b + h,
            -w / 2, w / 2, -h / 2, h / 2,
            m)
end

---用于重置world参数
function RawGetDefaultWorld()
    local w = {}
    for k, v in pairs(RAW_DEFAULT_WORLD) do
        w[k] = v
    end
    return w
end

function GetDefaultWorld()
    local w = {}
    for k, v in pairs(DEFAULT_WORLD) do
        w[k] = v
    end
    return w
end

function RawResetWorld()
    local w = {}
    for k, v in pairs(RAW_DEFAULT_WORLD) do
        w[k] = v
    end
    lstg.world = w
    DEFAULT_WORLD = w
    SetBound(lstg.world.boundl, lstg.world.boundr, lstg.world.boundb, lstg.world.boundt)
end

function ResetWorld()
    local w = {}
    for k, v in pairs(DEFAULT_WORLD) do
        w[k] = v
    end
    lstg.world = w
    SetBound(lstg.world.boundl, lstg.world.boundr, lstg.world.boundb, lstg.world.boundt)
end

---用于设置world参数
function OriginalSetWorld(l, r, b, t, bl, br, bb, bt, sl, sr, sb, st, pl, pr, pb, pt, m)
    local w = lstg.world
    w.l = l
    w.r = r
    w.b = b
    w.t = t
    w.boundl = bl
    w.boundr = br
    w.boundb = bb
    w.boundt = bt
    w.scrl = sl
    w.scrr = sr
    w.scrb = sb
    w.scrt = st
    w.pl = pl
    w.pr = pr
    w.pb = pb
    w.pt = pt
    w.world = m
end

function SetWorld(l, b, w, h, bound, m)
    l = l or 288
    b = b or 46
    w = w or 384
    h = h or 448
    bound = bound or 32
    m = m or 15
    OriginalSetWorld(-w / 2, w / 2, -h / 2, h / 2,
            -w / 2 - bound, w / 2 + bound, -h / 2 - bound, h / 2 + bound,
            l, l + w, b, b + h,
            -w / 2, w / 2, -h / 2, h / 2,
            m)
    SetBound(lstg.world.boundl, lstg.world.boundr, lstg.world.boundb, lstg.world.boundt)
end

function ToNormalScreen(time)
    if time then
        New(tasker, function()
            for i = 1, time do
                i = task.SetMode[2](i / time)
                SetWorld(160 + 128 * i, 30 + 16 * i, 640 - 256 * i, 480 - 32 * i)
                task.Wait()
            end
        end)
        SetWorld(288, 46, 384, 448)
    else
        SetWorld(288, 46, 384, 448)
    end
end

function ToBigScreen(time)
    if time then
        New(tasker, function()
            for i = 1, time do
                i = task.SetMode[2](i / time)
                SetWorld(288 - 128 * i, 46 - 16 * i, 384 + 256 * i, 448 + 32 * i)
                task.Wait()
            end
        end)
        SetWorld(160, 30, 640, 480)
    else
        SetWorld(160, 30, 640, 480)
    end
end

----------------------------------------
---3d

lstg.view3d = {
    eye = { 0, 0, -1 },
    at = { 0, 0, 0 },
    up = { 0, 1, 0 },
    fovy = PI_2,
    z = { 0.1, 2 },
    fog = { 0, 0, Color(0xFF000000) },
}

function Reset3D()
    local d = lstg.view3d
    d.eye = { 0, 0, -1 }
    d.at = { 0, 0, 0 }
    d.up = { 0, 1, 0 }
    d.fovy = PI_2
    d.z = { 0.1, 2 }
    d.fog = { 0, 0, Color(0xFF000000) }
end

function Set3D(key, a, b, c)
    if key == 'eye' then
        lstg.view3d.eye = { a, b, c }
    elseif key == 'at' then
        lstg.view3d.at = { a, b, c }
    elseif key == 'up' then
        lstg.view3d.up = { a, b, c }
    elseif key == 'fovy' then
        lstg.view3d.fovy = a
    elseif key == 'z' then
        assert(a > 0.00001 and b > a)
        lstg.view3d.z = { a, b }
    elseif key == 'fog' then
        local d = lstg.Color(0) -- 复制一个 Color
        d.a = 255 -- 模拟旧版本引擎的行为，雾颜色的 A 通道永远为 255
        d.r = c.r
        d.g = c.g
        d.b = c.b
        lstg.view3d.fog = { a, b, d }
    end
end

----------------------------------------
---视口、投影等的转换和坐标映射
local sqrt = sqrt
local tan = math.tan
local SetViewport = setViewportAndScissorRect
local SetPerspective = SetPerspective
local SetFog = SetFog
local SetImageScale = SetImageScale
local SetOrtho = SetOrtho
local unpack = unpack
local lstg = lstg
local s = screen
function SetViewMode(mode)
    lstg.viewmode = mode
    if mode == '3d' then
        local d = lstg.view3d
        local w = lstg.world
        local scale = s.scale
        local eye = d.eye
        local at = d.at
        local up = d.up
        local z = d.z
        local fovy = d.fovy
        local dx, dy = s.dx, s.dy
        local scrl, scrr = w.scrl, w.scrr
        SetViewport(scrl * scale + dx, scrr * scale + dx, w.scrb * scale + dy, w.scrt * scale + dy)
        SetPerspective(eye[1], eye[2], eye[3], at[1], at[2], at[3], up[1], up[2], up[3], fovy, (w.r - w.l) / (w.t - w.b), z[1], z[2])
        SetFog(unpack(d.fog))
        SetImageScale(sqrt((eye[1] - at[1]) * (eye[1] - at[1]) + (eye[2] - at[2]) * (eye[2] - at[2]) + (eye[3] - at[3]) * (eye[3] - at[3])) * 2 * tan(fovy * 0.5) / (scrr - scrl))
    elseif mode == 'world' then
        --计算world宽高和偏移
        local offset = lstg.worldoffset
        local oh, ov = offset.hscale, offset.vscale
        local world = lstg.world
        local x, y = offset.centerx, offset.centery
        local dx, dy = offset.dx / oh, offset.dy / ov
        local h_2, w_2 = (world.t - world.b) / oh / 2, (world.r - world.l) / ov / 2
        SetRenderRect(
                x - w_2 + dx, x + w_2 + dx,
                y - h_2 + dy, y + h_2 + dy,
                world.scrl, world.scrr, world.scrb, world.scrt)
    elseif mode == 'ui' then
        SetRenderRect(0, s.width, 0, s.height, 0, s.width, 0, s.height)
    else
        error('Invalid arguement.')
    end
end

function RenderClearViewMode(color)
    if not CheckRes("img", "white") then
        return
    end
    color.a = 255
    SetImageState("white", "", color)
    local w = lstg.world
    if lstg.viewmode == "3d" then
        SetViewMode("world")
        RenderRect("white", w.l, w.r, w.b, w.t)
        SetViewMode("3d")
    elseif lstg.viewmode == "world" then
        RenderRect("white", w.l, w.r, w.b, w.t)
    elseif lstg.viewmode == "ui" then
        RenderRect("white", 0, screen.width, 0, screen.height)
    end
end

function WorldToScreen(x, y, off)
    local w = lstg.world
    local scr = screen
    local k = scr.scale
    off = off and 0.5 or 0
    return (x - w.l + w.scrl) * k + off, (scr.height - y + w.b - w.scrb) * k + off
end

---设置渲染矩形（会被SetViewMode覆盖）
---@param l number @坐标系左边界
---@param r number @坐标系右边界
---@param b number @坐标系下边界
---@param t number @坐标系上边界
---@param scrl number @渲染系左边界
---@param scrr number @渲染系右边界
---@param scrb number @渲染系下边界
---@param scrt number @渲染系上边界
---@overload fun(info:table):nil @坐标系信息
function SetRenderRect(l, r, b, t, scrl, scrr, scrb, scrt)
    if not (l ~= r and b ~= t and scrl ~= scrr and scrb ~= scrt) then
        assert(false,
                string.format("coord: [%f, %f, %f, %f] screen: [%f, %f, %f, %f]", l, r, b, t, scrl, scrr, scrb, scrt))
    end
    local scr = screen
    local scale = scr.scale
    local dx = scr.dx
    local dy = scr.dy
    if l and r and b and t and scrl and scrr and scrb and scrt then
        --设置坐标系
        SetOrtho(l, r, b, t)
        --设置视口
        SetViewport(scrl * scale + dx, scrr * scale + dx, scrb * scale + dy, scrt * scale + dy)
        --清空fog
        SetFog()
        --设置图像缩放比
        SetImageScale(1)
    elseif type(l) == "table" then
        --设置坐标系
        SetOrtho(l.l, l.r, l.b, l.t)
        --设置视口
        SetViewport(l.scrl * scale + dx, l.scrr * scale + dx, l.scrb * scale + dy, l.scrt * scale + dy)
        --清空fog
        SetFog()
        --设置图像缩放比
        SetImageScale(1)
    else
        error("Invalid arguement.")
    end
end
----------------------------------------
---world offset
---by ETC
---用于独立world本身的数据、world坐标系中心偏移和横纵缩放、world坐标系整体偏移

local DEFAULT_WORLD_OFFSET = {
    centerx = 0, centery = 0, --world中心位置偏移
    hscale = 1, vscale = 1, --world横向、纵向缩放
    dx = 0, dy = 0, --整体偏移
}

lstg.worldoffset = {
    centerx = 0, centery = 0, --world中心位置偏移
    hscale = 1, vscale = 1, --world横向、纵向缩放
    dx = 0, dy = 0, --整体偏移
}

---重置world偏移
function ResetWorldOffset()
    local l = lstg
    l.worldoffset = l.worldoffset or {}
    for k, v in pairs(DEFAULT_WORLD_OFFSET) do
        l.worldoffset[k] = v
    end
end

---设置world偏移

function SetWorldOffset(centerx, centery, hscale, vscale)
    local w = lstg.worldoffset
    w.centerx = centerx
    w.centery = centery
    w.hscale = hscale
    w.vscale = vscale
end

---在2d上渲染3d
lstg.viewbillboard = {
    eye = { 0, 0, -1 },
    at = { 0, 0, 0 },
    up = { 0, 1, 0 },
    fovy = PI_2 / 2,
    z = { 0.01, 5 },
    fog = { 0, 0, Color(0xFF000000) },
}
function Set3Dwithmode(mode)
    local v = lstg.viewbillboard
    if mode == "world" then
        SetViewport(lstg.world.scrl * screen.scale + screen.dx, lstg.world.scrr * screen.scale + screen.dx,
                lstg.world.scrb * screen.scale + screen.dy, lstg.world.scrt * screen.scale + screen.dy)
    end
    SetPerspective(v.eye[1], v.eye[2], v.eye[3], v.at[1], v.at[2], v.at[3], v.up[1], v.up[2], v.up[3],
            v.fovy, (lstg.world.r - lstg.world.l) / (lstg.world.t - lstg.world.b), v.z[1], v.z[2])
    SetFog(v.fog[1], v.fog[2], v.fog[3])
    SetImageScale(((((v.eye[1] - v.at[1]) ^ 2 + (v.eye[2] - v.at[2]) ^ 2 + (v.eye[3] - v.at[3]) ^ 2) ^ 0.5) * 2 * math.tan(v.fovy * 0.5)) / (lstg.world.scrr - lstg.world.scrl))

end
function CalculatePosition(aX, aY, aZ, x1, x2, y1, y2)
    x1, x2, y1, y2 = x1 or -0.5, x2 or 0.5, y1 or -0.5, y2 or 0.5
    return
    rotate3D(x1, y2, 0, aX, aY, aZ),
    rotate3D(x2, y2, 0, aX, aY, aZ),
    rotate3D(x2, y1, 0, aX, aY, aZ),
    rotate3D(x1, y1, 0, aX, aY, aZ)
end
function rotate3D(x, y, z, ax, ay, az)
    x, y = x * cos(az) - y * sin(az), y * cos(az) + x * sin(az)
    x, z = x * cos(ay) - z * sin(ay), z * cos(ay) + x * sin(ay)
    y, z = y * cos(ax) - z * sin(ax), z * cos(ax) + y * sin(ax)
    local size = lstg.viewbillboard.fovy / PI_2
    return { x * size, y * size, z * size }
end
function WorldToBillBoard(t)
    t = t / 448 / 0.5 / (1 / math.tan(lstg.viewbillboard.fovy / 2))
    return t
end

---直接参数设置3d模式
function FastSet3DView(eyex, eyey, eyez, atx, aty, atz, upx, upy, upz, fovy, z1, z2)
    local w = lstg.world
    SetPerspective(eyex, eyey, eyez, atx, aty, atz, upx, upy, upz, fovy, (w.r - w.l) / (w.t - w.b), z1, z2)
    SetImageScale(((sqrt((eyex - atx) * (eyex - atx) + (eyey - aty) * (eyey - aty) + (eyez - atz) * (eyez - atz))) * 2 * math.tan(fovy * 0.5)) / (w.scrr - w.scrl))
end



----------------------------------------
---init

ResetScreen()--先初始化一次，！！！注意不能漏掉这一步
