-- 两只蜈蚣的 244 步击破控制、9480 份爆炸状态、残骸及原生碰撞回归。
-- 原版样本固定输入随机分支；共享随机队列与掉落另测，不把随机流差异混进演出计时。
function Class(_,c)return c end
local objects,host,scope,current,frame,randomIndex,corpseIndex,fxID,corpseID
local images={}
function CheckRes(_,name)return images[name]end
function LoadTexture()end
function SetTextureSamplerState()end
function LoadImage(name)images[name]=true end
function SetImageState(name)assert(images[name],'未载入图片 '..name)end
function Render(name)assert(images[name],'未载入图片 '..name)end
function IsValid(o)return o and not o.deleted end
object={RawDel=function(o)o.deleted=true end}
GROUP,LAYER={GHOST=0,ENEMY=2,ITEM=6},{ENEMY=-600,ITEM=-300}
lstg={var={score=0}}
function New(c,...)
    local o={class=c};c.init(o,...);objects[#objects+1]=o
    if host and host.run.wormEffects and host.run.wormEffects[o]then fxID=fxID+1;o.testID=fxID
    elseif host and host.run.wormCorpses and host.run.wormCorpses[o]then corpseID=corpseID+1;o.testID=corpseID end
    return o
end
ran={Int=function(_,a,b)
    if scope=='controller'then
        if b==0 then return 0 end
        if b==3 then corpseIndex=corpseIndex+1;return assert(current.corpseRandoms[corpseIndex])end
        randomIndex=randomIndex+1
        local r=assert(current.randoms[randomIndex],'出现多余的原版随机分支')
        assert(r[1]==frame and r[2]==b,'原版随机分支的帧或范围改变')
        return r[3]+a
    end
    return math.floor((a+b)/2)
end}
local data=dofile('mod/GAME/th46/midboss1_effect_data.lua')
for _,bank in pairs(data)do
    if bank.frames then for i=1,#bank.frames do images['th46_midboss1_effects_'..(bank.first+i-1)]=true end end
end
for _,bank in pairs(data.debris)do for i=1,#bank.frames do images['th46_midboss1_effects_'..(bank.first+i-1)]=true end end
local fixtures=dofile('tools/cv1000/fixtures/futari15_worm.lua')
local load=dofile
local ground
function dofile(path)
    if path=='mod/GAME/th46/gold.lua'then return {
        choose=function()return nil end,
        emitGround=function(_,x,y,kind)ground[#ground+1]={x,y,kind or 1}end,
    }end
    return load(path)
end
local death=dofile('mod/GAME/th46/worm_death.lua')
dofile=load
death.open()
local function hash(h,row)for _,n in ipairs(row)do h=(h*131+n)%16777213 end;return h end
for _,case in ipairs(fixtures)do
    current,objects,ground,randomIndex,corpseIndex,fxID,corpseID=case,{},{},0,0,0,0
    host={baseX=case.x,baseY=case.y,player={laser=false},run={serial=0,roadFrame=case.frame,roadCameraDelta=0,groundCorpses={}}}
    local run=host.run
    death.begin(host)
    local controllerHash,effectHash,effectStates,corpseHash,corpseStates=0,0,0,0,0
    for f=1,#case.scroll do
        frame=f;run.serial,run.roadFrame,run.roadGroundDelta=f,case.frame+f,tonumber(case.scroll:sub(f,f))*65536
        host.baseY=host.baseY-run.roadGroundDelta
        if f==122 then for _,r in ipairs(case.before)do run.groundCorpses[{boardX=r[1],boardY=r[2]}]=true end end
        scope='controller';if f<=122 then death.step(host)end
        if f<=122 then
            controllerHash=hash(controllerHash,{f,host.baseX,host.baseY,host.deathPhase,host.soundClock,host.soundInterval,
                host.burstClock,host.burstInterval,host.burstCount,host.deathWait or 0,host.deathFade,host.deathTone*0x10101})
        end
        scope='particles'
        for _,o in ipairs(objects)do if IsValid(o)and o.class.frame then o.class.frame(o)end end
        local effects,corpses={},{}
        for o in pairs(run.wormEffects)do effects[#effects+1]=o end
        for o in pairs(run.wormCorpses)do corpses[#corpses+1]=o end
        table.sort(effects,function(a,b)return a.testID<b.testID end)
        table.sort(corpses,function(a,b)return a.testID<b.testID end)
        for _,o in ipairs(effects)do
            effectHash=hash(effectHash,{f,o.testID,o.kind,o.boardX,o.boardY,o.boardVX,o.boardVY,o.visible and 1 or 0,o.wait,
                o.visible and o.index-1 or 0,o.visible and o.clock or 0,o.alpha,(o.flip==-1 and 1 or 0)+(o.flipY==-1 and 2 or 0),o.layer-LAYER.ENEMY+101})
            effectStates=effectStates+1;o.class.render(o)
        end
        for _,o in ipairs(corpses)do
            corpseHash=hash(corpseHash,{f,o.testID,o.kind,o.boardX,o.boardY,o.phase,o.clock,o.alpha,o.frozen and 1 or 0})
            corpseStates=corpseStates+1;o.class.render(o)
        end
    end
    assert(randomIndex==#case.randoms and corpseIndex==#case.corpseRandoms)
    assert(controllerHash==case.controllerHash,'原版击破状态机不符：'..controllerHash)
    assert(fxID==case.effects and effectStates==case.effectStates and effectHash==case.effectHash,'原版爆炸生命周期不符：'..effectHash)
    assert(corpseID==case.corpses and corpseStates==case.corpseStates and corpseHash==case.corpseHash,'原版残骸状态不符：'..corpseHash)
    assert(#ground==15)
    for i,r in ipairs(ground)do assert(r[3]==(i<=5 and 1 or 0))end
    assert(run.fragmentCount==0 and run.wormEffectCount==0)
    death.close(run);assert(not run.wormCorpses and not run.wormEffects)
end

-- 碰撞刚好扣到零即启动，保留原版 8200 / 十分之一 / 不计分三种事件。
host,scope,objects=nil,nil,{}
local worm=dofile('mod/GAME/th46/worm1.lua')(function()end)
worm.open()
for _,flags in ipairs({0,0x20,0x400})do
    local run={serial=0,roadFrame=745,roadCamera=0,roadCameraDelta=0}
    local p={laser=false,respawn=0,pilotPosition={x=120*65536,y=50*65536}}
    worm.step(run,745,p,0)
    local o=run.worm;o.player,o.entered,o.baseY=p,true,200*65536
    local before=lstg.var.score
    local shot={dmg=3456,damageFlags=flags,colli=true};o.colli=true;o.class.colli(o,shot)
    assert(shot.deleted and o.hp==0 and o.deathPhase==1 and not o.colli)
    assert(lstg.var.score==before+(flags==0 and 8200 or flags==0x20 and 820 or 0))
    o.damage(o,100);assert(o.hp==0)
    worm.close(run)
end

-- 小地面金块的 48 像素吸附与 96 像素抖动范围独立于大金块，拾取计数为 1。
local gold=dofile('mod/GAME/th46/gold.lua')
local run={serial=0,roadFrame=0,roadCameraDelta=0,roadGroundDelta=0}
local p={run=run,laser=false,respawn=0,pilotPosition={x=120*65536,y=50*65536}}
run.roadClock={player=p}
local coin=gold.emitGround(run,120*65536,100*65536,0)
run.serial=1;coin.class.frame(coin)
run.serial=2;coin.class.frame(coin)
assert(coin.radius==16 and coin.motion==0 and coin.tint==98 and coin.shakeX==-65536 and coin.interval==0)
p.pilotPosition.y=52*65536;run.serial=3;coin.class.frame(coin)
assert(coin.motion==1 and coin.speed==72)
p.pilotPosition.y=coin.boardY;coin.class.colli(coin,p)
assert(coin.popup and run.goldStage==1 and run.goldTotal==1)
gold.close(run)
print('Futari 1.5 两只蜈蚣击破、9480 份爆炸、777 份残骸状态、零血碰撞与小地面金块通过')
