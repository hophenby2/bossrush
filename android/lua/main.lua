-- Android 与 macOS 共用的 Sub 启动链，不加载 Windows DLL。
local desktop = rawget(_G, 'BossRushDesktop')
cc, ccb, ccui, ccexp = cc or ax, ccb or axb, ccui or axui, ccexp or axexp
__G__TRACKBACK__ = function(message)
    local text = debug.traceback(tostring(message), 2)
    lstg.SystemLog('BOSSRUSH_BOOT_ERROR: ' .. text)
    lstg.Print(text)
    return text
end
local bootError = __G__TRACKBACK__
local function bootstrap()
lstg.SystemLog('BOSSRUSH_BOOT: '..(desktop and 'macOS' or 'Android')..' 入口')
local fu = cc.FileUtils:getInstance()
fu:addSearchPath('src/')
fu:addSearchPath('res/')
require('config')
require('cocos.init')
package.path = package.path .. ';?/__init__.lua;'
lstg.SystemLog('BOSSRUSH_BOOT: Cocos 脚本已加载')
setmetatable(_G, nil)
require('cc.ext')
require('cc.to_string')
require('cc.color')
i18n = function(text) return text end
for _, namespace in ipairs({ lstg, cc, ccb }) do
    for _, value in pairs(namespace) do
        if type(value) == 'table' and getmetatable(value) and (value.create or value.new) then
            getmetatable(value).__call = function(class, ...) return (class.create or class.new)(class, ...) end
        end
    end
end
local director = cc.Director:getInstance()
director:setDisplayStats(false)
local frameSize = director:getOpenGLView():getFrameSize()
director:getOpenGLView():setDesignResolutionSize(frameSize.width, frameSize.height, cc.ResolutionPolicy.EXACT_FIT)
local scene = cc.Scene:create()
director:runWithScene(scene)
local function fail(message)
    local text = debug.traceback(tostring(message), 2)
    lstg.SystemLog('BOSSRUSH_ERROR: ' .. text)
    local label = cc.Label:createWithSystemFont('Boss Rush HD '..(desktop and 'macOS' or 'Android')..'\n' .. text, 'sans-serif', 16*frameSize.height/540)
    label:setDimensions(frameSize.width-80, frameSize.height-80)
    label:setPosition(frameSize.width/2, frameSize.height/2); label:setTextColor({ r=255,g=150,b=150,a=255 })
    scene:addChild(label, 10000)
    scene:unscheduleUpdate()
    return text
