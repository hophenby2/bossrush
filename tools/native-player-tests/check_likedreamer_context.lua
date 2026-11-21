-- 缓存必须保留实时字段、排序、同帧增删和练习恢复的可见性。
dofile('tools/likedreamer_parity/boss_fixture.lua')
local R=LikeDreamer.Recovered
local rt={stage=10,frame=1,nextEntityId=10,enemyCount=2,enemyRevision=1,enemiesById={}}
local a={entityId=8,ldX=12,spawnType=1,hp=20,active=true}
local b={entityId=3,ldX=34,spawnType=1,hp=40,active=true}
rt.enemiesById[8],rt.enemiesById[3]=a,b
local ctx=R.context(rt)
local list=ctx.enemies_
assert(#list==2 and list[1]._native==b and list[2]._native==a)
-- 未增删时禁止重新扫描；代理仍立即反映移动、受伤和锁定状态。
local originalClear=R.clear;local clears=0
R.clear=function(t) if t==list then clears=clears+1 end;return originalClear(t) end
a.ldX,a.hp,a.targetable=99,10,false
for i=1,100 do assert(R.context(rt).enemies_==list) end
assert(clears==0 and list[2].x==99 and list[2].hp==10 and list[2].targetable==false)
local c={entityId=5,ldX=56,spawnType=1,hp=60,active=true}
rt.enemiesById[5]=c;rt.enemyCount=3;rt.nextEntityId=11;rt.enemyRevision=2
R.context(rt);assert(#list==3 and list[2]._native==c)
rt.enemiesById[3]=nil;rt.enemyCount=2;rt.enemyRevision=3
R.context(rt);assert(#list==2 and list[1]._native==c)
-- 同一帧一删一增，数量与 nextId 恰巧恢复相同，仍必须失效。
rt.enemiesById[5]=nil;rt.enemiesById[3]=b;rt.enemyRevision=4
R.context(rt);assert(list[1]._native==b)
rt.enemiesById={[5]=c};rt.enemyCount=1;rt.nextEntityId=6;rt.enemyRevision=5
R.context(rt);assert(#list==1 and list[1]._native==c)
ctx.pendingEnemies_[1]='旧调用临时项';R.context(rt);assert(#ctx.pendingEnemies_==0)
assert(clears==4)
print('Like Dreamer 敌机视图实时字段、同帧增删、排序、恢复与容器身份通过。')
