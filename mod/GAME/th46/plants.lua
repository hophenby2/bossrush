-- 第一面 0x34 控制器、0x33 草与八条 0x35 大草丛指令。
-- 0x0c0a01f0 根据卷轴位置改变生成间隔，0x0c09fba0 / 0x0c0a00a0 保留定点运动与动画。
-- 差异 1：外观、速度、方向和击破粒子使用 LuaSTG 录像随机数，尚未共用原版全局序列。
-- 差异 2：地面投影和粒子混色使用 LuaSTG 近似；原版对象池占用及延后构造尚未接入。
local direction=dofile('mod/GAME/th46/direction.lua')
local data=dofile('mod/GAME/th46/plants_data.lua')
local gold=dofile('mod/GAME/th46/gold.lua')
local unit,vector=direction.unit,direction.vector
local floor,abs,max=math.floor,math.abs,math.max
local texture='th46_plants'
local controllerStart,controllerEnd,particleCapacity=2185,3548,128
-- 按当前未射击参考时间轴换算卷轴位置 >271、>279、>335；>391 时退出控制器。
local controllerChanges={[2588]={1,3},[2652]={2,3},[3100]={3,6}}
local bushes={
    {2556,69,364,14,272}, {2572,113,341,14,256}, {2588,150,356,15,240},
    {2660,102,351,14,256}, {2668,215,349,14,272}, {2684,16,344,15,240},
    {2740,68,343,14,272}, {2740,151,337,15,240},
}
-- 0x0c2dab18 的七个横向分区，以八像素为单位；0x34 的初始间隔为 16。
local lanes={0,4,8,12,16,20,24}

