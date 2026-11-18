-- 实际展开原版队列，比较每次分配的参数及 64 发许可造成的失败。
function Class(_,c)return c end
function New(c,...)local o={class=c};c.init(o,...);return o end
object={RawDel=function(o)o.deleted=true end};GROUP={GHOST=0,ENEMY_BULLET=2};LAYER={ENEMY_BULLET=2}
function CheckRes()return true end
local factory=dofile('mod/GAME/th46/boss5_bullet_factory.lua')
local reference=dofile(os.getenv('FUTARI15_BOSS5_BULLET_FACTORY')or'tools/cv1000/fixtures/futari15_boss5_bullet_factory.lua')
local test=dofile('tools/cv1000/verify_futari15_boss5_bullet_factory.lua')(factory,reference)
while not test.step()do end
for _,o in ipairs(test.objects)do assert(o.deleted)end
local run={serial=0,roadFrame=0,roadRank=128,roadFlash=0}
assert(factory.initializeScene(run,96)==54)
local accepted,failed=0,0
local manager=factory.create(run,{allocated=function(_,_,o)
    if o then accepted=accepted+1 else failed=failed+1 end
end})
for _=1,500 do assert(factory.enqueue(manager,'bullet',{19,300*65536,160*65536,0,256,0}))end
assert(not factory.enqueue(manager,'bullet',{19,0,0,0,0,0}),'出膛请求超过 500 份')
run.serial=1;factory.step(manager)
assert(accepted==64 and failed==436,'Original 没有按 64 发许可拒绝后续分配')
assert(run.boss5BulletCount==0 and #manager.rows==64,'出界回收提前释放许可或抹掉本步绘制')
factory.step(manager);assert(accepted==64 and failed==436,'同逻辑步重复更新敌弹队列')
manager.options.inhibited=true
assert(not factory.enqueue(manager,'bullet',{19,0,0,0,0,0}))
assert(#manager.jobs==0,'禁发状态仍占用请求队列')
factory.close(manager);factory.close(manager)
LAYER.ENEMY=-600
local body=dofile('mod/GAME/th46/boss5_body.lua')
local objects,requests,created,rejected=dofile('tools/cv1000/verify_futari15_boss5_gun_binding.lua')(body,{},true)
for _,o in ipairs(objects)do assert(o.deleted)end
local count,calls,rejected=test.result()
print(('第五面 %d 份原版队列、%d 次分配（%d 次原版失败）、500 请求与 64 发许可、出界及回收通过')
    :format(count,calls,rejected))
print(('第五面三段主任务与九组炮台实际生成 %d 发八类敌弹、%d 次出膛请求并完整回收通过'):format(created,requests))
