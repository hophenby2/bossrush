-- 在真实引擎检查矩形、椭圆边界与切换贴图后的判定保持。
local T={}
local count=0
local C=NativeActorCollision
local Enemy=Class(object,{
    init=function(o) o.group=GROUP.ENEMY;o.x,o.y=0,0;o.bound=false;o.colli=true;o.hits=0 end,
    colli=function(o,shot) if shot.actor_probe then o.hits=o.hits+1 end end,
},true)
local Shot=Class(object,{
    init=function(o,x,y) o.group=GROUP.PLAYER_BULLET;o.x,o.y=x,y;o.a,o.b=.01,.01;o.bound=false;o.colli=true;o.actor_probe=true end,
},true)
local Player=Class(object,{
    init=function(o,x,y) o.group=GROUP.PLAYER;o.x,o.y=x,y;o.A=1;o.a,o.b=1,1;o.bound=false;o.colli=true;o.hits=0 end,
    colli=function(o,enemy) if enemy.actor_probe and C.contact(o,enemy) then o.hits=o.hits+1 end end,
},true)
local function checkShot(x,y,expected,disabled)
    local e=New(Enemy);e.actor_probe=true
    C.bind(e,35,50,'box',40/7,40/7,'box',true)
    e.native_actor_collision.noDamage=disabled
    e.img='img_void' -- LuaSTG-x 会在这里重写 a/b。
    local shot=New(Shot,x,y)
    C.begin();C.shots();CollisionCheck(GROUP.ENEMY,GROUP.PLAYER_BULLET);C.finish()
    assert(e.hits==expected,'原生受弹矩形边界不符：'..x..','..y)
    e.colli=false;shot.colli=false;object.RawDel(e);object.RawDel(shot);count=count+1
end
local function checkContact(x,y,shape,expected)
    local e=New(Enemy);e.actor_probe=true
    C.bind(e,35,50,'box',5,8,shape,true)
    local p=New(Player,x,y)
    C.begin();CollisionCheck(GROUP.PLAYER,GROUP.ENEMY);C.finish()
    assert(p.hits==expected,'原生体术边界不符：'..shape..' '..x..','..y)
    e.colli=false;p.colli=false;object.RawDel(e);object.RawDel(p);count=count+1
end
local function checkSecondaryBoss(disabled,expected)
    local owner=New(Enemy)
    local actorId=next(TH39.data.bossTypes)
    local e=New(TH39.runtime.classes.actor,owner,actorId,0,0);e.actor_probe=true
    assert(e.group==GROUP.ENEMY,'永夜篇副 Boss 被错误地放入无体术组')
    SetAttr(e,'colli',true) -- 原作副 Boss 的 frame 在出生后的碰撞阶段开放判定。
    e.native_actor_collision.noContact=disabled
    local p=New(Player,0,0)
    C.begin();CollisionCheck(GROUP.PLAYER,GROUP.ENEMY);C.finish()
    assert(p.hits==expected,('永夜篇副 Boss 体术/耐久开关不符：%s/%d/%d'):format(tostring(disabled),p.hits,expected))
    owner.colli=false;e.colli=false;p.colli=false
    SetAttr(e,'colli',false)
    object.RawDel(owner);object.RawDel(e);object.RawDel(p);count=count+1
end
function T.before(p)
    p.protect=100000
    if stage.current_stage.timer==10 then
        checkShot(34.99,49.99,1);checkShot(35.005,50.005,1)
        checkShot(35.02,0,0);checkShot(0,50.02,0)
        checkShot(0,0,0,true)
        checkContact(4.99,7.99,'box',1);checkContact(5.1,0,'box',0)
        checkContact(4.5,7.2,'ellipse',0);checkContact(0,7.99,'ellipse',1)
        checkSecondaryBoss(false,1);checkSecondaryBoss(true,0)
    end
end
function T.after() end
function T.checkpoint() assert(count==11);lstg.SystemLog('SOURCE_ACTOR: 11 原生判定边界、副 Boss 体术与耐久受弹通过') end
return T
