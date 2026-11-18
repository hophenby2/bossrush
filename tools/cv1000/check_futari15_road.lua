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
        [3588]={{44,202,368,56},{45,140,400,56}}, [3596]={{46,223,368,56}}, [3604]={{47,171,368,56}},
        [4526]={{53,81,368}}, [4542]={{54,34,368}}, [4590]={{55,220,368}}, [4606]={{56,180,368}},
        [4622]={{57,136,368}}, [4782]={{58,36,397},{59,96,368}}, [4798]={{60,77,386}}, [4814]={{61,13,368}},
        [4990]={{62,140,368},{63,204,391}}, [5006]={{64,171,374}}, [5022]={{65,218,368}},
    }
    p.pilotPosition.y = 182*65536
    for frame = 2440, 5023 do
        step(frame,{})
        for _, birth in ipairs(births[frame] or {}) do
            local bug=assert(run.roadEnemies[birth[1]],'缺少末段飞虫')
            assert(bug.boardX==birth[2]*65536 and bug.boardY==birth[3]*65536)
            assert(bug.hp==64 and bug.speed==(birth[4] or 52))
            assert(bug.aimClock==(birth[4] and 35 or 34))
        end
        if frame==2684 then
            local mid=assert(run.midBoss)
            assert(mid.hp==0x4c20 and not mid.boxes[1].colli and not run.midGate)
            assert(mid.boardX==0x00730000 and mid.boardY==0x01510000)
        elseif frame==2782 then
            local mid=assert(run.midBoss)
            assert(run.midGate and mid.boardX==0x008194b0 and mid.boardY==0x00fa7350)
        elseif frame==2784 then
            local mid=assert(run.midBoss)
            assert(mid.boardX==0x00815b88 and mid.boardY==0x00fa9014 and mid.wingFrame==1)
            assert(mid.boxes[1].colli and mid.joints[3].x==36666 and mid.joints[3].y==-121360)
        elseif frame==2885 then
            local mid=assert(run.midBoss)
            assert(mid.boardX==0x00608e6d and mid.boardY==0x01168cab and mid.speed==0)
        elseif frame==3047 then
            local mid=assert(run.midBoss)
            local d=dofile('mod/GAME/th46/direction.lua')
            local y=mid.boardY-24*d.unit
            for side=-1,1,2 do
                local x=mid.boardX+side*68*d.unit
                local aim=side==-1 and mid.leftWingAim or mid.rightWingAim
                for offset=-32,32,32 do
                    local angle=(aim+offset)%512
                    local vx,vy=d.vector(64,angle)
                    local shot=assert(findShot(x+vx,y+vy),'缺少第一段双翼扇弹')
                    local sx,sy=d.vector(53,angle)
                    assert(shot.age==0 and shot.boardVX==sx and shot.boardVY==sy)
                end
            end
        elseif frame==3185 then
            local mid=assert(run.midBoss)
            local d=dofile('mod/GAME/th46/direction.lua')
            local y=mid.boardY+16*d.unit
            for side=-1,1,2 do
                local x=mid.boardX+side*24*d.unit
                local aim=d.heading(x,y,p.pilotPosition.x,p.pilotPosition.y)
                for offset=-6,6,4 do
                    local angle=(aim+offset)%512
                    local vx,vy=d.vector(64,angle)
                    local shot=assert(findShot(x+vx,y+vy),'缺少第二段 0x19 敌弹')
                    local sx,sy=d.vector(51,angle)
                    assert(shot.bank=='thin_shot' and shot.age==0 and shot.boardVX==sx and shot.boardVY==sy)
                end
            end
        elseif frame==3192 then
            local mid=assert(run.midBoss)
            local d=dofile('mod/GAME/th46/direction.lua')
            local x,y=mid.boardX,mid.boardY-24*d.unit
            local aim=d.heading(x,y,p.pilotPosition.x,p.pilotPosition.y)
            assert(mid.phase==2)
            for i, delta in ipairs({-72,40,-40,72}) do
                local angle=(aim+delta)%512
                local vx,vy=d.vector(64,angle)
                local shot=assert(findShot(x+(i<=2 and -68 or 68)*d.unit+vx,y+vy),'缺少横翼敌弹')
                local speedX,speedY=d.vector(47,angle)
                assert(shot.age==0 and shot.boardVX==speedX and shot.boardVY==speedY)
            end
        elseif frame==3517 then
            local worm=assert(run.worm)
            assert(worm.hp==3456 and worm.facing==128 and worm.baseY==410*65536)
            assert(worm.auxX==4536992 and worm.auxY==31264708 and not run.wormGate)
        elseif frame==3580 then
            assert(run.nextRoadSpawn==44 and run.midGate)
            for i=35,43 do assert(not IsValid(run.roadEnemies[i])) end
        elseif frame==3585 then
            local mid=assert(run.midBoss)
            assert(not run.midGate and mid.mode=='retreat' and not mid.boxes[1].colli)
        elseif frame==3596 then
            local bug=assert(run.roadEnemies[45])
            assert(bug.boardX==0x008c0000 and bug.boardY==0x01752000 and bug.speed==50)
            assert(bug.aimClock==27 and bug.heading==256)
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
            for i=48,52 do assert(not IsValid(run.roadEnemies[i])) end
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
    assert(run.nextRoadSpawn==66)
