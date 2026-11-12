-- 独立验证原始首只敌机和第一轮子弹；不只检查“对象创建未报错”。
arg={'th38-motion'}
local f=assert(io.open('tools/check_stage.lua'));local src=f:read('*a');f:close()
assert(loadstring(src:sub(1,assert(src:find('if path == "--all" then',1,true))-1)))()
local R=dofile('mod/GAME/th38/runtime.lua')
local c=R.controller(nil,'L/stage1/a')
local actualNew=New;local enemies,shots={},{}
New=function(cls,s,...)
    local o=actualNew(cls,s,...)
    if cls==R.classes.fairy then enemies[#enemies+1]=o elseif cls==R.classes.projectile then shots[#shots+1]=o end
    return o
end
for _=1,200 do R.tick(c) end
assert(#enemies==0,'原作400tick之前不应生成首只敌机')
R.step(c)
assert(#enemies==1,'原作400tick应该恰好生成首只敌机')
local e=enemies[1];local x,y=e.x,e.y
R.step(c)
assert(math.abs(e.x-x-2.4*cos(280))<1e-6 and math.abs(e.y-y-2.4*sin(280))<1e-6,'敌机5×.01×48=2.4px/tick、280度未正确积分')
for _=1,105 do R.step(c) end
assert(#shots>0,'首只敌机绑定的子发射器没有生成子弹')
local b=shots[#shots];local s=b.asl
local bx,by=b.x,b.y;local dx=s.speed*.01*48*cos(s.direction);local dy=s.speed*.01*48*sin(s.direction)
R.step(c)
assert(math.abs(b.x-bx-dx)<1e-5 and math.abs(b.y-by-dy)<1e-5,'子弹实际坐标没有按速度移动')
local event={1,1,0,0,0,0,0,0,2,1,5,0,1,1,1,0}
s.age=0;R.events(s,{event},0,true);assert(s.speed==5,'子弹变速事件失效')
local event2={1,1,0,0,0,0,0,0,24,1,9,0,1,1,1,0}
R.events(s,{event2},0,true);assert(s.vars[1]==9 and c.vars[1]~=9,'子弹私有变量污染关卡变量')
R.clear(c)
for o in pairs(R.objects) do assert(not IsValid(o),'清场残留原生对象') end
assert(#c.entities==0 and #c.emitters==0,'清场未释放状态表')
print(('首敌400tick、2.4px/tick、绑定出弹%d发、子弹位移/变速/私有变量/清场通过。'):format(#shots))
