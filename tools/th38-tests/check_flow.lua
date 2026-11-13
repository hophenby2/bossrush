-- 原关卡轴在Boss期间冻结；核对六面和Extra A的Boss顺序、奇数tick以及清场。
arg={'th38-flow'}
local f=assert(io.open('tools/check_stage.lua'));local src=f:read('*a');f:close()
assert(loadstring(src:sub(1,assert(src:find('if path == "--all" then',1,true))-1)))()
dofile('THlib/lib/Ltask.lua');dofile('mod/GAME/th38.lua')
local actual=New;local pending,seen,wall
New=function(cls,cards,...)
    if cls.StageLevel==36 then
        for _,card in ipairs(cards) do seen[#seen+1]=card.asl_source.id end
        pending={_live=true,ttl=3};return pending
    end
    return actual(cls,cards,...)
end
local count=0
for _,chapter in ipairs(TH38.data.chapters) do
    seen={};pending=nil;wall=0;lstg.var.sequence_run={}
    local scene={};local co=coroutine.create(function() TH38.runChapter(scene,chapter) end)
    while coroutine.status(co)~='dead' do
        wall=wall+1;assert(wall<15000,'关卡轴未自然结束')
        local frozen=pending and pending._live
        local before=lstg.var.sequence_run.road_time
        local ok,why=coroutine.resume(co);assert(ok,why)
        if frozen then assert(before==lstg.var.sequence_run.road_time,'Boss期间关卡轴提前前进');pending.ttl=pending.ttl-1;if pending.ttl==0 then pending._live=false end end
    end
    local expected={};for _,g in ipairs(chapter.bosses) do for _,c in ipairs(g.cards) do expected[#expected+1]=c.id end end
    assert(#seen==#expected,'缺少Boss阶段')
    for i,id in ipairs(expected) do assert(seen[i]==id,'出卡顺序不符') end
    for o in pairs(TH38.runtime.objects) do assert(not IsValid(o),'整关结束残留原生对象') end
    count=count+#seen;print(chapter.name..'面：'..#seen..'段Boss，关卡轴通过。');io.stdout:flush()
end
assert(count==71)
-- 跨分段转场清除旧弹、重置发射时钟，仍沿用同一宿主。
local host={x=0,y=100,hp=55000,_live=true}
local c=TH38.runtime.controller(host,'L/stage6/boss1/10')
for _=1,40 do TH38.runtime.tick(c) end
TH38.runtime.transition(c,'L/stage6/boss1/10/p2',true,true)
assert(c.time==0 and c.host==host and host.hp==55000)
TH38.runtime.tick(c);TH38.runtime.clear(c)
print('全部7面、71段Boss、转阶段与清场通过。')
