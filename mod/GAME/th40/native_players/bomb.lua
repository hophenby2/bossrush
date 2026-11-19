-- Spell_Reimu/Shinmyoumaru/PlaneB/Sanae/Koishi 与 BaseSpell 的攻击边界。
local M=...
local function runtime() return _editor_class.TH40.native end
local p,bomb
local function contains(o)
    if bomb.kind=='B' then return o.y>p.y-5 and math.abs(o.x-p.x)<120 end
    local r=bomb.radius+(o.region or o.a or 0)
    return Dist(o.x,o.y,bomb.x,bomb.y)<r
end
local function draw()
    if not bomb then return end
    local images=runtime().images;local key=bomb.kind=='reimu' and 'YINYANGYU' or bomb.kind=='C' and '球'
    local img=key and images[key]
    if img then
        SetImageState(img,'',255,255,255,255)
        Render(img,bomb.x,bomb.y,bomb.angle or 0,bomb.scale,bomb.scale)
    end
end
local oldFrame,oldRender,oldMiss,oldHit,oldBind,oldBomb=M.frame,M.render,M.miss,M.beforeHit,M.bind,M.bomb
function M.bind(player) bomb=nil;p=player;oldBind(player) end
function M.bomb(player,s)
    if s.enchantment=='green' then
        oldBomb(player,s)
        player.bombTime,player.cancelOnlyBomb=1,true;return true
    end
    if s.bombs<=0 or player.machine.id=='D' and player.summerGod then return false end
    s.bombs=s.bombs-1;p=player
    local kind=player.machine.id
    if kind=='A' then kind=player.slow==1 and 'reimu' or 'shin' end
    bomb={kind=kind,time=0,born=player.timer,x=player.x,y=player.y,scale=kind=='reimu' and 0 or 1,scaleVelocity=kind=='C' and .1 or kind=='shin' and .3 or 0,
        speed=kind=='reimu' and 2.2 or 0,damage=({reimu=40,shin=32,B=45,C=36,D=0})[kind],region=({reimu=64,shin=4,B=30,C=4,D=1000})[kind],life=({reimu=260,shin=300,B=390,C=300,D=60})[kind]}
    if kind=='D' then player.summerGod=true;runtime().deathClear(player.x,player.y,150,true) end
    player.summer_source.SpellList:Add(bomb)
    player.bombTime,player.nextspell,player.cancelOnlyBomb=bomb.life+1,bomb.life+1,true
    player.protect=math.max(player.protect,bomb.life+61)
    lstg.var.bomb_used=(lstg.var.bomb_used or 0)+1
    PlaySound('nep00',.5);return true
end
function M.frame(player,s)
    oldFrame(player,s)
    if player.machine.id=='D' then
        player.summerBodyAlpha=math.max(0,math.min(255,(player.summerBodyAlpha or 255)+(player.summerGod and -10 or 10)))
        if player.summerGod or player.summerBodyAlpha<255 then player.native_tint={player.summerBodyAlpha,255,255,255} end
    end
    if not bomb or p~=player or bomb.born==player.timer then return end
    local b=bomb;b.time=b.time+1
    if b.kind=='B' or b.kind=='shin' then b.x,b.y=player.x,player.y end
    b.y=b.y+b.speed
    if b.kind=='reimu' then b.speed=math.max(0,b.speed-2.2/210);b.angle=(b.angle or 0)+3 end
    b.scale=math.min(200,b.scale+b.scaleVelocity);b.radius=b.region*b.scale
    local t=b.time
    if b.kind=='reimu' then
        if 1<t and t<50 then b.scaleVelocity=b.scaleVelocity+.0004
        elseif 150<t and t<240 then b.scaleVelocity=b.scaleVelocity-.0004
        elseif t==240 then b.scaleVelocity=-b.scale/20 elseif t==260 then b.scaleVelocity=0 end
    elseif b.kind=='C' then
        if t==120 then b.scaleVelocity=10 elseif t==240 then b.damage=0 end
    elseif b.kind=='B' and t>=90 then
        if t==360 then b.damage=20 end
        player.y=math.max(-224,player.y-8)
    end
    if t>=9 and (b.kind~='B' or t>=90) then
        runtime().spellClear(contains,true)
        object.EnemyNontjtDo(function(o)
            if o.colli and not o.protect and contains(o) then Damage(o,b.damage) end
        end)
        if t<30 then for _,o in ObjList(GROUP.ITEM) do if contains(o) and o.kind~='red' and o.kind~='blue' and o.kind~='green' then
            o.target,o.attract=player,10
            if not o.doubled then o.doubled=true;o.amount=(o.amount or 1)*2 end
        end end end
    end
    if t>b.life then
        player.summer_source.SpellList:Clear();player.protect=math.max(player.protect,60);bomb=nil
    end
end
function M.speeds(player)
    if bomb and bomb.kind=='B' then return 1.6,.8 end
    return player.hspeed,player.lspeed
end
function M.beforeHit(player,other,s)
    if s.enchantment=='green' then return false end
    if player.summerGod then
        player.summerGod=false;player.protect=math.max(player.protect,60)
        runtime().deathClear(player.x,player.y,150,true);return true
    end
    return oldHit and oldHit(player,other,s)
end
function M.miss(player,s) player.summerTime=0;return oldMiss(player,s) end
function M.render(...) oldRender(...);draw() end
M.ownBomb=true
return M
