-- 第一面九条 0x31：0x0c0a83d0 构造，0x0c0a8cd0 更新，0x0c0a7a20 交替控制侧炮与中央炮。
-- 八组振动历史与 48 个轨迹点按原队列推进；832 HP 由两块非对称判定共用。
-- 差异 1：使用 LuaSTG 录像随机数，原版全局对象池占用尚未接入。
-- 差异 2：投影、受伤色及尾气使用 LuaSTG 混色近似；击破音效尚待移植。
local direction=dofile('mod/GAME/th46/direction.lua')
local data=dofile('mod/GAME/th46/skimmer_data.lua')
local rank=dofile('mod/GAME/th46/rank.lua').get
local exhaust=dofile('mod/GAME/th46/exhaust.lua')
local death=dofile('mod/GAME/th46/skimmer_death.lua')
local object,unit,vector,heading=object,direction.unit,direction.vector,direction.heading
local floor,trunc,min,max,abs=math.floor,math.modf,math.min,math.max,math.abs
local texture='th46_skimmer'
local spawns={
    {1369,145,384,false,190},{1561,212,379,true,202},{1609,52,384,false,205},
    {1785,193,384,true,216},{1961,50,384,true,227},{2089,199,374,false,235},
    {2265,158,384,true,246},{2393,99,384,false,254},{2537,156,384,true,266},
}
local shapes={{32,32,32,20,0},{12,12,8,8,-20}}
local waveSpeeds={4,52,51,50,48,48,48,48}
local wavePhases={256,288,332,376,420,420,376,376}

local function turn(current,target,speed)
    return (current+max(-speed,min(speed,(target-current+256)%512-256)))%512
end

local function program(o)
    if not o.programActive then return end
    o.programClock=o.programClock-1
    if o.programClock>=0 then return end
    while true do
        local row=data.program[o.programIndex]
        if not row then return end
        o.programIndex=o.programIndex+1
        if row[1]==4 then o.speed=row[3]
        elseif row[1]==3 then
            o.angle,o.programClock=row[2],row[3]
            if row[3]==0 then o.programActive=false end
            return
        elseif row[1]==5 then o.hitEnabled=false
        else error('0x31 未移植的移动指令 '..row[1]) end
    end
end

local function place(o)
    o.x,o.y=o.boardX/unit-120,o.boardY/unit-160
    for _,box in ipairs(o.boxes) do
        local s=box.shape
        box.x,box.y=o.x,o.y+s[5]+(s[3]-s[4])/2
    end
end

local function remove(o)
    if o.closed then return end
    o.closed,o.hide=true,true
    exhaust.detach(o)
    for _,box in ipairs(o.boxes) do box.colli=false;object.RawDel(box) end
    o.run.roadSkimmers[o]=nil
    object.RawDel(o)
end

local function draw(o,sprite,x,y,flip,alpha)
    local image=texture..'_'..(sprite-0x2823)
    if sprite==0x2844 then SetImageState(image,'',alpha or 255,255,255,255)
    else SetImageState(image,'',alpha or 255,o.tintR,o.tintG,o.tintB) end
    Render(image,floor(x/unit)-120,floor(y/unit)-160,0,flip or 1,1)
end

