-- 驱动正式的碰撞/帧/Bomb入口，核对8帧边界及安卓第一击→中弹→第二击。
local function noop() end
max,min=math.max,math.min
player_lib={};plus={Class=function() return {} end}
IsValid=function(o) return type(o)=='table' and o.live~=false end
GROUP={ENEMY_BULLET=1,ENEMY_BULLET2=2,INDES=3}
SetAttr=function(o,k,v) o[k]=v end
object={Del=function(o) o.live=false end}
local effects,network,bombs=0,0,0
New=function() effects=effects+1;return {} end
PlaySound=noop
GameNet={miss=function() network=network+1 end}
lstg={var={},world={}}
stage={current_stage={stage_name='test',is_menu=false}}
GameDrops=dofile('THlib/drops.lua')
lstg.system={castCharge4=function(p) bombs=bombs+1;p.protect=300 end}
item={PlayerMiss=function() lstg.var.dead=lstg.var.dead+1 end}
dofile('THlib/player/player_system.lua')
local prototype=player_lib.system
local function setup(available,held)
    effects,network,bombs=0,0,0
    lstg.var={__drops_version=GameDrops.VERSION,dead=0};GameDrops.reset()
    lstg.var.upgrades.players[1].bombs=available
    local p={x=0,y=0,death=0,protect=0,A=2,B=2,grazer={},lh=0,slow=0,nextshoot=0,nextspell=0,nextsp=0,
        __shoot_count=0,supportx=0,supporty=0}
    local s=setmetatable({player=p,keyState={spell=held or false}}, {__index=prototype})
    s.updateKeyState=function(self) self.keyStatePre=self.keyState;self.keyState={spell=self.spell or false} end
    s.findTarget=noop
    s.doFrameEvent=function()
        player_lib.defaultFrameEvent['frame.updateDeathState'][2](p)
        player_lib.defaultFrameEvent['frame.updateVar'][2](p)
    end
    p._wisys={frame=noop}
    return p,s
end
local function hit(p,s) s:colli({live=true,colli=true,group=GROUP.ENEMY_BULLET}) end
for frame=1,8 do
    local p,s=setup(3)
    hit(p,s)
    assert(p.death==98 and lstg.var.dead==0 and network==0 and effects==0,'命中当帧不能提交miss')
    for i=1,frame do s.spell=i==frame;s:frame() end
    assert(p.death==0 and not p.__deathbomb_pending and lstg.var.dead==0 and bombs==1,'第'..frame..'帧决死失败')
    for _=1,12 do s.spell=false;s:frame() end
    assert(lstg.var.dead==0 and effects==0 and network==0,'决死后仍登记死亡')
end
for _,available in ipairs({0,3}) do
    local p,s=setup(available)
    hit(p,s)
    for i=1,8 do s.spell=available==0 and i==4;s:frame() end
    assert(p.death==90 and lstg.var.dead==0,'第8帧应仍可决死')
    s.spell=true;s:frame()
    assert(lstg.var.dead==1 and bombs==0 and effects==1 and network==1,'第9帧不能挽回miss')
    for _=1,4 do s:frame() end
    assert(lstg.var.dead==1 and network==1,'miss重复提交')
end
local p,s=setup(3,true);hit(p,s);s.spell=true
for _=1,9 do s:frame() end
assert(lstg.var.dead==1 and bombs==0,'命中前一直按住X不能自动决死')
local now=1
lstg.AndroidClock=function() return now end
lstg.GetKeyState=function() return false end;lstg.GetLastKey=function() return 0 end
package.preload.keycode=function() return setmetatable({}, {__index=function(_,k) return k end}) end
setting={keys={spell=88},touchBombInterval=170}
GameNet=nil;ext={StageIsMenu=function() return false end}
local I=dofile('android/lua/input.lua')
local function firstTap()
    I.reset();now=now+1
    I.touch(1,480,270,'began');now=now+.02;I.touch(1,480,270,'ended')
    assert(I.lastTap,'第一击未保留')
end
p,s=setup(3);player=p
firstTap();hit(p,s);now=now+.06
I.touch(2,480,270,'began')
assert(I.pulses[88],'miss截断了双击')
s.spell=lstg.GetKeyState(88);s:frame()
assert(lstg.var.dead==0 and bombs==1 and p.death==0,'双击没有完成决死')
I.touch(2,480,270,'ended')
-- 原生旧作已有决死状态使用death=90，同样不能阻断第二击。
firstTap();p.death=90;p.original_deathbomb=6;now=now+.06
I.touch(2,480,270,'began');assert(I.pulses[88],'原作自机决死截断双击')
I.touch(2,480,270,'ended');p.original_deathbomb=nil
firstTap();p.death=90;now=now+.06
I.touch(2,480,270,'began');assert(not I.pulses[88],'已确认死亡仍响应双击')
print('PASS：第1–8帧决死、第9帧/无雷/按住X边界、miss仅登记一次、安卓跨命中双击及原作决死。')
