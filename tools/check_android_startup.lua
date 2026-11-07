-- 只执行实际启动界面的输入分支和帧调度函数，不启动引擎，不接触玩家目录。
local function noop() end
lstg = { var = {timeslow=1}, tmpvar = {} }
local now = 0
lstg.AndroidClock = function() return now end
int, sign = math.floor, function(n) return n>0 and 1 or n<0 and -1 or 0 end
stage = { stages = {}, New = function(name)
    local scene = {}
    stage.stages[name] = scene
    return scene
end }
LoadImageFromFile = noop
mask_fader = {Do=noop}
task = {New=noop}
scoredata = {}
local yes = false
menu = {Updatekey=noop, keyYes=function() return yes end}
for _,key in ipairs({'keyNo','keyUp','keyDown','keyLeft','keyRight'}) do menu[key]=function() return false end end
PlaySound = noop
ext = {mouse={_wheel=0, isDown=function() return false end}}
ui = {menu={shake_time=10}}
sp = {TweakValue=function(_,n,count,minimum) return (n-minimum)%count+minimum end}
dofile('THlib/UI/loading.lua')
local name = stage.stages.setname
name:init()
for _,wheel in ipairs({120,-120,120,120,-120}) do
    ext.mouse._wheel = wheel
    name:frame()
    assert(name.state2CursorX>=0 and name.state2CursorX<13)
    assert(name.state2CursorY>=0 and name.state2CursorY<7)
end
ext.mouse._wheel=0
name.state2CursorX,name.state2CursorY=0,0
yes=true
for _=1,4 do name:frame() end
assert(name.state2UserName=='AAAA')
name.state2CursorX,name.state2CursorY=12,6
name:frame()
assert(name.jump and scoredata.PlayerBrand=='AAAA')

-- 执行 ext.lua 中原样的帧入口，模拟启动已用十秒、以及加载中的慢帧。
local file = assert(io.open('THlib/ext/ext.lua','rb'))
local source=file:read('*a');file:close()
local first=assert(source:find('local differ = 1',1,true))
local last=assert(source:find('function RenderFunc()',first,true))
local step
lstg.StopWatch=function() return {GetElapsed=function() return now end} end
setting={keysys={menu=27}}
cur_setting={}
CheckMoney,ChangeGameTitle= noop,noop
GetLastKey=function() return 0 end
DoFrameEx=function(count) step=count end
ext.pause_menu={IsKilled=function() return true end,frame=noop}
ui_drawing={frame=noop}
ext.manual={IsKilled=function() return true end}
ext.achievement={frame=noop}
ext.MusicChange={frame=noop}
ext.Debugging,ext.InputDuration,ext.DurationAchievement=noop,noop,noop
ext.FRAMECOUNT=0
stage.current_stage=nil
stage.next_stage={stage_name='init',is_menu=true}
assert(loadstring(source:sub(first,last-1),'@THlib/ext/ext.lua:FrameFunc'))()
now=10
FrameFunc()
assert(step==1,'首帧把初始化耗时补跑成大量加载帧')
stage.current_stage=stage.next_stage;stage.next_stage=nil
now=now+0.25
FrameFunc()
assert(step==1,'加载慢帧再次累积并补跑')
stage.current_stage={stage_name='battle',is_menu=false}
now=now+1/60
FrameFunc()
assert(step==1,'加载结束遗留了补帧积压')
now=now+0.1
FrameFunc()
assert(step>=5 and step<=7,'战斗的正常补帧被影响')
print('首次命名的滚动、确认，以及加载阶段补帧隔离检查通过')
