-- 回归原版b191首轮：两发自机狙，速度3.5，60帧周期，15帧雾化之后才开始积分。
-- 刻意先推进静止的发射器，捕获“发射器速度缓存污染弹体”的实测故障。
arg={'th37-motion'}
local f=assert(io.open('tools/check_stage.lua'));local s=f:read('*a');f:close()
assert(loadstring(s:sub(1,assert(s:find('if path == "--all" then',1,true))-1)))()
local R=dofile('mod/GAME/th37/runtime.lua')
local host={_live=true,x=0,y=100}
local c=R.controller(host,'191',true)
local actualNew=New;local shots={}
New=function(cls,state,...)
    local o=actualNew(cls,state,...)
    if cls==R.classes.projectile then shots[#shots+1]=o end
    return o
end
for t=1,59 do R.tick(c) end
assert(#shots==0,'b191周期之前不应出弹')
R.tick(c)
assert(#shots==2,'b191首轮必须有两发')
for _,o in ipairs(shots) do
    local x,y=o.x,o.y
    for age=1,15 do o.class.frame(o) end
    assert(o.x==x and o.y==y,'雾化15帧内不能提前运动')
    o.class.frame(o)
    local distance=((o.x-x)^2+(o.y-y)^2)^.5
    assert(math.abs(distance-3.5)<1e-6,'首个有效帧位移应为3.5，实际'..distance)
    for _=1,9 do o.class.frame(o) end
    assert(math.abs(((o.x-x)^2+(o.y-y)^2)^.5-35)<1e-6,'十帧位移应为35')
    -- b198第190帧把Barrage.type设为零基23，即公共弹图表第24项。
    local source=dofile('mod/GAME/th37/patterns/198.lua')
    source.emitters[2].Sonevents(o.mhj,190,R);o.class.frame(o)
    assert(o.mhj.type==24,'Barrage零基弹图类型没有正确转换')
    o.mhj.alpha=2;o.class.frame(o);assert(not o.colli,'透明装饰弹不能有伤害判定')
    o.mhj.alpha=100;o.class.frame(o);assert(o.colli,'不透明的威胁弹必须恢复判定')
end
R.clear(c)
for _,o in ipairs(shots) do assert(not IsValid(o),'清场未回收弹体') end
local c2=R.controller(host,'367',true)
local parents=0
New=function(cls,state,...)
    local o=actualNew(cls,state,...)
    if state and state.pattern and state.pattern.id=='367' and state.parentid==0 and state.layerid>0 then parents=parents+1 end
    return o
end
for _=1,601 do R.tick(c2) end
assert(parents==2,'b367跨三个循环只应创建两个持久宿主，实际'..parents)
R.clear(c2)
print('b367一次事件跨三个Totalframe循环保留次数限制，持久宿主始终2个。')
print('b191位移、雾化、首轮弹数与清场回归通过：2发，首帧3.5px，十帧35px。')
