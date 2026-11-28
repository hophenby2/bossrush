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
-- 捕获正式绘制入口，检查原Type颜色映射、弹头/弹尾方向与光点位置。
local sprites={}
Render=function(...) sprites[#sprites+1]={...} end
local originalRender=N.classes.line.render
for typeId,color in ipairs({1,3,5,7,9,13,14,15}) do
    for _,mode in ipairs({'laser','ray'}) do
        local o={type=typeId-1,mode=mode,alpha=255,red=255,green=255,blue=255,
            direction=30,angle=mode=='ray' and 90 or -90,rot=-30,x=0,y=0,l2=256,height=.6,cx=320+256*math.cos(math.pi/6),
            cy=240+256*math.sin(math.pi/6),head=true,head_alpha=200,age=10}
        sprites={};originalRender(o)
        local s=sprites[1]
        assert(s[1]==N.images['Laser0_'..color],'未按原作颜色表选择激光贴图')
        assert(math.abs(s[2]-128*math.cos(math.pi/6))<1e-8 and math.abs(s[3]+64)<1e-8,'光束中点错误')
        assert(s[4]==(mode=='ray' and -30 or 150) and s[5]==1 and s[6]==.6,'长轴方向或尺寸错误')
        assert(#sprites==(mode=='laser' and 2 or 1),'直线激光头光点丢失，或射线误画光点')
        if mode=='laser' then
            assert(math.abs(sprites[2][2]-(o.cx-320))<1e-8 and math.abs(sprites[2][3]-(240-o.cy))<1e-8,'光点没有跟随弹头')
        end
    end
end
local textureArgs
local curve={type=2,alpha=255,red=255,green=255,blue=255,height=.7,w=1.4,
    data={SetAllWidth=function() end,Render=function(_,...) textureArgs={...} end}}
N.classes.curve.render(curve)
local region=N.regions.Laser0_5
assert(textureArgs[4]==region[3] and textureArgs[5]==region[4] and textureArgs[6]==region[5]
    and textureArgs[7]==region[6],'曲线激光没有使用原作颜色表对应的UV')
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
local owner={x=0,y=100,hp=10000};local run=N.new(owner,{hp=10000})
-- 蓄放能不属于本检查的绘制范围；使用正式表现模块，音效名按原清单登记。
N.presentation=assert(loadfile('mod/GAME/th40/presentation.lua'))(N)
N.sounds['se_ch02.wav']='se_ch02.wav';N.sounds['se_cat00.wav']='se_cat00.wav';N.sounds['se_enep02.wav']='se_enep02.wav'
N.controller(run.host,'St06/关底Boss/2符L.mbg',false)
local heads=0
for _=1,450 do
    N.step(run)
    for _,o in ipairs(run.bullets) do
        if IsValid(o) and o.mode=='laser' and o.head and o.head_alpha then
            heads=heads+1;assert(o.head_alpha>=150 and o.head_alpha<255,'光点透明度范围不符合原作')
            sprites={};originalRender(o)
            assert(#sprites==2 and sprites[2][2]==o.cx-320 and sprites[2][3]==240-o.cy,'白夜永昼之光漏画真实激光头')
        end
    end
end
assert(heads>0,'白夜永昼之光没有进入实际激光绘制路径')
N.stop(owner)
local owner={x=0,y=100,hp=1};local run=N.new(owner,{hp=1})
local stale=setmetatable({}, {__index=function() error('消弹后读取了已销毁的引擎对象') end})
removed[stale]=true
for _,list in ipairs({run.enemies,run.bullets,run.effects}) do list[#list+1]=stale end
N.step(run)
for _,list in ipairs({run.enemies,run.bullets,run.effects}) do
    for _,o in ipairs(list) do assert(o~=stale,'原生删除对象未从更新列表摘除') end
end
N.stop(owner)
print('激光颜色、朝向、光点、透明度、生效帧和回收检查通过；含白夜永昼之光450帧')
