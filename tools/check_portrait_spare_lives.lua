-- 直接调用正式竖屏HUD与挑战帧回调：残机不含当前自机，0残机仍能继续。
local function noop()end
Color=function(...)return{...}end
ui={RunHUD=dofile('THlib/UI/run_hud.lua')}
RogueTen={MISS_LIMIT=10};lstg={var={dead=0,rogue_run={}},world={scrl=0,scrr=540,scrb=0,scrt=630}}
stage={current_stage={timer=0},group={frame=noop}}
SetViewMode=noop;GameDrops={bombsEnabled=function()return false end}
local P={elementPosition=function(id)return 20,id=='life' and 100 or 70 end,score=noop}
local shown
P.drawInventory=function(id,x,y,value)if id=='life' then shown=value end end
local f=assert(io.open('android/lua/portrait.lua'));local source=f:read('*a');f:close()
local a=assert(source:find('function P.hud(alpha)',1,true));local b=assert(source:find('function P.drawInventory(',a,true))
assert(loadstring('return function(P) '..source:sub(a,b-1)..' end'))()(P)
-- 截取实际frame回调，仅替换与结算边界无关的资源和表现依赖。
local f=assert(io.open('mod/roguelike.lua'));source=f:read('*a');f:close()
a=assert(source:find('    function battle:frame()',1,true));b=assert(source:find('    function battle:render()',a,true))
local ended=0;local battle={timer=0}
local R={MISS_LIMIT=RogueTen.MISS_LIMIT,finish=function()ended=ended+1 end}
local stub={frame=noop}
assert(loadstring('return function(battle,R,misses,encounter,staged,titles,releaseChainGhosts) '..source:sub(a,b-1)..' end'))()(battle,R,function()return lstg.var.dead end,stub,stub,stub,noop)
for dead=0,10 do
    lstg.var.dead=dead;P.hud(255);battle:frame()
    assert(shown==math.max(0,9-dead),'竖屏残机计数不符：'..dead)
    assert(ended==(dead==10 and 1 or 0),'显示0残机时提前结算或再次死亡未结算')
end
lstg.var.dead=0;assert(ui.RunHUD.lives()==10,'横屏生命总数语义被改动')
lstg.var.rogue_run=nil;stage.current_stage.AllowMissCount=9;lstg.var.dead=9
assert(ui.RunHUD.spareLives()==0,'允许Miss次数的关卡残机口径不符')
SequenceResources={state=function()return{lives=0}end}
assert(ui.RunHUD.spareLives()==0,'原作0残机被再次减一')
print('竖屏残机：初始9、九次死亡后0且继续、第十次死亡结算通过')
