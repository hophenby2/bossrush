-- 原作 Batch.cs 将深绑定副本存于父弹体；Barrage.Draw 的出生雾为 15 帧。
arg={'th39-fireworks'}
local file=assert(io.open('tools/check_stage.lua'));local source=file:read('*a');file:close()
assert(loadstring(source:sub(1,assert(source:find('if path == "--all" then',1,true))-1)))()
dofile('THlib/lib/Ltask.lua')
local R=dofile('mod/GAME/th39/runtime.lua')
R.sound=function() end
math.randomseed(739)
local objects,born,shots,parents={}, {},{},{}
local rawNew=New
local clock,peakBurst,peakObjects=0,0,0
local example
New=function(class,...)
    local o=rawNew(class,...);objects[#objects+1]=o
    local s=o.mhj
    if s then
        born[s]=clock
        if s.type==52 then
            example=example or s
            shots[clock]=(shots[clock] or 0)+1
            peakBurst=math.max(peakBurst,shots[clock])
            local root=s.bound_source
            while root and root.type~=151 do root=root.bound_source end
            assert(root,'散弹失去原父对象')
            local elapsed=clock-born[root]
            assert(elapsed>=304 and elapsed<=306,'父对象重复生成分支或计时重启：'..elapsed)
        elseif s.type==148 then
            local root=s.bound_source
            while root and root.type~=151 do root=root.bound_source end
            parents[root]=(parents[root] or 0)+1
            assert(parents[root]==1,'同一父对象重复创建爆炸触发器')
        end
    end
    return o
end
local c=R.controller({_live=true,x=0,y=100},'143',false,{[1]={10,5400,54},[4]={2,2100}})
for tick=1,3360 do
    clock=tick;R.tick(c)
    local i=1
    while i<=#objects do
        local o=objects[i]
        if IsValid(o) and o.class.frame then o.class.frame(o) end
        i=i+1
    end
    local alive={}
    for _,o in ipairs(objects) do if IsValid(o) then alive[#alive+1]=o end end
    objects=alive;peakObjects=math.max(peakObjects,#objects)
end
assert(peakBurst==37,'首帧散弹数量与原事件不符：'..peakBurst)
assert(shots[372]==37 and shots[373]==31 and shots[374]==25,'首次分裂应为连续三帧 37/31/25 发')
assert(shots[848]==37 and shots[856]==37,'跨 840 帧循环后未延续原有的 8 帧间隔')
R.clear(c)
print(('PASS 流星花火 4 轮：单帧散弹峰值 %d，对象峰值 %d，无重复父子链'):format(peakBurst,peakObjects))

-- 真正调用正式绘制路径，检查雾图、缩放、透明度与第 16 帧的弹图切换。
local render,state=Render,SetImageState
local draws,colors={},{}
Render=function(...) draws[#draws+1]={...} end
SetImageState=function(...) colors[#colors+1]={...} end
local function clone(s)
    local t={};for k,v in pairs(s) do t[k]=v end
    t.changes,t.limits={},{};return t
end
local s=clone(example);s.alpha=100;s.Mist=true;s.life=2;s.Dispel=true;s.Sonevents=nil
s.dis,s.cancelAlpha=nil,nil;s.Outdispel=false;s.fx,s.fy=481,360;s.wscale,s.hscale=1,1
local b=rawNew(R.classes.projectile,s)
for i=1,5 do b.class.frame(b) end
b.class.render(b)
local fog=draws[#draws]
assert(fog[1]=='mhj3_birth_mist_2','没有绘制原作黄色弹雾')
assert(math.abs(fog[5]-(50/20+1.5*(1-5/15))*2/3)<1e-8,'雾图缩放错误')
assert(math.abs(colors[#colors][3]-255*5/15)<1e-8,'雾图透明度错误')
for i=6,16 do b.class.frame(b) end
b.class.render(b)
assert(draws[#draws][1]~=fog[1],'15 帧后未切换为子弹图')
for i=17,47 do b.class.frame(b) end
assert(IsValid(b),'自然消失的 30 帧尾段被提前删除')
b.class.frame(b)
assert(not IsValid(b),'自然消失尾段未回收')

-- 大图出生时额外放大；负缩放仍按原方向翻转，小图无颜色时直接使用弹图。
local D=dofile('mod/GAME/th39/catalogue.lua')
for _,width in ipairs({50,100}) do
    s=clone(example);s.pattern=clone(example.pattern);s.pattern.types={{0,0,width,50,25,25,7,-1,1,0,0,0,0,0,0,'barrages'}}
    s.type=#D.bulletTypes+1;s.Mist=true;s.alpha=100;s.Sonevents=nil;s.dis=nil
    s.Outdispel=false;s.fx,s.fy=481,360;s.wscale,s.hscale=-2,3
    local large=rawNew(R.classes.projectile,s);s.age=4;large.class.frame(large);large.class.render(large)
    local draw=draws[#draws];local extra=width>72 and 1-5/15 or 0
    assert(draw[1]~=fog[1] and math.abs(draw[5]+(2+extra)*2/3)<1e-8,'大图/无颜色出生缩放或翻转错误')
    assert(math.abs(draw[6]-(3+extra)*2/3)<1e-8,'大图出生纵向缩放错误')
end

-- 背景/死亡特效复用同一雾化绘制，不能继续使用实际子弹贴图淡入。
local effect=R.backgroundEffect('e54',480,360,739)
s=clone(example);s.controller=effect;s.age=5;s.alpha=100;s.Mist=true
s.fx,s.fy=481,360
effect.particles={s};effect.drawDirty=true
lstg.world=lstg.world or {l=-224,r=224,b=-256,t=256}
R.drawBackground(effect,1,0,0)
assert(draws[#draws][1]==fog[1],'特效路径未使用同一出生雾')
Render,SetImageState=render,state
New=rawNew
print('PASS 永夜普通弹与特效出生雾、15 帧边界、自然消失 30 帧尾段')

-- 消弹尾段中的对象仍有效，但 Batch.Shoot 不得再把它用作绑定发弹源。
c=R.controller({_live=true,x=0,y=100},'143',false)
local bound,owner
for _,e in ipairs(c.emitters) do if e.parentid==0 then
    if e.id==1 then bound=e elseif e.id==0 then owner=e end
end end
s=clone(example);s.controller=c;s.bucket=owner.bucket;s.dis=nil;s.Sonevents=nil;s.alpha=100;s.fx,s.fy=481,360
b=rawNew(R.classes.projectile,s);s.age=20
dofile('mod/GAME/ports/binding_index.lua').add(owner.bucket,b,s)
b.class.del(b);assert(IsValid(b) and s.dis==0,'未进入消弹尾段')
local before=CREATED_OBJECTS;R.fire(bound)
assert(CREATED_OBJECTS==before,'已消除父对象继续发弹')
R.clear(c)
print('PASS 永夜绑定发射器排除仍在淡出的已消除父对象')
