-- 为Python原始ECL时间轴对照提供真实Lua生成器的出场帧，不读写玩家数据。
local id,duration=assert(tonumber(arg[1])),assert(tonumber(arg[2]))
local f=assert(io.open('tools/sequence_registry.lua','rb'));local setup=f:read('*a');f:close()
setup=setup:sub(1,assert(setup:find('for _,id in ipairs({3400',1,true))-1)
assert(loadstring(setup))()
local metadata=assert(dofile('mod/GAME/original/sequence_timeline.lua')[id])
local Clock=dofile('mod/sequence_clock.lua')
local frame,live,markers=0,{},{}
for _,m in pairs(metadata.midpoints) do
    markers[#markers+1]={time=m[1],timeline=m[2],order=m[3]}
end
table.sort(markers,function(a,b) return a.time<b.time end)
-- 注册桩件的New也被EX局部缓存；统一打开其生成记录分支，避免把敌机AI当成时间轴验证。
for i=1,30 do
    local name=debug.getupvalue(New,i);if not name then break end
    if name=='tracing' then debug.setupvalue(New,i,true)
    elseif name=='serialize' then debug.setupvalue(New,i,function() return '' end) end
end
LoadSound=function() end
IsValid=function(o)
    if not o then return false end
    if o.live~=nil then return o.live end
    return o._live~=false
end
New=function(cls,...) return {class=cls,live=true,x=0,y=0,timer=0,ecs={base={x=0,y=0},off={x=0,y=0}}} end
local clock=Clock.new{primary=metadata.primary,length=metadata.length,metadata=metadata,markers=markers,
    onMid=function()
        local b={live=true,born=frame};live[#live+1]=b;return {b}
    end}
local originalEach=OriginalStageFlow.roadEach
OriginalStageFlow.roadEach=function(owner,waves,spawn)
    local indices={};for i,w in ipairs(waves) do indices[w]=i end
    originalEach(owner,waves,function(w)
        spawn(w)
        print(frame..','..metadata.waves[indices[w]][2])
    end)
end
local source
for _,unit in ipairs(_sc_pr_table[32]) do if unit.sc_group[1].card.card_id==id then source=unit.sc_group[1].card;break end end
local owner={class={},timer=0,x=0,y=400,_sequence_road_context=clock}
assert(source).init(owner)
while not clock.done do
    for _,b in ipairs(live) do if frame>=b.born+duration then b.live=false end end
    task.Do(owner)
    frame,owner.timer=frame+1,owner.timer+1
    assert(frame<50000,'时间轴没有结束')
end
