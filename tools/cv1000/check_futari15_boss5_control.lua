-- 主任务流程和外部挂载对照，不执行尚未移植的发弹器/演出/零件内部。
function Class(_,c)return c end
function New(c,...)local o={class=c};c.init(o,...);return o end
object={RawDel=function(o)o.deleted=true end};GROUP={GHOST=0}
local control=dofile('mod/GAME/th46/boss5_control.lua')
local fixtures=os.getenv('FUTARI15_BOSS5_CONTROL')and{os.getenv('FUTARI15_BOSS5_CONTROL')}or{
    'tools/cv1000/fixtures/futari15_boss5_control.lua',
    'tools/cv1000/fixtures/futari15_boss5_second.lua',
    'tools/cv1000/fixtures/futari15_boss5_third.lua',
    'tools/cv1000/fixtures/futari15_boss5_change1.lua',
    'tools/cv1000/fixtures/futari15_boss5_change2.lua',
    'tools/cv1000/fixtures/futari15_boss5_change1_timeout.lua',
    'tools/cv1000/fixtures/futari15_boss5_change2_timeout.lua',
    'tools/cv1000/fixtures/futari15_boss5_defeat.lua',
    'tools/cv1000/fixtures/futari15_boss5_defeat_timeout.lua',
}
local callbacks,calls=0,0
for _,path in ipairs(fixtures)do
    local reference=dofile(path)
    local host={run={serial=0}}
    local test=dofile('tools/cv1000/verify_futari15_boss5_control.lua')(control,host,reference)
    while true do
        test.prepare();control.step(test.manager)
        if test.check()then break end
    end
    assert(test.manager.deleted)
    for _,o in ipairs(test.slots)do assert(o.deleted)end
    for i=0,399 do assert(not host.nativeParameters.used[i],'第五面主任务泄漏参数块')end
    callbacks,calls=callbacks+test.callbacks,calls+test.calls
end
-- 移动槽已经占用首块时，五个主任务必须共用余下的首个空块；关闭不得释放移动槽。
local pool=control.parameters
local arena=pool.create()
local reserved=assert(pool.allocate(arena,52))
local warm=assert(pool.allocate(arena,0));pool.write(warm,24,4,12345);pool.release(warm)
local host={run={serial=0},raw={[28]=0},nativeParameters=arena}
local manager=control.create(host)
for i=2,5 do assert(control.add(manager,'second_init').index==i)end
assert(control.add(manager,'third_init')==0,'第五面主任务超过五槽容量')
host.run.serial=1;control.step(manager)
for i=1,5 do assert(manager.slots[i].block.index==i and manager.slots[i].block.count==1)end
assert(manager.slots[1].vars[24]==12345,'第五面主任务擅自清空未初始化参数')
control.close(manager)
assert(arena.used[0]and not reserved.closed)
for i=1,399 do assert(not arena.used[i],'第五面满槽关闭泄漏参数块')end
pool.release(reserved)
LAYER={ENEMY=-600}
local body=dofile('mod/GAME/th46/boss5_body.lua')
local objects=dofile('tools/cv1000/verify_futari15_boss5_transition.lua')(body,{})
for _,o in ipairs(objects)do assert(o.deleted and o.clock.deleted)end
print(('第五面关底 %d 次入场/攻击/换段/击破、%d 次接口、真实伤害与超时联动及参数回收通过'):format(callbacks,calls))
