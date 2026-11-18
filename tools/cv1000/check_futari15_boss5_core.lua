-- 对照独立 MAME 指令探针，并检查过量伤害、三段超时、非对称碰撞盒和回收。
function Class(_,c)return c end
function New(c,...)local o={class=c};c.init(o,...);return o end
object={RawDel=function(o)o.deleted=true end}
GROUP,LAYER={GHOST=0,ENEMY=2},{ENEMY=-600}
local core=dofile('mod/GAME/th46/boss5_core.lua')
local verify=dofile('tools/cv1000/verify_futari15_boss5_core.lua')
local custom=os.getenv('FUTARI15_BOSS5_FIXTURE')
local paths=custom and{custom}or{'tools/cv1000/fixtures/futari15_boss5_core.lua',
    'tools/cv1000/fixtures/futari15_boss5_timeout.lua'}
local counts,events={0,0},0
for _,path in ipairs(paths)do
    local n,e,old=verify(core,dofile(path))
    counts[1],counts[2],events=counts[1]+n[1],counts[2]+n[2],events+e
    assert(old.deleted)
    for _,b in ipairs(old.boxes)do assert(b.deleted and not b.colli)end
end

local p={pilotPosition={}}
local notices={}
local o=core.create({},p,function(_,e)notices[#notices+1]=e end)
assert(o.hp==1807744 and o.maxhp==1807744 and o.warningHP==136416 and #o.boxes==3)
core.enable(o,true)
assert(o.boxes[1].colli and o.boxes[2].colli and not o.boxes[3].colli)
local b=o.boxes[1]
b.damage(b,2147483647)
assert(o.hp==1069056 and o.phase==1 and o.invulnerable and o.raw[0x2688]==1)
b.damage(b,9999999);assert(o.hp==1069056 and #notices==1)
core.resume(o);b.damage(b,9999999)
assert(o.hp==545664 and o.phase==2 and #notices==2)
core.resume(o);o.defeatInhibited=true;b.damage(b,545665)
assert(o.hp==512 and not o.invulnerable and #notices==2)
o.defeatInhibited=false;b.damage(b,512)
assert(o.hp==0 and #notices==3 and o.raw[0x2634]==1 and notices[3].kind=='defeat')
for _,box in ipairs(o.boxes)do assert(not box.colli)end
core.close(o)

o=core.create({},p);core.enable(o,true)
for phase=0,2 do
    local clock=0x267c+phase*4
    core.advance(o,true)
    assert(o.raw[clock]==18000)
    for _=1,18000 do core.advance(o,false)end
    assert(o.raw[clock]==0 and o.phase==phase)
    if phase==2 then
        core.advance(o,false,true);assert(o.raw[clock]==300 and o.raw[0x2634]==0)
        for _=1,300 do core.advance(o,false,false)end
        assert(o.raw[clock]==0)
    end
    core.advance(o,false)
    assert(o.request.cause=='timeout'and o.request.phase==phase+1 and o.request.score==0)
    assert(o.raw[0x2694+phase*20]==2)
    if phase<2 then core.resume(o)end
end
core.close(o)

o=core.create({},p);core.enable(o,true)
o.raw[0x2610],o.raw[0x2640]=1,800000;core.applyPending(o)
assert(o.hp==1069056 and o.raw[0x2640]==0 and o.raw[0x2610]==0 and o.request.cause=='accumulated')
o.raw[0x2640]=999999;core.applyPending(o)
assert(o.hp==1069056 and o.raw[0x2640]==0)
core.resume(o)
local unit=65536
core.sync(o,{{120*unit,160*unit},{80*unit,100*unit}})
assert(o.boxes[1].x==0 and o.boxes[1].y==-28 and o.boxes[1].b==49)
assert(o.boxes[2].y==48 and o.boxes[3].x==-40)
core.setBox(o,3,true);assert(o.boxes[3].colli)
for _,box in ipairs(o.boxes)do
    local s=box.shape
    p.pilotPosition.x=box.originX+(s[4]+2)*unit
    p.pilotPosition.y=box.originY+unit
    assert(box.hitPilot(box,p))
    p.pilotPosition.x=p.pilotPosition.x+unit;assert(not box.hitPilot(box,p))
    p.pilotPosition.x=box.originX
    p.pilotPosition.y=box.originY+(s[6]+3)*unit
    assert(box.hitPilot(box,p))
    p.pilotPosition.y=p.pilotPosition.y+unit;assert(not box.hitPilot(box,p))
end
local shot={colli=true,dmg=100}
for _,box in ipairs(o.boxes)do box.class.colli(box,shot)end
assert(o.hp==1068956 and shot.deleted and not shot.colli,'一颗普通自弹不得重复扣三个盒的血')
core.close(o)
print(('第五面关底：%d 次真实受弹、%d 次倒数、%d 次换段/击破及原生三盒边界通过'):format(counts[1],counts[2],events))
