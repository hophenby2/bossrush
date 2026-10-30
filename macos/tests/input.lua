-- Mac 键盘事件桥接回归，不创建窗口，不读写玩家数据。
local root=assert(arg[1]);local n=0
local function check(value,message) assert(value,message);n=n+1 end
local function source(path) local f=assert(io.open(root..'/'..path,'rb'));local s=f:read('*a');f:close();return s end
package.preload.keycode=function() return assert(loadstring(source('macos/.cache/LuaSTG-x/src/keycode.lua')))() end
lstg={SystemLog=function() end,GetKeyState=function() return false end,GetLastKey=function() return 0 end,
    GetMousePosition=function() return 20,30 end,GetMouseState=function(button) return button==2 end,
    world={l=-192,r=192,b=-224,t=224,pl=-192,pr=192,pb=-224,pt=224,scrl=288,scrr=672,scrb=46,scrt=494}}
player={x=0,y=-100,hspeed=4,lspeed=2};stage={current_stage={}}
local menu=false
ext={StageIsMenu=function() return menu end,pause_menu={IsKilled=function() return true end}}
setting={keys={up=38,down=40,left=37,right=39,slow=16,shoot=90,spell=88,special=67}}
screen={scale=2,dx=0,dy=0}
local listeners={}
local function listener(kind)
    local l={kind=kind,handlers={}};function l:registerScriptHandler(fn,id) self.handlers[id]=fn end
    listeners[kind]=l;return l
end
local dispatcher={addEventListenerWithSceneGraphPriority=function() end}
cc={Handler={EVENT_KEYBOARD_PRESSED=1,EVENT_KEYBOARD_RELEASED=2,EVENT_MOUSE_DOWN=3,EVENT_MOUSE_MOVE=4,EVENT_MOUSE_UP=5,EVENT_MOUSE_SCROLL=6},
    FileUtils={getInstance=function() return {getStringFromFile=function(_,path) check(path=='game/android/input.lua','共用 Android 输入模块');return source('android/lua/input.lua') end} end},
    EventListenerKeyboard={create=function() return listener('keyboard') end},EventListenerMouse={create=function() return listener('mouse') end},
    Director={getInstance=function() return {getEventDispatcher=function() return dispatcher end} end}}
local I=assert(loadstring(source('macos/lua/input.lua')))();I.install({});I.beginFrame()
local k=listeners.keyboard.handlers
local function frame() I.endFrame();I.beginFrame() end
k[1](6);k[2](6);I.beginFrame()
check(GetLastKey()==27,'同次事件轮询中的 Esc 按下 / 抬起仍保留到逻辑帧')
frame();check(GetLastKey()==0,'Esc 事件不会重复触发')
k[1](29);I.beginFrame();check(GetKeyState(40),'方向键转换为 Windows 键码')
k[2](29);frame();check(not GetKeyState(40),'方向键释放当帧停止，不保留脉冲惯性')
k[1](12);k[1](13);I.beginFrame();check(GetKeyState(16),'左右 Shift 共用低速键')
k[2](12);frame();check(GetKeyState(16),'释放左 Shift 后右 Shift 仍生效')
k[2](13);frame();check(not GetKeyState(16),'两个 Shift 均释放后立即恢复高速')
k[1](10);k[2](10);I.beginFrame();check(GetLastKey()==13,'Mac Return 转换为确认键')
frame();k[1](72);k[2](72);I.beginFrame();check(GetLastKey()==188,'逗号音乐快捷键映射')
frame();k[1](54);k[2](54);I.beginFrame();check(I.preview and I.toggles.shoot and I.toggles.slow,'F8 单击进入触屏预览并开启默认开关')
frame();check(I.preview,'F8 事件只切换一次')
local m=listeners.mouse.handlers
local function point(x,y,button) return {getLocation=function() return {x=x,y=y} end,getMouseButton=function() return button or 0 end} end
m[3](point(800,600));check(I.movementId=='mac-mouse','战斗区鼠标进入拖拽')
m[4](point(864,648));local state={};I.readMovement(state)
check(state.touch_x==32 and state.touch_y==-76,'Retina 坐标转为世界中的相对拖拽终点')
m[5](point(864,648));I.readMovement(state);check(state.touch_x==nil and I.movementId==nil,'抬手清除移动目标')
check(GetMouseState(0)==false and not I.mouse.down,'拖拽不转成菜单点击')
I.preview=false;check(GetMouseState(2),'桌面右键转换为 Sub 的第三个鼠标键')
print('Mac 输入桥接回归通过：'..n..' 项')
