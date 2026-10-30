-- 兼容层的路径与对象行为共用 Android，平台名保留 Mac 独立身份。
AndroidPlatform.flipRenderTargets=false
local function expose(name,fn) lstg[name]=fn;_G[name]=fn end
expose('GetVersionName',function() return 'Boss Rush HD macOS / LuaSTG-x 20260913 / Metal / '..jit.version end)
expose('EnumGPUs',function() return {'macOS Metal'} end)

-- 少量对象的碰撞在主线程计算，避免每帧等待多次工作线程同步。
lstg.SetThreadPoolSize(0)

local log=lstg.SystemLog
expose('SystemLog',function(text) log(text);io.stdout:write(tostring(text)..'\n');io.stdout:flush() end)

lstg.WindowHelper:getInstance():setTitle('Boss Rush HD · Mac 测试版')

-- Metal 主画面直接提交，避免额外整屏离屏合成；显式后处理 RenderTarget 保持启用。
lstg.AndroidSetFrameBufferEnabled(false)
