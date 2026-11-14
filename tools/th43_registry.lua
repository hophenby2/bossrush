-- 栖霞园资源形状计算使用引擎色值和随机对象，注册测试只加载定义。
lstg.Rand=lstg.Rand or function() return ran end
lstg.Color=function()
    local mt
    local function new() return setmetatable({},mt) end
    mt={__mul=new,__add=new}
    return new()
end
lstg.sin,lstg.cos=sin,cos
SetAnimationState=function() end
lstg.SetAnimationState=SetAnimationState
lstg.SetImageState=SetImageState
SetAnimationCenter=SetAnimationCenter or function() end
SetImageCenter=SetImageCenter or function() end
bent_laser=bent_laser or Class(object)
bent_laser.Add_texture=bent_laser.Add_texture or function() end
misc=misc or {}
local define=boss.Define
boss.Define=function(id,name,bgm,bg,...)
    return define(id,name,bgm,bg or background,...)
end
dofile('mod/GAME/th43.lua')
boss.Define=define