end

local function checkMidDefeat(run,step,strike,findShot)
    local births={
        [3436]={{35,192,382},{36,129,368}}, [3452]={{37,228,368}}, [3460]={{38,150,367}},
        [3516]={{39,49,368}}, [3524]={{40,113,368}}, [3532]={{41,39,368}}, [3540]={{42,83,372}},
        [3580]={{43,147,368}},
    }
    for frame=0,3580 do
        step(frame,{})
        if frame==2866 and findShot then
            -- 原版第 8296 帧分配 0x13，角度 245，分配步走速度 64，后续速度为 55。
            local shot=assert(findShot(6507345,14597205),'缺少中 Boss 腹部首发')
            assert(shot.bank=='worm_shot' and shot.age==0 and shot.colli)
            assert(shot.boardVX==30305 and shot.boardVY==-223190)
        elseif frame==2872 and findShot then
            local shot=assert(findShot(6438397,14655219),'中 Boss 第二波腹部弹生成位置不符')
            assert(shot.age==0 and shot.boardVX==30856 and shot.boardVY==-227248)
        elseif frame==3137 then
            local mid=assert(run.midBoss)
            local part=mid.boxes[1]
            local x,y=part.boardX,part.boardY
            assert(part.hitPilot(part,{pilotPosition={x=x+10*65536,y=y+19*65536}}))
            assert(not part.hitPilot(part,{pilotPosition={x=x+11*65536,y=y+19*65536}}))
            assert(not part.hitPilot(part,{pilotPosition={x=x+10*65536,y=y+20*65536}}))
            strike(mid.boxes[2],0x100)
            assert(mid.hp==0x4b20 and mid.boxes[1].colli)
            strike(mid.boxes[3],mid.hp+1)
            assert(mid.hp==0 and mid.mode=='defeat' and run.midGate)
            for _,part in ipairs(mid.boxes) do assert(not part.colli) end
        elseif frame==3137+2 then
            local companions=0
            for effect in pairs(run.midEffects) do
                if effect.kind==11 and effect.birthFrame==frame then
                    assert(effect.visible and effect.wait==-1 and effect.alpha==112,'抬升爆炸的伴随粒子未当步启动')
                    companions=companions+1
                end
            end
            assert(companions==12 and run.fragmentCount==42)
        elseif frame==3137+8 then
            local count, fragments, delayed=0,0,0
            for effect in pairs(run.midEffects) do
                count=count+1
                if effect.kind==11 then fragments=fragments+1 end
                if effect.birthFrame==frame and effect.kind==2 then
                    assert(effect.wait==2 and effect.index==1,'零件爆炸末项的三步等待丢失')
                    delayed=delayed+1
                end
            end
            assert(run.midBoss.broken[4] and count>=10 and fragments>=5 and delayed==1)
        elseif frame==3137+44 then
            local mid=assert(run.midBoss)
            assert(mid.broken[1] and mid.broken[2] and mid.broken[3] and mid.broken[4] and run.midGate)
            local effects=0
            for effect in pairs(run.midEffects) do
                assert(effect.group==GROUP.GHOST and not effect.colli)
                effects=effects+1
            end
            assert(effects>=10 and effects<=160)
        elseif frame==3137+86 then
            assert(run.midGate)
        elseif frame==3137+87 then
            assert(not run.midGate and not run.midBoss.visible and run.midExplosionFrame==frame)
            local births,companions,ripples=0,0,0
            for effect in pairs(run.midEffects) do
                if effect.birthFrame==frame then
                    births=births+1
                    if effect.kind==11 then
                        local speed=math.sqrt(effect.boardVX^2+effect.boardVY^2)/4096
                        assert(effect.alpha==88 and effect.visible and math.floor(speed+0.5)==48,
                            '波纹伴随粒子的透明度、初速或等待时间不符')
                        companions=companions+1
                    elseif effect.kind==6 and effect.alpha==255 then
                        ripples=ripples+1
                    end
                end
            end
            assert(births==65 and companions==12 and ripples==12,'中 Boss 最终爆炸未按原表生成 65 个粒子')
            local fragments=0
            for fragment in pairs(run.roadFragments) do
                if fragment.birthFrame==frame then fragments=fragments+1 end
            end
            assert(fragments>0 and run.fragmentCount<=128,'最终爆炸碎片挂载或容量不符')
        end
        for _,birth in ipairs(births[frame] or {}) do
            local bug=assert(run.roadEnemies[birth[1]],'中 Boss 击破后飞虫未挂载')
            assert(bug.boardX==(birth[2]-run.roadCamera)*65536 and bug.boardY==birth[3]*65536)
            assert(bug.speed==(frame==3580 and 56 or 52))
        end
    end
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
        [4126]={{48,140,368}}, [4142]={{49,126,398},{50,177,368}},
        [4158]={{51,214,368}}, [4174]={{52,146,368}},
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

