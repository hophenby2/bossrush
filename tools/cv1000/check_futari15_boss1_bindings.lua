-- 主任务、真实炮台及二十槽演出管理器共同推进，查询结果由对象本身产生。
function Class(_,c)return c end
function New(c,...)local o={class=c};c.init(o,...);return o end
object={RawDel=function(o)o.deleted=true end};GROUP={GHOST=0,ENEMY=1};LAYER={ENEMY=0}
local body=dofile('mod/GAME/th46/boss1_body.lua')
local player={respawn=0,pilotPosition={x=120*65536,y=50*65536}}
local host,run,manager,state,ref=dofile('tools/cv1000/verify_futari15_boss1_bindings.lua')(body,player)
while state()<=#ref.steps do
    run.serial=ref.steps[state()][1]
    body.step(host)
    for o in pairs(run.boss1Children or {})do body.children.step(o)end
    local once=state();body.step(host);assert(state()==once,'同一步重复推进本体')
end
local _,callbacks,calls,queries,shots,effects,visited=state()
assert(callbacks==ref.states and calls==ref.calls and queries>0 and shots>0 and effects>0)
local taskGroup,clock=host.taskGroup,host.clock
body.close(host);body.close(host)
assert(host.deleted and clock.deleted and taskGroup.deleted and manager.deleted)
for o in pairs(visited)do assert(o.closed and o.deleted,'子任务没有回收')end
for _,o in ipairs(host.boxes)do assert(o.deleted)end
assert(not run.boss1Guns and not run.boss1Children and not host.controlGroup and not host.taskGroup)
print(('Futari 1.5 关底 %d 次主任务、%d 次请求、%d 次真实存活查询、%d 发的参数请求及 %d 次演出接口联动通过')
    :format(callbacks,calls,queries,shots,effects))

-- 实际移动槽计算起跳和落地，再由事件挂载真实演出槽；不提供录制的落地时刻或高度。
run={serial=0};host=body.create(run,player,0)
host.motionInput={0,0,120*65536,50*65536,1}
host.raw[24],host.raw[20]=1,5*65536
local requests,landings={},0
local api=body.makeControlAPI(host,{
    effect=function(_,kind)
        requests[kind]=(requests[kind]or 0)+1
        if kind=='camera_offset'then return {0,0}end
    end,
    motionEvent=function(_,kind)if kind=='land'then landings=landings+1 end end,
})
body.motion.create(host,'simple_init')
for _=1,200 do run.serial=run.serial+1;body.step(host)end
assert(landings==1 and host.raw[24]==0 and host.raw[16]==0)
assert(requests.sound==1 and requests.land_burst==2 and requests.land_dust==43 and requests.camera_offset==86)
assert(not next(host.taskGroup.slots),'落地任务没有自然结束')
api.close();body.close(host)
assert(host.deleted and not host.motion and not host.taskGroup and not host.motionEvent)
print('Futari 1.5 关底原生起跳、落地事件、86 次回弹任务与自然回收通过')
