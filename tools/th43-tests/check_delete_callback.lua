-- 实际预警线：Sub的BoundCheck删除原因不能变成原作淡出帧数。
arg={'th43-delete-callback'}
local f=assert(io.open('tools/check_stage.lua','rb'));local source=f:read('*a');f:close()
local popen=io.popen;io.popen=function() return nil end
assert(loadstring(source:sub(1,assert(source:find('if path == "--all" then',1,true))-1)))()
io.popen=popen
local originalClass=Class
Class=function(...) local c=originalClass(...);c.is_class=true;return c end
dofile('THlib/lib/Ltask.lua');SetAttr=rawset
bent_laser.RenderFunc,bent_laser.RenderFuncDeath={},{}
CheckRes=function() return nil end
dofile('tools/th43_registry.lua')
local E=TH43.runtime.env
local class=E.EISlib.Bullet.Laser.warning_laser
local function create()
    local o=E.New(class,0,0,100,10,10,10,0,'',lstg.Color(255,255,255,255))
    o.wide=8;return o
end
local first=create();first.class[2](first,'outofbound')
assert(first.turn_off and first.status=='normal' and first.group==GROUP.GHOST and first.d_wide==-.4,
    '引擎删除未沿原作20帧淡出')
local direct=create();class.del(direct,8)
assert(direct.d_wide==-1,'桥接覆盖了脚本显式指定的8帧淡出')
assert(first.class[2]==direct.class[2],'重复出生叠加删除回调包装')
print('PASS 栖霞园预警线：引擎删除原因隔离、默认20帧及主动指定8帧淡出保留。')
