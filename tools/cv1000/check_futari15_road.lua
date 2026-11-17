-- 对照 MAME 0.275 的飞虫挂载与首发敌弹，关键帧回归可脱离模拟器运行。
local reference = {
    [5485]={0x00320000,0x01600000,256,35,0},
    [5488]={0x00310000,0x01570000,248,32,1},
    [5510]={0x00393290,0x011b5370,203,10,3},
    [5521]={0x004d0090,0x0100f000,204,35,0},
    [5524]={0x00545d10,0x00f9b5f0,209,32,1},
    [5556]={0x0077fcc0,0x009e1310,256,0,0},
    [5557]={0x0077fcc0,0x009b1310,256,35,0},
    [5615]={0x0077fcc0,-0x0012ecf0,256,13,2},
}

local function check(run, p, step, hit, findShot)
    p.pilotPosition.y = 132*65536
    local shot
    for frame = 5485, 5616 do
        step(frame-5430,{
            right=frame>=5486 and frame<=5505,
            left=frame>=5521 and frame<=5540,
            up=frame>=5551 and frame<=5570,
        })
        local actor = run.roadEnemies[1]
        local expected = reference[frame]
        if expected then
            assert(actor and actor.boardX==expected[1] and actor.boardY==expected[2] and actor.heading==expected[3]
                and actor.aimClock==expected[4] and actor.wing==expected[5],
                ('第 %d 帧道中对象状态不符'):format(frame))
        end
        if frame==5521 then
            shot = assert(findShot())
            assert(shot.boardX==0x00526290 and shot.boardY==0x00fab9c0)
            assert(shot.boardVX==0x20c38 and shot.boardVY==-0x2c29f)
            local x,y = shot.boardX,shot.boardY
            assert(shot.hitPilot(shot,{pilotPosition={x=x+2*65536,y=y+65536}}))
            assert(not shot.hitPilot(shot,{pilotPosition={x=x+3*65536,y=y+65536}}))
        elseif frame==5523 then
            assert(shot.boardX==0x00577b00 and shot.boardY==0x00f53482)
        elseif frame==5544 or frame==5560 then
            local second = frame==5544
            local bug = assert(run.roadEnemies[second and 2 or 3])
            assert(bug.boardX==(second and 180 or 220)*65536 and bug.boardY==352*65536)
        elseif frame==5556 then
            assert(actor.hitPilot(actor,p) and not shot.hitPilot(shot,p))
            hit()
            assert(p.respawn==80 and IsValid(shot) and not shot.fade)
        elseif frame==5557 then
            assert(shot.boardX==0x00ae1a70 and shot.boardY==0x00975b64)
        elseif frame==5589 or frame==5609 then
            local first = frame==5589
            local bug = assert(run.roadEnemies[first and 4 or 5])
            assert(bug.boardX==(first and 130 or 173)*65536 and bug.boardY==368*65536)
            assert(bug.speed==52 and bug.heading==256)
            if first then assert(IsValid(shot) and shot.boardX==0x00efa170) end
        elseif frame==5590 then
            assert(not IsValid(shot))
        end
    end
    assert(not IsValid(run.roadEnemies[1]))
end

