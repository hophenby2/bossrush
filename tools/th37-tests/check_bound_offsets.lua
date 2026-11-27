-- 对照 Batch.cs:1741/1742 的绑定齐射公式，覆盖千桜华宴末段下落小玉。
arg={'th37-bound-offsets'}
local f=assert(io.open('tools/check_stage.lua'));local src=f:read('*a');f:close()
assert(loadstring(src:sub(1,assert(src:find('if path == "--all" then',1,true))-1)))()
local R=dofile('mod/GAME/th37/runtime.lua')
local rawNew=New;local shots={}
New=function(cls,s,...)local o=rawNew(cls,s,...);shots[#shots+1]=o;return o end
for _,pool in ipairs({false,true})do
    R.useStatePool=pool
    local c=R.controller(nil,'673');local emitter
    for _,e in ipairs(c.emitters)do if e.parentid==3 and e.id==14 then emitter=e end end
    assert(emitter and emitter.rand.fx==250 and emitter.bindid==13,'没有覆盖实际末段下落发射器')
    local random={};for k,v in pairs(emitter.rand)do random[k]=v end;emitter.rand=random
    emitter.bound_source={fx=315,fy=140}
    local positions={}
    for _,offset in ipairs({-240.75,0,230.25})do
        ran.Float=function(_,a,b)if a==-250 and b==250 then return offset end;return (a+b)/2 end
        R.fire(emitter)
        local s=shots[#shots].mhj
        local radial=emitter.rdirection
        local expected=315+emitter.r*math.cos(radial*math.pi/180)+(offset<0 and math.ceil(offset)or math.floor(offset))
        assert(math.abs(s.fx-expected)<1e-4,'绑定分支漏掉原作横坐标随机偏移')
        positions[#positions+1]=s.fx
    end
    assert(positions[3]-positions[1]>469,'实际下落小玉仍集中在一列')
    -- 多发齐射共用本次偏移，不能改成逐弹抽随机数。
    emitter.tiao=5;emitter.range=0;emitter.rand.fx=10;emitter.rand.fy=20;emitter.rand.sonspeed=0
    local calls=0
    ran.Float=function(_,a,b)calls=calls+1;return b end
    local before=#shots;R.fire(emitter)
    assert(calls==2 and #shots-before==5,'齐射随机数的抽取次数改变')
    for i=before+1,#shots do
        assert(math.abs(shots[i].mhj.fx-(315+emitter.r*math.cos(emitter.rdirection*math.pi/180)+10))<1e-4)
        assert(math.abs(shots[i].mhj.fy-(140+emitter.r*math.sin(emitter.rdirection*math.pi/180)+20))<1e-4)
    end
    R.clear(c)
end
print('PASS 千桜华宴末段：原作绑定出生随机坐标、负小数截断、齐射共享偏移/抽样次数及对象池两路径')
