-- 执行正式Boss桥接与Eliphia背景回调，覆盖绑定、原始跟随、删除及重试。
arg={'th43-spell-background'}
local f=assert(io.open('tools/check_stage.lua','rb'));local source=f:read('*a');f:close()
local popen=io.popen;io.popen=function() return nil end
assert(loadstring(source:sub(1,assert(source:find('if path == "--all" then',1,true))-1)))()
io.popen=popen
local originalClass=Class
Class=function(...) local c=originalClass(...);c.is_class=true;return c end
dofile('THlib/lib/Ltask.lua')
SetAttr=rawset
bent_laser.RenderFunc,bent_laser.RenderFuncDeath={},{}
CheckRes=function() return nil end
boss.del=function() end -- 宿主Boss系统不参与本次背景生命周期检查。
dofile('tools/th43_registry.lua')
local R=TH43.runtime
local class=assert(_editor_boss.bdb_s3boss_4a41)
local function up(fn,wanted)
    for i=1,100 do local name,value=debug.getupvalue(fn,i)
        if not name then break end
        if name==wanted then return value end
    end
    error(wanted)
end
local res=up(class.init,'res')
res.bossInitial=function() end -- 行走图和附属攻击对象另测，背景仍用真实原作类。
R.playMusic=function() end
ext.sc_pr=false
local function create(x,y)
    local owner=New(object);owner.class=class;owner.x,owner.y=x,y
    owner._bosssys={aura={_live=false}}
    class.init(owner,{})
    local bg=assert(owner.th43_spell_background)
    assert(bg.boss==owner,'Boss桥接未把所属实例传给Eliphia背景')
    assert(bg==owner.bg and #bg.layers==6)
    return owner,bg
end
local first,old=create(24,-36)
local x,y=0,144
for frame=1,60 do
    first.x,first.y=24+frame,-36+frame/2
    x,y=x+.1*(first.x-x),y+.1*(first.y-y)
    old.class.frame(old)
    assert(math.abs(old.center_x-x)<1e-10 and math.abs(old.center_y-y)<1e-10,
        '改变了原作每帧0.1的背景跟随')
end
class.del(first);assert(not IsValid(old),'Boss退出后符卡背景没有删除')
local second,bg=create(-48,96)
assert(bg~=old and bg.boss~=first,'重试复用了旧背景或旧Boss绑定')
bg.class.frame(bg)
assert(math.abs(bg.center_x+4.8)<1e-10 and math.abs(bg.center_y-139.2)<1e-10)
class.del(second);assert(not IsValid(bg))
R.clear()
print('PASS 栖霞园Eliphia背景：Boss实例传入、60帧原始跟随、退出删除与重试重新绑定')
