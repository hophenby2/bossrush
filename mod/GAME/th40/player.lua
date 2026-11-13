-- 夏夜祭自机。弹速、间隔与主炮伤害取自 MyPlane_*.cs。
local P=NativePlayers
local M={}
local art={
    reimu={'Reimu',{192,144,64,16},{0,176,16,16},{128,144,16,16}},
    marisa={'Marisa',{0,144,32,16},{0,164,256,26},{32,144,16,16}},
    sanae={'Sanae',{0,184,64,16},{0,144,32,32},{64,144,17,17}},
    koishi={'Koishi',{208,176,48,16},{176,144,32,16},{71,151,19,19}},
}
local function image(prefix,tex,name,rect)
    LoadImage(prefix..name,tex,unpack(rect))
end
function M.images(p,m)
    local data=art[m.art]
    local id='summer_player_'..m.art
    local prefix=id..'_'
    if not CheckRes('tex',id) then
        LoadTexture(id,'Resources/th40/MyPlane/'..data[1]..'.png')
        LoadImageGroup(prefix,id,0,0,32,48,8,3)
        image(prefix,id,'main',data[2])
        image(prefix,id,'sub',data[3])
        image(prefix,id,'option',data[4])
    end
    p.summerImages=prefix
    local images={}
    for i=1,24 do images[i]=prefix..i end
    return images
end
local function option(p,index,count)
    local n=index-(count+1)*.5
    if p.slow==1 then return n*18,18-math.abs(n)*4 end
    return n*25,4-math.abs(n)*12
end
function M.shoot(p,t,s)
    local id,tex=p.machine.id,p.summerImages
    if t%3==0 then
        for _,x in ipairs({-7,7}) do P.emit(p,tex..'main',x,0,30,90,p.machine.damage,4,1,nil,true).rot=90 end
        PlaySound('plst00',.16,p.x/384)
    end
    local count=math.floor(s.power/100)
    if t%(id=='D' and 10 or 4)~=0 then return end
    for i=1,count do
        local x,y=option(p,i,count)
        if id=='B' then
            P.ray(p,p.x+x,p.y+y,90,7,4,4,true)
        elseif id=='C' then
            for a=76,104,14 do P.emit(p,tex..'sub',x,y,13,a,p.slow==1 and 7 or 3,4,.6) end
        elseif id=='D' then
            P.emit(p,tex..'sub',x,y,12,90,p.slow==1 and 15 or 6,5,1,p.slow==1 and 4 or nil)
        else
            P.emit(p,tex..'sub',x,y,12,90,p.slow==1 and 5 or 9,5,1,p.slow==0 and 5 or nil)
            if p.slow==1 then P.emit(p,tex..'sub',x+4,y,12,90,5,5,1) end
        end
    end
end
function M.render(p,s)
    local count=math.floor(s.power/100)
    for i=1,count do
        local x,y=option(p,i,count)
        Render(p.summerImages..'option',p.x+x,p.y+y,p.timer*2)
    end
end
local extends={3,5,8,10,12,15,18,20,22}
local enchantmentColors={red={255,110,110},blue={120,185,255},green={125,255,150}}
function M.frame(p,s)
    local color=s.enchantment
    if not color then return end
    s.enchantmentTime=s.enchantmentTime-1
    if color=='blue' then
        for _,o in ObjList(GROUP.ITEM) do
            if o.native_pickup and o.kind=='power' then
                o.target,o.attract=p,8
                if not o.doubled then o.amount,o.doubled=o.amount*2,true end
            end
        end
    end
    if s.enchantmentTime==0 then
        s.enchantment,s.star=nil,0
        s.enchantmentCount=(s.enchantmentCount or 0)+1
        s.rate=(s.rate or 1)+.1
        local score=color=='red' and 5120000 or color=='green' and 1000000 or (s.pointrate or 100000)*20
        lstg.var.score=(lstg.var.score or 0)+score
        if color=='green' then p.protect=math.max(p.protect,60) end
        PlaySound('cardget',.4)
    end
end
function M.collect(s,kind,amount)
    if kind=='power' then return false end
    if (enchantmentColors[kind] or kind=='star') and not s.enchantment then
        s.star=math.min(3000,s.star+800*amount)
        if enchantmentColors[kind] then s.lastStarColor=kind end
        if s.star==3000 then
            s.enchantment=s.lastStarColor or 'green'
            s.enchantmentTime=s.enchantment=='green' and 420 or 600
        end
    end
    if kind=='red' then
        s.lifeChip=s.lifeChip+amount
        local need=extends[math.min(#extends,(s.extends or 0)+1)]
        while s.lifeChip>=need do
            s.lifeChip=s.lifeChip-need
            s.extends=(s.extends or 0)+1
            if s.life<8 then s.life=s.life+1 else s.bombs=math.min(8,s.bombs+1) end
            need=extends[math.min(#extends,s.extends+1)]
        end
    elseif kind=='green' then
        s.bombChip=s.bombChip+amount
        s.bombs=math.min(8,s.bombs+math.floor(s.bombChip/4))
        s.bombChip=s.bombChip%4
    elseif kind=='blue' then
        s.pointrate=(s.pointrate or 100000)+5000*amount
        lstg.var.score=(lstg.var.score or 0)+math.floor(s.pointrate*amount*(s.rate or 1))
    else return kind=='star' end
    return true
end
local function breakGreen(p,s)
    s.enchantment,s.enchantmentTime,s.star=nil,nil,0
    s.barrierCount=(s.barrierCount or 0)+1
    p.protect=math.max(p.protect,60)
    New(bomb_bullet_killer,p.x,p.y,500,500,false)
end
function M.bomb(p,s)
    if s.enchantment=='green' then
        breakGreen(p,s)
        p.bombTime,p.cancelOnlyBomb=36,true
    elseif s.bombs>0 then
        s.bombs=s.bombs-1
    else return false end
    lstg.var.bomb_used=(lstg.var.bomb_used or 0)+1
    return true
end
function M.miss(p,s)
    if s.enchantment~='green' then return end
    breakGreen(p,s)
    return true
end
P.adapters[38]=M
return M
