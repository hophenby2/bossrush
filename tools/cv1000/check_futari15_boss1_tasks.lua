-- 子任务的状态和结束来自原生逻辑；只补移动、其它控制器等外部对本体的修改。
function Class(_,c)return c end
function New(c,...)local o={class=c};c.init(o,...);return o end
object={RawDel=function(o)o.deleted=true end};GROUP={GHOST=0}
local tasks=dofile('mod/GAME/th46/boss1_tasks.lua')
local reference=dofile(os.getenv('FUTARI15_TASKS_FIXTURE')or'tools/cv1000/fixtures/futari15_boss1_tasks.lua')
local run={serial=0}
local host={run=run,raw=reference.initial,renderDepth=reference.depth}
local byId,api,row,operationIndex,calls,closed={},{},nil,0,0,0
local function same(a,b)
    if type(a)~=type(b)then return false end
    if type(a)~='table'then return a==b end
    if #a~=#b then return false end
    for i=1,#a do if not same(a[i],b[i])then return false end end
    return true
end
function api.invoke(_,kind)
    if kind=='camera_offset'then return row[12][operationIndex+1][2]end
    return 0
end
function api.observe(_,kind,args,result)
    local expected=assert(row[12][operationIndex+1],'多提交了演出接口 '..kind)
    local actual={kind};for _,value in ipairs(args)do actual[#actual+1]=value end
    assert(same(actual,expected[1]),'第 '..row[1]..' 帧 '..row[5]..' 演出接口不符：'..kind)
    if kind=='spawn'then
        assert(result~=0,'原生演出任务槽不足');result.sourceId=expected[2];byId[result.sourceId]=result
    end
    operationIndex,calls=operationIndex+1,calls+1
end
local manager=tasks.create(host,api)
for _,r in ipairs(reference.steps)do
    row,operationIndex=r,0
    local o=byId[r[3]]
    if not o then
        o=tasks.spawn(manager,r[5],r[8]);assert(o~=0)
        o.sourceId=r[3];byId[r[3]]=o
    end
    assert(o.mode==r[5]and not o.closed,'原版演出入口或存活状态不符')
    for i=1,#r[9],2 do host.raw[r[9][i]]=r[9][i+1]end
    run.serial=r[1];tasks.stepSlot(o)
    assert(o.mode==r[6]and o.closed==not r[7],'第 '..r[1]..' 帧演出入口切换或回收不符')
    assert(operationIndex==#r[12],'原版演出接口没有用完')
    local n=0
    for _,field in ipairs(tasks.fields)do n=(n*131+assert(host.raw[field[1]]))%16777213 end
    assert(n==r[10],'第 '..r[1]..' 帧 '..r[5]..' 本体写回不符：'..n..' / '..r[10])
    for i=1,#r[11],2 do
        assert(o.vars[r[11][i]]==r[11][i+1],'第 '..r[1]..' 帧 '..r[5]..' 私有字段 '..r[11][i]..' 不符')
    end
    if o.closed then closed=closed+1 end
    local mode=o.mode;tasks.stepSlot(o);assert(o.mode==mode,'同一逻辑步重复更新演出任务')
end
assert(calls==reference.calls and closed==reference.closed)
tasks.close(manager);tasks.close(manager)
assert(manager.deleted and not host.taskGroup)
local count=0;for _,o in pairs(byId)do assert(o.closed and o.deleted);count=count+1 end
print(('Futari 1.5 关底 %d 次演出任务、%d 份生命周期、%d 次接口和本体写回通过'):format(reference.states,count,calls))
