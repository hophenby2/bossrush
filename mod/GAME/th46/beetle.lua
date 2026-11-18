-- 第一面卷轴位置 138 / 497 的 0x30。按 0x0c1eea88 逐条执行移动，原版 HP 为 832。
-- 0x0c0fa230 每两步寻向，Original 每轮三发 0x12；0x0c0fa9b0 处理共享判定与击破。
-- 差异 1：使用 LuaSTG 录像随机数，全局 rank 的其他事件偏移和原版对象池占用尚未接入。
-- 差异 2：原版加算混色用 LuaSTG 近似；击破音效尚待移植。
local direction=dofile('mod/GAME/th46/direction.lua')
local data=dofile('mod/GAME/th46/beetle_data.lua')
local effectData=dofile('mod/GAME/th46/midboss1_effect_data.lua')
local fragments=dofile('mod/GAME/th46/fragments.lua')(effectData.debris)
local gold=dofile('mod/GAME/th46/gold.lua')
local exhaust=dofile('mod/GAME/th46/exhaust.lua')
local power=dofile('mod/GAME/th46/power.lua')
local rank=dofile('mod/GAME/th46/rank.lua').get
local object,unit,vector,heading=object,direction.unit,direction.vector,direction.heading
local floor,trunc,abs,min,max=math.floor,math.modf,math.abs,math.min,math.max
local texture,effectTexture='th46_beetle','th46_midboss1_effects'
local maxHP,protectionFrames,killPoints=0x340,80,0x19a
local spawns={{537,145,375},{5030,122,381}}
-- 两个矩形共用本体坐标，原版均向下偏两像素；上下界并不对称。
local boxes={{16,16,36,30,-2},{40,40,11,7,-2}}

local function stripSamples(run)
    if not run.data then return end
    local images={}
    for _,row in ipairs(data.sampled and data.sampled.sprites or {}) do images[row[1]]=true end
    for _,entries in pairs(run.data.enemies) do
        for i=#entries,1,-1 do
            local matched,other=false,false
            for _,pose in ipairs(entries[i].frames) do
                for at=6,#pose,6 do
                    local a,b=pose:byte(at,at+1)
                    if images[a*256+b] then matched=true else other=true end
                end
            end
            if matched and not other then table.remove(entries,i) end
        end
    end
end

local function draw(row,x,y,flip)
    local image=texture..'_'..row[1]
    SetImageState(image,'',255,255,255,255)
    Render(image,floor(x/unit)-120+row[2]*(flip or 1),floor(y/unit)-160+row[3],0,flip or 1,1)
end

local function advanceProgram(o)
    if not o.programActive then return end
    o.programClock=o.programClock-1
    if o.programClock>=0 then return end
    while true do
        local row=data.program[o.programIndex]
        if not row then return end
        o.programIndex=o.programIndex+1
        if row[1]==4 then
            o.speed,o.angle=row[3],o.angle%512
        elseif row[1]==3 then
            o.angle,o.programClock=row[2],row[3]
            if row[3]==0 then o.programActive=false end
            return
        else
            error('大型飞虫出现未移植的移动指令 '..row[1])
        end
    end
end

local function remove(o)
    if o.closed then return end
    o.closed,o.hide,o.colli=true,true,false
    exhaust.detach(o)
    for _,box in ipairs(o.boxes) do box.hide,box.colli=true,false;object.RawDel(box) end
    o.run.roadBeetles[o]=nil
    object.RawDel(o)
end

local function removeEffect(o)
    if o.closed then return end
    o.closed,o.hide=true,true
    o.run.beetleEffects[o]=nil
    object.RawDel(o)
end

