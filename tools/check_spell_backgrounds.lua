-- 原作资源与背景持有者的回归；动画本身由真实 ANM 检查覆盖。
dofile('tools/check_original_anm.lua')
local total=0
local function check(v,label) assert(v,label);total=total+1 end
local function read(path)
    local f=assert(io.open(path,'rb'));local s=f:read('*a'):gsub('\r\n','\n');f:close();return s
end
local function native(level,name)
    local o={class={StageLevel=level},ani=0,timer=0,x=0,y=96,rot=0}
    local walking={obj=o};o._wisys=walking
    OriginalStageVisual.bind_boss(walking,name)
    return o,walking
end
local y7=select(1,native(32,'Yuyuko'))._bg
local y8=select(1,native(29,'Yuyuko'))._bg
local y95=select(1,native(31,'Yuyuko'))._bg
check(y7~=y8 and y8~=y95 and y7~=y95,'同一角色在不同作品中使用本作背景')
local o,w=native(32,'Youmu');local old=o._bg
OriginalStageVisual.bind_boss(w,'Yuyuko')
check(o._bg~=old and o._original_actor.archive=='stg6enm','同一载体换角色时同时更新原版行走图和背景')
local kana=select(1,native(33,'Kanako'))._bg
local source
-- 执行正式管理器：相同编号新对象、同一对象不同背景、空背景均不能复用旧实例。
local creates=0
New=function(class) creates=creates+1;return {_live=true,class=class} end
IsValid=function(o) return type(o)=='table' and o._live==true end
object.Del=function(o) o._live=false end
lstg.tmpvar={};ext={};boss_drawSpellCircle={}
source=read('THlib/ext/ext_boss.lua')
assert(loadstring(source:sub(1,assert(source:find('local Smooth =',1,true))-1)))()
local manager=ext.boss_ui
local first={_live=true,ID='1',_bg=y7};boss_group={first}
manager:frame();local old=first.bg
manager:frame();check(first.bg==old and creates==2,'同一 Boss 不重复创建背景与符卡环')
local second={_live=true,ID='1',_bg=kana};boss_group={second}
manager:frame();check(not IsValid(old) and second.bg.class==second._bg,'同编号新 Boss 使用新符卡背景')
old=second.bg;second._bg=y95;manager:frame()
check(not IsValid(old) and second.bg.class==second._bg,'同一 Boss 换角色也更换符卡背景')
old=second.bg;second._bg=nil;manager:frame()
check(not IsValid(old) and second.bg==nil,'空背景不残留上张符卡背景')
boss_group={};manager:frame();check(manager.boss_bg_owner==nil,'离场释放背景持有的 Boss 引用')
print('符卡背景回归通过：'..total..' 项。')
