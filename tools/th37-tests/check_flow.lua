-- 原作关卡轴在Boss存在期间暂停；这里只验证完整脚本、演员顺序、续接阈值与清场。
arg={'th37-flow'}
local f=assert(io.open('tools/check_stage.lua'));local source=f:read('*a');f:close()
assert(loadstring(source:sub(1,assert(source:find('if path == "--all" then',1,true))-1)))()
dofile('THlib/lib/Ltask.lua')
dofile('mod/GAME/th37.lua')
local actualNew=New;local pending,seen,wall
New=function(cls,cards,...)
    if cls.StageLevel==35 then
        for _,card in ipairs(cards) do seen[#seen+1]=card.mhj_source.id end
        pending={_live=true,ttl=3};return pending
    end
    return actualNew(cls,cards,...)
end
local frames,totalCards=0,0
for _,chapter in ipairs(TH37.data.chapters) do
    pending=nil;seen={};wall=0
    lstg.var.sequence_run={}
    local scene={}
    local co=coroutine.create(function() TH37.runChapter(scene,chapter) end)
    while coroutine.status(co)~='dead' do
        wall=wall+1;assert(wall<chapter.length+200,'关卡未自然结束')
        local frozen=pending and pending._live and pending.ttl>0
        local before=lstg.var.sequence_run.road_time
        local ok,msg=coroutine.resume(co);assert(ok,msg)
        if frozen and pending._live then
            assert(lstg.var.sequence_run.road_time==before,'Boss仍存活时原关卡轴前进')
            pending.ttl=pending.ttl-1;if pending.ttl==0 then pending._live=false end
        end
    end
    local expected={};for _,g in ipairs(chapter.bosses) do for _,c in ipairs(g.cards) do expected[#expected+1]=c.id end end
    assert(#seen==#expected,'Boss阶段丢失')
    for i,id in ipairs(expected) do assert(seen[i]==id,'Boss顺序不符') end
    for o in pairs(TH37.runtime.objects) do assert(not IsValid(o),'关卡结束残留原生对象') end
    frames=frames+wall;totalCards=totalCards+#seen
    print('完整流程 '..chapter.name..'：'..#seen..'阶段，关卡轴'..chapter.length..'帧，Boss等待正确。')
    collectgarbage('collect')
end
assert(totalCards==93,'战斗集合不完整')
-- LAST的CONTINUE应为同一张卡的血量/剩余时间分段，不能变成新符卡。
local count=0
for _,meta in ipairs(TH37.data.cards) do
    for _,next in ipairs(meta.continuations or {}) do
        assert(next.hp<meta.hp and next.time<meta.seconds,'CONTINUE必须落在同一攻击内')
        count=count+1
    end
end
assert(count==8,'CONTINUE分支未全部接入')
print('八条完整流程、93战斗、8个CONTINUE阈值与关末清场检查通过。')
