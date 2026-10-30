-- Mac 只提供窗口和输入差异，资源 / 对象 / 游戏循环继续共用 Android 移植层。
BossRushDesktop = true
package.preload.config = function()
    DEBUG=0;CC_USE_FRAMEWORK=true;CC_SHOW_FPS=false;CC_DISABLE_GLOBAL=false
    CC_DESIGN_RESOLUTION={width=960,height=540,autoscale='SHOW_ALL'}
    local director=cc.Director:getInstance()
    if not director:getOpenGLView() then
        director:setOpenGLView(cc.GLViewImpl:createWithRect('Boss Rush HD · Mac 测试版',{x=0,y=0,width=1280,height=720},1,false))
    end
    lstg.MacConfigureDisplay()
    return {setting={windowed=true,windowsize_w=1280,windowsize_h=720,resizable=false}}
end
local files=cc.FileUtils:getInstance()
local chunk=assert(loadstring(files:getStringFromFile('game/android/main.lua'),'@game/android/main.lua'))
chunk()
