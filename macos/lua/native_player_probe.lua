-- Called only by the isolated macOS test harness.
local T={}
local level
local checked={}
local target
local firstHit,firstMiss,initialLife,initialBombs
local hazard=Class(object,{
    init=function(o,p)
        o.group=GROUP.ENEMY_BULLET
        o.x,o.y=p.x,p.y
        o.a,o.b=3,3
        o.colli=true
    end,
},true)
local function keys(key,on)
    AndroidInput.keys[setting.keys[key]]=on
end
local function enemy(p)
    if level==35 then
        return New(TH37.runtime.classes.fairy,TH37.runtime.stageState(1),
            {type=7,x=234,y=240-p.y-84,speed=0,speedf=0,life=300,hp=1000,id=-1})
    elseif level==36 then
        return New(TH38.runtime.classes.fairy,{c={closed=false},alive=true,kind='enemy',
            x=4.5,y=(p.y+84)/48-4.8,life=1000,color=5,enemyStyle=1,collision=true,age=1,immune=0,hit=.65})
    end
    local R=TH39.runtime
    local o=New(R.classes.fairy,R.stageState(1),{type=2,x=336,y=360-(p.y+84)*1.5,
        speed=0,speedf=0,life=300,hp=1000,id=-1,events={}})
    o.mhj.age=32
    return o
end
function T.before(p)
    local scene=stage.current_stage
    local t=scene.timer
    level=p.native_level
    local s=assert(NativePlayers.state())
    assert(p.machine.id==os.getenv('BOSSRUSH_MAC_TEST_MACHINE'))
    assert(CheckRes('img',p.img)=='global','自机行走图不在全局资源池')
    if t==5 then
        assert(s.life==(level==36 and (lstg.var.is_practice and 1 or 3) or 10))
        assert(lstg.var.__native_player_version==1 and not GameDrops.enabled())
        initialLife,initialBombs=s.life,s.bombs
        checked.spawn=true
    elseif t==40 then
        target=enemy(p)
    elseif t==73 then
        assert(target and IsValid(target) and target.hp<1000,
            ('实际自机射击没有命中原生敌机：%s，靶位置 %s/%s，发射 %s'):format(
                target and target.hp, target and target.x,target and target.y,p.shotClock))
        object.Del(target)
        checked.shot=true
    end
    keys('shoot',t>=46 and t<73)
    if lstg.var.is_practice then return end
    if t==80 or t==170 then
        p.protect=0
        New(hazard,p)
    elseif t==82 then
        assert(p.hit,'没有进入决死窗口')
        if level~=36 then keys('spell',true) end
    elseif t==83 then
        keys('spell',false)
    elseif t==120 then
        if level==36 then
            assert(s.life==initialLife and NativePlayers.barriers(s)==1,'受击应先扣一层结界')
        else
            assert(s.life==initialLife and s.bombs==initialBombs-(level==35 and 5 or 10),'决死 Bomb 库存或残机错误')
        end
        checked.firstHit=true
    elseif t==171 and level==36 then
        assert(p.hit)
        s.barrier=0
    elseif t==237 then
        local cost=level==36 and 1 or 5
        assert(s.life==initialLife-cost and lstg.var.dead==1,'决死超时后的掉命错误')
        assert(not NativePlayers.out(),'仍有剩余残机时错误判负')
        checked.miss=true
    end
end
function T.after(p)
    if p.death==0 and p.hit and not firstHit then firstHit=p.hit end
    if p.death==89 and not firstMiss then firstMiss=stage.current_stage.timer end
end
function T.checkpoint()
    assert(checked.spawn and checked.shot,'缺少自机与实际伤害检查')
    if not lstg.var.is_practice then assert(checked.firstHit and checked.miss and firstHit and firstMiss) end
end
return T