local function stripSamples(run)
    local sampled=data.sampled
    local images,tiles,shadows={},{},{}
    for _,row in ipairs(sampled.sprites or {}) do images[row[1]]=true end
    for _,row in ipairs(sampled.tiles or {}) do tiles[row[1]]=row end
    for _,row in ipairs(sampled.shadows or {}) do shadows[row[1]]=row end
    local function word(s,i)
        local a,b=s:byte(i,i+1)
        local n=a*256+b
        return n<32768 and n or n-65536
    end
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
    -- 同一批植物被旧导出器分别放入敌机和背景；只移除像素已确认的裁片，保留地形网格。
    for _,background in pairs(run.data.backgrounds) do
        local scenery=background[4]
        if scenery then
            local centers,kept={},{}
            for at=1,#scenery,6 do
                local a,b=scenery:byte(at,at+1)
                local shape=tiles[a*256+b]
                if shape then centers[(word(scenery,at+4)*2+shape[2])..':'..(word(scenery,at+2)*2+shape[3])]=true end
            end
            for at=1,#scenery,6 do
                local a,b=scenery:byte(at,at+1)
                local id=a*256+b
                local shadow=shadows[id]
                local duplicate=shadow and centers[(word(scenery,at+4)*2+shadow[2])..':'..(word(scenery,at+2)*2+shadow[3])]
                if not tiles[id] and not duplicate then kept[#kept+1]=scenery:sub(at,at+5) end
            end
            background[4]=table.concat(kept)
        end
    end
end

local function draw(frame,x,y,flipX,flipY,alpha,blend,r,g,b)
    local image=texture..'_'..frame[1]
    SetImageState(image,blend or '',alpha or 255,r or 255,g or 255,b or 255)
    Render(image,floor(x/unit)-120,floor(y/unit)-160,0,flipX or 1,flipY or 1)
end

local function remove(o)
    o.run.roadPlants[o]=nil
    o.colli,o.hide=false,true
    object.RawDel(o)
end

local function place(o)
    o.x,o.y=floor(o.boardX/unit)-120,floor(o.boardY/unit)-160+(o.large and 22 or 0)
end

local function hitPilot(o,p)
    local plant=o.host or o
    local x=floor(p.pilotPosition.x/unit)-floor(plant.boardX/unit)
    local y=floor(p.pilotPosition.y/unit)-1-floor(plant.boardY/unit)
    if plant.large then return abs(x)<=34 and y>=-22 and y<=66 end
    return abs(x)<=10 and abs(y)<=10
end

local function advanceParticle(o)
    if not o.visible then
        o.visible=true
        if o.dropKind~=nil then
            gold.emit(o.run,o.boardX+(ran:Int(0,16)-8)*unit,o.boardY+(ran:Int(0,16)-8)*unit,o.dropKind)
        end
    end
    -- 与中 Boss 粒子同属 0x0c0963ce 的更新队列；碎草动画另在换格时减 8 透明度。
    o.boardX,o.boardY=o.boardX+o.run.roadCameraDelta+o.boardVX,o.boardY+o.boardVY
    o.clock=o.clock-1
    if o.clock>=0 then return end
    o.alpha=max(0,o.alpha-8)
    o.index=o.index+1
    local frame=o.animation[o.index]
    if not frame then
        o.run.plantEffects[o]=nil
        o.run.plantEffectCount=o.run.plantEffectCount-1
        o.closed,o.hide=true,true
        object.RawDel(o)
        return
    end
    o.clock=frame[4]
end

local Particle=Class(object,{
    init=function(o,run,x,y,kind,speed,angle,first,alpha,flip,blend,drop)
        o.run,o.group,o.layer,o.bound,o.colli=run,GROUP.GHOST,LAYER.ENEMY+1,false,false
        o.boardX,o.boardY,o.boardVX,o.boardVY=x,y,vector(speed,angle)
        o.animation,o.kind,o.index,o.clock=data.particle[kind],kind,first,1
        o.serial,o.alpha,o.flip,o.blend=run.serial,alpha,flip,blend
        o.visible,o.dropKind,o.closed=false,drop,false
        run.plantEffects[o]=true
        run.plantEffectCount=run.plantEffectCount+1
    end,
    frame=function(o)
        if o.closed or o.serial==o.run.serial then return end
        o.serial=o.run.serial
        advanceParticle(o)
    end,
    render=function(o)
        if not o.visible then return end
        local frame=o.animation[o.index]
        local flip=o.flip==1 and -1 or 1
        draw(frame,o.boardX+flip*frame[2]*unit,o.boardY+frame[3]*unit,flip,1,o.alpha,o.blend)
    end,
})

local function particle(o,kind,speed,angle,first,alpha,flip,blend,drop)
    if o.run.plantEffectCount>=particleCapacity then return end
    return New(Particle,o.run,o.boardX,o.boardY,kind,speed,angle,first,alpha,flip,blend,drop)
end

local function explode(o)
    local focused=o.player.laser
    if o.large then
        -- 0x0c09fd7e：三组抛出的碎草，每组一层 128 透明度和一层普通混色。
        for pair=1,3 do
            local kind=(pair==3 and 20 or 18)+ran:Int(0,1)
            local speed=(pair==1 and 64 or pair==2 and 96 or 112)+ran:Int(0,16)
            local angle=(pair==3 and 160 or 192)+4*ran:Int(0,pair==3 and 31 or 15)
            local flip=ran:Int(0,1)
            local drop
            if pair==1 then drop=gold.choose(focused) end
            particle(o,kind,speed,angle,1,128,flip,'mul+add',drop)
            particle(o,kind,speed,angle,4,255,flip,'')
        end
    else
        -- Original 的 0x0c09f73a 读取本体速度和方向，第二组速度取 3/2 并向零取整。
        local flip=ran:Int(0,1)
        particle(o,18,o.speed,o.angle,1,128,flip,'mul+add',gold.choose(focused))
        particle(o,18,o.speed,o.angle,1,255,flip,'')
        local kind=20+ran:Int(0,1)
        local angle=o.angle+4*ran:Int(0,15)-32
        flip=ran:Int(0,1)
        particle(o,kind,floor(3*o.speed/2),angle,4,128,flip,'mul+add')
        particle(o,kind,floor(3*o.speed/2),angle,4,255,flip,'')
    end
    if not focused then gold.emit(o.run,o.boardX,o.boardY,0) end
end

local function damage(target,amount)
    local o=target.host or target
    if o.hp<=0 then return end
    o.hp=o.hp-amount
    if o.hp>0 then o.hitFlash=true;return end
    explode(o)
    remove(o)
end

local function hitShot(target,shot)
    if not target.colli or not shot.colli or not shot.dmg then return end
    damage(target,shot.dmg)
    shot.colli=false
    object.RawDel(shot)
end

local Plant=Class(object,{
    init=function(o,run,p,x,y,large,speed,angle)
        o.run,o.player,o.large,o.serial=run,p,large,run.serial
        o.boardX,o.boardY=x-(large and run.roadCamera or 0)*unit,y
        -- 受弹盒半宽 28、半高 24；自机另走 hitPilot，使用半宽和半高均为 8 的接触盒。
        o.group,o.layer,o.bound,o.colli=GROUP.ENEMY,LAYER.ENEMY,false,true
        o.a,o.b,o.rect=large and 33 or 29,large and 44 or 26,true
        o.hp,o.damage,o.hitPilot=large and 4096 or 4,damage,hitPilot
        o.speed,o.angle=speed,angle
        o.phase,o.clock,o.interval,o.entered,o.flash=0,1,1,false,0
        o.flashClock,o.hitFlash=0,false
        if large then
            o.flip,o.variant=0,3
            ran:Int(0,3)
            ran:Int(3,6)
            ran:Int(2,3)
            o.vibration=angle+ran:Int(0,16)-8
            ran:Int(0,32)
        else
            -- 保留未用于当前绘制的随机取值，避免删掉构造器字段后改变后续录像随机数的消费顺序。
            ran:Int(3,6)
            ran:Int(2,3)
            o.vibration=angle+ran:Int(0,16)-8
            ran:Int(0,32)
            o.flip,o.variant=ran:Int(0,3),ran:Int(0,2)
            ran:Int(0,1)
        end
        o.boardVX,o.boardVY=vector(speed,angle)
        run.roadPlants[o]=true
        place(o)
    end,
    colli=hitShot,
    render=function(o)
        local frame=data.body[o.variant][o.phase+1]
        local sx=o.flip%2==1 and -1 or 1
        local sy=not o.large and o.flip>=2 and -1 or 1
        local x,y=o.boardX+sx*frame[2]*unit,o.boardY+sy*frame[3]*unit
        local shadow=data.shadow[o.large and 3 or o.variant==0 and 1 or o.variant==1 and 2 or 3]
        draw(shadow,x,y,1,1,144,'',48,96,64)
        draw(frame,x+4*unit,y-88*unit,sx,sy,96,'',0,0,0)
        draw(frame,x,y,sx,sy,255,'',255,255,o.flash>0 and 64 or 255)
    end,
})

local function advance(o)
    o.boardX,o.boardY=o.boardX+o.boardVX+o.run.roadCameraDelta,o.boardY+o.boardVY
    place(o)
    o.flash=0
    if o.hitFlash then
        o.hitFlash=false
        o.flashClock=o.flashClock+1
        o.flash=o.flashClock%2
    end
    local margin=o.large and 64 or 36
    local x=o.boardX/unit+o.run.roadCamera
    local outside=x<=-margin-(o.large and 40 or 0) or x>=240+margin+(o.large and 40 or 0)
        or o.boardY<=-margin*unit or o.boardY>=(320+margin)*unit
    if not outside then o.entered=true
    elseif o.entered then remove(o);return end
    o.clock=o.clock-1
    if o.clock<0 then o.clock,o.phase=o.interval,(o.phase+1)%#data.body[o.variant] end
end

return {
    open=function(run)
        run.roadPlants,run.plantEffects,run.nextBush={}, {},1
        run.plantEffectCount=0
        run.plantController=nil
        stripSamples(run)
        if CheckRes('img',texture..'_0') then return end
        LoadTexture(texture,'Resources/th46/stage1/plants.png')
        SetTextureSamplerState(texture,'point+clamp')
        local function load(frames)
            for _,frame in ipairs(frames) do
                local slot=frame[1]
                LoadImage(texture..'_'..slot,texture,slot%12*128,floor(slot/12)*128,128,128)
            end
        end
        for _,frames in pairs(data.body) do load(frames) end
        for _,frames in pairs(data.particle) do load(frames) end
        load(data.shadow)
    end,
    step=function(run,frame,p)
        for o in pairs(run.roadPlants) do if IsValid(o) then advance(o) end end
        if frame==controllerStart then run.plantController={phase=0,clock=0,interval=16}
        elseif run.plantController then
            local controller=run.plantController
            local change=controllerChanges[frame]
            if change then controller.phase,controller.interval=change[1],change[2]
            elseif frame==controllerEnd then run.plantController=nil;controller=nil end
            if controller then
                controller.clock=controller.clock-1
                if controller.clock<0 then
                    controller.clock=controller.interval
                    local x=lanes[ran:Int(1,#lanes)]*8*unit
                    if not run.midGate then New(Plant,run,p,x,320*unit,false,24+ran:Int(0,20),224+4*ran:Int(0,16)) end
                end
            end
        end
        local row=bushes[run.nextBush]
        while row and row[1]==frame do
            New(Plant,run,p,row[2]*unit,row[3]*unit,true,row[4],row[5])
            run.nextBush=run.nextBush+1
            row=bushes[run.nextBush]
        end
    end,
    close=function(run)
        for o in pairs(run.roadPlants or {}) do if IsValid(o) then remove(o) end end
        for o in pairs(run.plantEffects or {}) do
            if IsValid(o) then o.closed,o.hide=true,true;object.RawDel(o) end
        end
        run.roadPlants,run.plantEffects,run.plantController=nil,nil,nil
        run.plantEffectCount=0
    end,
}
