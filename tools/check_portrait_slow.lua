-- 实际触点进入输入链，覆盖三种低速逻辑、多指、拖动、取消与暂停恢复。
package.preload.keycode=function() return setmetatable({}, {__index=function(_,k) return #k+100 end}) end
lstg={var={__input_version=2},GetKeyState=function() return false end,GetLastKey=function() return 0 end,
    world={l=-192,r=192,b=-224,t=224,pl=-192,pr=192,pb=-224,pt=224,scrl=0,scrr=540,scrb=285,scrt=915}}
setting={androidPortrait=true,resx=1080,resy=2400,keys={slow=65,shoot=90,spell=88}}
stage={current_stage={}};player={x=0,y=0,hspeed=4,lspeed=2,death=0}
local paused=false
ext={StageIsMenu=function() return false end,pause_menu={IsKilled=function() return not paused end}}
AndroidPortrait=dofile('android/lua/portrait.lua')
AndroidInput=dofile('android/lua/input.lua')
local I,P=AndroidInput,AndroidPortrait
local checks=0
local function check(v,s) assert(v,s);checks=checks+1 end
local function slow() return lstg.GetKeyState(65) end
local function button(id,event)
    local x,y=P.slowButton();I.touch(id,x,y,event)
end
local function fresh(mode)
    I.reset();setting.touchSlowMode=mode;stage.current_stage={};I.beginFrame()
end
fresh(nil);check(I.slowMode()==1 and slow(),'缺省为点击切换，开局保持低速')
button(1,'began');check(not slow(),'点击切到高速')
button(1,'moved');button(1,'ended');I.beginFrame();check(not slow(),'拖动/抬手和后续帧不会重新强制低速')
button(2,'began');button(2,'ended');check(slow(),'再次点击切到低速')
for _,mode in ipairs({2,3}) do
    fresh(mode);check(slow()==(mode==3),'松开时的速度由模式决定')
    I.touch(10,270,600,'began');I.touch(10,300,610,'moved')
    button(20,'began');check(slow()==(mode==2),'低速按钮独立于移动触点')
    local target=I.targetX
    button(21,'began');button(20,'cancelled');check(slow()==(mode==2),'多指仍有一个按住时保持按住状态')
    check(I.movementId==10 and I.targetX==target,'按钮不抢占移动触点')
    button(21,'ended');check(slow()==(mode==3),'最后一个按住触点抬手时恢复')
    check(not lstg.GetKeyState(88),'点击低速不能被双击识别成Bomb')
    button(22,'began');paused=true;I.beginFrame();check(not slow(),'暂停期间不输入低速')
    paused=false;I.beginFrame();check(slow()==(mode==3),'暂停清除按住触点，恢复使用未按住语义')
end
fresh(1);button(1,'began');button(1,'ended');paused=true;I.beginFrame();paused=false;I.beginFrame()
check(not slow(),'点击切换模式在暂停前后保持高速选择')
I.reset();I.beginFrame();check(not slow(),'失焦清除切换状态')
print('竖屏低速按钮三种逻辑、键位、多指/移动、取消、暂停检查通过：'..checks)
