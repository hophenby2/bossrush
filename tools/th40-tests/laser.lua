-- 半透明激光仍有判定；预警帧由源年龄控制，不能套用原生alpha激活门限。
arg[1]='th38-laser-contract'
local f=assert(io.open('tools/check_stage.lua','rb'));local s=f:read('*a');f:close()
assert(loadstring(s:sub(1,assert(s:find('if path == "--all" then',1,true))-1)))()
dofile('THlib/laser/laser.lua')
local calls={}
local removed=setmetatable({},{__mode='k'})
local engineValid=IsValid
IsValid=function(o) return not removed[o] and engineValid(o) end
laser.frame=function(o) calls[#calls+1]={mode=o.mode,age=o.age,alpha=o.alpha,colli=o.colli} end
bent_laser.frame=laser.frame
local N=dofile('mod/GAME/th40/native.lua');N.load()
for _,kind in ipairs({'laser','ray','bend'}) do
    local owner={x=0,y=100,hp=1};local run=N.new(owner,{hp=1})
    local b=N.spawn(run,{mode=kind,type=0,p={},cx=320,cy=128,alpha=80,life=100,width=1,height=.2,length=20,speed=1,direction=90},false)
    if kind=='bend' then assert(b.sample==4,'必须使用项目内已注册的曲线渲染器') end
    calls={}
    for _=1,65 do N.step(run) end
    assert(#calls==65,'激光每帧由原生类更新')
    for _,c in ipairs(calls) do
        assert(c.alpha==1,'透明度不能关闭原作激光碰撞')
        assert(c.colli==(c.age>=(kind=='ray' and 60 or 9)),'激光预警/生效年龄错误')
    end
    assert(b.alpha==80,'碰撞更新不能覆盖原作透明度')
    if kind~='bend' then
        local class,group,l1,l2,l3=b.class,b.group,b.l1,b.l2,b.l3
        laser.CutOnUnit(b,{x=b.x,y=b.y})
        assert(IsValid(b) and b.class==class and b.group==group and b.l1==l1 and b.l2==l2 and b.l3==l3,
            '原作光束因无敌接触被宿主切割、删除或改组')
    end
    N.stop(owner)
end
local owner={x=0,y=100,hp=1};local run=N.new(owner,{hp=1})
local stale=setmetatable({}, {__index=function() error('消弹后读取了已销毁的引擎对象') end})
removed[stale]=true
for _,list in ipairs({run.enemies,run.bullets,run.effects}) do list[#list+1]=stale end
N.step(run)
for _,list in ipairs({run.enemies,run.bullets,run.effects}) do
    for _,o in ipairs(list) do assert(o~=stale,'原生删除对象未从更新列表摘除') end
end
N.stop(owner)
print('直线/射线/曲线激光透明度、生效帧和回收检查通过')