end
__G__TRACKBACK__ = fail
local function start()
    lstg.FrameInit()
    -- x 的帧率计数未包含 Cocos 提交耗时；HUD 使用完整显示帧的墙钟计数。
    local displayedFPS, uiFpsStart, uiFpsFrames = 60, lstg.AndroidClock(), 0
    lstg.GetFPS = function() return displayedFPS end
    lstg.SystemLog('BOSSRUSH_GPU: ' .. lstg.AndroidRendererInfo())
    if lstg.AndroidVerifyGraphics then
        assert(lstg.AndroidVerifyGraphics())
        lstg.SystemLog('BOSSRUSH_GRAPHICS: NPOT sampler 切换与 UBO 零值/分段/重复/覆盖的 GPU 校验通过')
    end
    for k, v in pairs(lstg) do _G[k] = v end
    FileTaskWrapper = function(_, _, task) return task() end
    FileTaskAsyncWrapper = function(_, _, task) return task() end
    string.path_uniform = function(path) return path:gsub('\\', '/') end
    require('core.respool')
    local load = function(path) return assert(loadstring(fu:getStringFromFile(path), '@' .. path))() end
    load('game/android/render_modes.lua')
    lstg.RenderMode:create('one', ccb.BlendOperation.ADD, ccb.BlendFactor.ONE,
        ccb.BlendFactor.ZERO, lstg.RenderMode:getByName(''):getProgram())
    AndroidPlatform = load('game/android/platform.lua')
    load('game/android/compat.lua')
    if desktop then load('game/macos/compat.lua') end
    load('game/android/lazy_textures.lua')
    args = {}; start_game = true; cjson = cjson or json
    lstg.DoFile('launch.lua')
    local originalLoadConfigure = loadConfigure
    local function mobileSetting(s)
        s.mod = 'Boss Rush HD'; s.resx, s.resy, s.windowed = frameSize.width, frameSize.height, desktop==true
        s.vsync, s.nosplash = true, true
    end
    mobileSetting(default_setting)
    function loadConfigure() originalLoadConfigure(); mobileSetting(setting) end
    function ChangeVideoMode2() return true end
    function setting_keys_default()
        cur_setting.keys = DeSerialize(Serialize(default_setting.keys))
        cur_setting.keysys = DeSerialize(Serialize(default_setting.keysys))
    end
    function save_setting()
        mobileSetting(cur_setting)
        local f = assert(io.open('User/setting', 'w')); f:write(format_json(Serialize(cur_setting))); f:close()
    end
    setting.mod = 'Boss Rush HD'
    setting.resx, setting.resy, setting.windowed = frameSize.width, frameSize.height, desktop==true
    setting.vsync, setting.nosplash = true, true
    setting.allowsnapshot = true
    cur_setting = DeSerialize(Serialize(setting))
    AndroidInput = load(desktop and 'game/macos/input.lua' or 'game/android/input.lua')
    lstg.DoFile('core.lua')
    -- Sub 的辅助函数仅返回内容区坐标；Android 超宽屏 RT 使用完整物理画布。
    local worldToScreen = WorldToScreen
    WorldToScreen = function(...)
        local x, y = worldToScreen(...)
        return x + screen.dx, y + screen.dy
    end
    local profiler, diagnosticsMode, graphicsStarted
    local diagnostics = io.open('User/android-diagnostics', 'rb')
    if diagnostics then
        local mode = diagnostics:read('*a'); diagnostics:close()
        diagnosticsMode = mode
        AndroidInput.trace = mode:match('input') ~= nil
        if mode:match('^profile') then profiler = load('game/android/profiler.lua') end
    end
    AndroidInstallClasses()
    AndroidVerifyObjects()
    local newStage = stage.New
    stage.New = function(name, entrance, menu)
        return newStage(name, entrance or name == 'init', menu)
    end
    lstg.SystemLog('BOSSRUSH_GAMEINIT: 开始')
    GameInit()
    lstg.SystemLog('BOSSRUSH_GAMEINIT: 完成')
    if desktop then load('game/macos/test.lua').install() end
    if diagnosticsMode and diagnosticsMode:match('combat') then load('game/android/combat_check.lua').install(diagnosticsMode) end
    if diagnosticsMode and diagnosticsMode:match('drops') then load('game/android/drops_check.lua').install(diagnosticsMode) end
    local pauseCache = load('game/android/pause_cache.lua')
    AndroidPauseCache = pauseCache
    pauseCache.install()
    AndroidInput.install(scene)
    lstg.SystemLog('BOSSRUSH_INPUT: 已安装')
    -- x 的绘制命令池每个 BeginScene 复用一次，触屏控件必须与游戏共用同一帧。
    local endScene = EndScene
    EndScene = function()
        local capture=GameNet and GameNet.Capture
        local old=capture and capture.suppress
        if capture then capture.suppress=true end
        AndroidInput.render()
        if capture then capture.suppress=old end
        return endScene()
    end
    local pausedMusic = {}
    function AndroidBack() AndroidInput.pulse(27) end
    function AndroidFocus(active)
        if not active then
            if GameNet and GameNet.active() then GameNet.togglePause(true) end
            if SaveResume then SaveResume.flush('切到后台') end
            pauseCache.invalidate()
            AndroidInput.reset()
            if ext and not ext.StageIsMenu() then ext.pop_pause_menu = true end
            for _, name in ipairs(EnumRes2('bgm')) do
                if GetMusicState(name) == 'playing' then pausedMusic[name] = true; PauseMusic(name) end
            end
            if scoredata then SaveScoreData(); SaveSpellCardData() end
        else
            uiFpsStart, uiFpsFrames = lstg.AndroidClock(), 0
            for name in pairs(pausedMusic) do ResumeMusic(name) end
            pausedMusic = {}
        end
    end
    FocusLoseFunc = function() AndroidFocus(false) end
    local frames, previousStage = 0, false
    local clock = lstg.AndroidClock
    local sampleStart, sampleFrames, logicTime, renderTime = clock(), 0, 0, 0
    scene:scheduleUpdateWithPriorityLua(function()
        local ok = xpcall(function()
            frames = frames + 1
            AndroidInput.beginFrame()
            if frames <= 3 then
                lstg.SystemLog('BOSSRUSH_FRAME: ' .. frames .. ' stage=' .. tostring(stage.current_stage and stage.current_stage.stage_name))
            end
            local beforeLogic = clock()
            -- 仅私有 input 诊断使用保护，防止测试轨迹被死亡/重生中断；正式运行不进入此分支。
            if diagnosticsMode and diagnosticsMode:match('input') and player and IsValid(player) then player.protect=120 end
            local quit = FrameFunc()
            local afterLogic = clock()
            if diagnosticsMode and diagnosticsMode:match('graphics') and not graphicsStarted and
                stage.current_stage and stage.current_stage.stage_name == 'menu' then
                graphicsStarted = true
                load('game/android/graphics_check.lua').run()
            end
            if stage.current_stage ~= previousStage then
                previousStage = stage.current_stage
                lstg.SystemLog('BOSSRUSH_STAGE: ' .. tostring(previousStage and previousStage.stage_name))
            end
            RenderFunc()
            local afterRender = clock()
            uiFpsFrames = uiFpsFrames+1
            if afterRender-uiFpsStart >= 1 then
                displayedFPS = uiFpsFrames/(afterRender-uiFpsStart)
                uiFpsStart, uiFpsFrames = afterRender, 0
            end
            sampleFrames = sampleFrames + 1
            logicTime = logicTime + afterLogic-beforeLogic
            renderTime = renderTime + afterRender-afterLogic
            if afterRender-sampleStart >= 5 then
                if profiler then profiler.report(sampleFrames) end
                local draws,vertices = lstg.AndroidDrawStats()
                lstg.SystemLog(string.format('BOSSRUSH_PERF: stage=%s paused=%s fps=%.1f logic_ms=%.3f render_ms=%.3f draws=%d vertices=%d',
                    tostring(previousStage and previousStage.stage_name), tostring(not ext.pause_menu:IsKilled()),
                    sampleFrames/(afterRender-sampleStart), logicTime*1000/sampleFrames, renderTime*1000/sampleFrames,draws,vertices))
                sampleStart, sampleFrames, logicTime, renderTime = afterRender, 0, 0, 0
            end
            if frames <= 3 then lstg.SystemLog('BOSSRUSH_RENDERED: ' .. frames) end
            AndroidInput.endFrame()
            if quit then director:endToLua() end
        end, fail)
        if not ok then scene:unscheduleUpdate() end
    end, 0)
    lstg.SystemLog('BOSSRUSH_READY: '..(desktop and 'macOS' or 'Android')..' 游戏循环已启动')
end
xpcall(start, fail)
end
xpcall(bootstrap, bootError)
