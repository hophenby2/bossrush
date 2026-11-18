-- 原版 0x32 的三次挂载、定点历史及第 9591 帧击破记录；不以现有采样轨迹代替原生状态机。
function Class(_,c)return c end
local objects={}
function New(c,...)local o={class=c};c.init(o,...);objects[#objects+1]=o;return o end
function IsValid(o)return o and not o.deleted end
function CheckRes()return true end
object={RawDel=function(o)o.deleted=true end}
GROUP,LAYER={GHOST=0,ENEMY=2,ITEM=6},{ENEMY=-600,ITEM=-300}
lstg={var={score=0}}
local tape
ran={Int=function(_,a,b)
    if tape then local n=table.remove(tape,1);assert(n and n>=a and n<=b);return n end
    return math.floor((a+b)/2)
end}
-- 独立核对击破参数的随机调用；金块自身的选择与积分由专用检查覆盖。
local nativeDofile=dofile
function dofile(path)
    if path=='mod/GAME/th46/gold.lua'then return{choose=function()return nil end,emit=function()end}end
    return nativeDofile(path)
end
local create=dofile('mod/GAME/th46/longfly.lua')
local death=dofile('mod/GAME/th46/longfly_death.lua')
local exhaust=dofile('mod/GAME/th46/exhaust.lua')
local unit=65536
local module,run,p,emitted
local function setup()
    objects,emitted={},{}
    module=create(function(r,x,y,a,v,k)emitted[#emitted+1]={r.roadFrame,x,y,a%512,v,k}end)
    run={serial=0,roadFrame=0,roadCamera=0,roadCameraDelta=0}
    p={run=run,respawn=0,protect=255,laser=true,pilotPosition={x=120*unit,y=50*unit}}
    run.roadClock={player=p};module.open(run)
end
local function step(f)
    run.serial,run.roadFrame=run.serial+1,f;module.step(run,f,p)
    for _,o in ipairs(objects)do if IsValid(o)and o.class.frame then o.class.frame(o)end end
end
local function close()module.close(run);exhaust.close(run)end
local function motionHash(m)
    local h=0
    for at=0xfc,0x5c0,4 do h=(h*131+m[at])%16777213 end
    for at=0x60c,0x968,4 do h=(h*131+m[at])%16777213 end
    return h
end
local reference={
    [3934]={17563648,22413312,2,64,24,320,2618113},
    [3935]={17494144,22343808,2,63,24,320,10489865},
    [3999]={13052072,17913096,4,16,20,328,188368},
    [4000]={12988752,17861136,4,15,20,328,6421775},
    [4032]={11112792,16462936,6,0,16,336,4992859},
    [4100]={8165400,14888056,10,78,12,344,4353709},
    [4300]={4933632,10856088,26,178,12,160,15205182},
    [4744]={13749076,-4145584,35,-213,12,256,14717135},
    [4745]={13749076,-4194736,35,-214,12,256,6916795},
}
setup()
local first,born,seen=nil,{},{}
for f=0,5700 do
    step(f)
    for o in pairs(run.roadLongflies)do
        if not seen[o]then born[#born+1]=o.zone;seen[o]=true end
        if o.zone==428 then first=o end
    end
    if reference[f]then
        local m=first.raw
        local values={m[4],m[8],first.programIndex-1,first.programClock,m[20],m[24],motionHash(m)}
        for i,v in ipairs(values)do assert(v==reference[f][i],f..' 原版位移或历史不符 '..i)end
    end
end
assert(#born==3 and born[1]==428 and born[2]==472 and born[3]==483)
assert(not next(run.roadLongflies)and first.closed)
assert(#emitted==358,'Original 发弹周期不符')
local initial={4000,12988752,16288272,288,4,0x13}
for i,v in ipairs(initial)do assert(emitted[1][i]==v,'原版首发炮口或方向不符')end
close()

setup();step(3934)
local target=assert(next(run.roadLongflies))
local function strike(box,amount,flags)
    local shot={colli=true,dmg=amount,damageFlags=flags};box.class.colli(box,shot)
    assert(shot.deleted and not shot.colli)
end
strike(target.boxes[1],9999);assert(target.hp==3584,'丢失出生保护')
for f=3935,4000 do step(f)end
assert(target.raw[0xec]==0)
strike(target.boxes[1],100);assert(target.hp==3484 and target.boxes[2].hp==3484)
local x,y=math.floor(target.boardX/unit),math.floor(target.boardY/unit)
local function at(xx,yy)return{pilotPosition={x=xx*unit,y=yy*unit}}end
assert(target.boxes[1].hitPilot(target.boxes[1],at(x+66,y+34)))
assert(not target.boxes[1].hitPilot(target.boxes[1],at(x+67,y+34)))
assert(target.boxes[2].hitPilot(target.boxes[2],at(x+14,y-30)))
assert(not target.boxes[2].hitPilot(target.boxes[2],at(x+15,y-30)))
local previous=lstg.var.score
strike(target.boxes[2],target.hp+1,0x20)
assert(lstg.var.score==previous+480 and not target.boxes[1].colli and not target.boxes[2].colli)
target.boxes[1].damage(target.boxes[1],9999)
assert(lstg.var.score==previous+480,'共享判定重复结算击破')
close()

setup();step(3934);target=assert(next(run.roadLongflies))
target.raw[0xec]=0;previous=lstg.var.score
strike(target.boxes[1],3585,0x400)
assert(target.hp<0 and lstg.var.score==previous,'0x400 应扣血击破但不计分')
close()

-- 原版第 9591 帧的直接随机调用及二十份爆炸初值，包含四份延后初始化的碎片。
setup()
lstg.var.score=0
run.roadFrame=9591-5430
local host={run=run,player=p,boardX=9075624,boardY=15374416,raw={[0]=0,[4]=9075624,[8]=15374416}}
tape={0,1,20,15,1,4,1,0,8,10,2,8,1,14,11,6,1,5,6,13,1,2,2,2,0,1,4,4,9,2,4,1,5,1,12,7,4,1,9,1,3,10,1,7,2,1,2,8,6,6,7,6,0,8,13,3,1,2,11,2,4,14,2}
death.defeat(host)
assert(#tape==0 and run.longflyEffectCount==20 and run.fragmentCount==4 and lstg.var.score==4800)
tape=nil
local particles={}
for o in pairs(run.longflyEffects)do
    assert(not o.visible and o.index==(math.floor(o.flags/8)%2==1 and 1 or 4));particles[#particles+1]=o
end
table.sort(particles,function(a,b)
    for _,key in ipairs({'kind','boardX','boardY','boardVX','boardVY'})do if a[key]~=b[key]then return a[key]<b[key]end end
    return false
end)
local h=0
for _,o in ipairs(particles)do
    for _,key in ipairs({'kind','boardX','boardY','boardVX','boardVY','flags','wait','alpha'})do h=(h*131+o[key])%16777213 end
end
assert(h==8360250,'原版二十份爆炸初值不符：'..h)
for fragment in pairs(run.roadFragments)do assert(not fragment.initialized)end
for f=1,180 do step(run.roadFrame+1)end
assert(run.longflyEffectCount==0 and run.fragmentCount==0)
close()
print('Futari 1.5 三条 0x32、移动与振动历史、双炮、共享判定、击破参数及回收通过')