local Effect=Class(object,{
    init=function(o,host,x,y,kind,speed,angle,wait,first,alpha,blend,drop)
        o.run,o.serial=host.run,host.run.serial
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.ENEMY+2,false,false
        o.boardX,o.boardY,o.boardVX,o.boardVY=x,y,vector(speed,angle)
        o.kind,o.animation,o.index,o.wait=kind,effectData[kind],first,wait
        o.clock,o.alpha,o.blend,o.drop,o.visible,o.closed=0,alpha,blend,drop,false,false
        o.birthFrame=host.run.roadFrame
        o.run.beetleEffects[o]=true
    end,
    frame=function(o)
        if o.closed or o.serial==o.run.serial then return end
        o.serial=o.run.serial
        o.boardX=o.boardX+o.run.roadCameraDelta
        if not o.visible then
            o.wait=o.wait-1
            if o.wait>=0 then return end
            o.visible=true
            if o.drop~=nil then gold.emit(o.run,o.boardX+(ran:Int(0,16)-8)*unit,o.boardY+(ran:Int(0,16)-8)*unit,o.drop) end
        else
            o.clock=o.clock-1
            if o.clock<0 then
                o.index=o.index+1
                local row=o.animation.frames[o.index]
                if not row then removeEffect(o);return end
                o.clock=row[1]
            end
        end
        o.boardX,o.boardY=o.boardX+o.boardVX,o.boardY+o.boardVY
    end,
    render=function(o)
        if not o.visible then return end
        local row=o.animation.frames[o.index]
        local image=effectTexture..'_'..(o.animation.first+o.index-1)
        SetImageState(image,o.blend,o.alpha,255,255,255)
        Render(image,floor(o.boardX/unit)-120+row[2],floor(o.boardY/unit)-160+row[3])
    end,
})

local function explode(o)
    local focused=o.player.laser
    power.emit(o.run,o.boardX,o.boardY)
    for _=1,4 do fragments.emit(o.run,o.boardX,o.boardY,0,nil,true,LAYER.ENEMY+1) end
    local function effect(dx,dy,kind,speed,angle,wait,first,alpha,blend)
        New(Effect,o,o.boardX+dx*unit,o.boardY+dy*unit,kind,speed,angle,wait,first,alpha,blend,gold.choose(focused))
    end
    effect(16,4,4,6,ran:Int(0,31)-16,6,1,255,'')
    effect(-8,-4,6,5,96,3,4,255,'')
    effect(0,-8,2,0,0,0,1,255,'')
    effect(8,-48,5,0,0,0,4,112,'mul+add')
    if not focused then
        for _=1,2 do gold.emit(o.run,o.boardX+(ran:Int(0,16)-8)*unit,o.boardY+(ran:Int(0,16)-8)*unit,0) end
    end
end

local function damage(box,amount,flags)
    local o=box.host
    flags=flags or 0
    if o.hp<=0 or o.protect>0 or floor(flags/0x400)%2==1 then return end
    o.hp=o.hp-amount
    for _,part in ipairs(o.boxes) do part.hp=o.hp end
    if o.hp>0 then return end
    for _,part in ipairs(o.boxes) do part.colli=false end
    local points=floor(flags/0x20)%2==1 and floor(killPoints/40) or killPoints
    lstg.var.score=min(0xee6b27ff,lstg.var.score+points)
    explode(o)
end

local Hitbox=Class(object,{
    init=function(box,host,shape)
        box.run,box.host,box.shape=host.run,host,shape
        box.hp=host.hp
        box.group,box.layer,box.bound,box.colli=GROUP.ENEMY,LAYER.ENEMY,false,true
        box.a,box.b,box.rect=max(shape[1],shape[2])+1,(shape[3]+shape[4])/2+2,true
        box.hide,box.damage=true,damage
        box.hitPilot=function(part,p)
            local x=floor(p.pilotPosition.x/unit)-floor(part.host.boardX/unit)
            local y=floor(p.pilotPosition.y/unit)-1-floor(part.host.boardY/unit)-shape[5]
            return x>=-shape[1]-2 and x<=shape[2]+2 and y>=-shape[4]-2 and y<=shape[3]+2
        end
    end,
    colli=function(box,shot)
        if not shot.dmg or not shot.colli or not box.colli then return end
        damage(box,shot.dmg,shot.damageFlags)
        shot.colli=false
        object.RawDel(shot)
    end,
})

local function place(o)
    o.x,o.y=o.boardX/unit-120,o.boardY/unit-160
    for _,box in ipairs(o.boxes) do
        local shape=box.shape
        box.x,box.y=o.x,o.y+shape[5]+(shape[3]-shape[4])/2
    end
end

