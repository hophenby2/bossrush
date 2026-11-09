-- 执行实际消弹圈与激光切割，覆盖下一相首波、旧光残段和Bomb持续消弹。
local count=0
local function check(value,label) assert(value,label);count=count+1 end
local function noop() end
local pools={bullets={},lasers={},indes={}}
object={RawDel=function(o) o.status='del' end,Del=function(o) o.status='del' end,SetV=noop}
for method,pool in pairs({BulletDo='bullets',LaserDo='lasers',IndesDo='indes'}) do
    local key=pool
    object[method]=function(fn) for _,o in ipairs(pools[key]) do if o.status~='del' then fn(o) end end end
end
Class=function() return {} end
GROUP={PLAYER=1};item={obj={faith_minor={}}}
IsValid=function(o) return o and o.status~='del' end
Dist=function(a,b) return math.sqrt((a.x-b.x)^2+(a.y-b.y)^2) end
cos=function(a) return math.cos(math.rad(a)) end
sin=function(a) return math.sin(math.rad(a)) end
abs,sqrt=math.abs,math.sqrt
sign=function(x) return x<0 and -1 or 1 end
GetV=function() return 0 end
BulletBreak_Table={New=noop}
OriginalBulletVisual={
    cancel_bullet=function(o) o.status='del' end,
    cancel_laser=function(o) o.status='del' end,
    laser_drops=noop,
}
laser={ChangeImage=noop}
New=function(class,index,x,y,rot,l1,l2,l3,w,node,head)
    assert(class==laser)
    local o={index=index,x=x,y=y,rot=rot,l1=l1,l2=l2,l3=l3,w0=w,w=0,alpha=0,head=head,imgid=1}
    pools.lasers[#pools.lasers+1]=o;return o
end
local f=assert(io.open('THlib/laser/laser.lua','rb'));local source=f:read('*a');f:close()
local first=assert(source:find('function laser:CutOnRadius(',1,true))
local last=assert(source:find('local function InScope(',first,true))
assert(loadstring(source:sub(first,last-1)))()
dofile('THlib/bullet/clearbullet.lua')
local function cleaner(existing)
    local o={timer=0}
    bullet_cleaner.init(o,0,0,100,1,40,true,true,0,0,true,existing)
    return o
end
local function point() return {x=20,y=0} end
local oldBullet,oldIndes,oldLaser=point(),point(),point()
oldLaser._native_laser_game=10;oldLaser.rot=0;oldLaser.l1=0;oldLaser.l2=100;oldLaser.l3=0;oldLaser.protect=0
pools.bullets={oldBullet};pools.indes={oldIndes};pools.lasers={oldLaser}
local phase=cleaner(true)
local nextBullet,nextIndes,nextLaser=point(),point(),point()
nextLaser._native_laser_game=10;nextLaser.rot=0;nextLaser.l1=0;nextLaser.l2=100;nextLaser.l3=0;nextLaser.protect=0
pools.bullets[2]=nextBullet;pools.indes[2]=nextIndes;pools.lasers[2]=nextLaser
bullet_cleaner.frame(phase)
check(oldBullet.status=='del' and oldIndes.status=='del' and oldLaser.status=='del','旧子弹、不可消弹与原作激光全部清除')
check(not nextBullet.status and not nextIndes.status and not nextLaser.status,'下一相首波保留')
local bomb=cleaner(false)
local later=point();pools.bullets[3]=later
bullet_cleaner.frame(bomb)
check(nextBullet.status=='del' and nextIndes.status=='del' and nextLaser.status=='del' and later.status=='del','Bomb持续清除效果期间的新弹幕')
-- 调用正式切割函数确认残段继承目标身份，随后由同一消弹圈继续清除。
pools={bullets={},lasers={},indes={}}
local beam={x=-100,y=0,rot=0,l1=0,l2=300,l3=0,index=1,imgid=1,w=8,head=0}
local targets={[beam]=true}
laser.CutOnRadius(beam,70,130,targets)
local fragment=assert(pools.lasers[1])
check(targets[fragment] and fragment.secondhand and fragment._master_laser==beam,'旧激光切出的残段继续属于本次消弹')
fragment.x,fragment.y=0,0;fragment._native_laser_game=10;fragment.protect=0
phase=cleaner(true);phase.targets=targets
bullet_cleaner.frame(phase)
check(fragment.status=='del','残段继续被消弹圈清除')
print(('换卡消弹回归通过：%d 项。'):format(count))
