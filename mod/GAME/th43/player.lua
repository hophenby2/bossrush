-- 栖霞园的原作机体、残机、血力与槽位规则。
local R=...
local P=NativePlayers
if not P then return end
local level=41
local playerAdapter={}
P.adapters[level]=playerAdapter
local extendPoints={1100,2300,3500,4700}
local extraExtendPoints={1000,1600}
local pointValue={20,10,10,5,10}

function playerAdapter.reset(s,v,spell)
    v.bomb_used=0
    s.life=spell and 0 or v.is_practice and 40 or 10
    s.bombs=spell and 0 or v.is_practice and 40 or 15
    s.points,s.bombFragments,s.rank,s.rankChips,s.rankValue=0,0,0,0,0
end

function playerAdapter.init(p)
    p.name=p.machine.id
    p.hscale,p.vscale,p.protect=.25,.25,180
    p.grazeRadius=p.name=='reimu' and 50 or 30
end

function playerAdapter.collect(s,kind,amount)
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

function R.dropItems(x,y,green,blue,life,bomb)
    local result={}
    local s=P.enabled(nil,level) and P.state()
    if not s then return result end
    local function spawn(kind,total,groupSize)
        while total>0 do
            local amount=math.min(total,groupSize)
            result[#result+1]=P.pickup(x+ran:Float(-14,14),y+ran:Float(-12,12),kind,amount)
            total=total-amount
        end
    end
    if life then P.pickup(x,y,'life',5) end
    if bomb then P.pickup(x,y,'bombs',5) end
    spawn('rankPower',green*(pointValue[s.difficulty] or 10),50)
    spawn('points',blue,5)
    return result
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