local function stripSamples(run)
    if not run.data then return end
    local ids,partials,removed={},{},{}
    for _,row in ipairs(data.sampled.sprites) do ids[row[1]]=true end
    for _,row in ipairs(data.sampled.partialSprites or {}) do partials[row[1]]=true end
    for _,entries in pairs(run.data.enemies) do
        for i=#entries,1,-1 do
            local matched,other=false,false
            for _,pose in ipairs(entries[i].frames) do
                for at=6,#pose,6 do
                    local a,b=pose:byte(at,at+1)
                    local id=a*256+b
                    if ids[id] then matched=true elseif not partials[id] then other=true end
                end
            end
            if matched and not other then removed[entries[i].id]=true;table.remove(entries,i) end
        end
    end
    for _,shots in pairs(run.data.shots) do
        for i=#shots,1,-1 do if removed[shots[i].owner] then table.remove(shots,i) end end
    end
    local tiles={}
    for _,row in ipairs(data.sampled.tiles) do tiles[row[1]]=true end
    for _,background in pairs(run.data.backgrounds or {}) do
        if background[4] then
            local kept={}
            for at=1,#background[4],6 do
                local a,b=background[4]:byte(at,at+1)
                if not tiles[a*256+b] then kept[#kept+1]=background[4]:sub(at,at+5) end
            end
            background[4]=table.concat(kept)
        end
    end
end

local function damage(box,amount,flags)
    local o=box.host
    if o.hp<=0 or not o.hitEnabled then return end
    o.hitPending=true
    if o.protect>0 then return end
    o.hp=o.hp-amount
    o.hitFrame=o.run.roadFrame
    for _,part in ipairs(o.boxes) do part.hp=o.hp end
    if o.hp>0 then return end
    for _,part in ipairs(o.boxes) do part.colli=false end
    if o.gateClock==0 then o.run.skimmerGate=true end
    -- 击破入口在本文件后半部挂载，普通擦碰不会重复结算共享血量。
    o.defeat(o,flags or 0)
end

local Hitbox=Class(object,{
    init=function(o,host,shape)
        o.run,o.host,o.shape,o.hp,o.serial=host.run,host,shape,host.hp,host.run.serial
        o.group,o.layer,o.bound,o.colli=GROUP.ENEMY,LAYER.ENEMY,false,true
        o.a,o.b,o.rect=shape[1]+1,(shape[3]+shape[4])/2+2,true
        o.hide,o.damage=true,damage
        o.hitPilot=function(box,p)
            local x=floor(p.pilotPosition.x/unit)-floor(host.boardX/unit)
            -- 原版自机对象在控制坐标下方一像素，碰撞偏移再加一；最终中心是控制坐标。
            local y=floor(p.pilotPosition.y/unit)-floor(host.boardY/unit)-shape[5]
            return abs(x)<=shape[1]+2 and y>=-shape[4]-2 and y<=shape[3]+2
        end
    end,
    frame=function(o)
        if o.serial==o.run.serial or not o.colli then return end
        o.serial=o.run.serial
        local p=o.host.player
        -- 0x0c0795fa 将自机接触伤害设为 1，原碰撞批次每两步结算一次；保护不取消该伤害。
        if o.run.roadFrame%2==0 and p.respawn==0 and p.run==o.run and o.hitPilot(o,p) then damage(o,1,1) end
    end,
    colli=function(o,shot)
        if not o.colli or not shot.colli or not shot.dmg then return end
        damage(o,shot.dmg,shot.damageFlags)
        shot.colli=false;object.RawDel(shot)
    end,
})

local Enemy=Class(object,{
    init=function(o,run,spawn,p,defeat)
        o.run,o.player,o.defeat=run,p,defeat
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.ENEMY,false,false
        o.birthFrame,o.zone,o.hp,o.protect=run.roadFrame,spawn[5],832,48
        o.boardX,o.boardY=(spawn[2]-run.roadCamera)*unit,spawn[3]*unit
        o.programIndex,o.programClock,o.programActive,o.speed,o.angle=1,0,true,0,256
        o.hitEnabled,o.closed,o.entered=true,false,false
        o.hitPending,o.hitCount,o.tintR,o.tintG,o.tintB=false,0,255,255,255
        program(o)
        local value=rank(run)
        o.gateClock,o.fireClock,o.sideRemaining,o.sideCount=112,74-floor(value/4),1,1
        o.sideMode,o.mode=0,0
        o.aimClock,o.aimInterval,o.leftAim,o.rightAim=1,1,256,256
        o.centerClock,o.centerRemaining,o.centerCount,o.centerAim,o.centerShots=16-floor(value/64),2,2,0,0
        o.gun,o.gunClock,o.gunFrame,o.wingClock,o.wingFrame=256,0,0,61,7
        o.rawWaves,o.history,o.boxes={},{},{}
        for at=0xb8,0x2f4,4 do o.rawWaves[at]=0 end
        for i=0,7 do o.rawWaves[0xb8+i*0x48]=wavePhases[i+1] end
        for i=1,48 do o.history[i]={o.boardX,o.boardY} end
        for _,shape in ipairs(shapes) do o.boxes[#o.boxes+1]=New(Hitbox,o,shape) end
        run.roadSkimmers[o]=true
        place(o)
        exhaust.attach(o,0);exhaust.step(o)
    end,
    render=function(o)
        if o.closed then return end
        local w,x,y=o.rawWaves,o.boardX,o.boardY
        draw(o,0x2844,x+24*unit,y-88*unit,1,128)
        local function wing(phase,dx,offset,flip)
            local frame=data.wing[phase+1]
            local anchor=data.wingAnchor[frame+1]
            draw(o,0x2823+frame,x+dx*unit+anchor[1]*unit*flip+flip*trunc(w[offset]/10),
                y+(20+anchor[2])*unit+trunc(w[offset+4]/10),-flip)
        end
        wing(o.gunFrame,-12,0x1dc,-1)
        wing((o.gunFrame+1)%10,12,0x23c,1)
        draw(o,0x2829,x+trunc(w[0x194]/10),y+8*unit+trunc(w[0x198]/10))
        local function leg(phase,dx,offset,flip)
            local frame=data.leg[phase+1]
            local anchor=data.legAnchor[frame+1]
            draw(o,0x282b+frame,x+dx*unit+anchor[1]*unit*flip+flip*trunc(w[offset]/10),
                y+(8+anchor[2])*unit+trunc(w[offset+4]/10),-flip)
        end
        leg(o.wingFrame,-24,0x29c,-1)
        leg((o.wingFrame+1)%14,24,0x2cc,1)
        draw(o,0x282a,x+trunc(w[0x14c]/10),y+trunc(w[0x150]/10))
        draw(o,0x2833+floor((max(192,min(320,o.gun))-192)/8),x+trunc(w[0x104]/10),y-8*unit+trunc(w[0x108]/10))
    end,
})

return function(emit,defeat)
    defeat=defeat or death.defeat
    local function firing(o)
        local value=rank(o.run)
        if o.mode==0 then
            o.fireClock=o.fireClock-1
            if o.fireClock>=0 then return end
            o.fireClock,o.sideMode=5-floor(value/64),1
            if o.boardY<=160*unit then return end
            for _,angle in ipairs({o.leftAim,o.leftAim+4}) do emit(o.run,o.boardX-30*unit,o.boardY-unit,angle,8,0x19) end
            for _,angle in ipairs({o.rightAim,o.rightAim-4}) do emit(o.run,o.boardX+30*unit,o.boardY-unit,angle,8,0x19) end
            o.sideRemaining=o.sideRemaining-1
            if o.sideRemaining<=0 then
                o.sideRemaining,o.fireClock,o.sideMode,o.mode,o.centerShots=o.sideCount,32-floor(value/64),0,1,1
            end
        else
            o.centerClock=o.centerClock-1
            if o.centerClock>=0 then return end
            o.centerClock=4
            if o.boardY<=160*unit then return end
            local p=o.player
            local aim=p.respawn==0 and heading(o.boardX,o.boardY-16*unit,p.pilotPosition.x,p.pilotPosition.y) or 256
            o.centerAim=o.centerRemaining==o.centerCount and aim or turn(o.centerAim,aim,4)
            emit(o.run,o.boardX,o.boardY-16*unit,o.centerAim,10,0x12)
            o.centerShots,o.centerRemaining=o.centerShots+1,o.centerRemaining-1
            if o.centerRemaining<0 then o.centerRemaining,o.centerClock,o.mode=o.centerCount,32-floor(value/64),0 end
        end
    end
    local function step(o)
        if o.hp<=0 then remove(o);return end
        o.tintR,o.tintG,o.tintB=255,255,255
        if o.hitPending then
            if o.hitCount%2==1 then o.tintB=0 end
            o.hitCount=o.hitCount+1
        elseif o.hp<=207 and floor((o.run.roadFrame+1207)/2)%8==0 then
            o.tintG,o.tintB=64,64
        end
        o.hitPending=false
        program(o)
        local dx=o.run.roadCameraDelta
        local vx,vy=vector(o.speed,o.angle)
        o.boardX,o.boardY=o.boardX+vx+dx,o.boardY+vy
        for i=48,2,-1 do o.history[i][1],o.history[i][2]=o.history[i-1][1]+dx,o.history[i-1][2] end
        o.history[1][1],o.history[1][2]=o.boardX,o.boardY
        local w=o.rawWaves
        for i=0,7 do
            local base=0xb8+i*0x48
            for j=5,1,-1 do for k=0,8,4 do w[base+j*12+k]=w[base+(j-1)*12+k] end end
            w[base]=(w[base]+(i==0 and 1 or 12))%512
            local _,dy=vector(waveSpeeds[i+1],w[base])
            local at=base+(i==0 and 4 or 8)
            w[at]=w[at]+dy
        end
        o.boardX=o.boardX+trunc(w[0xbc]/80)
        place(o)
        local x=o.boardX+o.run.roadCamera*unit
        local inside=x>-72*unit and x<312*unit and o.boardY>-32*unit and o.boardY<352*unit
        if inside then o.entered=true elseif o.entered then
            if o.gateClock==0 then o.run.skimmerGate=true end
            remove(o);return
        end
        local p=o.player
        local function aim(dx,dy)
            return p.respawn==0 and heading(o.boardX+dx*unit,o.boardY+dy*unit,p.pilotPosition.x,p.pilotPosition.y) or 256
        end
        o.gun=turn(o.gun,max(192,min(320,aim(0,-16))),2)
        o.gunClock=o.gunClock-1
        if o.gunClock<0 then o.gunClock,o.gunFrame=3,(o.gunFrame+1)%10 end
        o.wingClock=o.wingClock-1
        if o.wingClock<0 then o.wingClock,o.wingFrame=2,(o.wingFrame+1)%14 end
        o.protect=max(0,o.protect-1)
        if o.sideMode==0 then
            o.aimClock=o.aimClock-1
            if o.aimClock<0 then
                o.aimClock=o.aimInterval
                o.leftAim,o.rightAim=turn(o.leftAim,aim(-30,-1),8),turn(o.rightAim,aim(30,-1),8)
            end
        end
        if o.gateClock>0 then o.gateClock=o.gateClock-1;o.run.skimmerGate=true end
        exhaust.step(o)
        firing(o)
    end
    return {
        open=function(run)
            run.roadSkimmers,run.nextSkimmer,run.skimmerGate={},1,false
            death.open(run)
            stripSamples(run)
            exhaust.open(run)
            if CheckRes('img',texture..'_0') then return end
            LoadTexture(texture,'Resources/th46/stage1/skimmer.png')
            SetTextureSamplerState(texture,'point+clamp')
            for i=0,33 do LoadImage(texture..'_'..i,texture,i%8*96,floor(i/8)*96,96,96) end
        end,
        step=function(run,frame,p)
            for o in pairs(run.roadSkimmers) do step(o) end
            local spawn=spawns[run.nextSkimmer]
            if spawn and spawn[1]==frame then
                if not spawn[4] or not run.skimmerGate then New(Enemy,run,spawn,p,defeat) end
                run.nextSkimmer=run.nextSkimmer+1
            end
        end,
        close=function(run)
            for o in pairs(run.roadSkimmers or {}) do remove(o) end
            death.close(run)
            run.roadSkimmers,run.skimmerGate=nil,false
        end,
    }
end
