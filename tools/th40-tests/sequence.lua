-- 执行真实连续道中调度器：快杀/慢杀中Boss，检查B段出生帧与末尾交接。
arg[1]='th38-sequence-clock'
local f=assert(io.open('tools/check_stage.lua','rb'));local s=f:read('*a');f:close()
assert(loadstring(s:sub(1,assert(s:find('if path == "--all" then',1,true))-1)))()
dofile('THlib/lib/Ltask.lua');dofile('THlib/enemy/boss_card.lua')
_sc_table,_sc_pr_table={},{}
dofile('mod/_editor_output.lua')
for game=31,35 do dofile('mod/GAME/th'..game..'.lua') end
dofile('mod/GAME/th38.lua');dofile('mod/GAME/original/stage_flow.lua').install()
local C=dofile('mod/sequence_catalog.lua');local T=_editor_class.TH38;local N=T.native
local checkCount=0
local function check(v,why) assert(v,why);checkCount=checkCount+1 end
local create=N.road_controller;local tick,roads
N.road_controller=function(o,path,time) roads[#roads+1]={tick=tick,path=path,time=time};return create(o,path,time) end
local objects={}
New=function(cls,...) local o={_live=true,timer=0,x=0,y=0};cls.init(o,...);objects[#objects+1]=o;return o end
task.Wait=function() coroutine.yield() end
for _,entry in ipairs({'thsss_lunatic','thsss_extra'}) do
 for _,ch in ipairs(C.chapters(entry,'reimu_player')) do
  for _,delay in ipairs({200,2000}) do
   tick,roads=1,{};lstg.var.sequence_run={};local source=T.data.stages[ch.name];local records={}
   local function spawn(rows,first,last)
    records[#records+1]={tick=tick,role=rows[first].role,first=first,last=last}
    return {{_live=true,death=tick+delay}}
   end
   local function alive(actors) for _,b in ipairs(actors) do if tick<b.death then return true end end;return false end
   local co=coroutine.create(function() T.runChapter({},ch,spawn,alive,function() end) end)
   while coroutine.status(co)~='dead' do
    local ok,err=coroutine.resume(co);assert(ok,err);tick=tick+1;assert(tick<40000,'顺序道中未结束')
   end
   check(roads[1].tick==2 and roads[1].time==2+source.offset,'A段使用本关原始时钟偏移')
   local b
   for _,r in ipairs(roads) do if r.path:find('/B/',1,true) then b=r;break end end
   if #source.bosses>1 then
    local expected=math.max(source.clock[2]+1,source.clock[1]+delay)
    check(records[1].role=='mid' and records[1].tick==source.clock[1],'中Boss在TimeMain到点出生')
    check(b and b.tick==expected and b.time==expected+source.offset,'B段等待中Boss离场并从实际TimeMain开始')
   else check(not b and records[1].role=='boss','四/六面不调用未使用的B段和中Boss') end
   for _,r in ipairs(records) do if r.role=='boss' then check(r.tick>=source.clock[3],'关底不早于原作时钟') end end
  end
 end
end
for _,o in ipairs(objects) do if o.th38_run then N.stop(o) end end
print('连续道中快杀/慢杀、控制器偏移、四/六面与关底交接检查通过：'..checkCount)
local scene={sequence_music='TH38_Boss06'};local played=0
PlayMusic=function() played=played+1 end;StopMusic=function() end
for _,meta in ipairs(T.data.phases) do if meta.chapter=='6' and meta.optional then lstg.tmpvar.th38_phase=meta;T.mediaFrame(scene) end end
assert(played==1 and scene.sequence_music=='TH38_Boss06FSC','六面FSC三阶段必须连续播放同一首曲目')
lstg.tmpvar.th38_phase=nil
print('FSC三阶段换曲只触发一次')
