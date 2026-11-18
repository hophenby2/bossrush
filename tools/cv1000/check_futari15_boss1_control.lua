-- 对照独立的主任务入口/返回和挂载请求；子任务内部不在此执行，查询使用原版探针的返回值。
function Class(_,c)return c end
function New(c,...)local o={class=c};c.init(o,...);return o end
object={RawDel=function(o)o.deleted=true end};GROUP={GHOST=0}
local control=dofile('mod/GAME/th46/boss1_control.lua')
local reference=dofile(os.getenv('FUTARI15_CONTROL_FIXTURE')or'tools/cv1000/fixtures/futari15_boss1_control.lua')
local run={serial=reference.steps[1][1]-1}
local host={run=run,raw=reference.initial}
local index,operationIndex,calls,callbacks,multiples=1,0,0,0,0
local row
local api={}
local closed=0
function api.close()closed=closed+1 end
local function operation(kind,args)
    local op=assert(row[9][operationIndex+1],'多调用了原版接口 '..kind)
    assert(op[1][1]==kind,'第 '..row[1]..' 帧接口不符：'..kind..' / '..op[1][1])
    assert(#op[1]==#args+1,'原版接口参数数目不符：'..kind)
    for i,value in ipairs(args)do
        if type(value)=='table'then value=value.sourceId end
        assert(value==op[1][i+1],'原版 '..kind..' 第 '..i..' 参数不符：'..tostring(value)..' / '..tostring(op[1][i+1]))
    end
    return op
end
function api.invoke(_,kind,args)
    return operation(kind,args)[2]
end
function api.observe(_,kind,args,result)
    local op=operation(kind,args)
    if kind=='control'then
        assert(result~=0,'原生主任务槽不足');result.sourceId=op[2]
    elseif kind=='random'or kind=='alive'or kind=='spawn'then
        assert(result==op[2],'原版接口返回值不符')
    end
    calls,operationIndex=calls+1,operationIndex+1
end
function api.beforeSlot(_,o)
    row=assert(reference.steps[index],'原生管理器多执行了一个主任务')
    assert(row[1]==run.serial and row[2]==o.sourceId and row[3]==o.mode,'第 '..run.serial..' 帧主任务顺序或入口不符：'..o.mode)
    for i=1,#row[6],2 do host.raw[row[6][i]]=row[6][i+1]end
    operationIndex=0
end
function api.afterSlot(_,o)
    assert(operationIndex==#row[9],'原版接口调用没有用完')
    assert(o.mode==row[4]and o.closed==not row[5],'原版入口切换或主任务回收不符')
    for i,at in ipairs(reference.fields)do
        assert(host.raw[at]==row[7][i],'第 '..row[1]..' 帧本体字段 '..at..' 不符')
    end
    for i=1,#row[8],2 do
        assert(o.vars[row[8][i]]==row[8][i+1],'第 '..row[1]..' 帧 '..row[3]..' 私有字段 '..row[8][i]..' 不符：'..tostring(o.vars[row[8][i]])..' / '..row[8][i+1])
    end
    callbacks,index=callbacks+1,index+1
end
local manager=control.create(host,api)
manager.slots[1].sourceId=reference.steps[1][2]
while index<=#reference.steps do
    run.serial=reference.steps[index][1]
    local before=index;control.step(manager)
    assert(index>before,'主任务管理器没有推进')
    if index-before>1 then multiples=multiples+1 end
    local once=index;control.step(manager);assert(index==once,'同一逻辑步重复运行主任务')
end
assert(callbacks==reference.states and calls==reference.calls and multiples>0)
local slots={};for _,o in pairs(manager.slots)do slots[#slots+1]=o end
control.close(manager);control.close(manager)
assert(manager.deleted and not host.controlGroup and closed==1)
for _,o in ipairs(slots)do assert(o.closed and o.deleted)end
print(('Futari 1.5 关底 %d 次主任务、%d 次接口、%d 次当步挂载与五槽回收通过'):format(callbacks,calls,multiples))
