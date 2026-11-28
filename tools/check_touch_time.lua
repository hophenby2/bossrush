-- 触点实际进入安卓输入链：停时丢弃增量，缓时拖动距离为三分之一，恢复后不补走。
package.preload.keycode=function() return setmetatable({}, {__index=function(_,k) return #k+100 end}) end
setting={keys={slow=16,shoot=90,spell=88},touchUnlimited=true}
lstg={var={__touch_always=true,__touch_unlimited=true},GetKeyState=function() return false end,GetLastKey=function() return 0 end,
    world={l=-192,r=192,b=-224,t=224,pl=-192,pr=192,pb=-224,pt=224,scrl=100,scrr=484,scrb=40,scrt=488}}
stage={current_stage={}};player={x=0,y=0,hspeed=4,lspeed=2,death=0}
ext={StageIsMenu=function() return false end}
local pause=0
GetCurrentSuperPause=function() return pause end
dofile('THlib/lib/Linput.lua')
local I=dofile('android/lua/input.lua')
local function near(a,b) assert(math.abs(a-b)<1e-8,tostring(a)..' / '..tostring(b)) end
local function start()
    I.reset();I.beginFrame();player.x,player.y=0,0
    I.touch(1,300,250,'began')
end
local function move(x,y)
    I.touch(1,x,y,'moved');player.key={};I.readMovement(player.key)
    player._touch_movement_used=nil;ApplyPendingTouchMovement(player)
end
start();move(330,280);near(player.x,30);near(player.y,30)
player.time_stop=true;I.beginFrame();move(390,340);near(player.x,30);near(player.y,30)
player.time_stop=false;I.beginFrame();move(396,346);near(player.x,36);near(player.y,36)
for _,kind in ipairs({'th08','native','global'}) do
    start()
    if kind=='th08' then player.th08_move_time_scale=1/3
    elseif kind=='native' then NativeTime={owner={},scale=.25}
    else lstg.var.timeslow=2 end
    move(330,280);near(player.x,10);near(player.y,10)
    player.th08_move_time_scale=nil;NativeTime=nil;lstg.var.timeslow=nil
    move(336,286);near(player.x,16);near(player.y,16)
end
for _,kind in ipairs({'superpause','native'}) do
    start();move(312,262)
    if kind=='native' then NativeTime={owner={},scale=.01} else pause=10 end
    I.beginFrame();move(372,322);near(player.x,12);near(player.y,12)
    NativeTime=nil;pause=0;I.beginFrame();move(378,328);near(player.x,18);near(player.y,18)
end
-- 真实停时还会锁定常规移动，补偿路径仍必须停住；普通死亡期间继续允许拖动。
start();player.lock=true;player.time_stop=true;move(330,280);near(player.x,0);near(player.y,0)
player.lock,player.time_stop=nil,nil;player.death=70;move(336,286);near(player.x,6);near(player.y,6)
-- 常规自机移动也调用正式事件，防止触点缩放后又被TH08倍率乘一次。
player_lib={};plus={Class=function() return {} end}
Forbid=function(v,a,b) return math.max(a,math.min(b,v)) end
dofile('THlib/player/player_system.lua')
start();player.th08_move_time_scale=1/3
player.__left_counting,player.__right_counting,player.__up_counting,player.__down_counting=0,0,0,0
I.touch(1,330,280,'moved');player.key={};I.readMovement(player.key)
player_lib.defaultFrameEvent['frame.move'][2](player)
near(player.x,10);near(player.y,10)
player.key={right=true};player.__right_flag=true
player_lib.defaultFrameEvent['frame.move'][2](player)
near(player.x,10+4/3)
print('触控停时、三类缓时、恢复无积压及死亡补偿检查通过')
