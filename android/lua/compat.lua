-- 只在 Android 启动链安装，保留桌面版脚本和游戏数值。
local P = assert(AndroidPlatform)
local fu = cc.FileUtils:getInstance()
local native = {}
for k, v in pairs(lstg) do native[k] = v end
local function expose(name, value) lstg[name] = value; _G[name] = value end
local function empty() end

local function points(a, b, c, d)
    if type(a) ~= 'number' then
        if type(b) ~= 'number' then return a.x, a.y, b.x, b.y end
        return a.x, a.y, b, c
    end
    if type(c) ~= 'number' then return a, b, c.x, c.y end
    return a, b, c, d
end
expose('Dist', function(...) return native.Dist(points(...)) end)
expose('Angle', function(...) return native.Angle(points(...)) end)

expose('DoFile', function(path)
    local normalized = P.normalize(path)
    if normalized:lower() == 'thlib/plus/nativeapi.lua' then
        return P.installNativeAPI()
    end
    local content = fu:getStringFromFile(P.resolve(path))
    assert(content ~= '', '脚本不存在或为空：' .. path)
    content = content:gsub('^\239\187\191', '')
    local chunk, message = loadstring(content, '@' .. normalized)
    assert(chunk, message)
    native.SystemLog('BOSSRUSH_LOAD: ' .. normalized)
    return chunk()
end)
expose('LoadTextFile', function(path) return fu:getStringFromFile(P.resolve(path)) end)
lstg.FileManager = {
    FileExist = P.exists,
    EnumFiles = function(path, extension) return P.enumerate(path, extension) end,
}
expose('FindFiles', function(path, extension) return P.enumerate(path, extension) end)
expose('ExtractRes', function(source, destination)
    local input = assert(io.open(source, 'rb'))
    local output = assert(io.open(destination, 'wb'))
    output:write(input:read('*a')); input:close(); output:close()
end)

-- 路径参数与资源类型号在 Sub 和 x 中不同。
for _, name in ipairs({ 'LoadTexture', 'LoadFont', 'LoadMusic', 'LoadSound', 'LoadPS' }) do
    local fn = assert(native[name], name)
    expose(name, function(resource, path, ...)
        return fn(resource, P.resolve(path), ...)
    end)
end
expose('LoadTTF', function(name, path, width, height)
    return native.LoadTTF(name, P.resolve(path), height or width)
end)
local types = { [8] = 7, [9] = 8 }
expose('CheckRes', function(kind, name)
    if kind == 1 and FindResRenderTarget(name) then
        local pools = lstg.getResourcePool()
        return pools.global[9]:at(name) and 'global' or 'stage'
    end
    return native.CheckRes(types[kind] or kind, name)
end)
expose('EnumRes', function(kind) return native.EnumRes(types[kind] or kind) end)
expose('RemoveResource', function(pool, kind, name) return native.RemoveResource(pool, types[kind] or kind, name) end)
local resourceStatus = 'global'
expose('SetResourceStatus', function(status) resourceStatus = status; return native.SetResourceStatus(status) end)
expose('GetResourceStatus', function() return resourceStatus end)
SetResourceStatus('global')
expose('GetTextureSize', function(name)
    local texture = assert(FindTexture2D(name), '找不到纹理：' .. name)
    return texture:getPixelsWide(), texture:getPixelsHigh()
end)

local resourceScale = setmetatable({}, { __mode = 'k' })
local function scaleResource(name, x, y, animation)
    local resource = assert(animation and FindResAnimation(name) or FindResSprite(name), name)
    y = y or x
    local old = resourceScale[resource] or { 1, 1 }
    assert(old[1] ~= 0 and old[2] ~= 0, '资源缩放不能为零')
    native.AndroidScaleResource(resource, x / old[1], y / old[2], animation)
    resourceScale[resource] = { x, y }
end
expose('SetImageScale', function(name, x, y)
    if type(name) == 'number' then return native.SetImageScale(name) end
    return scaleResource(name, x, y, false)
end)
expose('GetImageScale', function(name)
    if name == nil then return native.GetImageScale() end
    local scale = resourceScale[FindResSprite(name)] or { 1, 1 }
    return unpack(scale)
end)
expose('SetAnimationScale', function(name, x, y) return scaleResource(name, x, y, true) end)
expose('GetAnimationScale', function(name) return unpack(resourceScale[FindResAnimation(name)] or { 1, 1 }) end)
expose('SetTextureSamplerState', function(name, state)
    return native.SetTextureSamplerState(assert(FindResTexture(name) or FindResRenderTarget(name), name), state)
end)
expose('RenderAnimation', function(name, timer, x, y, rotation, horizontal, vertical)
    local factor = native.GetImageScale()
    horizontal = horizontal or 1
    return assert(FindResAnimation(name), name):render(timer, x, y, rotation or 0,
        horizontal * factor, (vertical or horizontal) * factor)
end)

