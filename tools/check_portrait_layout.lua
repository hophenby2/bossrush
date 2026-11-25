-- 仅覆盖本次布局编辑、Bomb触控和加载屏蔽，不读写玩家数据。
package.preload.keycode=function()return setmetatable({}, {__index=function(_,k)return #k+100 end})end
lstg={var={},GetKeyState=function()return false end,GetLastKey=function()return 0 end,
    world={l=-192,r=192,b=-224,t=224,pl=-192,pr=192,pb=-224,pt=224,scrl=0,scrr=540,scrb=165,scrt=795}}
setting={androidPortrait=true,resx=1080,resy=1920,keys={slow=16,shoot=90,spell=88},androidPortraitLayout={}}
cur_setting={androidPortraitLayout={}}
stage={current_stage={stage_name='test'}};local menu=false
ext={StageIsMenu=function()return menu end,pause_menu={IsKilled=function()return true end}}
player={x=0,y=0,hspeed=4,lspeed=2,death=0};screen={width=540,height=960}
AndroidPortrait=dofile('android/lua/portrait.lua');AndroidInput=dofile('android/lua/input.lua')
local I,P=AndroidInput,AndroidPortrait
local n=0
local function check(v,msg)assert(v,msg);n=n+1 end
function Serialize(v)return v end
local function copy(v)local r={};for k,x in pairs(v)do r[k]=type(x)=='table' and copy(x) or x end;return r end
DeSerialize=copy
local persisted
function save_setting()persisted=copy(cur_setting.androidPortraitLayout)end
function PlaySound()end
function Color(...)return {...}end
function SetViewMode()end
function SetImageState()end
function RenderRect()end
function Render4V()end
misc={RenderOutLine=function()end}
ui={RenderText=function()end,ResourceLoading={}}
GameDrops={renderStar=function()end}
P.layoutWorld=function()end;P.restoreWorld=function()end
local E=dofile('android/lua/portrait_layout.lua')(P)
local owner={alpha=1,locked=false}
local function render()
    P.beginRender();P.editor:render()
end
local function tap(x,y)
    I.touch(1,x,y,'began');I.touch(1,x,y,'ended');P.dispatch()
end
local function open()
    menu=true;I.beginFrame();P.editor=E.open(owner);render()
end
open()
local defaults={}
for _,id in ipairs({'slow','bomb','life','bombs'})do
    local x,y=P.elementPosition(id);defaults[id]={x,y}
    I.touch(2,x+3,y+2,'began');P.dispatch()
    I.touch(2,x+83,y+37,'moved');P.dispatch()
    I.touch(2,x+83,y+37,'ended');P.dispatch()
    local px,py=P.elementPosition(id,P.editor.draft)
    check(px==x+80 and py==y+35,'拖动必须保留指尖相对位置：'..id)
    render()
end
tap(436,55)
check(P.editor==nil and persisted.life and persisted.bombs,'四项位置保存到配置')
for id,pos in pairs(defaults)do
    local x,y=P.elementPosition(id);check(x==pos[1]+80 and y==pos[2]+35,'战斗使用保存位置：'..id)
end
open();tap(270,55);local x,y=P.elementPosition('slow',P.editor.draft)
check(x==defaults.slow[1] and y==defaults.slow[2],'恢复默认只作用于草稿')
tap(104,55);x,y=P.elementPosition('slow');check(x~=defaults.slow[1],'取消不覆盖保存位置')
local oldX,oldY=P.elementPosition('life')
lstg.world.scrr=432;lstg.world.scrt=669
x,y=P.elementPosition('life');check(math.abs(x-oldX*.8)<.001 and math.abs((y-165)-(oldY-165)*.8)<.001,'不同画布按场地区域比例应用')
menu=false;I.reset();I.beginFrame()
local bx,by=P.bombButton();I.touch(5,bx,by,'began')
check(GetKeyState(88),'Bomb按钮触发实际spell键')
for _=1,5 do I.endFrame();I.beginFrame()end
check(not GetKeyState(88),'长按不连续释放Bomb')
I.touch(5,bx,by,'ended');I.touch(6,bx,by,'began');check(GetKeyState(88),'重新点击能够再次释放Bomb')
ui.ResourceLoading.state={};I.beginFrame();check(next(I.touches)==nil and not GetKeyState(88),'加载清除持有触点和Bomb脉冲')
local draws=0;ui.RenderText=function()draws=draws+1 end
I.render();I.touch(7,bx,by,'began');check(draws==0 and next(I.touches)==nil,'战斗加载既不绘制也不响应按钮')
ui.ResourceLoading.state=nil;stage.current_stage.stage_name='init'
I.render();check(draws==0 and I.loading(),'启动加载同样不显示按钮')
print('竖屏布局、持久化、Bomb与加载屏蔽检查通过：'..n)
