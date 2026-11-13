-- 使用 check_stage.lua 的引擎桩载入移植作品的真实注册表。
GameContent=dofile('mod/content.lua')
lstg.CheckRes=CheckRes
lstg.Color=function() return 0 end
lstg.sin,lstg.cos=sin,cos
lstg.Rand=function() return ran end
setting=setting or {}
plus=plus or {}
dofile('THlib/plus/Utility.lua')
LoadPS=function() end
dofile('mod/GAME/th41.lua')
local define=boss.Define
boss.Define=function(id,name,bgm,bg,...)
    -- Like Dreamer 在启动战斗时创建背景。满足静态桩对默认背景的断言。
    return define(id,name,bgm,bg or background,...)
end
dofile('mod/GAME/th42.lua')
boss.Define=define
