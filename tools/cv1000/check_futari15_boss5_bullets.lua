-- 严格对象桩不继承类方法；回归不把记录的弹位置喂回对象。
function Class(_,c)return c end
function New(c,...)local o={class=c};c.init(o,...);return o end
object={RawDel=function(o)o.deleted=true end};GROUP={ENEMY_BULLET=2};LAYER={ENEMY_BULLET=2}
local bullets=dofile('mod/GAME/th46/boss5_bullets.lua')
local reference=dofile(os.getenv('FUTARI15_BOSS5_BULLETS')or'tools/cv1000/fixtures/futari15_boss5_bullets.lua')
local test=dofile('tools/cv1000/verify_futari15_boss5_bullets.lua')(bullets,reference)
while not test.step()do end
for _,o in ipairs(test.objects)do assert(o.deleted)end
local count,states,sprites,cancels=test.result()
print(('第五面 %d 发原生敌弹、%d 次状态、%d 份精灵和 %d 次真实消弹回调通过')
    :format(count,states,sprites,cancels))
