-- 夏夜祭自机。弹速、间隔与主炮伤害取自 MyPlane_*.cs。
local P=NativePlayers
local M={}
local function native() return _editor_class.TH40.native end
local shotRadius=15 -- BaseMyBullet 与 BulletGuidance 的原作判定半径。
local art={
    reimu={'Reimu',{192,144,64,16},{0,176,16,16},{128,144,16,16},{0,208,64,16}},
    marisa={'Marisa',{0,144,32,16},nil,{32,144,16,16}},
    sanae={'Sanae',{0,184,64,16},{0,144,32,32},{64,144,17,17},{144,144,64,11}},
    koishi={'Koishi',{208,176,48,16},{176,176,32,16},{71,151,19,19},{176,144,32,16}},
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
        if data[3] then image(prefix,id,'sub',data[3]) end
        image(prefix,id,'option',data[4])
        if data[5] then image(prefix,id,'focus',data[5]) end
        if m.id=='B' then
            for i=0,7 do LoadImage(prefix..'laser'..i,id,64-i*8,164,192,26) end
        end
    end
    p.summerImages=prefix
    local images={}
    for i=1,24 do images[i]=prefix..i end
    return images
end
function M.bind(p)
    local dir,index,clock=0,0,0
    p._wisys={frame=function()
        clock=clock+1
        local dx=p.__move_dx or 0;local nextdir=dx>.5 and 2 or dx<-.5 and 1 or 0
        if nextdir~=dir then index=1
        elseif nextdir==0 then index=math.floor(clock/6)%8
        elseif index<4 then index=index+.5 else index=4+math.floor(clock/6)%4 end
        dir=nextdir
        p.img=p.summerImages..(dir*8+math.floor(index)+1)
        p.a,p.b=p.A,p.B
    end,render=function()
        if p.native_body_hidden then return end
        SetImageState(p.img,'',unpack(p.native_tint or {255,255,255,255}))
        Render(p.img,p.x,p.y,0,1)
    end}
end
local focusedOptions={
    A={{{0,70}}, {{0,70},{0,70}}, {{0,70},{-24,0,87.5},{24,0,92.5}},
        {{0,70},{0,70},{-24,0,87.5},{24,0,92.5}}},
    B={{{0,40}}, {{-31,10,83},{31,10,97}}, {{0,40},{-31,10,83},{31,10,97}},
        {{-31,10,83},{31,10,97},{-14,35,87},{14,35,93}}},
    C={{{0,30}}, {{-10,30},{10,30}}, {{7,30},{-7,30},{0,30}},
        {{12,30},{-12,30},{6,30},{-6,30}}},
    D={{{0,44}}, {{-7,36},{7,36}}, {{16,29},{-16,29},{0,36}},
        {{16,29},{-16,29},{7,36},{-7,36}}},
}
local function option(p,index,count)
    if p.slow==1 then
        local point=focusedOptions[p.machine.id][count][index]
        return point[1],point[2],point[3] or 90
    end
    local n=index-(count+1)*.5
    return n*25,4-math.abs(n)*12,90
end
local ShotImpact=Class(object,{
    init=function(o,shot)
        o.x,o.y,o.rot=shot.x,shot.y,shot.rot
        o.vx,o.vy=3*cos(shot.dir),3*sin(shot.dir)
        o.texture=shot.img
        o.layer,o.group,o.bound,o.colli=LAYER.PLAYER_BULLET+.01,GROUP.GHOST,false,false
    end,
    frame=function(o) if o.timer>=15 then object.RawDel(o) end end,
    render=function(o)
        local size=1.2+o.timer*.05
        SetImageState(o.texture,'',math.floor(100*(1-o.timer/15)),255,255,255)
        Render(o.texture,o.x,o.y,o.rot,size)
        SetImageState(o.texture,'',255,255,255,255)
    end,
},true)
M.shotClass=Class(P.Shot,{
    kill=function(o)
        if o.killerenemy then New(ShotImpact,o) end
    end,
},true)
-- 原作魔理沙每帧发出光段，首帧回退 96，随后每帧前移 192，存活 5 帧。
local LaserShot=Class(object,{
    init=function(o,p,x,y,dir)
        o.source,o.offsetX,o.offsetY=p,x,y
        o.rot,o.co,o.si=dir,cos(dir),sin(dir)
        o.x,o.y=p.x+x-96*o.co,p.y+y-96*o.si
        o.layer,o.group,o.bound,o.colli=LAYER.PLAYER_BULLET,GROUP.GHOST,false,false
        o.damage=4
    end,
    frame=function(o)
        local p=o.source
        if o.timer>=5 or not IsValid(p) then object.RawDel(o);return end
        local distance=o.timer*192-96
        o.x,o.y=p.x+o.offsetX+distance*o.co,p.y+o.offsetY+distance*o.si
        if o.damage==0 then return end
        local hit=false
        object.EnemyNontjtDo(function(target)
            if not target.colli or target.protect or (target.hp or 0)<=0 then return end
            local dx,dy=target.x-o.x,target.y-o.y
            local along=(dx*o.co+dy*o.si-205)/128
            local across=(dx*o.si-dy*o.co)/13
            if along*along+across*across<1 then Damage(target,o.damage);hit=true end
        end)
        if hit then o.damage=0 end
    end,
    render=function(o)
        local p=o.source
        if not IsValid(p) then return end
        local img=p.summerImages..'laser'..(p.timer%8)
        Render(img,o.x,o.y,o.rot)
    end,
},true)
local function focusShots(p,x,y,dir,count,spread,speed,damage)
    for i=0,count-1 do
        local angle=dir+(i/(count-1)-.5)*spread
        P.emit(p,p.summerImages..'focus',x,y,speed,angle,damage,shotRadius,1).rot=angle
    end
end
function M.shoot(p,t,s)
    local id,tex=p.machine.id,p.summerImages
    if t%3==0 then
        for _,x in ipairs({-7,7}) do P.emit(p,tex..'main',x,0,30,90,p.machine.damage,shotRadius,1,nil,true).rot=90 end
        PlaySound('plst00',.16,p.x/384)
    end
    local count=math.min(4,math.floor(s.power/100))
    if id~='B' and t%(id=='D' and 10 or 4)~=0 then return end
    for i=1,count do
        local x,y,dir=option(p,i,count)
        if id=='B' then
            New(LaserShot,p,x,y,dir)
        elseif p.slow==1 then
            if id=='A' then focusShots(p,x,y,dir,2,6,18,5)
            elseif id=='C' then focusShots(p,x,y,dir,2,math.deg(.06),40,3)
            else focusShots(p,x,y,dir,5,24,15,6) end
        elseif id=='C' then
            for a=76,104,14 do P.emit(p,tex..'sub',x,y,13,a,3,shotRadius,.6) end
        elseif id=='D' then
            P.emit(p,tex..'sub',x,y,12,90,6,shotRadius,1)
        else
            P.emit(p,tex..'sub',x,y,12,90,9,shotRadius,1,5)
        end
    end
end
function M.render(p,s)
    local count=math.min(4,math.floor(s.power/100))
    for i=1,count do
        local x,y=option(p,i,count)
        Render(p.summerImages..'option',p.x+x,p.y+y,p.timer*2)
    end
    if p.slow==1 then
        local images=native().images;local r=p.timer*.02*4*180/math.pi
        if images.SlowEffect01 then
            SetImageState(images.SlowEffect01,'',120,255,255,255)
            Render(images.SlowEffect01,p.x,p.y,-r);Render(images.SlowEffect01,p.x,p.y,r)
        end
        if images.Center then Render(images.Center,p.x,p.y,-r) end
    end
end
function M.item(o,kind)
    local names={power='Item-0',red='StarShardRS',green='StarShardGS',blue='StarShardBS',star='SmallStar',life='Item-6',bombs='SpellItem'}
    local img=native().images[names[kind]]
    if not img then return end
    o.img,o.imgup=img,nil;o.native_item_visual={config={scale=1},name=kind,level=38}
    local radius=(kind=='life' or kind=='bombs') and 10 or (kind=='red' or kind=='green' or kind=='blue') and 8 or 5
    o.a,o.b,o.rect=radius,radius,false
end
function M.itemFrame(o)
    if not o.native_item_visual then return false end
    local p=o.target or player
    if o.attract>0 and IsValid(p) then SetV(o,math.min(10,o.attract),Angle(o,p))
    else
        o.vx=0
        o.vy=o.timer<=40 and math.max(0,4-o.timer*.1) or -math.min(1.5,(o.timer-40)*.15)
    end
    o.native_item_rotation=(o.kind=='red' or o.kind=='blue' or o.kind=='green') and 0 or o.timer<40 and -o.timer*.2*180/math.pi or 0
    if o.y<lstg.world.b-24 then object.RawDel(o) end
    return true
end
local DeathParticle=Class(object,{
    init=function(o,p)
        o.x,o.y=p.x,p.y;o.img=native().images.MyParticle01
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.PLAYER+1,false,false
        local a=ran:Int(0,359);local speed=math.floor(ran:Int(20,199)/10)
        o.vx,o.vy=speed*cos(a),speed*sin(a);o.scale=ran:Int(0,99)/100
    end,
    frame=function(o) if o.timer>=20 then object.RawDel(o) end end,
    render=function(o)
        if not o.img then return end
        SetImageState(o.img,'',math.max(0,200*(1-o.timer/20)),255,255,255)
        Render(o.img,o.x,o.y,0,math.max(.2,o.scale-o.timer/20))
    end,
},true)
function M.hit(p,s)
    if s.enchantment=='green' then M.miss(p,s);p.hit=nil;return end
    task.New(p,function()
        for _=1,4 do for _=1,10 do New(DeathParticle,p) end;task.Wait(1) end
    end)
end
function M.hitWindow() return 20 end
local extends={3,5,8,10,12,15,18,20,22}
local enchantmentColors={red={255,110,110},blue={120,185,255},green={125,255,150}}
function M.frame(p,s)
    if p.summerDamageGuard then
        p.summerDamageGuard=p.summerDamageGuard-1
        if p.summerDamageGuard<=0 then p.summerDamageGuard=nil end
    end
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
local GreenRemover=Class(object,{
    init=function(o,p)
        o.x,o.y=p.x,p.y;o.group,o.bound,o.colli=GROUP.GHOST,false,false
    end,
    frame=function(o)
        native().deathClear(o.x,o.y,500,true)
        if o.timer>=9 then object.RawDel(o) end
    end,
    render=function() end,
},true)
local function breakGreen(p,s)
    s.enchantment,s.enchantmentTime,s.star=nil,nil,0
    s.barrierCount=(s.barrierCount or 0)+1
    p.summerDamageGuard=30
    p.protect=math.max(p.protect,60)
    New(GreenRemover,p)
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
    if s.enchantment~='green' then
        p.summerDamageGuard=270
        for i=0,7 do
            local a=-2.2707963148739676+i*.1999999965940203
            P.pickup(p.x+40*math.cos(a),p.y-40*math.sin(a),'power',2)
        end
        return
    end
    breakGreen(p,s)
    return true
end
P.adapters[38]=M
return M
