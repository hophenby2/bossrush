-- 关底共享血量对照真实受弹回调；另外覆盖过量伤害、无敌、超时和六盒原生对象生命周期。
function Class(_,c)return c end
local objects={}
function New(c,...)local o={class=c};c.init(o,...);objects[#objects+1]=o;return o end
object={RawDel=function(o)o.deleted=true end}
GROUP,LAYER={GHOST=0,ENEMY=2},{ENEMY=-600}
local core=dofile('mod/GAME/th46/boss1_core.lua')
local unit=65536
local p={pilotPosition={x=120*unit,y=100*unit}}
local run={serial=0}
local requests={}
local o=core.create(run,p,function(_,kind,event,cause)requests[#requests+1]={kind,event,cause}end)
assert(#o.boxes==6 and #objects==7 and o.maxhp==170752 and o.warningHP==16704)
local hits=dofile('tools/cv1000/fixtures/futari15_boss1_core.lua')
local changes,defeats=0,0
for i,r in ipairs(hits)do
    o.hp,o.phase,o.invulnerable=r[2],r[3],r[4]~=0
    o.mode,o.enabled,o.request='fight',true,nil
    local box=o.boxes[(i-1)%6+1]
    box.damage(box,r[5],{damageFlags=r[6]})
    assert(o.hp==r[7] and o.phase==r[8] and o.invulnerable==(r[9]~=0),'第 '..r[1]..' 帧受弹结果与原版不符')
    assert(o.hitMark)
    for _,b in ipairs(o.boxes)do assert(b.hp==o.hp)end
    if o.request=='change'then changes=changes+1 elseif o.request=='defeat'then defeats=defeats+1 end
end
assert(changes==1 and defeats==1 and #requests==2)

local function fresh()
    requests={};o=core.create(run,p,function(_,kind,event,cause)requests[#requests+1]={kind,event,cause}end)
    core.enable(o,true)
    return o.boxes[1]
end
local b=fresh()
o.hp=66817;b.damage(b,1)
assert(o.hp==66816 and o.phase==1 and o.enabled and o.invulnerable and o.request=='change')
b.damage(b,999999);assert(o.hp==66816 and #requests==1)
core.resume(o);assert(o.mode=='fight' and not o.invulnerable and o.enabled)
b.damage(b,66816);assert(o.hp==0 and o.mode=='defeat' and #requests==2)
for _,box in ipairs(o.boxes)do assert(not box.colli)end
b.damage(b,1);assert(#requests==2)
core.close(o);core.close(o)
assert(o.deleted)
for _,box in ipairs(o.boxes)do assert(box.deleted and not box.colli)end

b=fresh();b.damage(b,2147483647)
assert(o.hp==66816 and o.request=='change','过量伤害不得穿透到下一段')
core.resume(o);core.advance(o,false,true)
b.damage(b,66817);assert(o.hp==512 and o.mode=='fight' and not o.invulnerable)
core.advance(o,false,false);b.damage(b,512);assert(o.mode=='defeat')

b=fresh();o.invulnerable=true;o.hitMark=false;b.damage(b,200000)
assert(o.hp==170752 and o.hitMark and #requests==0)
o.invulnerable=false
local clock=o.phaseClock;core.advance(o,true)
assert(o.phaseClock==clock)
for _=1,18000 do core.advance(o,false)end
assert(o.phaseClock==0 and o.mode=='fight')
core.advance(o,false)
assert(o.mode=='change' and o.hp==66816 and not o.enabled and requests[1][3]=='timeout')
local final=o.finalClock;for _=1,35 do core.advance(o,false)end
assert(o.finalClock==final)
core.resume(o)
for _=1,18001 do core.advance(o,false,true)end
assert(o.finalClock==300 and o.mode=='fight')
for _=1,301 do core.advance(o,false,false)end
assert(o.mode=='defeat' and requests[2][3]=='timeout')

b=fresh()
local points={}
for i=1,6 do points[i]={(60+i*10)*unit+32768,(170+i*10)*unit+32768}end
core.sync(o,points)
for _,box in ipairs(o.boxes)do
    local point=points[box.shape[1]+1]
    assert(box.colli and box.rect and box.group==GROUP.ENEMY and not box.bound)
    assert(box.boardX==point[1] and box.boardY==point[2])
    assert(box.x==math.floor(point[1]/unit)-120 and box.y==math.floor(point[2]/unit)-160)
    p.pilotPosition.x=point[1]+(box.shape[3]+2)*unit
    p.pilotPosition.y=point[2]+unit
    assert(box.hitPilot(box,p))
    p.pilotPosition.x=p.pilotPosition.x+unit;assert(not box.hitPilot(box,p))
    p.pilotPosition.x=point[1];p.pilotPosition.y=point[2]+(box.shape[4]+3)*unit
    assert(box.hitPilot(box,p))
    p.pilotPosition.y=p.pilotPosition.y+unit;assert(not box.hitPilot(box,p))
end
local shot={dmg=100,colli=true};b.class.colli(b,shot)
assert(shot.deleted and not shot.colli and o.hp==170652)
for _,box in ipairs(o.boxes)do box.class.colli(box,shot)end
assert(o.hp==170652,'重叠的六个受弹盒不得让一颗普通自弹重复扣血')
core.enable(o,false);shot={dmg=100,colli=true};b.class.colli(b,shot)
assert(not shot.deleted and o.hp==170652)
core.close(o)

-- 本体按构造器写入，出生时不能拿战斗中段的采样状态垫底。
local body=dofile('mod/GAME/th46/boss1_body.lua')
local birth=dofile('tools/cv1000/fixtures/futari15_boss1_birth.lua')
local host=body.create(run,p,birth.camera)
local birthHash=0
for _,field in ipairs(birth.fields)do birthHash=(birthHash*131+assert(host.raw[field[1]]))%16777213 end
assert(birthHash==birth.hash,'原版本体出生字段不符')
assert(host.renderDepth==birth.depth,'原版本体出生深度不符')
host.boxes[1].damage(host.boxes[1],170752-66816+1)
assert(host.raw[0x22ec]==1 and host.raw[0x1ffc]==66816,'换段通知没有同步本体血量')
body.syncHealth(host)
assert(host.raw[0x22ec]==1 and host.raw[0x1ffc]==66816)
local driver=body.motion.create(host,'simple_init')
body.close(host);body.close(host)
assert(host.deleted and driver.deleted and not host.motion)
for _,box in ipairs(host.boxes)do assert(box.deleted)end

-- 完整连射寿命对照原版：独立发弹探针同时覆盖自机当步受击前的瞄准顺序。
local guns=dofile('mod/GAME/th46/boss1_guns.lua')
local function hash(h,row)for _,n in ipairs(row)do h=(h*131+n)%16777213 end;return h end
local fields={
    head={'pauseClock','pause','shotClock','shotInterval','remaining','count','angle','kind','speed','pairs'},
    burst={'pauseClock','pause','shotClock','shotInterval','remaining','count','kind','speed','baseSpeed'},
    side={'pauseClock','pause','shotClock','shotInterval','remaining','count','waves','kind','speed','baseSpeed','side','sideClock','extraPairs'},
}
local totalStates,totalShots=0,0
for _,case in ipairs(dofile('tools/cv1000/fixtures/futari15_boss1_guns.lua'))do
    local shotHash,shotCount,stateHash=0,0,0
    run={serial=case.first}
    local host={run=run,player={pilotPosition={}}}
    local function emit(r,x,y,a,v,kind,count,spread)
        shotCount=shotCount+1;shotHash=hash(shotHash,{r.serial,x,y,a,v,kind,count or 1,spread or 0})
    end
    local gun
    if case.kind=='head'then gun=guns.head(host,emit)
    elseif case.kind=='burst'then gun=guns.burst(host,emit,case.config[1],case.config[2])
    else
        local c=case.config
        gun=guns.side(host,emit,{delay=c[1],pause=c[2],waves=c[3],speed=c[4]+2},c[5])
    end
    for i,input in ipairs(case.inputs)do
        run.serial=case.first+i-1
        host.boardX,host.boardY=input[1],input[2]
        host.player.pilotPosition.x,host.player.pilotPosition.y=input[3],input[4]
        host.player.respawn=input[5]
        if i==#case.inputs and case.kind=='head'then guns.stop(gun)end
        gun.class.frame(gun)
        if i<=case.states then
            assert(not gun.closed)
            local row={run.serial};for _,f in ipairs(fields[case.kind])do row[#row+1]=gun[f]end
            stateHash=hash(stateHash,row)
        end
    end
    assert(stateHash==case.stateHash,'原版 '..case.kind..' 计时/转向状态不符')
    assert(shotCount==case.shots and shotHash==case.shotHash,'原版 '..case.kind..' 发弹参数不符：'..shotHash..' / '..case.shotHash)
    assert(gun.closed and gun.deleted and not next(run.boss1Guns))
    guns.close(run);assert(not run.boss1Guns)
    totalStates,totalShots=totalStates+case.states,totalShots+case.shots
end
assert(totalStates==1050 and totalShots==192)
print('Futari 1.5 关底 474 次受弹、六盒判定、1050 份炮台状态和 192 组原版发弹参数通过')
