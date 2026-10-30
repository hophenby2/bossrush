-- 使用原背景类及实际换图 / 背景管理函数，验证角色映射和无缝换 Boss。
arg[1]='spell-backgrounds'
local function read(path)
    local f=assert(io.open(path,'rb'));local s=f:read('*a'):gsub('\r\n','\n');f:close();return s
end
local stub=read('tools/check_stage.lua')
assert(loadstring(stub:sub(1,assert(stub:find('if path == "--all" then',1,true))-1)))()
dofile('mod/_editor_output.lua')
for _,id in ipairs({'07','08','09','10'}) do dofile('mod/GAME/th'..id..'.lua') end
local total=0
local function check(v,label) assert(v,label);total=total+1 end
local source=read('THlib/enemy/boss.lua');local oldBoss=boss
assert(loadstring(source:sub(1,assert(source:find('function boss:init',1,true))-1)))()
local mapper=boss.UpdateSpellBackground;boss=oldBoss;boss.UpdateSpellBackground=mapper
local expected={
    {'Kanako','TH10','SCBG4'},{'Sanae','TH10','SCBG4'},{'Suwako','TH10','SCBG5'},
    {'Nitori','TH10','SCBG2'},{'Hina','TH10','SCBG2'},{'Aya','TH10','SCBG3'},
    {'Momizi','TH10','SCBG3'},{'Sizuha','TH10','SCBG1'},{'Minoriko','TH10','SCBG1'},
    {'Yuyuko','TH07','SCBG6'},{'Youmu','TH07','SCBG5'},{'Alice','TH07','SCBG3'},
    {'Chen','TH07','SCBG2'},{'Ran','TH07','SCBG7'},{'Yukari','TH07','SCBG8'},
    {'Nightbug','TH08','SCBG1'},{'Lorelei','TH08','SCBG2'},{'Kamishirasawa','TH08','SCBG2'},
    {'Kamishirasawa2','TH08','SCBG6'},{'Reimu','TH08','SCBG3+'},{'Marisa','TH08','SCBG3+'},
    {'Reisen','TH08','SCBG4'},{'Tewi','TH08','SCBG4'},{'Yagokoro','TH08','SCBG5'},
    {'Neet','TH08','SCBG5'},{'Mokou','TH08','SCBG6'},{'Remilia','TH08','SCBG-LW13'},
    {'Sakuya','TH09','SCBG4'},{'Medicine','TH09','SCBG6'},{'Komachi','TH09','SCBG9'},
    {'Shikieiki','TH09','SCBG10'},{'Chiruno','TH07','SCBG1'},{'Whiterock','TH07','SCBG2'},
}
for level=29,33 do
    for _,row in ipairs(expected) do
        local b={class={StageLevel=level},_bg={}}
        mapper(b,row[1])
        check(b._bg==assert(_editor_class[row[2]][row[3]]),'复用原背景类：'..level..'/'..row[1])
    end
end
local fallback={};local b={class={StageLevel=31},_bg=fallback}
mapper(b,'Suika');check(b._bg==fallback,'没有对应现成角色时保留原背景')
b.class.StageLevel=2;mapper(b,'Yuyuko');check(b._bg==fallback,'不更改原关卡或其他关卡背景')
-- TH34 的同一 Boss 载体在 before 里换立绘时必须同步背景。
source=read('THlib/WalkImageSystem.lua')
local start=assert(source:find('function BossWalkImageSystem:SetImageInList',1,true))
local stop=assert(source:find('BossWalkImageSystemRotate =',start,true))
BossWalkImageSystem={};CheckRes=function() return true end
assert(loadstring('local WalkImage={imglist={}}\n'..source:sub(start,stop-1)))()
b={class={StageLevel=32}};local walking={obj=b}
BossWalkImageSystem.SetImageInList(walking,'Youmu');check(b._bg==_editor_class.TH07.SCBG5,'妖梦换图采用自己的背景')
BossWalkImageSystem.SetImageInList(walking,'Yuyuko');check(b._bg==_editor_class.TH07.SCBG6,'同一载体换幽幽子立即更换背景')
-- 执行正式管理器：相同编号新对象、同一对象不同背景、空背景均不能复用旧实例。
local creates=0
New=function(class) creates=creates+1;return {_live=true,class=class} end
IsValid=function(o) return type(o)=='table' and o._live==true end
object.Del=function(o) o._live=false end
lstg.tmpvar={};ext={};boss_drawSpellCircle={}
source=read('THlib/ext/ext_boss.lua')
assert(loadstring(source:sub(1,assert(source:find('local Smooth =',1,true))-1)))()
local manager=ext.boss_ui
local first={_live=true,ID='1',_bg=_editor_class.TH07.SCBG5};boss_group={first}
manager:frame();local old=first.bg
manager:frame();check(first.bg==old and creates==2,'同一 Boss 不重复创建背景与符卡环')
local second={_live=true,ID='1',_bg=_editor_class.TH10.SCBG4};boss_group={second}
manager:frame();check(not IsValid(old) and second.bg.class==second._bg,'同编号新 Boss 使用新符卡背景')
old=second.bg;second._bg=_editor_class.TH07.SCBG6;manager:frame()
check(not IsValid(old) and second.bg.class==second._bg,'同一 Boss 换角色也更换符卡背景')
old=second.bg;second._bg=nil;manager:frame()
check(not IsValid(old) and second.bg==nil,'空背景不残留上张符卡背景')
boss_group={};manager:frame();check(manager.boss_bg_owner==nil,'离场释放背景持有的 Boss 引用')
print('符卡背景回归通过：'..total..' 项。')
