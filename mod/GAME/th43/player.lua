-- 栖霞园的原作机体、残机、血力与槽位规则。
local R=...
local P=NativePlayers
if not P then return end
local level=41
local playerAdapter={}
P.adapters[level]=playerAdapter
local extendPoints={1100,2300,3500,4700}
local extraExtendPoints={1000,1600}
local E=R.env
local smallPowerValue={20,10,10,5,10}
local function currentBoss()
    for _,b in ipairs(boss_group or {}) do
        if IsValid(b) and not b._sequence_road_carrier and b.class.StageLevel==level then return b end
    end
end

function playerAdapter.reset(s,v,spell)
    v.bomb_used=0
    s.life=spell and 0 or v.is_practice and 40 or 10
    s.bombs=spell and 0 or v.is_practice and 40 or 15
    s.pointrate=0
    s.points,s.bombFragments,s.rank,s.rankChips,s.rankValue=0,0,0,0,0
end

function playerAdapter.init(p)
    p.name=p.machine.id
    p.collect_line=p.name=='marisa' and 48 or 96
    p.th43CollectShift=0
    p._playersys:addFrameEvent('frame.itemCollect',95,function(o)
        o.th43CollectShift=math.max(0,math.min(1,o.th43CollectShift+(o.slow==1 and .1 or -.1)))
        if o.y>o.collect_line then
            E.item.collectAllItem(1,true)
        else
            local radius=50+(o.name=='sakuya' and 30 or 40)*o.th43CollectShift
            for _,pickup in ObjList(GROUP.ITEM) do
                if Dist(pickup,o)<radius then E.item.collectByTarget(pickup,o) end
            end
        end
    end)
    p.hscale,p.vscale,p.protect=.25,.25,180
    p.grazeRadius=p.name=='reimu' and 50 or 30
end

function playerAdapter.collect(s,kind,amount)
    if not s then return false end
    if kind=='points' then
        s.points=s.points+amount
        for _,value in ipairs(s.difficulty==5 and extraExtendPoints or extendPoints) do
            if s.points-amount<value and s.points>=value then s.life=math.min(40,s.life+5) end
        end
    elseif kind=='rankPower' then
        R.gainRankValue(amount)
    elseif kind=='bombFragments' then
        s.bombFragments=s.bombFragments+amount
        while s.bombFragments>=100 do
            s.bombs=math.min(40,s.bombs+5)
            s.bombFragments=s.bombFragments-100
        end
    elseif kind=='life' or kind=='bombs' then
        s[kind]=math.min(40,s[kind]+amount)
    else
        return false
    end
    return true
end

local system=E.system
local function state() return P.enabled(nil,level) and P.state() end
local function addScore(n) lstg.var.score=(lstg.var.score or 0)+n end
function system.addBonus(n)
    local s=state()
    if not s then return end
    local base=(s.difficulty or 4)*10000
    s.pointrate=math.min(5000000,math.max(base,s.pointrate or 0)+n)
end
function system.addLife(n) playerAdapter.collect(state(),'life',5*n) end
function system.addBomb(n) playerAdapter.collect(state(),'bombs',5*n) end
function system.collectPower(rate)
    addScore(500)
    R.gainRankValue(50*(rate or 1))
end
function system.collectSmallPower()
    local s=state()
    if not s then return end
    addScore(system.SMALL_POWER_SCORE)
    local b=currentBoss()
    if not (b and b.current_card and b.current_card.is_sc and b.timer>120) then
        system.addBonus(10*(player.minor_bonus_rate or 1))
    end
    R.gainRankValue(smallPowerValue[s.difficulty] or 10)
end
function system.collectBlue(rate,ignorePointRate)
    local s=state()
    if not s then return 0 end
    playerAdapter.collect(s,'points',1)
    local bonus=math.max((s.difficulty or 4)*10000,s.pointrate or 0)
    local multiplier=ignorePointRate and 1 or math.floor((lstg.tmpvar.point_rate or 1)*100)/100
    local score=math.floor(bonus*(rate or 1)*multiplier/10)*10
    addScore(score)
    return score
end
function system.collectChip(n)
    local s=state()
    if not s then return end
    E.item.collectAllPowerAndPoint(1,false)
    if E.system.PowerRank.getRank()<4 then R.addRankChip(n) else E.PlaySound('hyperpiece') end
    if s.difficulty==5 and not currentBoss() then
        E.EGGlib.ObjectEvent.clearBulletAndLaserInRangeCircle(player.x,player.y,225,3,0,15)
    end
