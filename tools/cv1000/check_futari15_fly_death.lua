-- 原版第 7803 帧低速击破及随后五步的粒子状态；覆盖等待、掉落、计分和重复碰撞。
function Class(_,methods) return methods end
function IsValid(o) return o and not o.deleted end
function CheckRes() return true end
object={RawDel=function(o) o.deleted=true end}
GROUP={GHOST=0,ITEM=6}
LAYER={ENEMY=-600,ITEM=-300}
lstg={var={score=0}}
local objects,random,draws={},{},{}
local calls=0
ran={Int=function(_,a,b)
    calls=calls+1
    local n=table.remove(random,1)
    if n~=nil then assert(n>=a and n<=b);return n end
    return math.floor((a+b)/2)
end}
function New(class,...)
    local o={class=class}
    class.init(o,...)
    objects[#objects+1]=o
    return o
end
function SetImageState() end
function Render(...) draws[#draws+1]={...} end
local death=dofile('mod/GAME/th46/fly_death.lua')
local unit=65536
local p={laser=true,respawn=0,pilotPosition={x=120*unit,y=50*unit}}
local function actor()
    local run={serial=0,roadFrame=2373,roadCamera=0,roadCameraDelta=0,roadClock={player=p}}
    death.open(run)
    return {run=run,player=p,boardX=9112000,boardY=14467984,speed=48,heading=266,hp=64,colli=true}
end
local function step(run)
    run.serial,run.roadFrame=run.serial+1,run.roadFrame+1
    for _,o in ipairs(objects) do if IsValid(o) then o.class.frame(o) end end
end
local o=actor()
random={6,0,14,2}
death.damage(o,63)
assert(o.hp==1 and o.colli and o.run.flyEffectCount==0 and lstg.var.score==0)
death.damage(o,1)
assert(o.hp==0 and not o.colli and lstg.var.score==240 and #random==0)
assert(o.run.flyEffectCount==4 and o.run.fragmentCount==3 and not o.run.roadGold)
local effects={}
for i=1,4 do
    local fx=objects[i]
    effects[i]=fx
    assert(fx.layer==LAYER.ENEMY-1,'飞虫爆炸未保留本体减一的绘制深度')
    assert(not fx.visible and fx.boardX==o.boardX and fx.boardY==o.boardY)
    fx.class.frame(fx)
    assert(not fx.visible,'碰撞当步提前启动粒子')
end
for fragment in pairs(o.run.roadFragments) do
    assert(fragment.layer==LAYER.ENEMY-2,'飞虫碎片未保留本体减二的绘制深度')
    assert(not fragment.initialized and fragment.boardX==o.boardX and fragment.boardY==o.boardY)
    fragment.class.render(fragment)
end
assert(#draws==0,'碰撞当步绘制了尚未初始化的碎片')
local before=calls
death.damage(o,100)
assert(calls==before and o.run.flyEffectCount==4 and lstg.var.score==240,'重复碰撞重复结算')
-- 各行依次为四份粒子的可见性、定点坐标、Lua 画格下标和计时器。
local reference={
    {{true,9136048,14272864,4,0},{false,9112000,14467984,4,0},{false,9112000,14467984,4,0},{false,9112000,14467984,4,0}},
    {{true,9160096,14077744,5,1},{false,9112000,14467984,4,0},{true,9132544,14405760,4,0},{true,9133528,14372080,4,0}},
    {{true,9184144,13882624,5,0},{true,9093964,14321644,4,0},{true,9153088,14343536,5,0},{true,9155056,14276176,5,0}},
    {{true,9208192,13687504,6,1},{true,9075928,14175304,5,0},{true,9173632,14281312,6,0},{true,9176584,14180272,6,0}},
    {{true,9232240,13492384,6,0},{true,9057892,14028964,6,0},{true,9194176,14219088,7,0},{true,9198112,14084368,7,0}},
}
for _,rows in ipairs(reference) do
    step(o.run)
    for i,r in ipairs(rows) do
        local fx=effects[i]
        assert(fx.visible==r[1] and fx.boardX==r[2] and fx.boardY==r[3] and fx.index==r[4] and fx.clock==r[5],
            ('原版粒子 %d 第 %d 步状态不符'):format(i,o.run.serial))
    end
end
assert(o.run.goldCount==1,'低速击破应从主爆炸启动时掉落金块')
assert(effects[3].alpha==80 and effects[3].flip==-1 and effects[4].alpha==48)
draws={}
effects[3].class.render(effects[3])
local frame=effects[3].animation.frames[effects[3].index]
assert(draws[1][2]==math.floor(effects[3].boardX/unit)-120-frame[2] and draws[1][5]==-1,'镜像粒子锚点不符')
for frame=1,160 do step(o.run) end
assert(o.run.flyEffectCount==0 and o.run.fragmentCount==0,'粒子或碎片未按动画/淡出回收')
death.close(o.run)
-- 常速直接掉小金块；主爆炸另按原版二分之一分支选择大金块。
for choice=0,1 do
    objects,random={}, {6,choice,14,2}
    p.laser=false
    local bug=actor()
    death.damage(bug,64)
    assert(bug.run.goldCount==1 and next(bug.run.roadGold).kind==0)
    step(bug.run)
    assert(bug.run.goldCount==(choice==0 and 2 or 1),'常速主爆炸掉落分支不符')
    death.close(bug.run)
end
objects={}
local bug=actor()
local score=lstg.var.score
death.damage(bug,64,0x400)
assert(bug.hp==64 and bug.colli and lstg.var.score==score and bug.run.flyEffectCount==0)
death.damage(bug,64,0x20)
assert(lstg.var.score==score+6,'0x20 事件未将击破分除以 40')
local pending={}
for fx in pairs(bug.run.flyEffects) do pending[#pending+1]=fx end
for fx in pairs(bug.run.roadFragments) do pending[#pending+1]=fx end
death.close(bug.run)
bug.run.serial=bug.run.serial+1
for _,fx in ipairs(pending) do fx.class.frame(fx);assert(not IsValid(fx)) end
assert(bug.run.flyEffectCount==0 and bug.run.fragmentCount==0,'离场清理后仍有待更新对象')
objects={}
bug=actor()
lstg.var.score=0xee6b27ff-1
death.damage(bug,64)
assert(lstg.var.score==0xee6b27ff,'击破分突破原版上限')
death.close(bug.run)
-- 原版第 7798 帧碰撞分配、第 7799–7800 帧初始化和积分的 0 类碎片。
local fragments=dofile('mod/GAME/th46/fragments.lua')(dofile('mod/GAME/th46/midboss1_effect_data.lua').debris)
local pool={serial=0,roadFrame=0,roadCameraDelta=0}
random={27,33,9,9}
local fragment=fragments.emit(pool,9232240,15443584,0,nil,true)
assert(#random==4 and not fragment.initialized,'延后碎片提前消耗了初始化随机数')
pool.serial=1
fragment.class.frame(fragment)
assert(#random==0 and fragment.boardX==9430900 and fragment.boardY==15534842 and fragment.speed==70
    and fragment.angle==96 and fragment.phase==31 and fragment.speedClock==0 and fragment.fadeDelay==55)
pool.serial=2
fragment.class.frame(fragment)
assert(fragment.boardX==9623884 and fragment.boardY==15620918 and fragment.speed==68
    and fragment.phase==3 and fragment.speedClock==1 and fragment.fadeDelay==54)
fragments.close(pool)
print('Futari 1.5 飞虫击破分、爆炸等待、碎片、金块与回收对照通过')
