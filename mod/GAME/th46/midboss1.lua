-- 第一面卷轴位置 284 的 0x80。0x0c11ed40 建立本体，0x0c120af0 等待道中演出送入场信号。
-- 原版随机数共用序列与全局粒子池顺序尚待接入，当前随机分支使用 LuaSTG 录像随机数。
local direction = dofile('mod/GAME/th46/direction.lua')
local effectData = dofile('mod/GAME/th46/midboss1_effect_data.lua')
local createFragments = dofile('mod/GAME/th46/fragments.lua')
local gold = dofile('mod/GAME/th46/gold.lua')
local unit, heading, vector = direction.unit, direction.heading, direction.vector
local abs, min, max, floor, trunc = math.abs, math.min, math.max, math.floor, math.modf
local texture = 'th46_midboss1'
local effectTexture = 'th46_midboss1_effects'
local emissions = effectData.emissions

local birthFrame, enterFrame, timeoutAge = 2684, 2782, 901
local maxHP = 0x4c20
-- 0x0c121e80 / 0x0c122080 的四组腹部扇弹。组间计时 32 与出弹计时 5 都减到负数才推进。
local fanInterval, fanPause = 6, 33
local fanWidths = {1,1,3,5}
-- 0x0c122000 / 0x0c1224b0 和 0x0c121f00 / 0x0c1221f0 在第二段并行发射。
local wingFirstFrame, wingInterval, wingWaves = 347, 7, 28
local shoulderInterval = 17
local shoulderBursts = {{403,2,4}, {502,4,6}}
-- 0x0c120390 把第一面纵向卷轴速度乘以 10/9，向零取整。
local defeatScroll = trunc(unit*10/9)
-- 0x0c11fa20 的十组累加振动。前两项只动纵向，后续左右部件使用不同的初相。
local waves = {
    {256,60,0}, {300,52,0}, {308,40,-3}, {300,40,3}, {308,44,-2},
    {300,44,2}, {352,44,-2}, {344,44,2}, {256,44,-3}, {256,44,3},
}
-- 0x0c11ed40 挂在同一个伤害回调上的三个矩形，依次取左、右、上、下距离与纵向偏移。
local boxes = {{8,8,16,32,-44}, {136,136,8,8,0}, {72,72,24,16,0}}

local function distance(x,y,xx,yy)
    local dx,dy=abs(xx-x),abs(yy-y)
    return max(dx,dy)+floor(min(dx,dy)/2)
end

local function turn(angle,target)
    local delta=(target-angle+256)%512-256
    return (angle+max(-4,min(4,delta)))%512
end

local function beginMove(o,mode,x,y,interval)
    -- 0x0c120190 / 0x0c120280 以初始距离的一半作为加速阶段的分界。
    o.motion,o.targetX,o.targetY=mode,x,y
    o.halfDistance=floor(distance(o.boardX,o.boardY,x,y)/2)
    o.heading=heading(o.boardX,o.boardY,x,y)
    o.speedClock,o.speedInterval,o.brake=interval,interval,false
    o.speed=max(o.speed,1)
end

local function wanderTarget(o,p)
    -- 0x0c11fe40 接近上一目标 16 像素时重掷；0x0c11ffd0 的横向中心读取自机。
    local center=o.motion=='aim_wander' and p.pilotPosition.x or o.wanderX
    o.targetX=center+(ran:Int(0,48)-24)*unit
    o.targetY=o.wanderY+(ran:Int(0,48)-24)*unit
end

local function beginWander(o,p)
    o.motion=o.phase==2 and 'aim_wander' or 'wander'
    o.speed=o.phase==2 and 12 or 7
    o.wanderX,o.wanderY=o.boardX,o.boardY
    wanderTarget(o,p)
end

local function advancePose(o,dx)
    o.boardX=o.boardX+dx
    for i, wave in ipairs(waves) do
        local joint=o.joints[i]
        joint.phase=(joint.phase+8)%512
        local vx,vy=vector(wave[2],joint.phase)
        if wave[3]~=0 then joint.x=joint.x+trunc(vx/abs(wave[3]))*(wave[3]<0 and -1 or 1) end
        joint.y=joint.y+vy
    end
    o.wingClock=o.wingClock-1
    if o.wingClock<0 then
        o.wingFrame,o.wingClock=(o.wingFrame+1)%16,1
    end
end

