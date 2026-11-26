-- 实际二面关底一非：静止的自机狙父弹、绑定预警、绘制及判定必须使用同一方向。
arg={'th38-warning-angle'}
local f=assert(io.open('tools/check_stage.lua'));local src=f:read('*a');f:close()
assert(loadstring(src:sub(1,assert(src:find('if path == "--all" then',1,true))-1)))()
player.x,player.y,player.A,player.B=100,-176,2.5,2.5
local R=dofile('mod/GAME/th38/runtime.lua')
local F=dofile('mod/GAME/th38/fixed_laser.lua')
local c=R.controller({_live=true,x=0,y=100,hp=13500},'L/stage2/boss2/1')
local warning
for tick=1,120 do
    R.step(c)
    for _,s in ipairs(c.entities) do
        if s.kind=='beam' and s.beamMode==1 and s.parent and s.parent.kind=='bullet' and s.parent.age>3 then
            warning=s;break
        end
    end
    if warning then break end
end
local s=assert(warning,'二面关底一非未创建绑定预警')
local parent=s.parent
assert(parent.speed==0 and parent.followSpeed and s.direction==0,'没有覆盖静止自机狙父弹')
local render,states=Render,SetImageState
local draws={}
Render=function(...) draws[#draws+1]={...} end
SetImageState=function() end
NativePlayers={visual={data={unity={beams={[s.laserStyle]={[s.color+1]='warning'}}}},sprite=function()return 'warning',1 end}}
local angles={}
for _,x in ipairs({100,-100,0,140}) do
    player.x=x;R.step(c)
    local px,py=parent.x*48-216,parent.y*48+230.4
    local expected=math.deg(math.atan2(player.y-py,player.x-px))
    assert(math.abs(parent.rotation-expected)<1e-5,'静止父弹朝向丢失')
    assert(math.abs(F.direction(s)-expected)<1e-5,'绑定预警没有使用父对象世界朝向')
    local dx,dy=s.x-parent.x,s.y-parent.y
    assert(math.abs(dx*sin(expected)-dy*cos(expected))<1e-5,'预警伸展方向与父弹朝向不一致')
    assert(math.abs(s.native.rot-expected-180)<1e-5,'激光引擎方向不一致')
    s.native.class.render(s.native)
    assert(math.abs(draws[#draws][4]-expected+90)<1e-5,'激光图像角度不一致')
    local co,si=cos(expected),sin(expected)
    local ax,ay=(s.x-4.5-.16*co)*48,(s.y+4.8-.16*si)*48
    local distance=F.distance(s,ax-(s.lineLength*4-.32)*24*co,ay-(s.lineLength*4-.32)*24*si)
    assert(distance<1e-5,'判定轴与预警方向不一致')
    angles[#angles+1]=('%.3f'):format(expected)
end
assert(F.direction({direction=37})==37,'未绑定的固定激光方向被修改')
Render,SetImageState=render,states
R.clear(c)
for o in pairs(R.objects)do assert(not IsValid(o),'卡结束后残留对象')end
print('PASS 二面关底一非：静止自机狙、四个站位预警方向、伸展/绘制/判定轴及清场；角度 '..table.concat(angles,','))
