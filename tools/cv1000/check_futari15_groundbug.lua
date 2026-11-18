-- 0x42–0x44 的四次挂载与 2611 份原版状态；另核对原生碰撞、地面掉落及生命周期。
function Class(_,c)return c end
local objects={}
function New(c,...)local o={class=c};c.init(o,...);objects[#objects+1]=o;return o end
local images={}
function CheckRes(_,name)return images[name]end
function LoadTexture()end
function SetTextureSamplerState()end
function LoadImage(name)images[name]=true end
function SetImageState(name)assert(images[name],'未载入图片 '..name)end
function Render(name)assert(images[name],'未载入图片 '..name)end
function IsValid(o)return o and not o.deleted end
object={RawDel=function(o)o.deleted=true end}
GROUP,LAYER={GHOST=0,NONTJT=3,ITEM=6},{ENEMY=-600,ITEM=-300}
lstg={var={score=0}}
ran={Int=function(_,a,b)return math.floor((a+b)/2)end}
local create=dofile('mod/GAME/th46/groundbug.lua')
local scroll=dofile('mod/GAME/th46/groundscroll.lua')
local gold=dofile('mod/GAME/th46/gold.lua')
local fragments=dofile('mod/GAME/th46/fragments.lua')(dofile('mod/GAME/th46/midboss1_effect_data.lua').debris)
local module,run,p,emitted
local function setup()
 objects,emitted={},{}
 module=create(function(r,x,y,a,v,k)emitted[#emitted+1]={r.roadFrame,x,y,a%512,v,k}end)
 run={serial=0,roadFrame=0,roadCamera=0,roadCameraDelta=0}
 p={run=run,respawn=0,protect=255,laser=false,pilotPosition={x=120*65536,y=50*65536}}
 run.roadClock={player=p};scroll.open(run);module.open(run)
end
local function step(f,particles)
 run.serial,run.roadFrame=run.serial+1,f;scroll.step(run);module.step(run,f,p)
 if particles then for _,o in ipairs(objects)do if IsValid(o)and o.class.frame then o.class.frame(o)end end end
end
local function close()module.close(run);gold.close(run);fragments.close(run)end
setup()
local count,h,scrollHash,born,seen=0,0,0,{},{}
local recoveries={{1571,1587,-48,0,1},{1845,1893,48,-2,1},{1894,1923,-48,0,1},{2261,2309,48,-2,1},{2310,2339,-48,0,1},{2603,2651,48,-2,1},{2652,2681,-48,0,1},{2969,3017,48,-2,1},{3018,3047,-48,0,1},{3361,3409,48,-2,1},{3410,3439,-48,0,1},{3719,3767,48,-2,1},{3768,3797,-48,0,1},{4097,4145,48,-2,1},{4146,4175,-48,0,1},{4435,4483,48,-2,1},{4484,4513,-48,0,1},{4775,4823,48,-2,1},{4824,4853,-48,0,1},{5111,5159,48,-2,1},{5160,5170,-48,0,1}}
local first
for f=0,5670 do
 p.pilotPosition.y,p.respawn=50*65536,0
 for _,r in ipairs(recoveries)do if f>=r[1]and f<=r[2]then p.pilotPosition.y,p.respawn=(r[3]+(f-r[1])*r[4])*65536,r[5];break end end
 step(f)
 if f>=1571 then scrollHash=(scrollHash*131+run.roadGroundDelta)%16777213 end
 local list={};for o in pairs(run.roadGroundbugs)do list[#list+1]=o end
 table.sort(list,function(a,b)return a.zone<b.zone end)
 for _,o in ipairs(list)do
  if not seen[o]then born[#born+1]=o.zone;seen[o]=true end
  if o.zone==213 then first=o end
  o.class.render(o)
  if o.expired then assert(not o.box.colli)end
  assert(o.box.group==GROUP.NONTJT and o.box.a==33 and o.box.b==30)
  for _,n in ipairs({f,o.zone,o.programIndex-1,o.programClock})do h=(h*131+n)%16777213 end
  for at=4,0x544,4 do if at~=60 then h=(h*131+o.raw[at])%16777213 end end
  count=count+1
 end
end
assert(count==2611 and h==15755915,'原版移动、附肢或发弹状态不符：'..count..' / '..h)
assert(#born==4 and born[1]==213 and born[2]==236 and born[3]==446 and born[4]==455)
assert(not next(run.roadGroundbugs)and first.closed)
assert(#emitted==91,'原版发弹条数不符')
local shotHash=0
for _,row in ipairs(emitted)do for _,n in ipairs(row)do shotHash=(shotHash*131+n)%16777213 end end
assert(shotHash==12883374,'原版出膛参数不符')
assert(scrollHash==5556552,'4100 步原版地面卷轴位移不符')
close()

setup();for f=0,1737 do step(f)end
local target=assert(next(run.roadGroundbugs))
local function strike(amount,flags)
 local shot={colli=true,dmg=amount,damageFlags=flags}
 target.box.class.colli(target.box,shot);assert(shot.deleted)
end
strike(100);assert(target.hp==1436 and target.box.hp==1436,'地面敌机不应套用飞行敌机的出生保护')
local before=lstg.var.score
strike(1437,0x20)
assert(lstg.var.score==before+260 and not target.box.colli)
assert(run.groundEffectCount==11 and run.fragmentCount==6 and run.goldCount==5)
assert(next(run.groundCorpses))
for o in pairs(run.groundEffects)do assert(not o.visible and o.alpha==192)end
for o in pairs(run.roadGold)do assert(o.ground and not o.initialized and o.radius==24)end
for f=1738,2120 do step(f,true)end
assert(run.groundEffectCount==0 and run.fragmentCount==0)
close();assert(run.goldCount==0 and run.fragmentCount==0)

setup();for f=0,1800 do step(f)end
target=assert(next(run.roadGroundbugs));before=lstg.var.score;strike(1537,0x400)
assert(target.hp<0 and lstg.var.score==before,'0x400 击破应扣血但不计分')
close()

-- 地面金块不经过空中抛物线；出生后的第一次更新只初始化，吸附启动再等一步才积分。
setup();p.laser=true
local coin=gold.emitGround(run,120*65536,150*65536)
run.serial=run.serial+1;coin.class.frame(coin)
assert(coin.initialized and coin.boardY==150*65536 and coin.motion==0 and coin.layer==LAYER.ENEMY-1)
run.roadGroundDelta=65536;run.serial=run.serial+1;coin.class.frame(coin)
assert(coin.motion==1 and coin.boardY==149*65536 and coin.speed==72 and coin.interval==0 and coin.layer==LAYER.ENEMY+40)
run.serial=run.serial+1;coin.class.frame(coin)
assert(coin.boardY<148*65536)
p.pilotPosition.x,p.pilotPosition.y=coin.boardX,coin.boardY
before=lstg.var.score;coin.class.colli(coin,p)
assert(coin.popup and run.goldStage==2 and run.goldTotal==2 and lstg.var.score==before+2)
for i=1,80 do run.serial=run.serial+1;coin.class.frame(coin)end
assert(coin.closed);close()
print('Futari 1.5 四条地面敌机、滚动指令、附肢、交替炮、判定、击破与地面金块通过')
