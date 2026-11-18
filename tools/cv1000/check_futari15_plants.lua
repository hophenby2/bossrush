-- 对照第一面 0x34 的挂载节奏、0x35 的出生参数及原版碎草更新，不启动模拟器。
function Class(_,methods) return methods end
function IsValid(o) return o and not o.deleted end
function CheckRes() return true end
object={RawDel=function(o) o.deleted=true end}
GROUP={GHOST=0,ENEMY=2,ITEM=6}
LAYER={ENEMY=-600,ITEM=-300}
ran={Int=function(_,a,b) return math.floor((a+b)/2) end}
local Plant,Particle
local births={}
function New(class,...)
    local o={class=class}
    class.init(o,...)
    if o.large~=nil then Plant=class;births[#births+1]=o end
    if o.animation then Particle=class end
    return o
end
lstg={var={score=0}}
local unit=65536
local plants=dofile('mod/GAME/th46/plants.lua')
local gold=dofile('mod/GAME/th46/gold.lua')
local p={laser=true,respawn=0,pilotPosition={x=120*unit,y=50*unit}}
local function word(n) return string.char(math.floor(n/256)%256,n%256) end
local pose=string.rep('\0',4)..string.char(1)..word(906)..string.rep('\0',4)
local other=string.rep('\0',4)..string.char(1)..word(3)..string.rep('\0',4)
local run={serial=0,roadCamera=0,roadCameraDelta=0,roadFrame=0,roadClock={player=p},
    data={enemies={[2622]={{frames={pose}},{frames={other}}}},
          backgrounds={[1]={0,0,{{0,816}},word(816)..word(20)..word(30)..word(3)..word(4)..word(5)}}}}
p.run=run
plants.open(run)
assert(#run.data.enemies[2622]==1 and run.data.enemies[2622][1].frames[1]==other)
assert(run.data.backgrounds[1][4]==word(3)..word(4)..word(5),'植物旧背景裁片未移除')
assert(run.data.backgrounds[1][3][1][2]==816,'错误修改了地形网格')
local expectedBushes={
    {2556,69,364,14,272},{2572,113,341,14,256},{2588,150,356,15,240},
    {2660,102,351,14,256},{2668,215,349,14,272},{2684,16,344,15,240},
    {2740,68,343,14,272},{2740,151,337,15,240},
}
local grassTimes,bushCount={},0
for frame=0,3548 do
    run.serial,run.roadFrame=run.serial+1,frame
    local old=#births
    plants.step(run,frame,p)
    if frame==2782 then run.midGate=true end
    for i=old+1,#births do
        local o=births[i]
        if o.large then
            bushCount=bushCount+1
            local r=expectedBushes[bushCount]
            assert(frame==r[1] and o.boardX==r[2]*unit and o.boardY==r[3]*unit)
            assert(o.speed==r[4] and o.angle==r[5] and o.hp==4096 and o.clock==1 and o.phase==0)
        else
            grassTimes[#grassTimes+1]=frame
            assert(o.hp==4 and o.boardY==320*unit)
        end
    end
end
assert(bushCount==8 and #grassTimes==72 and not run.plantController)
for i=1,24 do assert(grassTimes[i]==2186+(i-1)*17,'0x34 初段挂载间隔不符') end
for i=25,72 do assert(grassTimes[i]==2594+(i-25)*4,'0x34 密集段挂载间隔不符') end
plants.close(run)
plants.open(run)
run.nextBush=9

-- 原版第 7986–7988 帧大草丛，定点速度由 14、272 直接查 SH-3 方向表。
local bush=New(Plant,run,p,4521984,23855104,true,14,272)
plants.step(run,9999,p)
assert(bush.boardX==4510798 and bush.boardY==23798866 and bush.phase==0 and bush.clock==0 and bush.entered)
plants.step(run,9999,p)
assert(bush.boardX==4499612 and bush.boardY==23742628 and bush.phase==1 and bush.clock==1)
local bx,by=bush.boardX,bush.boardY
assert(bush.hitPilot(bush,{pilotPosition={x=bx+34*unit,y=math.floor(by/unit)*unit+67*unit}}))
assert(not bush.hitPilot(bush,{pilotPosition={x=bx+35*unit,y=by}}))
bush.damage(bush,1)
assert(bush.hp==4095 and bush.hitFlash)
plants.step(run,9999,p)
assert(bush.flash==1 and not bush.hitFlash)
plants.step(run,9999,p)
assert(bush.flash==0)
bush.damage(bush,4095)
assert(not IsValid(bush) and run.plantEffectCount==6,'大草丛未生成三组碎草')
for effect in pairs(run.plantEffects) do assert(not effect.visible,'碰撞后生成的碎草提前更新') end
plants.close(run)
gold.close(run)
plants.open(run)

-- 原版第 7800 帧碰撞后分配，7801 帧激活，7802 帧换格并减 8 透明度。
local grass=New(Plant,run,p,9375312,13524608,false,41,224)
assert(grass.hitPilot(grass,{pilotPosition={x=grass.boardX+10*unit,y=grass.boardY+unit}}))
assert(not grass.hitPilot(grass,{pilotPosition={x=grass.boardX+11*unit,y=grass.boardY+unit}}))
local shot={dmg=4,colli=true}
grass.class.colli(grass,shot)
assert(not IsValid(grass) and shot.deleted and not shot.colli and run.plantEffectCount==4)
local effect
for o in pairs(run.plantEffects) do if o.kind==18 and o.alpha==128 then effect=o end end
assert(effect and effect.boardX==9375312 and effect.boardY==13524608 and not effect.visible)
effect.class.frame(effect)
assert(not effect.visible,'减速等待帧提前启动碎草')
run.serial=run.serial+1
effect.class.frame(effect)
assert(effect.visible and effect.boardX==9439559 and effect.boardY==13369464)
assert(effect.index==1 and effect.clock==0 and effect.alpha==128)
run.serial=run.serial+1
effect.class.frame(effect)
assert(effect.boardX==9503806 and effect.boardY==13214320 and effect.index==2 and effect.alpha==120)
local spawned=0
for _ in pairs(run.roadGold) do spawned=spawned+1 end
assert(spawned==1,'粒子激活掉落重复或缺失')
for serial=1,180 do
    run.serial=run.serial+1
    for o in pairs(run.plantEffects) do if IsValid(o) then o.class.frame(o) end end
end
assert(run.plantEffectCount==0 and next(run.plantEffects)==nil,'碎草动画结束未回收')
gold.close(run)
plants.close(run)
plants.open(run)
run.nextBush=9
local leaving=New(Plant,run,p,0,unit,false,32,256)
leaving.entered=true
leaving.boardY=-35*unit
plants.step(run,9999,p)
assert(not IsValid(leaving),'已入场植物越界后未回收')
for _=1,40 do
    local o=New(Plant,run,p,0,0,false,32,256)
    o.damage(o,4)
end
assert(run.plantEffectCount==128,'植物粒子超出 128 槽容量')
local effects={}
for o in pairs(run.plantEffects) do effects[#effects+1]=o end
plants.close(run)
run.serial=run.serial+1
for _,o in ipairs(effects) do
    assert(not IsValid(o))
    o.class.frame(o)
end
assert(run.plantEffectCount==0 and run.roadPlants==nil)
print('Futari 1.5 植物挂载、八处草丛、定点运动、碰撞击破、碎草动画及采样替换通过')
