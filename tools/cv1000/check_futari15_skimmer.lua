-- 原版第 6799–8431 帧的 0x31 回归：移动及振动历史校验和、交替炮、两块判定与六份爆炸。
function Class(_,c) return c end
function New(c,...) local o={class=c};c.init(o,...);objects[#objects+1]=o;return o end
function IsValid(o) return o and not o.deleted end
function CheckRes() return true end
object={RawDel=function(o) o.deleted=true end}
GROUP,LAYER={GHOST=0,ENEMY=2,ITEM=6},{ENEMY=-600,ITEM=-300}
lstg={var={score=0}}
objects={}
local angles={}
ran={Int=function(_,a,b) if b==31 then return table.remove(angles,1) or 15 end;return math.floor((a+b)/2) end}
local create=dofile('mod/GAME/th46/skimmer.lua')
local data=dofile('mod/GAME/th46/skimmer_data.lua')
local exhaust=dofile('mod/GAME/th46/exhaust.lua')
local unit=65536
local module,emissions,run,p
local function setup(stage)
    objects,emissions={},{}
    module=create(function(r,x,y,a,v,k) emissions[#emissions+1]={r.roadFrame,x,y,a%512,v,k} end)
    run={serial=0,roadFrame=0,roadCamera=0,roadCameraDelta=0,data=stage}
    p={run=run,respawn=0,protect=255,laser=false,pilotPosition={x=120*unit,y=50*unit}}
    run.roadClock={player=p}
    module.open(run)
end
local function step(frame)
    run.serial,run.roadFrame=run.serial+1,frame
    -- 代入原版记录中的 rank，独立验证本类；全局计时与受击缩减由关卡及自机层负责。
    run.roadRank=frame<1649 and 26 or frame<2403 and 27 or 28
    module.step(run,frame,p)
    for _,o in ipairs(objects) do if IsValid(o) and o.class.frame then o.class.frame(o) end end
end
local function close()
    module.close(run);exhaust.close(run)
end
local function waveHash(o)
    local hash=0
    for at=0xb8,0x2f4,4 do hash=(hash*131+o.rawWaves[at])%16777213 end
    for _,point in ipairs(o.history) do for _,value in ipairs(point) do hash=(hash*131+value)%16777213 end end
    return hash
end
local reference={
    [1369]={9502720,25165824,28,2,32,48,0,7,68,0,11273356},
    [1370]={9502516,25051136,28,2,31,47,1,7,67,0,3928896},
    [1401]={9396128,21495808,28,2,0,16,8,7,36,0,15595060},
    [1438]={9038319,17989632,16,10,3,0,8,10,32,1,2699100},
    [1455]={8807569,17145856,10,14,4,0,2,2,32,1,10582098},
    [1475]={8500537,16392192,9,16,0,0,7,8,22,0,13999599},
}
setup()
local first,born,seen={}, {},{}
for frame=0,3100 do
    step(frame)
    for o in pairs(run.roadSkimmers) do
        if not seen[o] then born[#born+1]=o.zone;seen[o]=true end
        if o.zone==190 then first=o end
    end
    if reference[frame] then
        local values={first.boardX,first.boardY,first.speed,first.programIndex-1,first.programClock,
            first.protect,first.gunFrame,first.wingFrame,first.fireClock,first.mode,waveHash(first)}
        for i,value in ipairs(values) do assert(value==reference[frame][i],frame..' 原版状态 '..i..' 不符') end
    end
    if frame==1777 or frame==1781 then assert(first.tintB==255) end
    if frame==1779 then assert(first.tintR==255 and first.tintG==255 and first.tintB==0,'原版受伤闪色相位不符') end
end
assert(#born==4 and born[1]==190 and born[2]==205 and born[3]==235 and born[4]==254,'九条指令的禁入分支不符')
assert(not next(run.roadSkimmers) and run.skimmerGate,'退场错误地解除了原版保留的禁入状态')
local expected={
    {1438,7072239,17924096,251,8,25},{1438,7072239,17924096,255,8,25},
    {1438,11004399,17924096,274,8,25},{1438,11004399,17924096,270,8,25},
    {1455,8807569,16097280,263,10,18},{1460,8733804,15896576,263,10,18},
    {1465,8657850,15712256,262,10,18},
}
assert(#emissions==84)
for i,row in ipairs(expected) do for j,v in ipairs(row) do assert(emissions[i][j]==v,'首组原版发弹不符') end end
close()

-- 两个矩形共享血量，接触伤害在保护中仍按原版每两步结算；不能依赖射击键。
setup()
for frame=0,1700 do step(frame) end
local contact
for o in pairs(run.roadSkimmers) do if o.zone==205 then contact=o end end
assert(contact and contact.hp==832)
p.pilotPosition.x,p.pilotPosition.y=contact.boardX,contact.boardY-29*unit
for frame=1701,1710 do step(frame) end
assert(contact.hp==827 and contact.boxes[1].hp==827 and contact.boxes[2].hp==827)
local hp=contact.hp
for _,box in ipairs(contact.boxes) do box.class.frame(box) end
assert(contact.hp==hp,'同一逻辑步重复结算接触伤害')
close()

setup()
step(1369)
local target=assert(next(run.roadSkimmers))
local function strike(box,amount,flags)
    local shot={colli=true,dmg=amount,damageFlags=flags}
    box.class.colli(box,shot)
    assert(not shot.colli and shot.deleted)
end
strike(target.boxes[1],9999)
assert(target.hp==832,'丢失出生保护')
for frame=1370,1439 do step(frame) end
assert(target.protect==0)
strike(target.boxes[1],100)
assert(target.hp==732 and target.boxes[2].hp==732 and target.boxes[1].run==run)
local left,top=math.floor(target.boardX/unit),math.floor(target.boardY/unit)
local function pilotAt(x,y) return {pilotPosition={x=x*unit,y=y*unit}} end
assert(target.boxes[1].hitPilot(target.boxes[1],pilotAt(left+34,top+34)))
assert(not target.boxes[1].hitPilot(target.boxes[1],pilotAt(left+35,top+34)))
assert(target.boxes[2].hitPilot(target.boxes[2],pilotAt(left+14,top-30)))
assert(not target.boxes[2].hitPilot(target.boxes[2],pilotAt(left+15,top-30)))
p.laser=true;angles={27,30,30};lstg.var.score=0
strike(target.boxes[2],836)
assert(target.hp==-104 and not target.boxes[1].colli and not target.boxes[2].colli)
assert(lstg.var.score==1800 and run.fragmentCount==8 and run.skimmerEffectCount==6)
target.boxes[1].damage(target.boxes[1],10)
assert(lstg.var.score==1800 and run.fragmentCount==8 and run.skimmerEffectCount==6,'重复结算击破')
local probe,count
count=0
for fx in pairs(run.skimmerEffects) do
    count=count+1
    assert(not fx.visible and fx.index==(fx.flags==10 and 1 or 4))
    if fx.kind==2 and fx.alpha==160 then probe=fx end
end
assert(count==6 and probe and probe.wait==3)
for fragment in pairs(run.roadFragments) do assert(not fragment.initialized) end
for frame=1440,1443 do step(frame) end
assert(probe.visible and probe.boardX==11141792 and probe.boardY==17669787,'原版延后启动与首次积分不符')
for frame=1444,1640 do step(frame) end
assert(run.skimmerEffectCount==0 and run.fragmentCount==0)
close()

-- 十像素的越页拆片单独出现时不能判成 0x31；只有同一对象还命中完整裁片才可辅助确认。
local function word(n) return string.char(math.floor(n/256)%256,n%256) end
local function pose(ids)
    local layers={}
    for _,id in ipairs(ids) do layers[#layers+1]=word(id)..word(0)..word(0) end
    return word(0)..word(0)..string.char(#ids)..table.concat(layers)
end
local full,part,tile=data.sampled.sprites[1][1],data.sampled.partialSprites[1][1],data.sampled.tiles[1][1]
local stage={
    enemies={[0]={{id=1,frames={pose({full,part})}},{id=2,frames={pose({part})}},{id=3,frames={pose({1})}}}},
    shots={[0]={{owner=1},{owner=2}}},
    backgrounds={[0]={0,0,{},word(tile)..word(0)..word(0)..word(1)..word(0)..word(0)}},
}
setup(stage)
assert(#stage.enemies[0]==2 and stage.enemies[0][1].id==2 and #stage.shots[0]==1 and stage.shots[0][1].owner==2)
assert(stage.backgrounds[0][4]==word(1)..word(0)..word(0),'误删了未匹配的地形')
close()
print('Futari 1.5 九条 0x31 指令、振动历史、交替炮、共享判定、接触伤害与击破回收通过')