if arg and arg[1]=='--luastg' then return check,checkWaves,checkLateWaves,checkDefeatedWorm,checkMidDefeat end

function Class(_,methods) return methods end
function IsValid(o) return o and not o.deleted end
function CheckRes() return true end
object = {RawDel=function(o) o.deleted=true end}
GROUP = {GHOST=0,ENEMY=1,ENEMY_BULLET=2,ITEM=3,NONTJT=7}
LAYER = {ENEMY=1,ENEMY_BULLET=2,ITEM=3}
ran = {Int=function(_,a,b) return a==36 and 42 or math.floor((a+b)/2) end}
local shots = {}
function ObjList(group)
    local index=0
    return function()
        while index<#shots do
            index=index+1;local o=shots[index]
            if IsValid(o)and o.group==group then return index,o end
        end
    end
end
local particleClasses = {}
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
    if o.animation then particleClasses[o.kind]=class end
    return o
end
lstg = {LoadTextFile=function(path)
    local file=assert(io.open(path,'rb'))
    local data=file:read('*a')
    file:close()
    return data
end}
lstg.var={score=0}
local road = dofile('mod/GAME/th46/road1.lua')()
local pilot = dofile('mod/GAME/th46/pilot.lua')
local p = {respawn=0}
local run = {stageNumber=1,serial=0,data=dofile('mod/GAME/pgm/source.lua')('th46').load(1)}
pilot.spawn(p)
road.open(run)
for _,entries in pairs(run.data.enemies) do
    for _,entry in ipairs(entries) do assert(entry.id<92 or entry.id>96,'大型飞虫原生化后仍保留对应旧采样对象') end