local Enemy=Class(object,{
    init=function(o,run,spawn,p)
        o.run,o.player,o.group,o.layer,o.bound,o.colli=run,p,GROUP.GHOST,LAYER.ENEMY,false,false
        o.boardX,o.boardY=(spawn[2]-run.roadCamera)*unit,spawn[3]*unit
        o.birthFrame,o.hp,o.protect=run.roadFrame,maxHP,protectionFrames
        o.programIndex,o.programClock,o.programActive,o.speed,o.angle=1,0,true,0,256
        advanceProgram(o)
        local value=rank(run)
        o.gun,o.aimClock,o.animationFrame,o.animationClock=256,1,0,0
        o.fireClock,o.firePause=64+ran:Int(0,15)-floor(value/8),132-floor(value/4)
        o.waves={{256,44,12,0},{300,44,12,0},{256,6,8,0},{0,6,8,0}}
        o.entered,o.closed,o.boxes=false,false,{}
        for _,shape in ipairs(boxes) do o.boxes[#o.boxes+1]=New(Hitbox,o,shape) end
        run.roadBeetles[o]=true
        place(o)
        exhaust.attach(o)
        exhaust.step(o)
    end,
    render=function(o)
        local wing=o.animationFrame%32
        draw(data.wing[wing+1],o.boardX-12*unit,o.boardY-16*unit)
        draw(data.wing[(wing+1)%32+1],o.boardX+12*unit,o.boardY-16*unit,-1)
        local gun=floor((max(192,min(320,o.gun))-192)/4)
        draw(data.gun[gun+1],o.boardX+4*unit,o.boardY-28*unit+trunc(o.waves[2][4]/10))
        draw(data.body[wing+1],o.boardX,o.boardY+trunc(o.waves[1][4]/10))
    end,
})

return function(emit)
    local function stepEnemy(o,p)
        if o.hp<=0 then remove(o);return end
        advanceProgram(o)
        local vx,vy=vector(o.speed,o.angle)
        o.boardX,o.boardY=o.boardX+vx+o.run.roadCameraDelta,o.boardY+vy
        for _,wave in ipairs(o.waves) do
            wave[1]=(wave[1]+wave[3])%512
            local _,dy=vector(wave[2],wave[1])
            wave[4]=wave[4]+dy
        end
        place(o)
        local x=o.boardX+o.run.roadCamera*unit
        local inside=x>-72*unit and x<312*unit and o.boardY>-32*unit and o.boardY<352*unit
        if inside then o.entered=true elseif o.entered then remove(o);return end
        exhaust.step(o)
        o.animationClock=o.animationClock-1
        if o.animationClock<0 then o.animationClock,o.animationFrame=1,o.animationFrame+1 end
        o.protect=max(0,o.protect-1)
        o.aimClock=o.aimClock-1
        if o.aimClock<0 then
            o.aimClock=1
            local aim=p.respawn==0 and heading(o.boardX,o.boardY,p.pilotPosition.x,p.pilotPosition.y) or 256
            aim=max(192,min(320,aim))
            local delta=(aim-o.gun+256)%512-256
            o.gun=(o.gun+max(-4,min(4,delta)))%512
        end
        o.fireClock=o.fireClock-1
        if o.fireClock<0 and o.boardY>64*unit then
            o.fireClock=o.firePause
            local muzzle=data.muzzle[floor(((o.gun+8)%512)/16)+1]
            -- 0x0c0fa2ac 的炮口偏移不左移 16 位；保留原版的亚像素偏移。
            for i=-1,1 do emit(o.run,o.boardX-unit+muzzle[1],o.boardY-17*unit+muzzle[2],o.gun+i*24,4,0x12) end
        end
    end
    return {
        open=function(run)
            run.roadBeetles,run.beetleEffects,run.nextBeetle={},{},1
            exhaust.open(run)
            power.open(run)
            stripSamples(run)
            if CheckRes('img',texture..'_0') then return end
            LoadTexture(texture,'Resources/th46/stage1/beetle.png')
            SetTextureSamplerState(texture,'point+clamp')
            for i=0,96 do LoadImage(texture..'_'..i,texture,i%12*96,floor(i/12)*96,96,96) end
            for col=0,16 do
                for phase=0,3 do LoadImage('th46_road1_beetle_shot_'..col..'_'..phase,texture,col*32,864+phase*32,32,32) end
            end
        end,
        step=function(run,frame,p)
            for o in pairs(run.roadBeetles) do stepEnemy(o,p) end
            local index=run.nextBeetle
            if spawns[index] and spawns[index][1]==frame then
                New(Enemy,run,spawns[index],p)
                run.nextBeetle=index+1
            end
        end,
        close=function(run)
            for o in pairs(run.roadBeetles or {}) do remove(o) end
            for o in pairs(run.beetleEffects or {}) do removeEffect(o) end
            fragments.close(run)
            exhaust.close(run)
            power.close(run)
            run.roadBeetles,run.beetleEffects=nil,nil
        end,
    }
end
