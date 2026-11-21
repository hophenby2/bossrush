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
-- 精简分支已移除首次命名入口；存在旧入口时才执行对应输入回归。
if name then
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
end

-- 执行真实的帧调度与入口，启动、加载和战斗慢帧都不能积累追帧债务。
local file = assert(io.open('THlib/ext/ext.lua','rb'))
local source=file:read('*a');file:close()
local first=assert(source:find('local function DoFrameEx(',1,true))
local last=assert(source:find('function RenderFunc()',first,true))
local step
lstg.StopWatch=function() return {GetElapsed=function() return now end} end
setting={keysys={menu=27}}
cur_setting={frameskip=true} -- 旧配置也不能重新开启追帧。
CheckMoney,ChangeGameTitle= noop,noop
GetLastKey=function() return 0 end
DoFrame=function() step=(step or 0)+1 end
ext.GetFakeFPS=function() return 1 end
ext.replay={IsReplay=function() return false end,IsRecording=function() return true end}
local fakeTicks=0
ext.MusicFrame=function(kind,count) if kind=='faketimer' then fakeTicks=fakeTicks+(count or 1) end end
ext.FastMusic=noop
ext.FrameCounter=0
ext.pause_menu={IsKilled=function() return true end,frame=noop}
ui_drawing={frame=noop}
ext.manual={IsKilled=function() return true end}
ext.achievement={frame=noop}
ext.MusicChange={frame=noop}
ext.Debugging,ext.InputDuration,ext.DurationAchievement=noop,noop,noop
ext.FRAMECOUNT=0
stage.current_stage=nil
stage.next_stage={stage_name='init',is_menu=true}
assert(loadstring('local replayTicker,slowTicker=0,0;\n'..source:sub(first,last-1),'@THlib/ext/ext.lua:FrameFunc'))()
now=10
step=0
FrameFunc()
assert(step==1,'首帧把初始化耗时补跑成大量加载帧')
stage.current_stage=stage.next_stage;stage.next_stage=nil
now=now+0.25
step=0
FrameFunc()
assert(step==1,'加载慢帧再次累积并补跑')
stage.current_stage={stage_name='battle',is_menu=false}
now=now+1/60
step=0
FrameFunc()
assert(step==1,'加载结束遗留了补帧积压')
now=now+0.1
step=0
local previousFake=fakeTicks
FrameFunc()
assert(step==1,'战斗慢帧触发了追帧')
assert(fakeTicks==previousFake+1,'战斗慢帧按墙钟补偿了音乐时钟')
for _=1,12 do
    now=now+1/60;step=0;FrameFunc()
    assert(step==1,'慢帧之后出现加速补跑')
end
ext.GetFakeFPS=function() return .5 end
step=0;FrameFunc();FrameFunc()
assert(step==1,'原作时缓的分数逻辑帧受到影响')
ext.GetFakeFPS=function() return 1 end
SaveProfiles={pending=false};SaveSync={visible=true,frame=noop}
step=0;now=now+1000;FrameFunc()
assert(step==0,'同步页暂停时推进了战斗')
SaveSync.visible=false;FrameFunc()
assert(step==1,'关闭同步页后补跑了暂停时长')
ext.replay.IsReplay=function() return true end
setting.keysys.repfast,setting.keysys.repslow=65,66
setting.ReplayFastSpeed,setting.ReplaySlowSpeed=120,30
GetKeyState=function(key) return key==65 end
step=0;FrameFunc()
assert(step==2,'录像手动快进受到影响')
print('加载、战斗慢帧和暂停恢复均不追帧；原作时缓与录像手动快进保留')