end
local rankColors={'green','blue','purple'}
local RankRing=Class(object,{
    init=function(o,x,y,rank)
        o.x,o.y,o.layer=x,y,LAYER.BG+51
        o.group,o.bound,o.colli=GROUP.GHOST,false,false
        o.texture='boom_'..rankColors[rank]
    end,
    frame=function(o) if o.timer>=60 then Del(o) end end,
    render=function(o)
        local fade=math.max(0,(o.timer-30)/30)
        for i=1,3 do
            local radius=600*math.min(1,o.timer*i/30)
            E.sp.misc.RenderRing3(o.texture,o.x,o.y,radius*fade,radius,60,1,0,360,
                'mul+add',Color(100*(1-fade),255,255,255))
        end
    end,
})
function R.rankUpCircle(rank)
    if not currentBoss() then
        player.protect=math.max(player.protect,30)
        E.EGGlib.ObjectEvent.allBulletsDo(function(o)
            if Dist(player,o)<900 then Kill(o) end
        end)
        E.EISlib.Bullet.Laser.cutLasersByCircle(player.x,player.y,900,true)
    end
    E.New(RankRing,player.x,player.y,rank)
end
function R.dropByAura(o)
    local s=state()
    if not s then return end
    local color=o.th43_aura_color
    local blood=E.item.Blood
    local rank=E.system.PowerRank.getRank()
    if color==1 or color==2 then
        local size=blood.Small
        if rank==2 then size=blood.Mid
        elseif rank==4 or rank==3 and s.rankChips<6 then size=blood.Big end
        blood.create(o.x,o.y,size)
    elseif color==13 or color==14 then blood.create(o.x,o.y,blood.Big)
    elseif color==9 or color==10 then
        blood.create(o.x,o.y,blood.Huge)
        E.item.PlayerBomb.create(o.x,o.y)
    elseif color==3 or color==4 then
        if rank==4 then blood.create(o.x,o.y,blood.Huge) end
        E.item.PlayerLife.create(o.x,o.y)
    end
end

function playerAdapter.bomb(p,s)
    if s.bombs<5 then return false end
    s.bombs=s.bombs-5
    lstg.var.bomb_used=(lstg.var.bomb_used or 0)+1
    R.addRankChip(-3)
    return true
end

function playerAdapter.miss(p,s)
    lstg.var.dead=(lstg.var.dead or 0)+1
    s.life=s.life-5
    s.bombs=math.max(15,s.bombs)
    R.playerMiss()
    p.protect,p.death=390,90
    New(player_death_ef,p.x,p.y)
    New(bomb_bullet_killer,p.x,p.y,64,64,false)
    PlaySound('pldead00',.5)
    return true
end

function playerAdapter.hitWindow(p,s)
    return s.bombs<5 and 2 or p.machine.window
end

function playerAdapter.frame(p)
    local special=p._playersys.keyState.special
    if special and not p.specialHeld and not p.dialog then R.tryHyper() end
    p.specialHeld=special
    if E.system.PowerRank.isInHyper() then E.item.collectAllPowerAndPoint(2,false) end
end

function playerAdapter.shoot(p,t)
    local slow=p.slow==1
    local m=p.machine
    local function fire(part,x,y,speed,angle,dmg,scale,homing)
        P.emit(p,p.shotImage..m.id..'_'..part,x,y,speed,angle,dmg,12,scale,homing)
    end
    if m.id=='marisa' and not slow then
        for _,x in ipairs({-72,-40,42,72}) do P.ray(p,p.x+x,p.y,90,3,.48,.48,true) end
    end
    if t%6~=0 then return end
    if m.id=='reimu' then
        local count=slow and 2.5 or 1.5
        for i=-count,count do fire('main',0,0,20,90+4*i,slow and 1.5 or m.damage,.375) end
        for i,x in ipairs(slow and {-30,-15,15,30} or {-40,-20,20,40}) do
            local y=i==2 or i==3
            if slow then fire('straight',x,y and 30 or 0,20,90,1.8,.375)
            else
                local dir=({112,100,80,68})[i]+6*math.floor((t%18)/6)*(x<0 and -1 or 1)
                fire('trail',x,y and 30 or 0,9,dir,1.5,.375,8)
            end
        end
    elseif m.id=='marisa' then
        for i=-3,3,2 do fire('main',12*i,-15-5*math.abs(i),20,90,m.damage,.375) end
        if slow then
            for i,x in ipairs({-36,-12,12,36}) do
                fire('spread',x,(i==2 or i==3) and 40 or 30,17,90,3,.375)
            end
        end
    else
        for _,a in ipairs(slow and {-12,-6,0,6,12} or {-20,-9,0,9,20}) do
            fire('main',0,0,20,90+a,m.damage,.3125)
        end
        for i,x in ipairs(slow and {-70,-30,30,70} or {-40,-20,20,40}) do
            local inner=i==2 or i==3
            if slow then
                local y=inner and -10 or 0
                local target=p.target
                local rot=target and IsValid(target) and Angle(p.x+x,p.y+y,target.x,target.y) or 90
                for side=-1,1,2 do
                    fire('straight',x+5*sin(rot)*side,y-5*cos(rot)*side,20,rot,.9,.4375)
                end
            else
                local rot=({93,66,114,87})[i]
                for side=-1,1,2 do fire('spread',x,inner and 30 or 0,20,rot+6*side,.9,.3125) end
            end
        end
    end
end