end
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
    for effect in pairs(run.midEffects or {}) do
        if IsValid(effect) then effect.class.frame(effect) end
    end
    for effect in pairs(run.wormEffects or {}) do
        if IsValid(effect) then effect.class.frame(effect) end
    end
    for corpse in pairs(run.wormCorpses or {}) do
        if IsValid(corpse) then corpse.class.frame(corpse) end
    end
    for fragment in pairs(run.roadFragments or {}) do
        if IsValid(fragment) then fragment.class.frame(fragment) end
    end
    for item in pairs(run.roadGold or {}) do
        if IsValid(item) then item.class.frame(item) end
    end
    for effect in pairs(run.plantEffects or {}) do
        if IsValid(effect) then effect.class.frame(effect) end
    end
    for effect in pairs(run.flyEffects or {}) do
        if IsValid(effect) then effect.class.frame(effect) end
    end
    if verifyShotRender and frame==55 then
        draws={}
        run.roadShadows.class.render(run.roadShadows)
        assert(run.roadShadows.layer==LAYER.ENEMY-1 and #draws==1)
        assert(draws[1][1]=='th46_road1_shadow_0' and draws[1][2]==-46 and draws[1][3]==104)
        local bug=run.roadEnemies[1]
        local facing=bug.facing
        bug.facing=496
        draws={}
        run.roadShadows.class.render(run.roadShadows)
        assert(draws[1][1]=='th46_road1_shadow_1' and draws[1][4]==-1,'投影朝向折叠与镜像不符')
        bug.facing=facing
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
local function strike(target,damage)
    local shot={dmg=damage,colli=true}
    target.class.colli(target,shot)
    assert(shot.deleted)
end
checkDefeatedWorm(run,step,strike)
road.close(run)
run.serial,run.roadFrame,shots=0,nil,{}
pilot.spawn(p)
road.open(run)
road.attach(run,p)
checkMidDefeat(run,step,strike,findShot)
assert(not IsValid(run.midBoss),'中 Boss 控制对象在击破倒数后未回收')
-- 原版 8654 帧最终爆炸后，连续 82 次更新各隔一帧，8819 帧起恢复全速。
run.roadSlow={phase=0,enabled=true}
local updates=0
for elapsed=1,180 do
    local advancing=road.advance(run)
    assert(advancing==(elapsed>164 or elapsed%2==1),'中 Boss 击破减速的帧相位不符')
    if advancing then
        updates=updates+1
        if updates==82 then run.roadSlow.enabled=false end
    end
end
assert(updates==98 and not run.roadSlow,'中 Boss 击破减速未恢复')
-- 原版第 8575 帧的 0x0a 粒子与第 8579 帧的 0x05 粒子。动画分派表从 0x0c28bd50 开始。
local effectReference={
    {10,6298623,17405648,-23424,7422,4,0,6275199,17347534,5,0,0x128e},
    {5,5649317,17168590,-17370,32508,1,0,5631947,17135562,2,0,0x128b},
    {11,7515711,17994674,-117056,-58912,4,0,7398655,17870226,5,0,0x11bd},
}
for _,r in ipairs(effectReference) do
    local class=assert(particleClasses[r[1]])
    local effect=New(class,run,r[2],r[3],r[1],1,0,0,r[6],'')
    effect.boardX,effect.boardY=r[2],r[3]
    effect.boardVX,effect.boardVY,effect.clock,effect.visible=r[4],r[5],r[7],true
    assert(effect.animation.frames[r[6]][4]==r[12],'粒子类型与原版动画表错位')
    run.serial=run.serial+1
    effect.class.frame(effect)
    assert(effect.boardX==r[8] and effect.boardY==r[9] and effect.index==r[10] and effect.clock==r[11])
end
-- 原版第 8569 帧抬升爆炸与第 8654 帧最终波纹的伴随粒子出生状态。
local coreCompanion=New(particleClasses[11],run,7632767,18119122,11,32,346,0,4,'mul+add',112)
assert(coreCompanion.boardX==7515711 and coreCompanion.boardY==17994674 and coreCompanion.visible)
local rippleCompanion=New(particleClasses[11],run,8526231,14775350,11,48,484,0,4,'mul+add',88)
assert(rippleCompanion.boardX==8460039 and rippleCompanion.boardY==14894902 and rippleCompanion.visible)
-- 第 8569 帧分配，等待计时从 5 减到负数的第 8575 帧启动。
local waiting=New(particleClasses[10],run,6322047,17856978,10,1,0,6,4,'')
assert(waiting.boardY==17791442 and waiting.wait==5,'粒子挂载当步未随卷轴位移')
waiting.boardVX,waiting.boardVY=-23424,7422
for elapsed=1,6 do
    run.serial=run.serial+1
    waiting.class.frame(waiting)
    assert(waiting.visible==(elapsed==6),'待发粒子提前进入动画')
end
assert(waiting.boardX==6298623 and waiting.boardY==17405648 and waiting.index==4 and waiting.clock==0,
    '待发粒子的卷轴位移与原版不符')
local effects={}
for effect in pairs(run.midEffects) do effects[#effects+1]=effect end
road.close(run)
for _,effect in ipairs(effects) do assert(not IsValid(effect),'离开关卡后粒子未回收') end
local fragments=dofile('mod/GAME/th46/fragments.lua')(dofile('mod/GAME/th46/midboss1_effect_data.lua').debris)
-- 原版第 8654–8655 帧的普通碎片与 24 类碎片，以及第 8627–8628 帧的奇数初速分支。
local fragmentReference={
    {0,10518483,16957784,62,-24,31,0,255,31,10464978,17164252,60,3,1,255,30},
    {1,8053008,17290830,68,-72,7,0,255,71,7896291,17439770,66,11,1,255,70},
    {24,21507273,3627295,14,202,28,1,239,0,21542553,3549321,14,29,0,231,0},
    {24,10955206,9612355,15,234,31,0,255,15,10969402,9528276,13,0,3,255,14},
}
for _,r in ipairs(fragmentReference) do
    local pool={serial=0,roadFrame=0,roadCameraDelta=0}
    local fragment=fragments.emit(pool,0,0,r[1])
    fragment.boardX,fragment.boardY,fragment.speed,fragment.angle=r[2],r[3],r[4],r[5]
    fragment.phase,fragment.speedClock,fragment.alpha,fragment.fadeDelay=r[6],r[7],r[8],r[9]
    fragment.class.frame(fragment)
    assert(fragment.boardX==r[2] and fragment.boardY==r[3] and fragment.phase==r[6],'碎片在减速等待帧继续更新')
    pool.serial=1
    fragment.class.frame(fragment)
    local values={fragment.boardX,fragment.boardY,fragment.speed,fragment.phase,
        fragment.speedClock,fragment.alpha,fragment.fadeDelay}
    for i,value in ipairs(values) do assert(value==r[9+i],'碎片状态与原版记录不符') end
    fragments.close(pool)
    assert(not IsValid(fragment) and pool.fragmentCount==0)
end
local pool={serial=0,roadFrame=0,roadCameraDelta=0}
for _=1,129 do fragments.emit(pool,0,0,0) end
assert(pool.fragmentCount==128,'碎片池未遵守原版容量')
for serial=1,150 do
    pool.serial=serial
    for fragment in pairs(pool.roadFragments) do fragment.class.frame(fragment) end
end
assert(pool.fragmentCount==0 and next(pool.roadFragments)==nil,'碎片淡出后未归还槽位')
run.serial,run.roadFrame,shots=0,nil,{}
p.run=run
pilot.spawn(p)
road.open(run)
road.attach(run,p)
for frame=0,3192 do
    step(frame,{})
    if frame==2968 then
        -- 原版第 8398 帧中弹，第 8622 帧重新分配敌弹。
        pilot.onHit(p)
        assert(run.roadShotResume==3192)
    elseif frame>2968 then
        local births=0
        for _,shot in ipairs(shots) do
            if IsValid(shot) and shot.age==0 then births=births+1 end
        end
        assert(births==(frame==3192 and 4 or 0),'扣命后的敌弹禁发计时不符')
    end
end
road.close(run)
print('Futari 1.5 第一面飞虫、蜈蚣、中 Boss 发弹与零件、受击禁发状态对照通过')
