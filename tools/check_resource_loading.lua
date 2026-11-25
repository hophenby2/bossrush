-- 执行实际加载控制器和主循环，检查加载期间只运行资源任务，不接触玩家存档。
local function noop() end
local function read(path)
    local f=assert(io.open(path,'rb'));local s=f:read('*a');f:close();return s
end
int,max,min,sin=math.floor,math.max,math.min,function(x) return math.sin(math.rad(x)) end
lstg={var={},tmpvar={},world={},system={frame=noop}}
local now=0;lstg.AndroidClock=function() return now end
AndroidPlatform={}
GetResourceStatus=function() return 'stage' end
SetResourceStatus=noop
setting={displayBG=true,keysys={menu=27}}
stage={stages={}}
function stage.New(name) local s={};stage.stages[name]=s;return s end
ui={RenderText=noop,RenderTip=noop}
mask_fader={Do=noop,frame=noop}
LoadImageFromFile,SetImageState,SetFontState,Render,RenderRect,Color=noop,noop,noop,noop,noop,noop
dofile('THlib/lib/Ltask.lua')
dofile('THlib/UI/loading.lua')
local L=ui.ResourceLoading
local P=dofile('mod/rogue_preload.lua')
RogueEncounter={preloading=P.active,preloadFrame=P.frame}
local ticks,inputs,collisions,music,initializations=0,0,0,0,0
ext={FrameCounter=0,FRAMECOUNT=0,GetFakeFPS=function() return 1 end,
    replay={IsReplay=function() return false end},
    pause_menu={IsKilled=function() return true end,frame=noop},manual={IsKilled=function() return true end},
    boss_ui={frame=noop},achievement={frame=noop},MusicChange={frame=noop},
    MusicFrame=function() music=music+1 end,FastMusic=noop,
    Debugging=noop,InputDuration=noop,DurationAchievement=noop}
ui_drawing={frame=noop}
CheckMoney,ChangeGameTitle,ResetPool,RemoveResource=noop,noop,noop,noop
GetLastKey=function() return 0 end
GetInput=function() inputs=inputs+1 end
GetCurrentSuperPause=function() return 0 end
CollisionCheck=function() collisions=collisions+1 end
BoundCheck,UpdateXY,AfterFrame=noop,noop,noop
GROUP={}
local objectTicks,taskTicks,stageTicks=0,0,0
ObjFrame=function() objectTicks=objectTicks+1;ticks=ticks+1 end
local loop=read('THlib/ext/ext.lua')
local a=assert(loop:find('local function DoFrame()',1,true))
local b=assert(loop:find('_G.DoFrame = DoFrame',a,true))
local c=assert(loop:find('local function DoFrameEx()',b,true))
local d=assert(loop:find('function RenderFunc()',c,true))
local function change()
    stage.current_stage=stage.next_stage;stage.next_stage=nil
    stage.current_stage.timer=0;stage.current_stage:init();L.stageReady()
end
assert(loadstring('local ChangeGameStage=...;local replayTicker,slowTicker=0,0;\n'..
    loop:sub(a,b+#'_G.DoFrame = DoFrame'-1)..'\n'..loop:sub(c,d-1),'@THlib/ext/ext.lua'))(change)
-- 使用随机模式真正登记的准备回调，覆盖同一登记器下的四个模式。
local rogue=read('mod/roguelike.lua')
local prepare=assert(rogue:match('(    function battle:prepareResources%(%)\n.-)    function battle:init'))
local function scene(name,resources)
    local s={stage_name=name,is_menu=false,del=noop,
        frame=function() stageTicks=stageTicks+1 end}
    function s:init()
        initializations=initializations+1
        self.rogue_resources_ready=false
        task.New(self,function() while true do taskTicks=taskTicks+1;task.Wait() end end)
    end
    if resources then
        local encounter={warmup=function()
            P.run(function() for _=1,4 do coroutine.yield() end end)
        end}
        assert(loadstring('local battle,encounter=...;\n'..prepare))(s,encounter)
    end
    return s
end
local function display() now=now+1/60;FrameFunc();if L.state then L.render() end end
for _,kind in ipairs({'关卡练习','符卡练习','single','staged','dual','chain'}) do
    -- 加载期间即使倍率很高，也不能累积战斗帧或在结束时补跑。
    ext.GetFakeFPS=function() return 8 end
    stage.current_stage={is_menu=true,del=noop}
    local s=scene(kind,kind~='关卡练习' and kind~='符卡练习')
    stage.next_stage=s
    local initialized=initializations
    local initial={ticks,inputs,collisions,music,taskTicks,stageTicks,objectTicks}
    display();assert(initializations==initialized and not s.timer,'首次显示加载页前初始化了场景')
    display();assert(s.timer==0,'场景初始化推进了逻辑时间')
    local frames=0
    while L.state do
        frames=frames+1;assert(frames<30,'资源任务完成后加载页未退出：'..kind)
        assert(ticks==initial[1] and inputs==initial[2] and collisions==initial[3] and music==initial[4],
            '加载页下推进了对象、录像输入、碰撞或音乐逻辑时钟：'..kind)
        assert(taskTicks==initial[5] and stageTicks==initial[6] and objectTicks==initial[7],
            '加载页下执行了关卡任务或战斗回调：'..kind)
        assert(s.timer==0,'加载期间关卡计时改变：'..kind)
        if L.state.done and L.state.presented then break end
        display()
    end
    assert(not P.active(),'完成进度显示时仍有未完成资源任务')
    ext.GetFakeFPS=function() return 1 end
    display();assert(not L.state and s.timer==1,'加载页撤下后未从第一逻辑帧开始：'..kind)
    assert(taskTicks==initial[5]+1 and objectTicks==initial[7]+1,'加载结束后补跑了隐藏战斗帧')
    if s.prepareResources then assert(s.rogue_resources_ready,'随机模式未记录预载完成') end
end
-- 战斗中延迟出现的资源任务也冻结逻辑，已完成准备不会再调用关卡准备回调。
local previous=ticks
P.defer(function() coroutine.yield();coroutine.yield() end)
for _=1,4 do display();assert(ticks==previous,'中途预载推进了战斗') end
while L.state do
    if L.state.done and L.state.presented then break end
    display();assert(ticks==previous,'中途预载完成前提前恢复了战斗')
end
display();assert(not L.state and ticks==previous+1,'中途预载结束后未按一帧恢复')
-- 取消加载返回标题，不能把准备状态带入下一次练习。
stage.next_stage=scene('取消中的练习',false);display()
stage.next_stage={is_menu=true};assert(not L.beforeFrame() and not L.state,'返回标题残留加载状态')
print('关卡/符卡练习及 single/staged/dual/chain：加载期间零战斗、零输入和零碰撞；资源分帧、完成画面、取消与恢复通过')
