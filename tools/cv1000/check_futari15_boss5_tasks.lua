-- 桩件使用严格实例表，不允许从类表隐式继承对象方法。
function Class(_,c)return c end
function New(c,...)local o={class=c};c.init(o,...);return o end
object={RawDel=function(o)o.deleted=true end};GROUP={GHOST=0}
local tasks=dofile('mod/GAME/th46/boss5_tasks.lua')
local reference=dofile(os.getenv('FUTARI15_BOSS5_TASKS')or'tools/cv1000/fixtures/futari15_boss5_tasks.lua')
local test=dofile('tools/cv1000/verify_futari15_boss5_tasks.lua')(tasks,reference)
while not test.step()do end
for _,o in ipairs(test.objects)do assert(o.deleted)end
local callbacks,calls=test.result()
local host={run={serial=0},raw={},nativeHandle=65534}
local manager=tasks.create(host)
local last=tasks.add(manager,'head_up_init',{17})
assert(last==65535)
assert(tasks.add(manager,'head_down_init')==1,'句柄溢出没有跳过零')
for i=3,20 do assert(tasks.add(manager,'head_up_init')==i-1)end
assert(tasks.add(manager,'head_up_init')==0 and host.nativeHandle==19,'满槽消耗了句柄')
assert(tasks.alive(manager,65535)and not tasks.alive(manager,0))
tasks.clear(manager)
local _,slot=tasks.add(manager,'head_up_init')
assert(slot.index==1 and slot.config[1]==17,'空配置重用没有保留原槽配置')
tasks.close(manager)
LAYER={ENEMY=-600}
local body=dofile('mod/GAME/th46/boss5_body.lua')
local owner,slots=dofile('tools/cv1000/verify_futari15_boss5_task_binding.lua')(body,{})
assert(owner.deleted)
for _,o in ipairs(slots)do assert(o.deleted)end
print(('第五面演出 %d 次独立回调、%d 次接口、二十槽与句柄回收通过'):format(callbacks,calls))
