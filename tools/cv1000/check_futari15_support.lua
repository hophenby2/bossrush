-- 原版第 6154 帧尾气和第 6204–6334 帧 P 状态；检查挂载、拾取、rank 与独立回收。
function Class(_,c) return c end
function New(c,...) local o={class=c};c.init(o,...);return o end
function IsValid(o) return o and not o.deleted end
function CheckRes() return true end
object={RawDel=function(o) o.deleted=true end}
GROUP,LAYER={GHOST=0,ITEM=6},{ENEMY=-600,ITEM=-300}
lstg={var={score=0}}
local state={power=0,bombs=3}
NativePlayers={state=function() return state end}
local choices={}
local drawn={}
function SetImageState() end
function Render(image) drawn[image]=true end
ran={Int=function(_,a,b)
    local choice=table.remove(choices,1) or math.floor((a+b)/2)
    assert(choice>=a and choice<=b,'随机输入超出原版范围')
    return choice
end}
local unit=65536
local power=dofile('mod/GAME/th46/power.lua')
local exhaust=dofile('mod/GAME/th46/exhaust.lua')
local rank=dofile('mod/GAME/th46/rank.lua')
local run={serial=0,roadFrame=724,roadCamera=0,roadCameraDelta=0}
power.open(run);exhaust.open(run)
local function step(o)
    run.serial,run.roadFrame=run.serial+1,run.roadFrame+1
    o.class.frame(o)
end
local function expect(o,values)
    for k,v in pairs(values) do assert(o[k]==v,k..' 与原版不符：'..tostring(o[k])..' / '..tostring(v)) end
end

-- 分配当步无判定/无绘制，下一步只初始化，第三步才开始漂浮。
local p=power.emit(run,9502720,15097856)
assert(p.native_pickup and not p.colli and not p.initialized)
choices={14};step(p)
expect(p,{boardX=9502720,boardY=15097856,boardVX=-40950,boardVY=-61290,angle=304,speed=18,phase=0,clock=2,bounce=1800})
p.class.frame(p)
assert(p.clock==2 and p.bounce==1800,'重复逻辑序号推进了道具')
step(p)
expect(p,{boardX=9461770,boardY=15036566,phase=0,clock=1,bounce=1799})
-- 第 6412 帧左边反弹，第 6424 帧下边反弹；同时验证零画格从 24 开始倒数。
p.boardX,p.boardY,p.boardVX,p.boardVY=1080750,2472116,-40950,-61290
p.angle,p.phase,p.clock,p.bounce=304,0,0,1594
choices={11};step(p)
expect(p,{boardX=1048576,boardY=2410826,boardVX=14382,boardVY=-72306,angle=240,phase=1,clock=2,bounce=1593})
p.boardX,p.boardY=1206778,1640684
p.angle,p.phase,p.clock,p.bounce=240,0,22,1582
choices={10};step(p)
expect(p,{boardX=1221160,boardY=1572864,boardVX=34740,boardVY=65016,angle=40,phase=0,clock=21,bounce=1581})
-- 镜头位移在回调前施加；初始化和浮字都不能漏掉。
run.roadCameraDelta=-unit
local x=p.boardX;step(p);assert(p.boardX==x-unit+34740)
run.roadCameraDelta=0

local pilot={run=run,respawn=0,protect=255,pilotPosition={x=120*unit,y=50*unit}}
p.boardX,p.boardY=7782420,3088684
pilot.pilotPosition.x,pilot.pilotPosition.y=p.boardX,p.boardY+unit
local function collect(item) item.class.colli(item,pilot) end
pilot.respawn=1;collect(p);assert(not p.popup)
pilot.respawn=0;pilot.run={};collect(p);assert(not p.popup)
pilot.run=run
state.power=0;lstg.var.score=0;run.roadFrame=822
rank.advance(run);local previousRank=rank.get(run)
local pickupPhase=p.phase
choices={0};collect(p)
assert(p.popup and not p.colli and state.power==1 and lstg.var.score==500 and rank.get(run)==previousRank)
p.class.render(p);assert(drawn['th46_power_'..pickupPhase],'拾取当步漏掉原版先提交的图标')
collect(p);assert(lstg.var.score==500,'同一 P 重复结算')
rank.advance(run);assert(rank.get(run)==previousRank+2,'火力贡献没有在下一步生效')
step(p)
expect(p,{boardX=7839764,boardY=3121452,boardVX=57344,boardVY=0,phase=1,clock=0,alpha=249})
for _=2,52 do step(p) end
expect(p,{boardX=10764308,boardY=4792620,phase=52,alpha=0})
assert(IsValid(p));step(p);assert(not IsValid(p) and run.powerCount==0)

-- 满级分支使用不同的三段浮字状态机，不能复用 53 步的 Power Up 动画。
p=power.emit(run,7782420,3088684)
choices={14};step(p)
state.power=7;lstg.var.score=0
choices={0};collect(p)
assert(p.full and p.points==10000 and state.power==7 and lstg.var.score==10000)
for i=1,81 do
    step(p)
    if i==16 then expect(p,{phase=8,clock=1,count=4,hold=5,mode=1,alpha=255}) end
