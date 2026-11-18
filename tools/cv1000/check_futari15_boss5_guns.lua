-- 不给实例继承类方法，保持与 Windows Sub 实际对象一致。
function Class(_,c)return c end
function New(c,...)local o={class=c};c.init(o,...);return o end
object={RawDel=function(o)o.deleted=true end};GROUP={GHOST=0}
local guns=dofile('mod/GAME/th46/boss5_guns.lua')
local reference=dofile(os.getenv('FUTARI15_BOSS5_GUNS')or'tools/cv1000/fixtures/futari15_boss5_guns.lua')
local test=dofile('tools/cv1000/verify_futari15_boss5_guns.lua')(guns,reference)
while not test.step()do end
for _,o in ipairs(test.objects)do assert(o.deleted)end
local callbacks,calls=test.result()
local host={run={serial=0},raw={},nativeHandle=65534}
local manager=guns.create(host)
local first=guns.add(manager,'first_a_init',{17})
assert(first==65535 and guns.add(manager,'first_b_init')==1)
for i=3,30 do assert(guns.add(manager,'first_a_init')==i-1)end
assert(guns.add(manager,'first_a_init')==0 and host.nativeHandle==29,'满炮台槽消耗句柄')
assert(guns.alive(manager,65535)and not guns.alive(manager,0))
guns.clear(manager)
local _,slot=guns.add(manager,'first_a_init')
assert(slot.index==1 and slot.config[1]==17,'炮台空配置重用丢失旧参数')
guns.close(manager)
LAYER={ENEMY=-600}
local body=dofile('mod/GAME/th46/boss5_body.lua')
local objects,shots=dofile('tools/cv1000/verify_futari15_boss5_gun_binding.lua')(body,{})
for _,o in ipairs(objects)do assert(o.deleted)end
print(('第五面炮台 %d 次独立回调、%d 次接口及三段主任务联动 %d 次出膛请求、三十槽回收通过')
    :format(callbacks,calls,shots))
