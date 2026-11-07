-- 调用实际触控模块与暂停菜单frame，不读写玩家数据。
package.preload.keycode = function()
    return setmetatable({}, {__index=function(_, key) return key:byte()+100 end})
end
lstg={var={},tmpvar={},GetKeyState=function() return false end,GetLastKey=function() return 0 end}
setting={keys={shoot=90,spell=88,up=38,down=40},keysys={menu=27,retry=82}}
KEY={ENTER=13}
task={Do=function() end}
ui={menu={shake_time=10}}
function LoadFX() end
function LoadImageFromFile() end
function Color() return {} end
local sounds, orders = 0, {}
function PlaySound() sounds=sounds+1 end
ext={StageIsMenu=function() return false end,replay={IsReplay=function() return false end},
    PushPauseMenuOrder=function(order) orders[#orders+1]=order end}
AndroidInput=dofile('android/lua/input.lua')
dofile('THlib/ext/ext_pause_menu.lua')
local input, menu=AndroidInput,ext.pause_menu
menu.FlyOut=function(self) self.kill=true;self.lock=true end
local function open(text)
    input.reset()
    menu:init()
    menu.kill,menu.lock,menu.t,menu.mask_x=false,false,0,300
    lstg.tmpvar.pause_menu_text=text
    input.beginFrame()
end
local function tap(x,y)
    input.touch(1,x,y,'began');input.touch(1,x,y,'ended')
    menu:frame();input.endFrame()
end
local function wait()
    for _=1,16 do menu:frame();input.endFrame() end
end
open()
tap(350,220)
assert(menu.pos==2 and menu.choose and #orders==0,'点击第二项应进入确认，不执行命令')
wait()
assert(#orders==0,'一个触点不能穿透到确认菜单')
input.touch(2,510,200,'began');menu:frame();input.endFrame()
input.touch(2,510,225,'moved');menu:frame();input.endFrame()
assert(menu.pos2==1 and #orders==0,'拖动应选择确认行')
input.touch(2,510,225,'ended');menu:frame();input.endFrame()
assert(#orders==0 and menu.choose,'拖动抬手不能误确认')
tap(510,225)
assert(orders[1]=='退出并保存录像' and menu.kill,'点击确认应执行原暂停命令')
open()
tap(350,170);assert(menu.pos==4 and menu.choose,'末项位置应对齐渲染')
wait();tap(510,200)
assert(not menu.choose and not menu.kill and #orders==1,'点击取消应返回主列表')
open({'返回游戏','返回标题菜单'})
tap(350,170);assert(menu.pos==1 and not menu.choose,'定制列表不能点到不存在的第四行')
tap(350,245);assert(menu.kill and orders[2]=='返回游戏','第一项应直接继续')
open()
input.pulse(40);menu:frame();input.endFrame()
assert(menu.pos==2,'键盘方向键继续有效')
input.reset();assert(not input.pauseTap)

-- 使用入口中的实际默认值迁移，覆盖旧设置、用户再次关闭和桌面三个分支。
local f=assert(io.open('android/lua/main.lua','rb'))
local source=f:read('*a');f:close()
local code=assert(source:match('(local function mobileSetting%(s%)[%s%S]-end)%s+mobileSetting%(default_setting%)'))
local make=assert(loadstring(code..'\nreturn mobileSetting'))
setfenv(make,{desktop=false,frameSize={width=1600,height=720}})
local apply=make()
local saved={touchUnlimited=false,vsync=false}
apply(saved);assert(saved.touchUnlimited and saved.touchUnlimitedDefaultApplied,'升级应启用移动端默认值')
assert(saved.vsync==false,'移动端不能强制重开垂直同步')
saved.touchUnlimited=false;apply(saved);assert(not saved.touchUnlimited,'手动关闭后不能再次强制开启')
saved.vsync=true;apply(saved);assert(saved.vsync==true,'同步开启的选择也应保留')
make=assert(loadstring(code..'\nreturn mobileSetting'))
setfenv(make,{desktop=true,frameSize={width=1600,height=720}})
saved={touchUnlimited=false};make()(saved);assert(not saved.touchUnlimited,'桌面设置不能受影响')
print('暂停点选、拖动、二次确认、键盘兼容及移动端默认值检查通过')
