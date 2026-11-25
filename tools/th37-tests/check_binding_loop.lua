-- 春雪的深绑定事件状态随父弹体存活，跨总时间轴循环后仍需保留。
arg={'th37-binding-loop'}
local file=assert(io.open('tools/check_stage.lua'));local source=file:read('*a');file:close()
assert(loadstring(source:sub(1,assert(source:find('if path == "--all" then',1,true))-1)))()
local R=dofile('mod/GAME/th37/runtime.lua')
R.sound=function() end
local function clone(s)
    local t={};for k,v in pairs(s) do t[k]=v end;return t
end
local original=R.loadPattern('365')
local root,child
for _,s in ipairs(original.emitters) do
    if s.id==12 and s.parentid==0 then root=clone(s) end
    if s.id==13 and s.parentid==0 then child=clone(s) end
end
root.id,root.bindid,root.Deepbind,root.begin,root.life,root.t=0,-1,false,1,1,9999
root.tiao,root.sonlife,root.Outdispel,root.Mist=1,400,false,false
root.Parentevents=function(o,t)
    if t==1 and R.once(o,'root',1) then R.fire(o) end
end
root.Sonevents=nil
child.id,child.bindid,child.Deepbind,child.begin,child.life,child.t=1,0,true,1,400,10
child.tiao,child.sonlife,child.Outdispel,child.Mist=1,1,false,false
child.Parentevents=function(o,t)
    if t==1 then R.change(o,'tiao',2,0,1,'正比',1) end
end
child.Sonevents=nil
R.patterns.binding_loop={id='binding_loop',total=80,center=original.center,centerAvailable=false,types=original.types,
    centerEvents=function() end,emitters={root,child}}
local rawNew,objects,shots=New,{},{}
local clock=0
New=function(class,...)
    local o=rawNew(class,...);objects[#objects+1]=o
    if o.mhj and o.mhj.parentid==1 then shots[clock]=(shots[clock] or 0)+1 end
    return o
end
local c=R.controller({_live=true,x=0,y=0},'binding_loop',true)
for t=1,240 do
    clock=t;R.tick(c)
    for _,o in ipairs(objects) do if IsValid(o) then o.class.frame(o) end end
end
local checks=0
for t,n in pairs(shots) do assert(n==3,'跨循环后丢失深绑定的事件结果：'..t..'/'..n);checks=checks+1 end
assert(checks>=20,'未覆盖足够的循环后发弹')
R.clear(c);New=rawNew
print('PASS 春雪深绑定跨 3 轮总时间轴，保留父对象事件状态与出弹数量')
