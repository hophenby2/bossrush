-- 原Time.Update的gotowhere!=0；实际243首波第179帧必须发射，保留后续循环。
arg={'th39-global-jump'}
local f=assert(io.open('tools/check_stage.lua'));local src=f:read('*a');f:close()
assert(loadstring(src:sub(1,assert(src:find('if path == "--all" then',1,true))-1)))()
dofile('THlib/lib/Ltask.lua')
local R=dofile('mod/GAME/th39/runtime.lua');R.sound=function() end
local objects,bursts={},{}
local rawNew=New
local frame=0
New=function(class,...)
    local o=rawNew(class,...);objects[#objects+1]=o
    if o.mhj and o.mhj.pattern.id=='243' and o.mhj.type==152 then
        bursts[frame]=(bursts[frame] or 0)+1
    end
    return o
end
local c=R.controller({_live=true,x=0,y=70},'243',false,{[1]={15,99900,55}})
for tick=1,1260 do
    frame=tick;R.tick(c)
    assert(c.time==(tick-1)%420+1,'目标0改变了实际时间轴：'..tick..'/'..c.time)
    local n=#objects
    for i=1,n do local o=objects[i];if IsValid(o) and o.class.frame then o.class.frame(o) end end
    local alive={};for _,o in ipairs(objects) do if IsValid(o) then alive[#alive+1]=o end end;objects=alive
end
for _,tick in ipairs({179,599,1019}) do assert(bursts[tick]==45,'帝王切开该波未生成45个原作发射体：'..tick..'/'..tostring(bursts[tick])) end
R.clear(c)
for _,runtime in ipairs({R,dofile('mod/GAME/th37/runtime.lua')}) do
    local state={time=179,jumps={}}
    runtime.jump(state,2,1,0);assert(state.time==179 and state.jumps[2]==1,'未配置的跳转改变时间或丢失次数')
    runtime.jump(state,3,1,7);assert(state.time==7,'一次有效跳转失效')
    state.time=179;runtime.jump(state,3,1,7);assert(state.time==179,'次数限制失效')
    runtime.jump(state,4,0,2);assert(state.time==2,'无限跳转失效')
    state.time=179;runtime.jump(state,4,0,2);assert(state.time==2,'重复无限跳转失效')
end
print('PASS 帝王切开三轮179/599/1019帧各45发；春雪/永夜零目标、有限及无限跳转语义。')