end
expect(p,{boardX=12427284,boardY=5742892,phase=40,clock=0,count=15,hold=-1,mode=2,alpha=24})
step(p);assert(p.closed and run.powerCount==0)
local capped=power.emit(run,120*unit,49*unit)
step(capped);lstg.var.score=0xee6b27fe;choices={0};collect(capped)
assert(lstg.var.score==0xee6b27ff)
power.close(run);power.open(run)
for _=1,12 do assert(power.emit(run,120*unit,100*unit)) end
assert(not power.emit(run,0,0) and run.powerCount==12)
power.close(run);assert(run.powerCount==0)

-- 原版 6154 帧四份尾气：代入原版节点相位、振动锚点及随机取值，核对当步积分。
local host={run=run,boardX=9502720,boardY=15917056,angle=256,
    waves={{0,0,0,0},{0,0,0,0},{0,0,0,53014},{0,0,0,-185690}}}
exhaust.attach(host)
local phases={8,2,7,0}
for i,node in ipairs(host.exhaustNodes) do node.phase,node.clock,node.spawnClock=phases[i],0,0 end
choices={0,83,1,33,0,49,0,29}
exhaust.step(host)
local reference={
    [453]={boardX=7635156,boardY=16269030,boardVX=-32556,boardVY=36816,kind=18,phase=24,clock=1,alpha=157},
    [39]={boardX=11360360,boardY=16275834,boardVX=22632,boardVY=43620,kind=8,phase=2,clock=0,alpha=94},
    [487]={boardX=7652868,boardY=15516070,boardVX=-14844,boardVY=46848,kind=18,phase=24,clock=1,alpha=157},
    [43]={boardX=11362472,boardY=15511678,boardVX=24744,boardVY=42456,kind=18,phase=24,clock=1,alpha=157},
}
local sparks={}
for o in pairs(run.exhaustSparks) do
    expect(o,assert(reference[o.angle]));sparks[#sparks+1]=o
    o.class.frame(o);assert(o.alpha==reference[o.angle].alpha,'尾气在出生步重复积分')
end
assert(#sparks==4)
exhaust.detach(host)
for _,node in ipairs(host.exhaustNodes) do assert(not IsValid(node)) end
assert(run.exhaustCount==4,'卸载节点错误地删除了已发出的粒子')
for _=1,52 do
    run.serial=run.serial+1
    for _,o in ipairs(sparks) do if IsValid(o) then o.class.frame(o) end end
end
assert(run.exhaustCount==0 and not next(run.exhaustSparks))

-- 0x31 的两份原版出生记录：第 6804 帧的 15 类、第 6810 帧的 0 类。
-- 分开控制一次节点分配，保留原版随机角及首格，再运行到实际回收步。
for _,sample in ipairs({
    {9499652,24592384,{0,54},482,51,
        {boardX=7646956,boardY=25686812,boardVX=-17688,boardVY=45852,kind=15,phase=24,clock=1,alpha=157},
        {boardX=6762556,boardY=27979412,phase=0,clock=1,alpha=7}},
    {9489236,23904256,{1,0,3},24,33,
        {boardX=7668496,boardY=24999860,boardVX=14268,boardVY=47028,kind=0,phase=4,clock=2,alpha=124},
        {boardX=8125072,boardY=26504756,phase=14,clock=1,alpha=0}},
}) do
    local skimmer={run=run,boardX=sample[1],boardY=sample[2],angle=256}
    exhaust.attach(skimmer,0)
    assert(#skimmer.exhaustNodes==2)
    skimmer.exhaustNodes[1].spawnClock,skimmer.exhaustNodes[2].spawnClock=0,1000
    choices=sample[3];exhaust.step(skimmer)
    local particle=assert(next(run.exhaustSparks))
    expect(particle,sample[6]);assert(particle.angle==sample[4])
    for _=2,sample[5] do step(particle) end
    expect(particle,sample[7]);assert(not IsValid(particle) and run.exhaustCount==0)
    exhaust.detach(skimmer)
end
for _=1,33 do
    for _,node in ipairs(host.exhaustNodes) do node.spawnClock=0 end
    exhaust.step(host)
end
assert(run.exhaustCount==128,'尾气没有遵守 128 槽上限')
exhaust.close(run)
exhaust.close(run);power.close(run)
state.power,state.bombs=7,3;run.roadRank,run.roadRankTime=nil,nil
assert(rank.get(run)==38+math.floor((run.roadFrame+129)/512))
state.bombs=2;run.roadRank=nil
assert(rank.get(run)==34+math.floor((run.roadFrame+129)/512))
-- 六次自然受击的原版计时：先截掉低四位再乘 15；本步 rank 保持锁存值。
for _,row in ipairs({{926,855},{1499,1395},{1731,1620},{2036,1905},{2247,2100},{2466,2310}}) do
    run.roadRankTime,run.roadRank=row[1],31
    rank.hit(run)
    assert(run.roadRankTime==row[2] and rank.get(run)==31)
    rank.advance(run)
    assert(run.roadRankTime==row[2]+1)
end
print('Futari 1.5 尾气挂载、原版粒子状态、P 反弹、两类拾取、rank 与回收通过')