local function move(o,p,dx)
    local vx,vy=vector(o.speed,o.heading)
    o.boardX,o.boardY=o.boardX+vx,o.boardY+vy
    advancePose(o,dx)
    local gap=distance(o.boardX,o.boardY,o.targetX,o.targetY)
    if o.motion=='wander' or o.motion=='aim_wander' then
        o.heading=turn(o.heading,heading(o.boardX,o.boardY,o.targetX,o.targetY))
        if gap<=16*unit then wanderTarget(o,p) end
        return
    end
    -- 0x0c120460 / 0x0c1205d0：先用旧速度走一步，再按剩余距离转向和增减速。
    if not o.brake then
        o.heading=turn(o.heading,heading(o.boardX,o.boardY,o.targetX,o.targetY))
        if gap<=o.halfDistance then
            o.brake=true
        else
            o.speedClock=o.speedClock-1
            if o.speedClock<0 then o.speed,o.speedClock=o.speed+1,o.speedInterval end
            if gap<=8*unit then o.brake=true end
        end
    end
    if o.brake then
        o.speedClock=o.speedClock-1
        if o.speedClock<0 then o.speed,o.speedClock=o.speed-1,o.speedInterval end
    end
    if o.speed<=0 then o.motion='start_wander' end
end

local function draw(sprite,x,y,mirror,tone)
    local image=texture..'_'..sprite
    tone=tone or 255
    SetImageState(image,'',255,tone,tone,tone)
    Render(image,floor(x/unit)-120,floor(y/unit)-160,0,mirror or 1,1)
end

local function damage(part,amount)
    local o=part.host
    if o.mode~='fight' then return end
    o.hp=o.hp-amount
    if o.hp>0 then return end
    -- 0x0c11f140 的三个碰撞子对象共享 0x0ebc，降到零的当步即关闭判定。
    o.hp=0
    o.laserDefeat=o.player.laser
    o.mode,o.defeatFrame='defeat',o.run.roadFrame
    for _, child in ipairs(o.boxes) do child.colli=false end
end

local function hitPilot(part,p)
    local pilot=p.pilotPosition
    local box=part.shape
    local x=floor(pilot.x/unit)-floor(part.boardX/unit)
    local y=floor(pilot.y/unit)-1-floor(part.boardY/unit)
    return x>=-box[1]-2 and x<=box[2]+2 and y>=-box[4]-2 and y<=box[3]+2
end

local function aimAt(p,x,y)
    local player=p.pilotPosition
    return p.respawn==0 and heading(x,y,player.x,player.y) or 256
end

