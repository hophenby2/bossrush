-- 显式性能入口：星降之里使用正式渲染、音效和碰撞，忽略窗口焦点与物理输入。
-- 配合隔离存档的 android-diagnostics：
-- profile case=39008 frames=2700 seed=739 probe=1 sampling=1 trace=counts shoot=0 hold=1 quit=1
local T={}
function T.install()
    ext.Debugging=function()end
    AndroidFocus=function()end
    GetInput=function()LoadSaveInputState({})end
end
return T
