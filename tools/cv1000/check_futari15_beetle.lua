-- 第一面两条 0x30 的原版运动、三路发弹、共享判定和击破回归，不依赖模拟器。
function Class(_,c) return c end
function IsValid(o) return o and not o.deleted end
function CheckRes() return true end
object={RawDel=function(o) o.deleted=true end}
GROUP={GHOST=0,ENEMY=2,ITEM=6}
LAYER={ENEMY=-600,ITEM=-300}
ran={Int=function(_,a,b) return b==15 and 12 or math.floor((a+b)/2) end}
lstg={var={score=0}}
local objects,emissions={},{}
function New(c,...)
    local o={class=c};c.init(o,...);objects[#objects+1]=o;return o
end
local beetle=dofile('mod/GAME/th46/beetle.lua')(function(run,x,y,angle,speed,kind)
    emissions[#emissions+1]={run.roadFrame,x,y,angle,speed,kind}
end)
local p={laser=true,respawn=0,pilotPosition={x=120*65536,y=50*65536}}
local function setup()
    local run={serial=0,roadFrame=0,roadCamera=0,roadCameraDelta=0}
    run.roadClock,p.run={player=p},run
    beetle.open(run)
    return run
end
local function step(run,frame)
    run.serial,run.roadFrame=run.serial+1,frame
    beetle.step(run,frame,p)
    for _,o in ipairs(objects) do if IsValid(o) and o.class.frame then o.class.frame(o) end end
end
local run=setup()
local reference={
    [537]={9502720,24576000,32,2,16,80,0,0},
    [538]={9502720,24444928,32,2,15,79,1,1},
    [553]={9502720,22478848,32,2,0,64,8,0},
    [554]={9502720,22364160,28,4,8,63,9,1},
    [610]={9502720,18153472,10,16,6,7,37,1},
    [628]={9502720,17539072,6,20,6,0,46,1},
    [670]={9502720,16801792,4,22,349,0,67,1},
    [1070]={9502720,8577024,16,28,0,0,267,1},
}
local first,second
for frame=0,6000 do
    step(run,frame)
    if frame==537 then first=assert(next(run.roadBeetles)) end
    local r=reference[frame]
    if r then
        local values={first.boardX,first.boardY,first.speed,first.programIndex-1,first.programClock,
            first.protect,first.animationFrame,first.animationClock}
        for i,v in ipairs(values) do assert(v==r[i],frame..' 原版状态 '..i..' 不符') end
    end
    if frame==738 then
        local n=#emissions
        assert(n>=3)
        for i=1,3 do
            local shot=emissions[n-3+i]
            assert(shot[1]==738 and shot[2]==9437182 and shot[3]==14573560 and shot[4]==243+(i-1)*24
                and shot[5]==4 and shot[6]==0x12,'第 6168 帧三路发弹与原版不符')
        end
    elseif frame==1182 then
        assert(first.closed and not IsValid(first.boxes[1]),'出界当步未回收共享判定')
    elseif frame==5030 then
        second=assert(next(run.roadBeetles))
        assert(second~=first and second.boardX==122*65536 and second.boardY==381*65536 and second.hp==832)
    end
end
assert(second.closed and not next(run.roadBeetles),'两条指令自然退场后仍有对象')
beetle.close(run)
objects={}
run=setup()
step(run,537)
local o=assert(next(run.roadBeetles))
local a,b=o.boxes[1],o.boxes[2]
local function strike(box,amount,flags)
    local shot={colli=true,dmg=amount,damageFlags=flags}
    box.class.colli(box,shot)
    assert(not shot.colli and not IsValid(shot))
end
strike(a,1000)
assert(o.hp==832 and a.hp==832 and b.hp==832,'初始 80 步无敌丢失')
for frame=538,617 do step(run,frame) end
assert(o.protect==0)
strike(a,100)
assert(o.hp==732 and a.hp==732 and b.hp==732,'两个矩形没有共享 HP')
strike(b,1000,0x400)
assert(o.hp==732)
-- 自机判定按原版含边界整数盒比较，与自弹使用的宽判定分开。
local function pilotAt(x,y) return {pilotPosition={x=x,y=y}} end
assert(a.hitPilot(a,pilotAt(o.boardX+18*65536,o.boardY+37*65536)))
assert(not a.hitPilot(a,pilotAt(o.boardX+19*65536,o.boardY+37*65536)))
assert(b.hitPilot(b,pilotAt(o.boardX+42*65536,o.boardY+12*65536)))
assert(not b.hitPilot(b,pilotAt(o.boardX+42*65536,o.boardY+13*65536)))
strike(b,733)
assert(o.hp==-1 and not a.colli and not b.colli and lstg.var.score==410 and run.fragmentCount==4)
local kinds={}
local effects={}
for fx in pairs(run.beetleEffects) do
    kinds[fx.kind]=true;effects[#effects+1]=fx
    assert(not fx.visible and fx.layer==LAYER.ENEMY+2)
end
assert(#effects==4 and kinds[2] and kinds[4] and kinds[5] and kinds[6])
for fragment in pairs(run.roadFragments) do assert(not fragment.initialized and fragment.layer==LAYER.ENEMY+1) end
for frame=618,800 do step(run,frame) end
assert(o.closed and not next(run.beetleEffects) and run.fragmentCount==0,'击破演出未完成回收')
beetle.close(run)
for _,fx in ipairs(effects) do assert(not IsValid(fx)) end
print('Futari 1.5 两条大型飞虫指令、移动、三路发弹、共享碰撞与击破通过')