local function checkWaves(run, step, findShot, cancel)
    local births = {
        [198]={{6,215,363,52}}, [409]={{7,136,368,52}}, [425]={{8,199,368,52}}, [441]={{9,162,368,52}},
        [505]={{10,-12,393},{11,76,401},{12,21,352}}, [537]={{13,45,352}},
        [1913]={{21,150,368,52}}, [1929]={{22,176,368,52}}, [1945]={{23,205,368,52},{24,146,407,52}},
        [2329]={{25,151,352},{26,220,368,52}}, [2345]={{27,180,352},{28,135,368,52}},
        [2361]={{29,199,368,52}}, [2377]={{30,145,368,52}}, [2393]={{31,180,352}},
        [2409]={{32,202,352}}, [2425]={{33,223,352}}, [2438]={{34,250,352}},
    }
    local cancelled
    for frame = 187, 2439 do
        step(frame,{})
        for _, birth in ipairs(births[frame] or {}) do
            local bug=assert(run.roadEnemies[birth[1]],'缺少原程序挂载的飞虫')
            assert(bug.boardX==birth[2]*65536 and bug.boardY==birth[3]*65536)
            assert(bug.hp==64 and bug.heading==256 and bug.aimClock==35)
            assert(bug.speed==(birth[4] or 48))
        end
        if frame==236 then
            local bug=assert(run.roadEnemies[4])
            assert(bug.speed==0 and bug.retreat and bug.boardY==0x00efa000 and bug.aimClock==16)
        elseif frame==264 then
            local bug=assert(run.roadEnemies[4])
            assert(bug.speed==14 and bug.retreat and bug.aimClock==16)
        elseif frame==486 then
            local bug=assert(run.roadEnemies[7])
            assert(bug.speed==0 and bug.retreat and bug.boardY==0x00efa000)
        elseif frame==505 then
            local bug=run.roadEnemies[12]
            bug.damage(bug,64)
        elseif frame==506 then
            assert(IsValid(run.roadEnemies[10]) and IsValid(run.roadEnemies[11]))
            assert(not IsValid(run.roadEnemies[12]))
        elseif frame==746 then
            local worm=assert(run.worm)
            assert(worm.hp==3456 and worm.auxX==13432480 and worm.auxY==29495236)
            assert(worm.firstX==205 and worm.firstY==413 and worm.midX==210 and worm.midY==431)
            worm.damage(worm,3457)
            assert(worm.hp==3456 and not run.wormGate)
        elseif frame==1092 then
            assert(not run.wormGate and run.worm.baseY==240*65536)
        elseif frame==1093 then
            assert(run.wormGate and run.worm.facing==382)
            assert(run.worm.auxX==13452916 and run.worm.auxY==22561792)
        elseif frame==1129 and findShot then
            assert(#run.data.shots[1132]==0 and #run.data.shots[1198]==0)
            local first=assert(findShot(0x00943440,0x01339cc0))
            assert(first.bank=='worm_shot' and first.age==0 and first.colli)
            assert(first.boardVX==-0x1dded and first.boardVY==-0x29535)
        elseif frame==1156 then
            assert(run.worm.facing==256 and run.worm.auxSpeed==8)
        elseif frame==1178 and cancel then
            cancelled=assert(findShot(0x00775e08,0x00b59500))
            cancel(cancelled)
            assert(cancelled.cancelFrame==0 and not cancelled.colli)
        elseif frame==1179 and cancelled then
            assert(cancelled.cancelFrame==1 and cancelled.boardX==0x0076ec7b and cancelled.boardY==0x00b42ea0)
        elseif frame==1209 and cancelled then
            assert(cancelled.cancelFrame==31 and IsValid(cancelled))
        elseif frame==1210 and cancelled then
            assert(not IsValid(cancelled))
        elseif frame==1657 then
            assert(run.wormGate)
            for i=14,20 do assert(not IsValid(run.roadEnemies[i])) end
        elseif frame==1796 then
            assert(not IsValid(run.worm) and not run.wormGate)
        end
    end
    assert(run.nextRoadSpawn==35)
end

local function checkLateWaves(run, p, step, findShot)
    local births = {
        [4526]={{40,81,368}}, [4542]={{41,34,368}}, [4590]={{42,220,368}}, [4606]={{43,180,368}},
        [4622]={{44,136,368}}, [4782]={{45,36,397},{46,96,368}}, [4798]={{47,77,386}}, [4814]={{48,13,368}},
        [4990]={{49,140,368},{50,204,391}}, [5006]={{51,171,374}}, [5022]={{52,218,368}},
    }
    p.pilotPosition.y = 182*65536
    for frame = 2440, 5023 do
        step(frame,{})
        for _, birth in ipairs(births[frame] or {}) do
            local bug=assert(run.roadEnemies[birth[1]],'缺少末段飞虫')
            assert(bug.boardX==birth[2]*65536 and bug.boardY==birth[3]*65536)
            assert(bug.hp==64 and bug.speed==52 and bug.aimClock==34)
        end
        if frame==3517 then
            local worm=assert(run.worm)
            assert(worm.hp==3456 and worm.facing==128 and worm.baseY==410*65536)
            assert(worm.auxX==4536992 and worm.auxY==31264708 and not run.wormGate)
        elseif frame==3689 then
            local worm=assert(run.worm)
            assert(run.wormGate and worm.facing==130 and worm.baseY==239*65536)
        elseif frame==3716 then
            assert(#run.data.shots[3876]==0 and #run.data.shots[3924]==0 and #run.data.shots[4085]>0)
            local shot=assert(findShot(0x006d7040,0x01390500),'缺少第二只蜈蚣第 9146 帧的敌弹')
            assert(shot.bank=='worm_shot' and shot.age==0 and shot.boardVX==0x28347 and shot.boardVY==-0x1f608)
        elseif frame==3752 then
            assert(run.worm.facing==256 and run.worm.auxSpeed==8)
        elseif frame==4174 then
            assert(run.wormGate)
            for i=35,39 do assert(not IsValid(run.roadEnemies[i])) end
        elseif frame==4341 then
            assert(not IsValid(run.worm) and not run.wormGate)
        elseif frame==4561 then
            local shot=assert(findShot(0x005487c0,0x01104e00),'缺少原版第 9991 帧发弹')
            assert(shot.boardVX==0x156c8 and shot.boardVY==-0x33bc0 and shot.age==0)
        elseif frame==4562 then
            local shot=assert(findShot(0x0055de88,0x010d1240),'原版第 9992 帧的弹槽位置不符')
            assert(shot.age==1)
        end
    end
    assert(run.nextRoadSpawn==53)
end

local function checkDefeatedWorm(run, step, strike)
    local lastFanCount
    for frame = 0, 1657 do
        step(frame,{})
        if frame==1194 then
            local worm=assert(run.worm)
            assert(worm.hp==3456 and worm.colli and run.wormGate)
            strike(worm,3471)
            assert(worm.hp==-15 and not worm.colli and run.wormGate)
            lastFanCount=worm.fanCount
        elseif frame==1316 then
            assert(IsValid(run.worm) and run.wormGate and run.worm.fanCount==lastFanCount)
        elseif frame==1317 then
            assert(not IsValid(run.worm) and not run.wormGate)
        end
    end
    for i=14,16 do assert(not IsValid(run.roadEnemies[i])) end
    -- 前两只直飞，后一对走带减速的 0x13，挂载时按当前横向卷轴扣除偏移。
    assert(run.nextRoadSpawn==21)
    assert(run.roadEnemies[17].boardY<352*65536)
    assert(run.roadEnemies[20].boardX==(155-run.roadCamera)*65536)
    assert(run.roadEnemies[20].boardY==368*65536)

    local births = {
        [4126]={{35,140,368}}, [4142]={{36,126,398},{37,177,368}},
        [4158]={{38,214,368}}, [4174]={{39,146,368}},
    }
    for frame = 1658, 4174 do
        step(frame,{})
        if frame==3837 then
            local worm=assert(run.worm)
            assert(worm.colli and run.wormGate and worm.hp==3456)
            strike(worm,3523)
            assert(worm.hp==-67 and not worm.colli)
            lastFanCount=worm.fanCount
        elseif frame==3959 then
            assert(IsValid(run.worm) and run.wormGate and run.worm.fanCount==lastFanCount)
        elseif frame==3960 then
            assert(not IsValid(run.worm) and not run.wormGate)
        end
        for _, birth in ipairs(births[frame] or {}) do
            local bug=assert(run.roadEnemies[birth[1]],'第二只蜈蚣击破后未挂载飞虫')
            assert(bug.boardX==(birth[2]-run.roadCamera)*65536 and bug.boardY==birth[3]*65536)
            assert(bug.hp==64 and bug.speed==52)
        end
    end
end

if arg and arg[1]=='--luastg' then return check,checkWaves,checkLateWaves,checkDefeatedWorm end

function Class(_,methods) return methods end
function IsValid(o) return o and not o.deleted end
function CheckRes() return true end
object = {RawDel=function(o) o.deleted=true end}
GROUP = {GHOST=0,ENEMY=1,ENEMY_BULLET=2}
LAYER = {ENEMY=1,ENEMY_BULLET=2}
ran = {Int=function(_,a) return a==36 and 42 or 2 end}
local shots = {}
local draws, imageAlpha = {}, {}
function SetImageState(image,blend,alpha)
    imageAlpha[image] = {blend,alpha}
end
function Render(image,x,y,_,flipX,flipY)
    draws[#draws+1] = {image,x,y,flipX,flipY,unpack(imageAlpha[image])}
end
function New(class,...)
    local o={class=class}
    class.init(o,...)
    if o.group==GROUP.ENEMY_BULLET then
        shots[#shots+1]=o
    end
    return o
end
lstg = {LoadTextFile=function(path)
    local file=assert(io.open(path,'rb'))
    local data=file:read('*a')
    file:close()
    return data
end}
local road = dofile('mod/GAME/th46/road1.lua')()
local pilot = dofile('mod/GAME/th46/pilot.lua')
local p = {respawn=0}
local run = {stageNumber=1,serial=0,data=dofile('mod/GAME/pgm/source.lua')('th46').load(1)}
pilot.spawn(p)
road.open(run)
assert(#run.data.enemies[94]==0)
assert(#run.data.enemies[219]==0)
for _, key in ipairs({{4684,1298},{4947,1395}}) do
    for _, entry in ipairs(run.data.enemies[key[1]] or {}) do assert(entry.id~=key[2]) end
end
road.attach(run,p)
local verifyShotRender = true
local function step(frame,keys)
    run.serial,run.roadFrame=run.serial+1,frame
    if p.respawn==0 then
        pilot.move(p,keys)
    else
        p.respawn=p.respawn-1
        if p.respawn==0 then pilot.spawn(p) else pilot.fall(p) end
    end
    run.roadClock.class.frame(run.roadClock)
    for _, shot in ipairs(shots) do
        if IsValid(shot) then shot.class.frame(shot) end
    end
    if verifyShotRender and (frame==91 or frame==93) then
        draws={}
        local shot=assert(shots[1])
        shot.class.render(shot)
        if frame==91 then
            assert(#draws==1 and draws[1][1]=='th46_road1_flash_6_0' and draws[1][2]==-38 and draws[1][3]==90)
        else
            local trail=assert(draws[2])
            assert(draws[1][1]=='th46_road1_shot_6_1' and draws[1][3]==85)
            assert(trail[2]==-35 and trail[3]==87 and trail[4]==1 and trail[5]==-1)
            assert(trail[6]=='mul+add' and trail[7]==58 and imageAlpha[trail[1]][1]=='')
        end
    end
end
check(run,p,step,function() p.respawn=80 end,function() return shots[1] end)
local function findShot(x,y)
    for _, shot in ipairs(shots) do
        if IsValid(shot) and shot.boardX==x and shot.boardY==y then return shot end
    end
end
checkWaves(run,step,findShot,function(o) o.cancelOnContact(o) end)
checkLateWaves(run,p,step,findShot)
road.close(run)
verifyShotRender,shots=false,{}
run.serial,run.roadFrame=0,nil
pilot.spawn(p)
road.open(run)
road.attach(run,p)
checkDefeatedWorm(run,step,function(worm,damage)
    local shot={dmg=damage,colli=true}
    worm.class.colli(worm,shot)
    assert(shot.deleted)
end)
road.close(run)
print('Futari 1.5 第一面 52 条飞虫指令、两只蜈蚣的位移、发弹、碰撞与禁入状态通过')
