-- MAME 0.275 第 8654–8850 帧的原版金块状态；不依赖模拟器，保留运动和拾取的独立回归。
function Class(_,methods) return methods end
function New(class,...) local o={class=class};class.init(o,...);return o end
function IsValid(o) return o and not o.deleted end
function CheckRes() return true end
object={RawDel=function(o) o.deleted=true end}
GROUP,LAYER={ITEM=6},{ITEM=-300}
ran={Int=function(_,a,b) return math.floor((a+b)/2) end}
lstg={var={score=0}}
local gold=dofile('mod/GAME/th46/gold.lua')
local unit=65536
local p={respawn=0,protect=255,laser=true,pilotPosition={x=120*unit,y=50*unit}}
local run={serial=0,roadFrame=3224,roadCamera=0,roadCameraDelta=0,roadClock={player=p}}
p.run=run
local function step(o)
    run.serial=run.serial+1
    o.class.frame(o)
end
local function seed(o,values)
    local fields={'boardX','boardY','speed','angle','phase','clock','interval','motion','air','tint','boardVX','boardVY'}
    for i,field in ipairs(fields) do o[field]=values[i] end
end
local function expect(o,values)
    local fields={'boardX','boardY','speed','angle','phase','clock','interval','motion','air','tint','boardVX','boardVY'}
    for i,field in ipairs(fields) do assert(o[field]==values[i],field..' 与原版不符') end
end

-- 出生当步只初始化，下一次逻辑更新才移动；中 Boss 减速的等待帧不能继续动画。
local small=gold.emit(run,8607690,14513206,0)
assert(small.boardX==8607690 and small.boardY==14513206 and small.air==48)
assert(small.native_pickup,'原生金块会被通用道具开关删除')
seed(small,{8607690,14513206,24,279,4,0,0,0,48,64,-27360,-94392})
small.class.frame(small)
expect(small,{8607690,14513206,24,279,4,0,0,0,48,64,-27360,-94392})
step(small)
expect(small,{8578050,14607556,26,279,5,0,0,0,47,64,-29640,-102258})
step(small);step(small)
expect(small,{8511930,14772658,30,279,7,0,0,0,45,64,-34200,-117990})
local large=gold.emit(run,0,0,1)
seed(large,{11597308,12726324,61,238,3,0,1,0,27,80,54717,-243756})
step(large)
expect(large,{11597308,12671184,63,238,4,1,1,0,26,80,56511,-251748})

-- 第 8705 帧解除低速后吸附；奇数初速到 89，不能误钳到自由运动的 88。
p.laser=false
run.roadFrame=4449-1207
seed(small,{8372938,14006211,81,242,6,0,0,0,23,64,56700,-326835})
step(small)
expect(small,{8372938,13867914,83,242,7,0,0,1,22,80,58100,-334905})
step(small)
expect(small,{8351603,13520434,85,261,8,0,0,1,22,80,-21335,-347480})
for _=1,3 do step(small) end
expect(small,{8285088,12437114,89,261,11,0,0,1,22,80,-22339,-363832})
seed(large,{11597308,9733440,84,238,0,1,1,0,2,80,75348,-335664})
step(large)
expect(large,{11597308,9594384,84,238,0,0,0,1,1,112,75348,-335664})
step(large)
expect(large,{11420488,9299292,84,300,1,0,0,1,1,112,-176820,-295092})
local x,y=small.boardX,small.boardY
p.respawn=80
step(small)
assert(small.motion==0 and small.boardX==x and small.boardY==y,'受击回退当步误执行自由位移')
p.respawn=0
gold.close(run)

-- 第 8832 帧落地小金块：计数 324→325，加 325 分，转向左上角的计数浮字。
run.goldStage,run.goldTotal,lstg.var.score=324,324,200000
small=gold.emit(run,8156250,4063126,0)
small.air=0
p.pilotPosition.x,p.pilotPosition.y=small.boardX,small.boardY+unit
small.class.colli(small,p)
assert(small.popup and not small.colli and small.points==325)
assert(run.goldStage==325 and run.goldTotal==325 and lstg.var.score==200325)
assert(small.popupVX==-50520 and small.popupVY==84312)
small.class.colli(small,p)
assert(lstg.var.score==200325,'重复碰撞重复计分')
step(small)
assert(small.shown==109 and small.popupX==8105730 and small.popupY==4147438 and small.alpha==255)
step(small)
assert(small.shown==182 and small.popupX==8055210 and small.popupY==4231750)
for _=1,16 do step(small) end
assert(small.shown==325 and small.alpha==159 and small.popupX==7246890 and small.popupY==5580742)
for _=1,10 do step(small) end
assert(not IsValid(small) and run.goldCount==0,'浮字淡出后未归还道具槽')

-- 四类拾取、无敌中拾取、复活中禁拾取，以及整数判定边界和分数上限。
for kind=0,1 do
    for _,air in ipairs({0,48}) do
        run.goldStage,run.goldTotal,lstg.var.score=100,200,0
        local coin=gold.emit(run,120*unit,50*unit,kind)
        coin.air=air
        p.pilotPosition.x,p.pilotPosition.y=coin.boardX+(coin.radius+2)*unit,51*unit
        p.respawn=1
        coin.class.colli(coin,p)
        assert(not coin.popup)
        p.respawn=0
        p.pilotPosition.x=p.pilotPosition.x+unit
        coin.class.colli(coin,p)
        assert(not coin.popup,'判定外拾取')
        p.pilotPosition.x=p.pilotPosition.x-unit
        coin.class.colli(coin,p)
        local increment=(kind+1)*(air>0 and 2 or 1)
        assert(run.goldStage==100+increment and run.goldTotal==200+increment)
        assert(lstg.var.score==(100+increment)*(air>0 and 2 or 1))
        gold.close(run)
    end
end
run.goldStage,run.goldTotal,lstg.var.score=9998,99998,0xee6b27ff-1
large=gold.emit(run,120*unit,50*unit,1)
p.pilotPosition.x,p.pilotPosition.y=120*unit,51*unit
large.class.colli(large,p)
assert(run.goldStage==9999 and run.goldTotal==99999 and lstg.var.score==0xee6b27ff)
gold.close(run)
run.serial=run.serial+1
large.class.frame(large)
for _=1,1025 do gold.emit(run,0,0,0) end
assert(run.goldCount==1024,'道具池未遵守原版容量')
gold.close(run)
local absent=gold.emit(run,400*unit,400*unit,0)
absent.speed,absent.boardVX,absent.boardVY=88,0,-3*unit
for _=1,179 do step(absent) end
assert(IsValid(absent),'场外出生道具提前回收')
step(absent)
assert(not IsValid(absent),'场外道具未在 180 步后回收')
for choice=0,1 do
    ran.Int=function() return choice end
    assert(gold.choose(true)==choice)
    assert(gold.choose(false)==(choice==0 and 1 or nil))
end
print('Futari 1.5 原版金块运动、吸附、拾取计分、浮字、边界与容量对照通过')
