-- 对照原BExecution/Barrage/Center的边界行为，覆盖千桜华宴曾出现的实际差异。
arg={'th37-673'}
local file=assert(io.open('tools/check_stage.lua'))
local source=file:read('*a');file:close()
assert(loadstring(source:sub(1,assert(source:find('if path == "--all" then',1,true))-1)))()
local R=dofile('mod/GAME/th37/runtime.lua')
local pattern=R.loadPattern('673')
local actualNew=New
local objects={}
New=function(cls,state,...)
    local o=actualNew(cls,state,...)
    objects[#objects+1]=o
    return o
end
local function near(a,b,message)
    assert(math.abs(a-b)<1e-7,(message or '数值不一致')..': '..a..' / '..b)
end
local function spawn(layer,id,overrides)
    local c=R.controller(nil,'673')
    for _,e in ipairs(c.emitters) do
        if e.parentid==layer and e.id==id then
            e.fx,e.fy,e.tiao=315,140,1
            e.rand={}
            for k,v in pairs(overrides or {}) do e[k]=v end
            local before=#objects
            R.fire(e)
            assert(#objects==before+1)
            return objects[#objects],c,e
        end
    end
    error('找不到发射器')
end
local function step(o,n)
    for _=1,n do assert(IsValid(o),'弹体提前回收');o.class.frame(o) end
end
-- 原BExecution的整数增量先截断。负小数也必须覆盖，正数测不出错图。
local random=ran.Float
for _,case in ipairs({{-1.75,257},{-.75,258},{.75,258},{1.75,259}}) do
    ran.Float=function(_,a,b) return a==-2 and b==2 and case[1] or (a+b)/2 end
    local fan,c=spawn(2,4)
    step(fan,32)
    assert(fan.mhj.type==case[2],'大折扇随机切到了错误贴图')
    near(fan.b,1,'大折扇基础判定必须为1')
    R.clear(c)
end
ran.Float=random
-- 原Barrage先按未乘横纵比的方向设置head，再运行朝向事件。
local fan,c=spawn(2,0,{fdirection=45,sonlife=60,wscale=1})
step(fan,1);near(fan.rot,-135,'压缩轨迹改变了扇子朝向')
R.clear(c)
local petal,c=spawn(2,16,{fdirection=0,sonspeed=1,sonaspeed=1,sonaspeedd=90,Outdispel=false})
petal.mhj.Sonevents=function(s,t,r)
    if t==1 then r.change(s,'sonspeed',2,0,0,'正比',1);r.change(s,'head',10,0,1,'正比',1) end
end
step(petal,1)
near(petal.mhj.sonspeedd,45,'加速度后方向没有更新')
near(petal.rot,-145,'朝向事件未参与绘制')
local x,y=petal.mhj.fx,petal.mhj.fy
step(petal,1)
near(petal.mhj.fx-x,math.sqrt(2),'变速没有沿当前方向')
near(petal.mhj.fy-y,math.sqrt(2)+1,'变速后的加速度没有积分')
R.clear(c)
-- 小弹的出生用原mist，大弹在出生时增加缩放；记录真实render参数。
local renders={}
Render=function(...) renders[#renders+1]={...} end
local function render(o)
    renders={};o.class.render(o);return renders
end
local card,c=spawn(2,2,{Mist=true})
step(card,1)
local draws=render(card)
assert(draws[1][1]=='mhj2_mist_5','御札出生未使用原雾化贴图')
near(draws[1][5],24/30+1.5*14/15,'雾化缩放')
R.clear(c)
local glow,c=spawn(2,10,{Mist=true})
step(glow,1);draws=render(glow)
assert(draws[1][1]==glow.img,'大光晕出生必须绘制自身')
near(draws[1][5],.4+14/15,'大光晕出生缩放')
R.clear(c)
local glow,c=spawn(2,10)
step(glow,10);draws=render(glow)
assert(#draws>1,'原作Afterimage没有生成残影')
assert(draws[2][2]~=draws[1][2] or draws[2][3]~=draws[1][3],'残影未保存历史位置')
local shadow=glow.mhj.shadows[1].alpha
step(glow,1);near(glow.mhj.shadows[1].alpha,shadow-.02,'残影衰减')
R.clear(c)
-- 原Dispel在寿命后保留20帧。公共小弹缩小，自定义贴图放大。
local small,c=spawn(3,12,{sonlife=20,sonspeed=0,Outdispel=false,Mist=false})
step(small,21)
assert(IsValid(small) and not small.colli,'消散首帧仍应绘制且无判定')
near(small.mhj.alpha,95);near(small.hscale,.94)
step(small,18);assert(IsValid(small),'消散结束前提前删除')
step(small,1);assert(not IsValid(small),'消散20帧后未删除')
R.clear(c)
local crystal,c=spawn(2,8,{sonlife=20,sonspeed=0,Outdispel=false,Mist=false})
crystal.mhj.Sonevents=nil
step(crystal,21);near(crystal.hscale,.16,'自定义弹消散应放大')
R.clear(c)
-- 同层高光后绘制，后层在前层全部弹体之后。
local a,ca=spawn(2,10)
local b,cb=spawn(3,0)
assert(a.layer<b.layer,'跨层遮挡顺序错误')
local d,cd=spawn(2,16)
assert(d.layer<a.layer,'同层高光必须在普通弹之后')
R.clear(ca);R.clear(cb);R.clear(cd)
-- Center事件在本帧运动之后执行，且不能修改初始坐标基准。
local host={_live=true,x=0,y=70}
local center=R.controller(host,'673');center.emitters={}
for _=1,120 do R.tick(center) end
local hx,hy=host.x,host.y
R.tick(center)
near(host.x-hx,1/36000,'中心速度事件提前生效')
near(host.y,hy)
R.tick(center)
assert(host.x~=hx and host.y~=hy,'中心速度未带动Boss')
near(center.center.fx,315);near(center.center.fy,140)
R.clear(center)
-- 雾化宿主的普通绑定要等待第16帧。
local crystal,c=spawn(2,8,{Outdispel=false})
local child
for _,e in ipairs(c.emitters) do if e.parentid==2 and e.id==9 then child=e end end
c.emitters={child}
local n=#objects
R.tick(c);assert(#objects==n,'雾化期间提前绑定出弹')
crystal.mhj.age=16
R.tick(c);assert(#objects==n+1,'出生期结束后没有绑定出弹')
R.clear(c)
-- 原Judge对高速穿越和细长旋转弹采用相对线段，不添加自机原生判定半径。
local s={pattern=pattern,type=260,wscale=1,hscale=1,head=0,previousX=300,previousY=140,fx=330,fy=140}
assert(R.sweptHit(s,315,140),'高速弹穿越自机未命中')
assert(not R.sweptHit(s,315,146),'线段外误判')
s.previousX,s.previousY,s.fx,s.fy=315,140,315,140
s.wscale,s.hscale=.1,2
assert(R.sweptHit(s,324,140) and not R.sweptHit(s,315,141),'非等比椭圆轴错误')
s.head=90
assert(R.sweptHit(s,315,149) and not R.sweptHit(s,316,140),'判定未随head旋转')
local shot,c=spawn(2,16,{fdirection=0,sonspeed=30,Outdispel=false})
shot.mhj.Sonevents=nil
step(shot,1)
local hits=0
player={_live=true,x=13,y=87,colli=true,class={colli=function() hits=hits+1 end}}
R.beginCollisions();assert(hits==1 and not shot.colli,'碰撞入口未调用原作扫掠判定')
R.finishCollisions();assert(shot.colli,'自机碰撞后未恢复Bomb判定')
R.clear(c)
for o in pairs(R.objects) do assert(not IsValid(o),'回归检查结束残留对象') end
print('千桜华宴：负数换图、中心移动、花瓣弹道/朝向、雾化、残影、消散、分层、绑定及扫掠判定通过。')
