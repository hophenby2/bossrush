dofile('mod/GAME/ports/dreamer/LikeDreamer/core.lua')
object={};Class=function(base) return setmetatable({},{__index=base}) end
GROUP_ENEMY_BULLET,GROUP_GHOST,LAYER_ENEMY_BULLET=2,0,2
local M=dofile('mod/GAME/ports/dreamer/LikeDreamer/projectile.lua')
local registry=M.ProjectileRegistry.new()
local rt={frame=1};player={playerStateTimer=10}
local a,b,c,d={active=true},{active=false,_deactivatedFrame=1},{active=true,status='del'},{active=true}
for _,p in ipairs({a,b,c,d}) do registry:register(p,rt) end
registry:prepare(rt)
assert(#registry.projectiles==3 and registry:ordinal(a,rt)==0 and registry:ordinal(b,rt)==1 and registry:ordinal(d,rt)==2)
assert(registry:activeOrdinal(d,rt)==1)
player.playerStateTimer=30;assert(registry:spawnPlayerStateTimer(rt,30)==10)
local e={active=true};registry:register(e,rt);assert(registry:ordinal(e,rt)==3)
rt.frame=2;registry:prepare(rt)
assert(#registry.projectiles==3 and registry.projectiles[1]==a and registry.projectiles[2]==d and registry.projectiles[3]==e)
assert(registry:ordinal(d,rt)==1 and registry:spawnPlayerStateTimer(rt,30)==30)
d.active=false;d._deactivatedFrame=2
assert(registry:ordinal(e,rt)==2 and registry:activeOrdinal(e,rt)==1)
rt.frame=3;registry:prepare(rt);assert(#registry.projectiles==2 and registry.projectiles[2]==e)
registry:prepare({frame=1});assert(#registry.projectiles==0)
print('Like Dreamer 弹链稳定顺序、终帧保留、下一帧摘链、活动序号和切换恢复通过。')
