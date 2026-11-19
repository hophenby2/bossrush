-- 栖霞园的原作机体、残机、血力与槽位规则。
local R=...
local P=NativePlayers
if not P then return end
local level=41
local playerAdapter={ownBomb=true,lateFrame=true,heldBomb=true}
P.adapters[level]=playerAdapter
local extendPoints={1100,2300,3500,4700}
local extraExtendPoints={1000,1600}
local E=R.env
local Original=assert(loadfile('mod/GAME/th43/native_players/bridge.lua'))(R)
local smallPowerValue={20,10,10,5,10}
local function currentBoss()
    for _,b in ipairs(boss_group or {}) do
        if IsValid(b) and not b._sequence_road_carrier and b.class.StageLevel==level then return b end
    end
end

function playerAdapter.reset(s,v,spell)
    v.bomb_used=0
    v.dyeitem={red=0,blue=0,small=0}
    s.dyeChain,s.stageChain=0,0
    s.life=spell and 0 or v.is_practice and 40 or 10
    s.bombs=spell and 0 or v.is_practice and 40 or 15
    s.pointrate=0
    s.points,s.bombFragments,s.rank,s.rankChips,s.rankValue=0,0,0,0,0
end

function playerAdapter.init(p)
    p.name=p.machine.id
    p.collect_line=p.name=='marisa' and 48 or 96
    p._playersys:addFrameEvent('frame.itemCollect',95,function(o)
        if o.y>o.collect_line then
            E.item.collectAllItem(1,true)
        else
            local range=o.bdb_collect or {50,90}
            local radius=range[1]+(range[2]-range[1])*(o.lh or 0)
            for _,pickup in ObjList(GROUP.ITEM) do
                local chip=o.bdb_collect_chip
                local reach=pickup.class==E.item.Blood and chip and chip[1]+(chip[2]-chip[1])*(o.lh or 0) or radius
                if Dist(pickup,o)<reach then E.item.collectByTarget(pickup,o) end
            end
        end
    end)
    local bodyScale=.85*E.lstg.globalimagescale
    p.hscale,p.vscale,p.protect=bodyScale,bodyScale,180
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
        s[kind]=math.max(0,math.min(40,s[kind]+amount))
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
function system.getBomb() local s=state();return s and s.bombs/5 or 0 end
function system.getLife() local s=state();return s and s.life/5 or 0 end
function system.canBomb() return system.getBomb()>0 end
local function countItem(kind)
    local v=lstg.var
    v.dyeitem=v.dyeitem or {}
    local items=lstg.tmpvar._system_items or {}
    lstg.tmpvar._system_items=items
    items[kind]=(items[kind] or 0)+1
    v.dyeitem[kind]=(v.dyeitem[kind] or 0)+1
end
function system.collectPower(rate)
    if not state() then return end
    countItem('red')
    addScore(500)
    R.gainRankValue(50*(rate or 1))
end
function system.collectSmallPower()
    local s=state()
    if not s then return end
    countItem('small')
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
    countItem('blue')
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
function R.countEnemy(o)
    local s=state()
    if not s or o.no_count or E.player_class.isInBomb(player) then return end
    local rank=E.system.PowerRank.getRank()
    local n=(rank>=4 and 5 or math.max(1,rank))*(o.type and 10 or 1)
    s.stageChain=(s.stageChain or 0)+n
    s.dyeChain=(s.dyeChain or 0)+n
end
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
    if p.nextspell>0 or p.lockspell>0 or Original.power.isInHyper() then return false end
    if R.tryHyper() then return false end
    if s.bombs<5 then return false end
    s.bombs=s.bombs-5
    lstg.var.bomb_used=(lstg.var.bomb_used or 0)+1
    Original.spell(p)
    p.bombTime,p.cancelOnlyBomb=p.nextspell,true
    return true
end

function playerAdapter.miss(p,s)
    lstg.var.dead=(lstg.var.dead or 0)+1
    s.life=s.life-5
    s.bombs=math.max(15,s.bombs)
    R.playerMiss()
    p.protect,p.death=390,90
    P.death.miss(p)
    PlaySound('pldead00',.5)
    return true
end

function playerAdapter.hitWindow(p,s)
    return s.bombs<5 and 2 or p.machine.window
end

function playerAdapter.bind(p) Original.bind(p) end
function playerAdapter.beforeHit(p) return Original.hit(p) end
function playerAdapter.updateSlow(p,slow)
    if p.slowlock then return 1 end
    if p.lock_player_shift<=0 then p.bdb_slow=slow and 1 or 0 end
    return p.bdb_slow or 0
end
function playerAdapter.move(p)
    if p.bdb_move_lock then p.__move_dx,p.__move_dy=0,0;return true end
end
function playerAdapter.beforeRender(p) Original.render(p) end
function playerAdapter.frame(p)
    local special=p._playersys.keyState.special
    if special and not p.specialHeld and not p.dialog then R.tryHyper() end
    p.specialHeld=special
    Original.frame(p)
end
function playerAdapter.shoot(p) Original.shoot(p) end
function playerAdapter.shotHit(dmg)
    Original.power.addValue(dmg*(Original.power.isInHyper() and 4 or 3))
    Original.sync()
end