return function(emit)
    local fragments=createFragments(effectData.debris)
    local function advanceEffect(o)
        if not o.visible and o.wait==0 and o.dropKind~=nil then
            -- 0x0c096570 在启动粒子的位移之前，以旧坐标各偏 ±8 像素分配道具。
            gold.emit(o.run,o.boardX+(ran:Int(0,16)-8)*unit,o.boardY+(ran:Int(0,16)-8)*unit,o.dropKind)
        end
        o.boardX=o.boardX+o.run.roadCameraDelta
        o.boardY=o.boardY-unit
        if not o.visible then
            o.wait=o.wait-1
            o.visible=o.wait<0
            if o.visible then
                o.boardX,o.boardY=o.boardX+o.boardVX,o.boardY+o.boardVY
            end
            return
        end
        o.boardX,o.boardY=o.boardX+o.boardVX,o.boardY+o.boardVY
        o.clock=o.clock-1
        if o.clock>=0 then return end
        o.index=o.index+1
        local frame=o.animation.frames[o.index]
        if not frame then
            o.run.midEffects[o]=nil
            object.RawDel(o)
            return
        end
        o.clock=frame[1]
    end

    local PartEffect=Class(object,{
        init=function(o,run,x,y,kind,speed,angle,wait,first,blend,alpha,dropKind)
            o.run,o.group,o.layer,o.bound,o.colli=run,GROUP.GHOST,LAYER.ENEMY+1,false,false
            o.boardX,o.boardY,o.serial=x,y,run.serial
            o.birthFrame=run.roadFrame
            o.boardVX,o.boardVY=vector(speed,angle)
            o.kind,o.wait,o.animation,o.index=kind,wait,effectData[kind],first
            o.clock=o.animation.frames[first][1]
            o.blend,o.alpha,o.visible=blend,alpha or 112,false
            o.dropKind=dropKind
            run.midEffects[o]=true
            advanceEffect(o)
        end,
        frame=function(o)
            if o.serial==o.run.serial then return end
            o.serial=o.run.serial
            advanceEffect(o)
        end,
        render=function(o)
            if not o.visible then return end
            local frame=o.animation.frames[o.index]
            local image=effectTexture..'_'..(o.animation.first+o.index-1)
            SetImageState(image,o.blend,o.alpha,255,255,255)
            Render(image,floor(o.boardX/unit)-120+frame[2],floor(o.boardY/unit)-160+frame[3])
        end,
    })

    local function effect(run,x,y,kind,speed,angle,wait,first,blend,alpha,host)
        local dropKind=host and gold.choose(host.laserDefeat)
        return New(PartEffect,run,x,y,kind,speed,angle,wait,first,blend,alpha,dropKind)
    end

    local function emitTable(o,rows,x,y,delaySecondary)
        -- 0x0c120740 的等待单位是两步；原版粒子的初始画格由标志位 8 决定。
        for _,row in ipairs(rows) do
            local angle=(row[6]*8+8+ran:Int(0,16))%512
            local first=row[2]>=8 and 1 or 4
            local blend=(row[2]==1 or row[2]==8) and '' or 'mul+add'
            effect(o.run,x+row[3],y+row[4],row[1],row[5],angle,row[7]+2*ran:Int(0,1),first,blend,nil,o)
            local secondaryAngle=ran:Int(0,511)
            local wait=delaySecondary and row[7]+2+2*ran:Int(0,1) or 0
            effect(o.run,x,y,11,32,secondaryAngle,wait,4,'mul+add',nil,o)
            for _=1,row[9] do fragments.emit(o.run,x+row[3],y+row[4],row[8]) end
        end
    end

    local Hitbox=Class(object,{
        init=function(part,o,shape)
            part.run,part.host,part.shape=o.run,o,shape
            part.group,part.layer,part.rect=GROUP.ENEMY,LAYER.ENEMY,true
            part.a,part.b=max(shape[1],shape[2])+1,max(shape[3],shape[4])+2
            part.bound,part.colli,part.hide=false,false,true
            part.damage,part.hitPilot=damage,hitPilot
        end,
        colli=function(part,shot)
            if not shot.dmg or not shot.colli or not part.colli then return end
            damage(part,shot.dmg)
            object.RawDel(shot)
        end,
    })

    local function partInfo(o,part)
        local side=part%2==1 and -1 or 1
        local flap=(o.wingFrame+(side==1 and 3 or 0))%16
        local joint=o.joints[part+4]
        local x=o.boardX+side*(part<=2 and 80 or 68)*unit+trunc(joint.x/10)
        local y=o.boardY-(part<=2 and 8 or 28)*unit+trunc(joint.y/10)
        local sprite
        if part<=2 then
            sprite=o.broken[part] and 0x4373 or 0x3dbe+flap
            if flap~=0 then y=y+4*unit end
        else
            sprite=0x3dce
        end
        return sprite,x,y,-side
    end

    local Boss=Class(object,{
        init=function(o,run,p)
            o.run,o.group,o.layer,o.bound,o.colli=run,GROUP.GHOST,LAYER.ENEMY,false,false
            o.player=p
            o.mode,o.motion,o.phase,o.hp='waiting','waiting',0,maxHP
            o.boardX,o.boardY=(115-run.roadCamera)*unit,337*unit
            o.speed,o.heading,o.wingFrame,o.wingClock=5,0,0,0
            o.boxes,o.joints,o.broken,o.flames={},{},{},{}
            for i,shape in ipairs(boxes) do o.boxes[i]=New(Hitbox,o,shape) end
            for i,wave in ipairs(waves) do o.joints[i]={phase=wave[1],x=0,y=0} end
        end,
        render=function(o)
            if o.mode=='waiting' or not o.visible then return end
            local tone=o.flash or 255
            local x,y=o.boardX,o.boardY
            for i=3,4 do
                local side=i==3 and -1 or 1
                local joint=o.joints[i]
                draw(0x3dbd,x+side*16*unit+trunc(joint.x/10),y+44*unit+trunc(joint.y/10),-side,tone)
            end
            for part=1,4 do
                if part<=2 or not o.broken[part] then
                    local sprite,px,py,side=partInfo(o,part)
                    draw(sprite,px,py,side,tone)
                end
            end
            local bodyY=y+trunc(o.joints[1].y/10)
            draw(0x3dde,x,bodyY,1,tone)
            draw(0x3ddf,x-24*unit,bodyY+12*unit,1,tone)
            draw(0x3def,x+24*unit,bodyY+12*unit,1,tone)
            draw(0x3dff,x,y-32*unit+trunc(o.joints[2].y/10),1,tone)
        end,
    })

    local function updateBoxes(o)
        for _,part in ipairs(o.boxes) do
            part.boardX,part.boardY=o.boardX,o.boardY+part.shape[5]*unit
            part.x,part.y=floor(part.boardX/unit)-120,floor(part.boardY/unit)-160
            part.hp=o.hp
            part.colli=o.mode=='fight' and o.visible
        end
    end

    local function breakPart(o,part)
        local _,x,y=partInfo(o,part)
        o.broken[part]=true
        o.flames[part]={index=1,clock=2}
        -- 0x0c120900 读取 0x0c2fa5c0；末项含三步等待，须连同其它字段一起保留。
        emitTable(o,emissions.part,x,y,true)
    end

    local function flame(o,part,controller)
        controller.clock=controller.clock-1
        if controller.clock>=0 then return end
        controller.clock=2
        local row=emissions.flame[controller.index]
        local _,x,y,mirror=partInfo(o,part)
        local side=-mirror
        local small=part>=3
        x=x+(row[3]-(small and 48*unit or 0))*side
        y=y+row[4]
        local spread=small and 16 or 32
        local angle=(256-(small and 40 or 128)*side+ran:Int(0,spread)-spread/2)%512
        local speed=row[5]+ran:Int(0,16)+(small and 72 or 40)
        effect(o.run,x,y,row[1],speed,angle,0,4,'',255)
        speed=row[5]+ran:Int(0,16)+(small and 72 or 56)
        local secondAngle=(angle+ran:Int(0,32)-16)%512
        effect(o.run,x,y,row[1],speed,secondAngle,2,row[2]>=8 and 1 or 4,'mul+add')
        -- 0x0c125110 / 0x0c1252ec 每轮另挂一份普通碎片与两份 24 类碎片。
        local debrisSpread=small and 48 or 128
        local debrisBase=angle-debrisSpread/2
        fragments.emit(o.run,x,y,0,debrisBase+ran:Int(0,debrisSpread))
        fragments.emit(o.run,x,y,24,debrisBase+ran:Int(0,debrisSpread))
        fragments.emit(o.run,x,y,24,debrisBase+ran:Int(0,debrisSpread))
        controller.index=controller.index+1
        if not emissions.flame[controller.index] then o.flames[part]=nil end
    end

    local function finalExplosion(o)
        local x,y=o.boardX,o.boardY
        -- 0x0c1213de 逐行读入 41 份爆炸，0x0c121810 叠加十二份波纹和十二份粒子。
        for _,row in ipairs(emissions.final) do
            local first=row[2]>=8 and 1 or 4
            local blend=(row[2]==1 or row[2]==8) and '' or 'mul+add'
            effect(o.run,x+row[3],y+row[4],row[1],row[5],row[6]*8,floor(row[7]/3),first,blend,nil,o)
            for _=1,2*row[9] do fragments.emit(o.run,x+row[3],y+row[4],row[8]) end
        end
        -- 0x0c121810 的伴随粒子当步启动，初速 48、透明度 88，出生点在中心各偏 ±4 像素。
        for _,row in ipairs(emissions.ripple) do
            local angle=(row[6]*8+8+ran:Int(0,16))%512
            effect(o.run,x+row[3],y+row[4],row[1],row[5],angle,row[7]+2*ran:Int(0,1),4,'',255,o)
            local px,py=x+(ran:Int(0,8)-4)*unit,y+(ran:Int(0,8)-4)*unit
            effect(o.run,px,py,11,48,ran:Int(0,511),0,4,'mul+add',88,o)
            for _=1,row[9] do fragments.emit(o.run,x+row[3],y+row[4],row[8]) end
        end
        -- 0x0c1214ac 的普通击破分支另在本体中心分配一个小金块。
        if not o.laserDefeat then gold.emit(o.run,x,y,0) end
        o.visible,o.run.midGate=false,false
        o.run.midExplosionFrame=o.run.roadFrame
        o.releaseClock=96
        o.run.roadSlow={phase=0,enabled=true}
    end

    local function defeat(o,frame,dx)
        local age=frame-o.defeatFrame
        if age<=2 then
            local vx,vy=vector(o.speed,o.heading)
            o.boardX,o.boardY=o.boardX+vx,o.boardY+vy
            advancePose(o,dx)
            o.speed=3
        end
        if age==2 then
            -- 0x0c120ca0 先抬升，再分别倒数四个零件的击破时机。
            o.impulseAngle=(ran:Int(0,16)-5)%512
            local rightTip,leftTip=ran:Int(4,8),ran:Int(10,14)
            local rightWing,leftWing=ran:Int(28,32),ran:Int(40,44)
            o.breakFrames={leftWing,rightWing,leftTip,rightTip}
            o.slowAge=leftWing+2+17
            o.releaseAge=o.slowAge+26
            emitTable(o,emissions.coreLeft,o.boardX,o.boardY)
            emitTable(o,emissions.coreRight,o.boardX,o.boardY)
        elseif age>=4 then
            local driftX,driftY=vector(o.speed,o.heading)
            local vx,vy=vector(max(0,48-(age-4)*2),o.impulseAngle)
            o.boardX=o.boardX+driftX+vx-ran:Int(-0x8000,0x7fff)
            o.boardY=o.boardY+driftY+vy-defeatScroll
            advancePose(o,dx)
            for part,controller in pairs(o.flames) do flame(o,part,controller) end
            for part,delay in ipairs(o.breakFrames) do
                if age==delay+2 then breakPart(o,part) end
            end
            if age==o.slowAge then o.speed,o.flash=1,128 end
            if age>=o.slowAge+17 then o.flash=min(255,128+(age-o.slowAge-16)*16) end
            if age==o.releaseAge then finalExplosion(o) end
        end
        if o.releaseAge and age>o.releaseAge then
            -- 0x0c1215a0 在 96 步倒数进入末 15 步时撤销减速，回调仍完成本步。
            if o.releaseClock==15 then o.run.roadSlow.enabled=false end
            o.releaseClock=o.releaseClock-1
            return o.releaseClock>=0
        end
        return true
    end

    local function fireFan(o,age,p)
        local fan=o.fan
        if age==o.fanStart then
            fan={group=1,pulse=0,offset=12,nextAge=age}
            o.fan=fan
        end
        if not fan or age~=fan.nextAge then return end
        local x,y=o.boardX,o.boardY-50*unit
        local aim=aimAt(p,x,y)
        -- 一组内只允许每波转过 4 格。下一组首波重新瞄准。
        fan.aim=fan.pulse==0 and aim or turn(fan.aim,aim)
        local width=fanWidths[fan.group]
        for i=0,width-1 do
            emit(o.run,x,y,(fan.aim+(i-(width-1)/2)*40)%512,fan.offset)
        end
        fan.pulse,fan.offset,fan.nextAge=fan.pulse+1,fan.offset+1,age+fanInterval
        if fan.pulse==fan.group+1 then
            fan.group,fan.pulse,fan.nextAge=fan.group+1,0,fan.nextAge+fanPause
            if not fanWidths[fan.group] then o.fan=nil end
        end
    end

    local function fireWingFans(o,age,p)
        -- 0x0c122340 接在腹部扇弹之后，各翼只在首波锁定一次方向。
        local elapsed=age-o.fanStart-181
        if elapsed<0 or elapsed>=32 or elapsed%4~=0 then return end
        local x,y=o.boardX,o.boardY-24*unit
        if elapsed==0 then
            o.leftWingAim=aimAt(p,x-68*unit,y)
            o.rightWingAim=aimAt(p,x+68*unit,y)
        end
        for delta=-32,32,32 do emit(o.run,x-68*unit,y,(o.leftWingAim+delta)%512,10) end
        for delta=-32,32,32 do emit(o.run,x+68*unit,y,(o.rightWingAim+delta)%512,10) end
    end

    local function fireWings(o,age,p)
        local elapsed=age-wingFirstFrame
        if elapsed<0 or elapsed>=wingWaves*wingInterval or elapsed%wingInterval~=0 then return end
        local x,y=o.boardX,o.boardY-24*unit
        local aim=aimAt(p,x,y)
        -- 两翼共用本体方向。各自发两路，右边整组比左边多 32 个角度单位。
        emit(o.run,x-68*unit,y,(aim-72)%512,4)
        emit(o.run,x-68*unit,y,(aim+40)%512,4)
        emit(o.run,x+68*unit,y,(aim-40)%512,4)
        emit(o.run,x+68*unit,y,(aim+72)%512,4)
    end

    local function fireShoulders(o,age,p)
        for _,burst in ipairs(shoulderBursts) do
            local elapsed=age-burst[1]
            if elapsed>=0 and elapsed<burst[2]*shoulderInterval and elapsed%shoulderInterval==0 then
                local y=o.boardY+16*unit
                for side=-1,1,2 do
                    local x=o.boardX+side*24*unit
                    local aim=aimAt(p,x,y)
                    for i=1,burst[3] do
                        emit(o.run,x,y,(aim+4*i-2*(burst[3]+1))%512,8,0x19)
                    end
                end
            end
        end
    end

    local function stepBoss(o,frame,p,dx)
        local age=frame-enterFrame
        if o.mode=='waiting' then
            if age==0 then
                o.boardX,o.boardY=0x008194b0-o.run.roadCamera*unit,0x00fa7350
                o.mode,o.run.midGate,o.speed='fight',true,4
            end
        elseif o.mode=='defeat' then
            if not defeat(o,frame,dx) then return false end
        elseif frame==birthFrame+timeoutAge then
            o.run.midGate,o.mode,o.speed=false,'retreat',4
        elseif o.mode=='retreat' then
            if o.motion~='leave' then
                beginMove(o,'leave',(120-o.run.roadCamera)*unit,576*unit,8)
            else
                move(o,p,dx)
            end
            if o.boardY>512*unit then return false end
        elseif age==1 then
            o.visible=true
            beginMove(o,'entry',(120-o.run.roadCamera)*unit,256*unit,8)
        elseif age==3 or age==648 then
            o.phase=1
            o.fanStart=age==3 and 84 or age+82
            beginMove(o,'approach',(96-o.run.roadCamera)*unit,280*unit,4)
        elseif age==343 then
            o.motion='second_entry'
        elseif o.motion=='second_entry' then
            o.phase=2
            beginMove(o,'approach',p.pilotPosition.x,280*unit,4)
        elseif o.motion=='start_wander' then
            beginWander(o,p)
        elseif o.motion~='waiting' then
            move(o,p,dx)
        end
        if o.mode=='fight' then
            if o.phase==1 then
                fireFan(o,age,p)
                fireWingFans(o,age,p)
            elseif o.phase==2 then
                fireShoulders(o,age,p)
                fireWings(o,age,p)
            end
        end
        updateBoxes(o)
        return true
    end

    local function removeBody(run)
        local o=run.midBoss
        if IsValid(o) then
            o.hide=true
            for _,part in ipairs(o.boxes) do
                part.colli=false
                object.RawDel(part)
            end
            object.RawDel(o)
        end
        run.midBoss,run.midGate=nil,false
    end

    local function close(run)
        removeBody(run)
        for effect in pairs(run.midEffects or {}) do
            if IsValid(effect) then object.RawDel(effect) end
        end
        run.midEffects=nil
        fragments.close(run)
    end

    return {
        open=function()
            if CheckRes('img',texture..'_'..0x3dbd) then return end
            LoadTexture(texture,'Resources/th46/stage1/midboss1.png')
            SetTextureSamplerState(texture,'point+clamp')
            for slot=0,83 do
                local sprite=slot<82 and 0x3dbd+slot or 0x4373+slot-82
                LoadImage(texture..'_'..sprite,texture,slot%12*160,floor(slot/12)*112,160,112)
            end
            LoadTexture(effectTexture,'Resources/th46/stage1/midboss1_effects.png')
            SetTextureSamplerState(effectTexture,'point+clamp')
            for kind=0,11 do
                local animation=effectData[kind]
                for i=1,#animation.frames do
                    local slot=animation.first+i-1
                    LoadImage(effectTexture..'_'..slot,effectTexture,slot%15*128,floor(slot/15)*128,128,128)
                end
            end
            for _,animation in pairs(effectData.debris) do
                for i=1,#animation.frames do
                    local slot=animation.first+i-1
                    LoadImage(effectTexture..'_'..slot,effectTexture,slot%15*128,floor(slot/15)*128,128,128)
                end
            end
        end,
        step=function(run,frame,p,dx)
            if frame==birthFrame then
                run.midEffects={}
                run.midBoss=New(Boss,run,p)
            elseif IsValid(run.midBoss) and not stepBoss(run.midBoss,frame,p,dx) then
                removeBody(run)
            end
        end,
        close=close,
    }
end
