-- 消弹同帧仍存活的退役目标，以及栖霞园没有base的数组类，沿实际索敌/追踪入口检查。
local function read(path)local f=assert(io.open(path,'rb'));local s=f:read('*a');f:close();return s end
local enemy=read('THlib/enemy/enemy.lua')
assert(loadstring(enemy:sub(assert(enemy:find('function GetDamageHandler',1,true)),assert(enemy:find('\nenemy = Class',1,true))-1)))()
local source=read('THlib/player/player.lua')
player_lib={};local player_class={};local trail={}
IsValid=function(o)return o and not o.invalid end
abs,sign=math.abs,function(x)return x<0 and -1 or 1 end
sin=function(a)return math.sin(math.rad(a))end;cos=function(a)return math.cos(math.rad(a))end
Dist=function(a,b)return math.sqrt((a.x-b.x)^2+(a.y-b.y)^2)end
Angle=function(a,b)return math.deg(math.atan2(b.y-a.y,b.x-a.x))end
object={}
assert(loadstring('local player_class=...\n'..source:sub(assert(source:find('function player_lib.CanTarget',1,true)),assert(source:find('\nlocal SetImageState',1,true))-1)))(player_class)
assert(loadstring('local player_bullet_trail=...\n'..source:sub(assert(source:find('function player_bullet_trail:frame()',1,true)),assert(source:find('\nplayer_death_ef =',1,true))-1)))(trail)
local hit=0
local live={status='normal',colli=true,x=10,y=100,class={base={take_damage=function(_,d)hit=hit+d end}}}
local retired={status='del',colli=true,x=0,y=100,class={}}
local blank={status='normal',colli=true,x=0,y=100,class={}}
local dead=setmetatable({invalid=true},{__index=function()error('读取了已释放目标')end})
for _,target in ipairs({retired,blank,dead})do
    assert(not player_lib.CanTarget(target),'退役或无伤害入口的对象仍可索敌')
    local shot={target=target,x=0,y=0,rot=90,v=10,trail=900}
    trail.frame(shot)
    assert(math.abs(shot.vx)<1e-8 and shot.vy==10,'失去目标后未保持原飞行方向')
end
object.EnemyNontjtDo=function(fn)for _,o in ipairs({retired,blank,dead,live})do fn(o)end end
local p={x=0,y=0};player_class.findtarget(p);assert(p.target==live,'有效敌机被错误排除')
local shot={target=live,x=0,y=0,rot=0,v=10,trail=9000};trail.frame(shot)
assert(shot.vy>9,'有效目标没有继续追踪')
Damage(live,3);assert(hit==3,'旧式敌机伤害入口改变')
local sourceTarget={class={},_th43_take_damage=function(_,d)hit=hit+d*2 end,colli=true,status='normal'}
assert(player_lib.CanTarget(sourceTarget),'栖霞园数组类被误排除')
Damage(sourceTarget,5);assert(hit==13,'数组类伤害入口未被使用')
assert(GetDamageHandler(blank)==nil,'无base对象被伪造成可受伤目标')
local alternate=function()end;live.class.base.take_damage2=alternate
assert(GetDamageHandler(live,true)==alternate,'拍照专用伤害入口丢失')
print('PASS 追踪弹/索敌的退役目标、无base类、有效目标及两种伤害入口')
