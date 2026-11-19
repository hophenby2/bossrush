-- 对照原 b652：灯笼仍在时抹掉Boss弹；追踪球碰到灯笼后才放行。
arg={'th37-fields'}
local f=assert(io.open('tools/check_stage.lua'));local src=f:read('*a');f:close()
assert(loadstring(src:sub(1,assert(src:find('if path == "--all" then',1,true))-1)))()
local R=dofile('mod/GAME/th37/runtime.lua')
local actualNew=New;local objects={}
New=function(cls,s,...) local o=actualNew(cls,s,...);objects[#objects+1]=o;return o end
local function find(c,kind,layer,id)
    for _,e in ipairs(c.emitters) do if e.kind==kind and e.parentid==layer and e.id==id then return e end end
    error('原始发射器不存在')
end
local function scenario(chase,lantern)
    local c=R.controller(nil,'652');c.time=559
    local source,pursuer,gun=find(c,'batch',2,5),find(c,'batch',2,8),find(c,'batch',2,11)
    c.emitters={find(c,'cover',2,0),find(c,'cover',2,1)}
    local lamp
    if lantern then R.fire(source);lamp=objects[#objects];lamp.mhj.fx,lamp.mhj.fy,lamp.mhj.age=200,200,40 end
    if chase then R.fire(pursuer);local p=objects[#objects];p.mhj.fx,p.mhj.fy,p.mhj.age=200,200,20 end
    local function step(n)
        for _=1,n do
            R.tick(c)
            for _,o in ipairs(objects) do if IsValid(o) and o.mhj.controller==c then o.class.frame(o) end end
        end
    end
    step(chase and 25 or 3)
    if chase then assert(lamp.mhj.life==0,'追踪球碰到灯笼后没有结束灯笼生命') end
    local before=#objects;R.fire(gun);step(10)
    local threats=0
    for i=before+1,#objects do local o=objects[i];if IsValid(o) and o.mhj.life>0 and o.colli then threats=threats+1 end end
    if lantern and not chase then assert(threats==0,'未追到灯笼却从Boss发出有效弹')
    else assert(threats==21,'灯笼消失后Boss原作21条扇弹没有放行：'..threats) end
    R.clear(c);return threats
end
assert(scenario(false,true)==0)
assert(scenario(true,true)==21)
assert(scenario(false,false)==21)
-- 新进入覆盖区域的老弹，当前帧340必须立即触发，不能从驻留第1帧重算。
local c=R.controller(nil,'652');local source=find(c,'batch',1,0);local cover=find(c,'cover',1,0)
c.emitters={cover};R.fire(source);local o=objects[#objects];local s=o.mhj
s.age=339;s.Mist=false;s.sonspeed=80;s.sonmotion_dirty=true;s.Sonevents=nil;s.fx,s.fy=188,336
R.tick(c);o.class.frame(o)
assert(math.abs(s.sonspeed-(80*59+.01)/60)<1e-6,'覆盖事件把弹龄误当成驻留时长')
s.fx,s.fy=2000,2000;R.tick(c)
assert(not next(s.covers),'离开覆盖区域后仍保留区域事件')
R.clear(c)
-- 原 b843 力场的 controlid=18 指向零基17，保留现有速度并乘横纵倍率。
local c=R.controller(nil,'843');local source=find(c,'batch',1,17);local force=find(c,'force',1,0)
R.fire(source);local s=objects[#objects].mhj
s.age=20;s.Mist=false;s.sonspeed=3;s.sonspeedd=0;s.xscale=2;s.yscale=3;s.mx=nil;s.sonmotion_dirty=true
s.fx,s.fy=force.x-4+10,force.y+16
c.emitters={force};c.time=force.begin-1;R.tick(c)
assert(math.abs(s.mx-(6-.007*2))<1e-8 and math.abs(s.my)<1e-8,'b843吸引力场目标编号、坐标或倍率错误')
R.clear(c)
print('b652：未追到灯笼0发有效弹、追到后21发；无宿主不生效、弹龄340与离开卸载通过。')
print('b843：零基17号目标吸引力0.007、横向倍率2与原有速度保留通过。')
