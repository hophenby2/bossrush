-- 实际注册表的练习/随机候选筛选；保留完整流程中的过渡和全部历史索引。
arg={}
local f=assert(io.open('tools/sequence_registry.lua','rb'));local src=f:read('*a');f:close()
local popen=io.popen;io.popen=function() return nil end
src=src:sub(1,assert(src:find('for _,id in ipairs({3400',1,true))-1)
src=src:gsub("dofile%('tools/th43_registry.lua'%)","bent_laser.RenderFunc,bent_laser.RenderFuncDeath={},{};dofile('tools/th43_registry.lua')",1)
assert(loadstring(src))()
io.popen=popen
local practice=dofile('mod/original_practice.lua')
local function list(level)
    local out={}
    for _,row in ipairs(practice.cards(level)) do
        local id=row.unit.sc_group[1].card.card_id
        assert(_sc_pr_table[level][row.index]==row.unit,'改变了练习索引')
        out[id]=true
    end
    return out
end
local th08=list(29)
assert(not th08[467] and th08[465],'空过渡未排除，或误删正常第三非')
local transition
for _,row in ipairs(OriginalStageFlow.units(29)) do
    if row.unit.sc_group[1].card.card_id==467 then transition=row end
end
assert(transition,'从完整原作流程移除了必要过渡')
local th07=list(32)
local count=0
for id,meta in pairs(_editor_class.TH34.th07_motion_source) do
    if meta.difficulty and meta.difficulty~=3 then
        assert(not th07[id],'练习候选混入Normal/Hard：'..id)
        count=count+1
    end
end
assert(count>0 and th07[4391] and th07[3480] and th07[3411],'误删Lunatic、Extra或Phantasm')
local pool=dofile('mod/rogue_pool.lua')
for _,variant in ipairs({'single','staged'}) do
    local filters=pool.defaults(variant);filters.stages={TH31=true,TH34=true};filters.cards.survival=true
    for _,bucket in ipairs(pool.build(filters)) do for _,entry in ipairs(bucket.cards) do
        assert(not (entry.level==29 and entry.cardId==467),'随机池保留了空过渡')
        if entry.level==32 then
            local meta=_editor_class.TH34.th07_motion_source[entry.cardId]
            assert(not meta or not meta.difficulty or meta.difficulty==3,'随机Lunatic池混入Normal/Hard')
        end
    end end
end
print(('PASS 实际候选筛选：永夜抄80帧空过渡、妖妖梦%d张Normal/Hard、L/EX/PH与历史索引保留'):format(count))
