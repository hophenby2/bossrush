-- 灯笼视图只改变桥接容器：实时读写、对象筛选、回收与稳定帧分配专项。
local CS=dofile('mod/GAME/ports/source_csharp.lua').new()
local R={objects={}}
local alive={}
IsValid=function(o) return alive[o]==true end
local deleted=0
Del=function(o) assert(alive[o]);deleted=deleted+1;o.mhj.dis=0 end
local view,reset=dofile('mod/GAME/ports/mhj/native_players/night_barrage_view.lua')(CS,R)
local function add(controller,x,extra)
    local state={controller=controller,is_projectile=true,fx=x,fy=23,age=42,life=100,alpha=100}
    for k,v in pairs(extra or {}) do state[k]=v end
    local o={mhj=state};alive[o]=true;R.objects[o]=true
    return o,state
end
local a,b={},{}
local first,s1=add(a,11)
local second,s2=add(a,22)
local third=add(b,33)
add({effectLayer=1},44)
add(a,55,{familiar=1})
add(a,66,{is_projectile=false})
local invalid=setmetatable({}, {__index=function() error('读取了失效引擎对象') end})
R.objects[invalid]=true
local function find(csm,x)
    for _,owner in CS.each(csm.csc) do
        assert(owner.highlightDispel==true and owner.layerm.LayerArray.Count==1)
        for _,p in CS.each(owner.layerm.LayerArray[0].Barrages) do if p.x==x then return p end end
    end
end
local csm=view();assert(csm.csc.Count==2)
local p1,p2=find(csm,11),find(csm,22)
assert(p1 and p2 and find(csm,33) and not find(csm,44) and not find(csm,55) and not find(csm,66))
assert(p1.time==42 and p1.add==0 and p1.NeedDelete==0 and not p1.centerMasked and not p1.Dis)
s1.fx,s1.alpha=12,31
assert(p1.x==12 and p1.alpha==31,'视图变成了静态快照')
p1.time,p1.Blend=80,true
assert(s1.age==80 and s1.Blend==true and s2.age==42)
p1.Dis=true;p1.Dis=true;p1.Dis=false
assert(deleted==1 and p1.Dis,'消弹写回或重复 Del 行为改变')
assert(view()==csm and find(csm,12)==p1 and find(csm,22)==p2,'稳定帧重复创建了视图代理')
second.mhj={controller=a,is_projectile=true,fx=24,fy=23,age=7}
assert(find(view(),24)==p2 and p2.time==7,'原生对象状态替换后仍读取旧状态')
local weak=setmetatable({first,p1},{__mode='v'})
R.objects[first],alive[first]=nil,nil;first,p1=nil,nil
view();collectgarbage('collect')
assert(weak[1]==nil and weak[2]==nil,'退役对象被桥接缓存永久保留')
for i=1,2000 do add(a,1000+i) end
for _=1,1000 do view() end
collectgarbage('collect');collectgarbage('stop')
local before=collectgarbage('count')
for _=1,1000 do view() end
local allocated=collectgarbage('count')-before
collectgarbage('restart')
assert(allocated<64,'稳定帧仍在持续创建桥接对象：'..allocated..' KB')
local dormant=view(false)
assert(dormant.csc.Count==0 and view(false)==dormant,'不使用弹体列表时仍保留了旧代理')
assert(view()~=csm and find(view(),24)~=p2,'恢复消弹时没有重新建立实时视图')
reset();local nextView=view()
assert(nextView~=csm and find(nextView,24)~=p2,'重新绑定没有清除旧代理缓存')
for o in pairs(R.objects) do R.objects[o]=nil;alive[o]=nil end
assert(view().csc.Count==0,'空场景残留了弹体视图')
print(('灯笼视图筛选、实时写回、代理复用、回收和重置通过；2002 弹体、1000 帧增量 %.2f KB'):format(allocated))
