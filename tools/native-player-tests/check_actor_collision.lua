local C=dofile('THlib/native_actor_collision.lua')
function IsValid(o) return o and o.live end
function SetAttr(o,key,value) o[key]=value end
GROUP={PLAYER_BULLET=4}
local shot={rot=90,rect=false,colli=true,live=true}
function ObjList() return ipairs({shot}) end
local actor={a=16,b=16,rect=false,rot=90,colli=true,live=true}
C.bind(actor,35,50,'box',40/7,40/7,'box',true)
-- LuaSTG-x 的贴图赋值会覆写判定；各碰撞阶段恢复原尺寸。
actor.a,actor.b=0,0
C.begin();assert(actor.a==40/7 and actor.b==40/7 and actor.rect and actor.rot==0)
local p={x=40/7+.1,y=0,A=1};actor.x,actor.y=0,0
assert(not C.contact(p,actor),'原作点对矩形体术不应扩张自机半径')
p.x=40/7-.1;assert(C.contact(p,actor))
C.shots();assert(actor.a==35 and actor.b==50 and actor.rect);assert(shot.rot==0 and shot.rect)
assert(shot._original_collision_rot==90,'碰撞时未保留生成命中特效所需的弹道角')
C.finish();assert(actor.a==35 and actor.b==50 and actor.rot==90)
assert(shot.rot==90 and not shot.rect and shot._original_collision_rot==nil)
shot._original_collision_rot=123
C.begin();C.shots();assert(shot._original_collision_rot==123,'覆盖了旧作碰撞先行保存的角度')
C.finish();assert(shot._original_collision_rot==123,'没有还原旧作碰撞的角度记录')
shot._original_collision_rot=nil
actor.native_actor_collision.noDamage=true
C.begin();C.shots();assert(not actor.colli,'耐久 Boss 不应吸收自机弹');C.finish();assert(actor.colli)
actor.native_actor_collision.noDamage=false
C.bind(actor,80/3,120/3,'box',80/7*2/3,120/7*2/3,'ellipse',true)
p.x,p.y=80/7*2/3*.9,120/7*2/3*.9;assert(not C.contact(p,actor),'椭圆变成了矩形')
p.x,p.y=0,120/7*2/3*.9;assert(C.contact(p,actor))
C.bind(actor,40*.48,40*.48,'ellipse',20*.48,20*.48,'ellipse')
p.x,p.y,p.A=10,0,1;assert(C.contact(p,actor));p.x=11;assert(not C.contact(p,actor))
actor.native_actor_collision.noContact=true;p.x=0;assert(not C.contact(p,actor))
actor.a,actor.b,actor.rect=32,32,false;C.preserve(actor);actor.a,actor.b=0,0
C.begin();assert(actor.a==32 and actor.b==32);C.finish()
actor.a,actor.b=24,24;C.begin();assert(actor.a==24 and actor.b==24);C.finish()
AndroidPlatform={}
C.bind(actor,5,8,'ellipse');assert(actor.rect=='ellipse','LuaSTG-x 不能用 false 表示非等比椭圆')
actor.rect=2;C.preserve(actor);C.begin();assert(actor.rect=='ellipse');C.finish()
local hit=dofile('mod/GAME/th40/collision.lua')
local summer={age=8,x=0,y=0,region=4,width=1,height=1,follow=false,angle=0}
local target={x=0,y=0,A=1}
assert(not hit(summer,target));summer.age=9;target.x=4.99;assert(hit(summer,target))
target.x=5;assert(not hit(summer,target))
summer.width=2;target.x=2.99;assert(hit(summer,target));target.x=3.01;assert(not hit(summer,target))
target.x,target.y=0,6.99;assert(hit(summer,target));target.y=7.01;assert(not hit(summer,target))
summer.angle=90;target.x,target.y=6.99,0;assert(hit(summer,target));target.x=7.01;assert(not hit(summer,target))
print('体术/受弹分离、点/矩形、椭圆、贴图覆写和原生尺寸保持检查通过')
