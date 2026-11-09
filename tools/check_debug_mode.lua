-- 标题口令必须是五次独立按下，且不能跨页面、其它输入或超时间隔累计。
KEY={['8']=56,NULL=0}
local down,last,unlocked=false,0,0
GetKeyState=function() return down end
GetLastKey=function() return last end
PlaySound=function() end
local title={alpha=1,locked=false,on_debug_unlocked=function() unlocked=unlocked+1 end}
local function fresh() down,last=false,0;return dofile('THlib/UI/debug_mode.lua') end
local function frame(d,key,held)
    last,down=key or 0,held or false;d.frame(title)
end
local function press(d) frame(d,56,true);frame(d) end
local d=fresh()
for _=1,20 do frame(d,56,true) end
assert(not d.enabled and d.count==1,'长按不能代替五次独立按下')
frame(d);for _=1,4 do press(d) end
assert(d.enabled and unlocked==1,'标题页五次独立按下解锁练习')
press(d);assert(unlocked==1,'已解锁时不重复触发')
d=fresh();for _=1,4 do press(d) end
frame(d,13);press(d);assert(not d.enabled and d.count==1,'其它按键打断口令')
d=fresh();for _=1,4 do press(d) end
for _=1,121 do frame(d) end
press(d);assert(not d.enabled and d.count==1,'超过输入间隔后重新计数')
d=fresh();for _=1,4 do press(d) end
title.locked=true;frame(d);title.locked=false;press(d)
assert(not d.enabled and d.count==1,'离开标题前台后重新计数')
assert(d.touchKey(940,10)==56 and not d.touchKey(500,10),'横屏版本号触区对应口令键')
title.alpha=0;frame(d);assert(not d.touchKey(940,10),'隐藏菜单不接收版本号触控')
print('标题调试口令、长按防重复、输入打断和触区检查通过')
