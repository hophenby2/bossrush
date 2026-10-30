-- 不依赖 Android 的契约检查：资源路径、文件流和多点触控。
local originalIO, originalLines, originalRemove, originalRename = io.open, io.lines, os.remove, os.rename
local resources = {
    ['game/asset_index.lua'] = 'return {"Resources/测试.PNG", "manual", "BadApple/file1", "THlib/se/se_ok.wav"}',
    ['game/manual'] = '第一行\r\n第二行\n',
    ['game/BadApple/file1'] = 'A\0BC',
    ['game/Resources/测试.PNG'] = 'PNG',
}
local fu = {}
function fu:getWritablePath() return '/tmp/bossrush-check/' end
function fu:createDirectory() return true end
function fu:isDirectoryExist() return false end
function fu:isFileExist(path) return resources[path] ~= nil end
function fu:getStringFromFile(path) return resources[path] or '' end
cc = { FileUtils = { getInstance = function() return fu end } }
local P = dofile('android/lua/platform.lua')
assert(P.resolve('resources\\测试.png') == 'game/Resources/测试.PNG')
assert(P.resolve('User\\Score.dat') == '/tmp/bossrush-check/bossrush/User/Score.dat')
assert(not pcall(P.resolve, '../User/Score.dat'))
assert(not pcall(io.open, 'Resources/测试.PNG', 'w'))
assert(io.open('missing') == nil)
local f = assert(io.open('manual'))
assert(f:read('*l') == '第一行')
assert(f:read('*l') == '第二行')
assert(f:read('*l') == nil)
assert(f:seek('set', 0) == 0)
assert(f:read('*a') == resources['game/manual'])
f:close(); assert(not pcall(f.read, f))
local binary = assert(io.open('BadApple\\file1', 'rb'))
assert(binary:read(2) == 'A\0'); assert(binary:seek('cur', 0) == 2)
assert(binary:read(2) == 'BC'); assert(binary:read(1) == nil)
local lines = io.lines('manual'); assert(lines() == '第一行'); assert(lines() == '第二行'); assert(lines() == nil)
local pngs = P.enumerate('Resources\\', 'png')
assert(#pngs == 1 and pngs[1][1] == 'Resources/测试.PNG')
local sounds = P.enumerate('THlib/se/', 'wav')
assert(#sounds == 1 and sounds[1][1]:sub(13, -5) == 'ok')
plus = {}; P.installNativeAPI()
assert(plus.DirectoryExists('Resources'))
assert(not plus.DirectoryExists('User'))
io.open, io.lines, os.remove, os.rename = originalIO, originalLines, originalRemove, originalRename

resources['game/asset_dimensions.lua'] = 'return {["Resources/BossBackGround/demo.png"]={1024,512}, ["Resources/BossImage/demo.png"]={128,256}}'
AndroidPlatform = P
local textures, loads, pool, resets = {}, 0, 'global', 0
function GetResourceStatus() return pool end
function SetResourceStatus(value) pool = value end
FindResForObject = function(name) return textures[name] end
lstg = {
    LoadTexture=function(name) loads=loads+1; textures[name]=true end,
    GetTextureSize=function() return 1,1 end,
    LoadImage=function(_, texture) assert(textures[texture]) end,
    LoadAnimation=function(_, texture) assert(textures[texture]) end,
    RenderTexture=function(name) assert(textures[name]) end,
    SetTextureSamplerState=function(name) assert(textures[name]) end,
    CheckRes=function(_, name) return textures[name] and 'global' end,
    EnumRes=function() local names={}; for name in pairs(textures) do names[#names+1]=name end; return names,{} end,
    RemoveResource=function(_, _, name) textures[name]=nil end,
    ResetPool=function() resets=resets+1 end,
}
local lazy = dofile('android/lua/lazy_textures.lua')
LoadTexture('bg', 'Resources/BossBackGround/demo.png')
SetTextureSamplerState('bg', 'linear+wrap')
local width,height=GetTextureSize('bg'); assert(width==1024 and height==512 and loads==0)
assert(CheckRes(1,'bg')=='global')
RenderTexture('bg',''); assert(loads==1)
LoadTexture('boss','Resources/BossImage/demo.png'); assert(loads==1)
LoadImage('boss11','boss'); assert(loads==2)
ResetPool(); assert(resets==1 and textures.bg==nil and textures.boss)
RenderTexture('bg',''); assert(loads==3)
assert(lazy.releaseBackgrounds)

package.preload.keycode = function()
    return setmetatable({ ESCAPE=6, BACKSPACE=7, TAB=8, ENTER=164, SPACE=59,
        SHIFT=12, CTRL=14, ALT=16, LEFT=26, RIGHT=27, UP=28, DOWN=29,
        HOME=21, END=24, PGUP=22, PGDN=25 }, { __index=function(_, key) return key:byte()+100 end })
end
lstg = { var={}, GetKeyState=function() return false end, GetLastKey=function() return 0 end }
local input = dofile('android/lua/input.lua')
input.touch(1, 180, 130, 'began')
input.touch(2, 853, 90, 'began')
input.touch(3, 750, 92, 'began')
assert(lstg.GetKeyState(39) and lstg.GetKeyState(90) and lstg.GetKeyState(16))
input.touch(2, 853, 90, 'ended')
assert(lstg.GetKeyState(39) and lstg.GetKeyState(16) and lstg.GetKeyState(90), '射击抬手后保持开启')
input.touch(6,853,90,'began');assert(not lstg.GetKeyState(90) and lstg.GetKeyState(16), '再次点击立即关闭射击，低速独立')
input.touch(6,853,90,'moved');assert(not lstg.GetKeyState(90), '移动事件不重复切换')
input.touch(6,853,90,'ended')
input.touch(4, 750, 92, 'began')
input.touch(3, 750, 92, 'cancelled')
assert(not lstg.GetKeyState(16), '第二次点击关闭低速，取消另一个触点不会反转开关')
input.touch(4,750,92,'ended');input.touch(7,750,92,'began');input.touch(7,750,92,'ended')
assert(lstg.GetKeyState(16), '重新点击并抬手保持低速')
input.touch(5, 500, 400, 'began'); assert(lstg.GetMouseState(0))
input.touch(5, 500, 420, 'moved'); assert(input.wheel == -160)
input.touch(5, 500, 420, 'ended'); assert(lstg.GetMouseState(0))
input.endFrame(); input.endFrame(); assert(not lstg.GetMouseState(0))
input.reset(); assert(not lstg.GetKeyState(39) and not lstg.GetKeyState(16))
input.pulse(27); assert(lstg.GetLastKey() == 27 and lstg.GetKeyState(27))
input.endFrame(); input.endFrame(); assert(not lstg.GetKeyState(27))
local handlers = {}
cc.Handler = { EVENT_TOUCHES_BEGAN=1, EVENT_TOUCHES_MOVED=2, EVENT_TOUCHES_ENDED=3, EVENT_TOUCHES_CANCELLED=4 }
cc.EventListenerTouchAllAtOnce = { create=function()
    return { registerScriptHandler=function(_, fn, event) handlers[event] = fn end }
end }
cc.Director = { getInstance=function() return {
    getEventDispatcher=function() return { addEventListenerWithSceneGraphPriority=function() end } end,
} end }
screen = { scale=2, dx=240, dy=0 }
input.install({})
local touch = { getId=function() return 42 end, getLocation=function() return { x=1946, y=180 } end }
handlers[1]({touch}); assert(lstg.GetKeyState(90))
handlers[3]({touch}); assert(lstg.GetKeyState(90), '原生抬手仍保持射击')
handlers[1]({touch});handlers[3]({touch});assert(not lstg.GetKeyState(90), '原生再次点击关闭射击')
input.reset()
player = { x=0, y=0, hspeed=4, lspeed=2, death=0 }
lstg.world = { l=-192,r=192,b=-224,t=224,scrl=288,scrr=672,scrb=46,scrt=494,pl=-192,pr=192,pb=-224,pt=224 }
input.touch(1,400,270,'began')
assert(not lstg.GetKeyState(39) and not lstg.GetMouseState(0))
input.touch(2,853,90,'began'); input.touch(3,750,92,'began')
input.touch(1,430,290,'moved')
assert(player.x==0 and player.y==0, '拖拽不能绕过原游戏移动和录像系统')
assert(lstg.GetKeyState(39) and lstg.GetKeyState(38) and lstg.GetKeyState(90) and lstg.GetKeyState(16))
player.x,player.y=30,20; input.beginFrame()
assert(not lstg.GetKeyState(39) and not lstg.GetKeyState(38), '到达相对拖拽目标后应停下')
input.touch(1,450,290,'moved'); input.touch(1,450,290,'ended')
assert(not lstg.GetKeyState(39) and lstg.GetKeyState(90) and not lstg.GetMouseState(0))
input.reset(); input.touch(7,180,130,'began'); input.touch(8,400,270,'began')
input.touch(8,350,270,'moved'); assert(lstg.GetKeyState(39) and not lstg.GetKeyState(37))
input.touch(7,180,130,'cancelled'); input.touch(8,300,270,'moved')
assert(not lstg.GetKeyState(37) and not lstg.GetKeyState(39), '移动触点不能相互抢占')
input.reset(); input.touch(9,400,270,'began'); input.touch(9,450,270,'moved')
player.death=100; input.beginFrame(); assert(not lstg.GetKeyState(39))
input.reset(); player.death=0; setting={keys={shoot=65,right=68}}
input.touch(10,180,130,'began'); input.touch(11,853,90,'began')
assert(lstg.GetKeyState(68) and lstg.GetKeyState(65) and not lstg.GetKeyState(90))
local atTitle,atPause=false,false
ext={StageIsMenu=function() return atTitle end,pause_menu={IsKilled=function() return not atPause end}}
input.beginFrame();atPause=true;input.beginFrame()
assert(input.toggles.shoot and not lstg.GetKeyState(65), '暂停保留开关，但暂停菜单不接收射击')
atPause=false;input.beginFrame();assert(lstg.GetKeyState(65), '继续游戏自动沿用暂停前的射击开关')
atTitle=true;input.beginFrame()
assert(not lstg.GetKeyState(68) and not lstg.GetKeyState(65) and not input.toggles.shoot, '回到标题清除开关')
atTitle=false;input.beginFrame();assert(lstg.GetKeyState(65),'进关默认射击')
input.touch(12,853,90,'began');input.touch(12,853,90,'ended');assert(not lstg.GetKeyState(65),'手动关闭默认射击')
input.reset();input.beginFrame();assert(not lstg.GetKeyState(65), '切后台 / 失焦使用完整重置，清除开关')
local paused,sceneRenders,blurs,copies=false,0,0,0
PostEffect=function(fx) if fx=='fx:pause_menu_blur' then blurs=blurs+1 else copies=copies+1 end end
RenderFunc=function() sceneRenders=sceneRenders+1; if paused then PostEffect('fx:pause_menu_blur') end end
LoadFX=function() end; CreateRenderTarget=function() end
local renderView
BeginScene=function() end; EndScene=function() end; SetViewMode=function(mode) renderView=mode end
PushRenderTarget=function() end; PopRenderTarget=function() end; RenderClear=function() end; Color=function() end
stage={current_stage={is_menu=false}}
ext={pause_menu={IsKilled=function() return not paused end,render=function() PostEffect('fx:pause_menu_blur') end},
    manual={render=function() end}, achievement={render=function() SetViewMode('world') end},
    RenderFPS=function() assert(renderView=='ui','暂停帧率必须恢复 UI 视口') end}
achievement=nil
local pauseCache=dofile('android/lua/pause_cache.lua'); pauseCache.install()
RenderFunc(); assert(sceneRenders==1 and blurs==0)
paused=true; RenderFunc(); RenderFunc(); RenderFunc()
assert(sceneRenders==2 and blurs==1 and copies==3,'冻结场景与模糊只能捕获一次')
pauseCache.invalidate(); RenderFunc(); assert(sceneRenders==3 and blurs==2)
paused=false; RenderFunc(); paused=true; RenderFunc()
assert(sceneRenders==5 and blurs==3,'恢复后再暂停必须重新捕获')
stage.current_stage={is_menu=false}; RenderFunc(); assert(sceneRenders==6 and blurs==4)
print('Android 契约检查通过：资源、流、多指摇杆/相对拖拽、射击/低速开关、暂停延续/失焦重置、死亡/键位及暂停缓存失效')