local rtStack = {}
expose('PushRenderTarget', function(name)
    native.PushRenderTarget(name)
    rtStack[#rtStack + 1] = name
end)
expose('PopRenderTarget', function(name)
    local top = assert(rtStack[#rtStack], 'RenderTarget 栈为空')
    assert(name == nil or name == top, 'RenderTarget 出栈顺序错误')
    native.PopRenderTarget(top)
    rtStack[#rtStack] = nil
end)
expose('LoadFX', function(name, path)
    local stem = P.normalize(path):match('([^/]+)%.hlsl$')
    assert(stem, '未适配的 shader：' .. path)
    return native.LoadFX(name, 'game/android/shaders/' .. stem .. '.frag', 'game/android/shaders/common.vert')
end)
expose('PostEffect', function(fx, target, sampler, blend, constants)
    local effect = assert(FindResFX(fx), fx)
    for i, value in ipairs(constants or {}) do
        effect:setVec4('user_data_' .. (i - 1), { x = value[1] or 0, y = value[2] or 0, z = value[3] or 0, w = value[4] or 0 })
    end
    return native.PostEffect(target, fx, blend, {})
end)
local textureVertices = { {}, {}, {}, {} }
expose('RenderTexture', function(name, blend, ...)
    local target = FindResRenderTarget(name)
    if not target then return native.RenderTexture(name, blend, ...) end
    local height = target:getTexture():getPixelsHigh()
    local input = { ... }
    for i = 1, 4 do
        for j = 1, 6 do textureVertices[i][j] = input[i][j] end
        textureVertices[i][5] = height-input[i][5]
    end
    return native.RenderTexture(name, blend, unpack(textureVertices))
end)
expose('SaveTexture', function(name, path)
    local target = FindResRenderTarget(name)
    if target then return target:getTarget():saveToFile(P.resolve(path), false) end
end)
expose('Snapshot', function(path) return native.Snapshot(P.resolve(path)) end)

expose('SetBGMSpeed', function(name, speed) assert(FindResMusic(name), name):getSource():setPitch(speed) end)
expose('GetBGMSpeed', function(name) return assert(FindResMusic(name), name):getSource():getPitch() end)
expose('GetBGMVolume', function(name) return assert(FindResMusic(name), name):getSource():getVolume() end)
expose('SetSESpeed', function(name, speed) assert(FindResSound(name), name):getSource():setPitch(speed) end)
expose('GetSESpeed', function(name) return assert(FindResSound(name), name):getSource():getPitch() end)
expose('GetSEVolume', function(name) return assert(FindResSound(name), name):getSource():getVolume() end)
expose('SetBGMLoop', function(name, ending, duration)
    assert(FindResMusic(name), name):getSource():setLoopingPoint(math.max(0, ending - duration), ending)
end)
expose('IsSameWorld', function(a, b) return bit.band(a, b) ~= 0 end)
expose('ActiveWorlds', empty)
expose('SetResolution', empty)
expose('SetWindowed', empty)
expose('SetSplash', empty)
expose('ShowSplashWindow', empty)
expose('SetTitle', empty)
expose('SetVsync', empty)
expose('ChangeVideoMode', function() return true end)
expose('EnumResolutions', function() return { { 960, 540 } } end)
expose('EnumGPUs', function() return { 'Android OpenGL ES' } end)
expose('GetVersionName', function() return 'Boss Rush HD Android / LuaSTG-x 20260913' end)
expose('GetVersionNumber', function() return 0x1000 end)
expose('SetFog', function(...)
    native.SetFog(...)
    lstg.RenderMode:getDefault():setProgram(lstg.RenderMode:getByName(''):getProgram())
end)
expose('Log', function(_, text) return native.SystemLog(tostring(text)) end)
expose('CacheTTFString', empty)
expose('GetMouseWheelDelta', function() return AndroidInput and AndroidInput.wheel or 0 end)
expose('SetScissorRect', empty)
expose('StopWatch', function()
    local timer = native.StopWatch:new()
    return {
        GetElapsed = function() return timer:get() end,
        Reset = function() timer:reset() end,
        Pause = function() timer:pause() end,
        Resume = function() timer:resume() end,
    }
end)

-- 旧曲线激光 API 在 x 中拆成节点操作，保留原框架调用方式。
expose('BentLaserData', function()
    local raw = lstg.GameObjectBentLaser:create()
    local laser = { raw = raw, width = 1 }
    function laser:Update(object, length, width, inactive)
        self.width = width
        self.raw:setNodeLimit(math.max(2, math.floor(length)))
        self.raw:pushHead(object.x, object.y, inactive and inactive > 0 and 0 or width)
    end
    function laser:UpdatePositionByList(list, length, width)
        self.raw:clear(); self.width = width
        self.raw:setNodeLimit(math.max(2, length))
        for i = length, 1, -1 do self.raw:pushHead(list[i].x, list[i].y, width) end
    end
    function laser:SetAllWidth(width) self.width = width; self.raw:setAllWidth(width) end
    function laser:CollisionCheck(x, y, rotation, a, b)
        return self.raw:collisionCheckExtendWidth(x, y, math.max(a or 0, b or 0) * 2)
    end
    function laser:CollisionCheckWidth(x, y, width, rotation, a, b)
        return self.raw:collisionCheckExtendWidth(x, y, width-self.width+math.max(a or 0, b or 0)*2)
    end
    function laser:BoundCheck() return self.raw:boundCheck() end
    function laser:Render(texture, blend, color, x, y, width, height)
        return self.raw:render(assert(FindResTexture(texture), texture),
            assert(lstg.RenderMode:getByName(blend), blend), color, x, y, width, height)
    end
    function laser:SampleByLength(distance)
        assert(distance > 0, '采样间距必须大于零')
        local result, accumulated = {}, 0
        for i = 0, self.raw:getNodeCount()-2 do
            local a, b = self.raw:getNodePosition(i), self.raw:getNodePosition(i+1)
            local dx, dy = b.x-a.x, b.y-a.y
            local length = math.sqrt(dx*dx+dy*dy)
            while length > 0 and accumulated <= length do
                result[#result+1] = { x=a.x+dx*accumulated/length, y=a.y+dy*accumulated/length,
                    rot=math.atan2(dy,dx)*180/math.pi }
                accumulated = accumulated+distance
            end
            accumulated = accumulated-length
        end
        return result
    end
    function laser:SampleByTime(seconds)
        local result = {}
        for i = 0, self.raw:getNodeCount()-1, math.max(1, math.floor(seconds*60)) do
            local p = self.raw:getNodePosition(i); result[#result+1] = {x=p.x,y=p.y}
        end
        return result
    end
    laser.LaserSampleByTime = laser.SampleByTime
    function laser:Release() self.raw = nil end
    return laser
end)

-- Sub 类只有六个回调，x 还要求类编号及显式注册。
local registered = setmetatable({}, { __mode = 'k' })
local classCount = 0
function AndroidRegisterClass(class)
    if not registered[class] then
        classCount = classCount + 1; registered[class] = classCount
    end
    class[7] = registered[class]
    native.RegisterClass(class)
    return class
end
function AndroidInstallClasses()
    local originalClass, originalInit, pending = Class, InitAllClass, { object }
    function Class(base, definition, sort)
        local result = originalClass(base, definition, sort)
        pending[#pending + 1] = result
        if sort then AndroidRegisterClass(result) end
        return result
    end
    function InitAllClass()
        originalInit()
        for _, class in ipairs(pending) do AndroidRegisterClass(class) end
        pending = {}
    end
    expose('New', function(class, ...)
        if not registered[class] then AndroidRegisterClass(class) end
        return native.New(class, ...)
    end)
end
function AndroidVerifyObjects()
    assert(Dist({x=0,y=0},3,4)==5 and math.abs(Angle(0,0,{x=0,y=1})-90)<0.0001,
        'Sub 的对象与坐标混合数学接口不兼容')
    local probeClass = Class(object, {
        init=function(o) o.x=10000; o.y=10000; o.vx=1; o.bound=false; o.colli=false; o.group=13; o.steps=0; o.res='android_custom_field' end,
        frame=function(o) o.steps=o.steps+1 end,
        render=empty,
    }, true)
    local o = New(probeClass)
    local count = 0
    for _ in ObjList(13) do count=count+1 end
    assert(count == 1, 'Android 原生对象 group 属性无效')
    assert(o.res=='android_custom_field', 'Sub 自定义 res 字段被引擎截获')
    SetSuperPause(0); ObjFrame(); AfterFrame(); BoundCheck()
    assert(o.steps==1 and o.timer==1 and o.x==10001 and o.status=='normal', 'Android 原生对象属性或边界检查不兼容')
    SetSuperPause(2); ObjFrame(); AfterFrame()
    assert(o.steps==1 and o.timer==1 and o.x==10001, '超级暂停未冻结运动或计时')
    o.nopause=true; ObjFrame(); AfterFrame()
    assert(o.steps==2 and o.timer==2 and o.x==10002, 'nopause 对象未在超级暂停期间继续更新')
    SetSuperPause(0); ObjFrame(); AfterFrame()
    o.status='del'; AfterFrame()
    assert(not IsValid(o), 'Android 对象回收失败')
    local badClass = Class(object, { init=function() error('android_expected_error') end }, true)
    local success, message = pcall(New, badClass)
    assert(not success and tostring(message):find('android_expected_error', 1, true), 'Lua 对象构造错误无法安全捕获')
    ResetPool()
    native.SystemLog('BOSSRUSH_CONTRACTS: 原生属性、分组、运动、边界、超级暂停、回收与错误展开通过')
end
return native
