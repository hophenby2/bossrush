-- 地炮的 0x1710d4 先挂首帧回调，首帧再把弹体切换到 0x1740b4。
return function(program,art)
    local bit = require('bit')
    local band,bor = bit.band,bit.bor
    local floor = math.floor
    local s16 = program.s16
    local M = {}
    local handlers = {}

    local function expired(b)
        return band(b.h,0xffff) >= 0x7000 or band(b.l,0xffff) >= 0x3800
    end

    local function velocity(b)
        b.dh,b.dl = program.vector(b.speed,b.angle,b.run.slowVectors)
    end

    local function launch(b,callback)
        if expired(b) then return false end
        local run = b.run
        local direction = floor(band(b.angle + 4,0xf8) / 8) + 1
        local shifts = program.bulletLaunch[direction]
        b.h,b.l = s16(b.h + shifts[1]),s16(b.l + shifts[2])
        run.bulletFlashCycle = (run.bulletFlashCycle or 0) % 3 + 1
        b.flash = program.flashImages[direction][run.bulletFlashCycle]
        b.flashH,b.flashL = b.offsetH + shifts[1],b.offsetL + shifts[2]
        velocity(b)
        b.flags,b.callback = band(b.flags,0xfeff),callback
        b.update = handlers[b.callback]
        return true
    end

    local function advance(b)
        local run = b.run
        b.flash = nil
        b.h,b.l = program.addPacked(b.h,b.l,b.dh * 0x10000 + band(b.dl - run.cameraStep,0xffff))
    end

    local function adjustSpeed(b)
        local run = b.run
        local target = run.awakened and b.fastSpeed or b.baseSpeed
        if run.reloadBulletVelocity or run.awakeningReload then velocity(b)
        elseif b.speed ~= target and not (run.awakened and run.slowVectors) then
            b.speedClock = b.speedClock - 1
            if b.speedClock < 0 then
                local speed = run.awakened and b.speed + 1 or b.speed - 2
                b.speed = run.awakened and math.min(speed,target) or math.max(speed,target)
                b.speedClock = 0
                velocity(b)
            end
        end
    end

    local function move(b)
        advance(b)
        if expired(b) then return false end
        adjustSpeed(b)
        return true
    end

    handlers[0x17403a] = function(b)
        if not launch(b,0x1740b4) then return false end
        b.images,b.offsetH,b.offsetL = program.roundImages,-0x200,-0x200
        return true
    end

    handlers[0x1740b4] = function(b)
        if not move(b) then return false end
        if not b.run.stopPathClock then b.imageFrame = b.imageFrame % 4 + 1 end
        return true
    end

    handlers[0x1741bc] = function(b)
        if not launch(b,0x174236) then return false end
        b.images,b.offsetH,b.offsetL = program.mid1.roundImages,-0x200,-0x200
        return true
    end

    handlers[0x174236] = function(b)
        if not move(b) then return false end
        if not b.run.stopPathClock then b.imageFrame = b.imageFrame % 8 + 1 end
        return true
    end

    handlers[0x174d10] = function(b)
        if not launch(b,0x174d8a) then return false end
        b.images,b.offsetH,b.offsetL = program.heavyRoundImages,-0x200,-0x200
        return true
    end

    handlers[0x174d8a] = function(b)
        if not move(b) then return false end
        if not b.run.stopPathClock then b.imageFrame = b.imageFrame % 4 + 1 end
        return true
    end

    handlers[0x17433e] = function(b)
        if not launch(b,0x1743b8) then return false end
        b.images,b.offsetH,b.offsetL = program.gunshipRoundImages,-0x400,-0x200
        return true
    end

    handlers[0x1743b8] = handlers[0x1740b4]

    local function launchArrow(b,callback,images)
        if not launch(b,callback) then return false end
        local angle = floor(band(b.angle + 4,0xf8) / 8) + 1
        b.images = images[program.arrowDirection[angle]]
        b.offsetH,b.offsetL,b.imageFrame,b.imageClock = -0x400,-0x200,3,1
        return true
    end

    handlers[0x1744ee] = function(b)
        return launchArrow(b,0x174578,program.arrowImages)
    end

    handlers[0x174578] = function(b)
        if not move(b) then return false end
        b.imageClock = b.imageClock - 1
        if b.imageClock < 0 then b.imageClock,b.imageFrame = 1,(b.imageFrame + 1) % 3 + 1 end
        return true
    end

    handlers[0x17493a] = function(b)
        return launchArrow(b,0x1749c4,program.twinTankBulletImages)
    end

    handlers[0x1749c4] = handlers[0x174578]

    handlers[0x1753bc] = function(b)
        return launchArrow(b,0x175446,program.gunshipArrowImages)
    end

    handlers[0x175446] = handlers[0x174578]

    handlers[0x174e92] = function(b)
        if not launch(b,0x174f0c) then return false end
        b.images,b.offsetH,b.offsetL = program.boss1.sweepRound,-0x400,-0x200
        return true
    end

    handlers[0x174f0c] = move

    handlers[0x175bb0] = function(b)
        if not launch(b,0x175c2a) then return false end
        b.images,b.offsetH,b.offsetL = program.stage2Forts.roundImage,-0x200,-0x200
        return true
    end

    handlers[0x175c2a] = move

    local boss2Rounds = {program.boss2.round}
    handlers[0x175d32] = function(b)
        if not launch(b,0x175dac) then return false end
        b.images,b.offsetH,b.offsetL = boss2Rounds,-0x400,-0x200
        return true
    end

    handlers[0x175dac] = move

    handlers[0x175014] = function(b)
        if not launch(b,0x17508e) then return false end
        b.images,b.offsetH,b.offsetL = program.boss1Core.ringBullet,-0x400,-0x200
        return true
    end

    handlers[0x17508e] = move

    handlers[0x175196] = function(b)
        if not launch(b,0x175220) then return false end
        b.images,b.offsetH,b.offsetL = program.mid2.rounds,-0x200,-0x200
        b.imageFrame,b.imageClock = 3,1
        return true
    end

    handlers[0x175220] = function(b)
        if not move(b) then return false end
        if not b.run.stopPathClock then
            b.imageClock = b.imageClock-1
            if b.imageClock<0 then b.imageClock,b.imageFrame = 1,b.imageFrame==3 and 1 or 3 end
        end
        return true
    end

    local function sweepArrow(b,callback,index)
        if not launchArrow(b,callback,program.boss1.sweepArrows[index]) then return false end
        b.nextImage = 2
        return true
    end

    local function moveSweepArrow(b)
        if not move(b) then return false end
        b.imageClock = b.imageClock-1
        if b.imageClock < 0 then
            b.imageClock,b.imageFrame = 1,b.nextImage
            b.nextImage = b.nextImage == 1 and 3 or 1
        end
        return true
    end

    handlers[0x1755e2] = function(b) return sweepArrow(b,0x17566c,1) end
    handlers[0x175808] = function(b) return sweepArrow(b,0x175892,2) end
    handlers[0x17566c],handlers[0x175892] = moveSweepArrow,moveSweepArrow
    handlers[0x174714] = function(b)
        if not launchArrow(b,0x17479e,program.boss6.images.finalTailArrows) then return false end
        b.nextImage=2
        return true
    end
    handlers[0x17479e] = moveSweepArrow

    handlers[0x175eb4] = function(b)
        if not launch(b,0x175f2e) then return false end
        b.images,b.offsetH,b.offsetL = program.boss1.arcImages,-0x400,-0x200
        return true
    end

    handlers[0x175f2e] = handlers[0x1740b4]

    local function cycleLaunch(callback,images,offsetH)
        return function(b)
            if not launch(b,callback) then return false end
            b.images,b.offsetH,b.offsetL = images,offsetH,-0x200
            b.imageFrame,b.cycleFrame = #images,#images-1
            return true
        end
    end

    local function cycleMove(b)
        if not move(b) then return false end
        if not b.run.stopPathClock then
            local frame = b.cycleFrame
            b.imageFrame,b.cycleFrame = frame,frame > 1 and frame-1 or #b.images-1
        end
        return true
    end

    handlers[0x1761da] = cycleLaunch(0x17625c,program.dualCannon.roundImages,-0x200)
    handlers[0x17637e] = cycleLaunch(0x176400,program.dualCannon.largeImages,-0x400)
    handlers[0x176522] = cycleLaunch(0x1765a4,program.mid1.ringImages,-0x400)
    handlers[0x17625c],handlers[0x176400],handlers[0x1765a4] = cycleMove,cycleMove,cycleMove

    -- 0x176714 的五面末段炮弹沿 0x28d0e0 起的四帧正向轮换。
    handlers[0x176714] = function(b)
        if not launch(b,0x17678e) then return false end
        b.images,b.offsetH,b.offsetL=program.boss1Core.chargeRing,-0x400,-0x200
        return true
    end

    handlers[0x17678e] = handlers[0x1740b4]

    -- 0x177692 的母弹每三帧加速，按发射方传入的角度逐次放出子弹。
    handlers[0x177692] = function(b)
        local run=b.run
        b.flash=nil
        velocity(b)
        b.h,b.l=program.addPacked(b.h,b.l,b.dh*0x10000+band(b.dl-run.cameraStep,0xffff))
        if expired(b) then return false end
        if not run.stopPathClock and not run.freeze then
            b.accelClock,b.emitClock=b.accelClock-1,b.emitClock-1
            if b.accelClock<0 then b.accelClock,b.speed=2,band(b.speed+1,255) end
            if b.emitClock<0 then
                b.emitClock=7
                M.emit(b,0xd,-3,b.emitAngle,0,0,true)
                b.emitAngle=band(b.emitAngle+b.emitTurn,255)
            end
        end
        if not run.stopPathClock then b.imageFrame=b.imageFrame%4+1 end
        return true
    end

    handlers[0x177604] = function(b)
        if not launch(b,0x177692) then return false end
        b.images,b.offsetH,b.offsetL=program.boss1Core.chargeRing,-0x400,-0x200
        b.accelClock,b.emitClock=2,0
        return true
    end

    -- 0x1777fc 先检查左右边，再检查上下边。0x14f008 把触边坐标留给下一帧的敌机队列。
    handlers[0x1777fc] = function(b)
        advance(b)
        local heading
        if b.l<=0x200 then heading=0x10
        elseif b.l>=0x3600 then heading=0x30
        elseif b.h<=0x600 then heading=0
        elseif b.h>=0x6c00 then heading=0x20 end
        if heading then
            local queue=b.run.spawnQueue
            queue[#queue+1]={[3]=0x7e,[4]=0,[10]=0x1a6dd4,h=b.h,l=b.l,heading=heading}
            return false
        end
        adjustSpeed(b)
        if not b.run.stopPathClock then b.imageFrame=b.imageFrame%4+1 end
        return true
    end

    handlers[0x17778c] = function(b)
        if not launch(b,0x1777fc) then return false end
        b.images,b.offsetH,b.offsetL=program.boss1Core.chargeRing,-0x400,-0x200
        return true
    end

    handlers[0x176920]=function(b)
        advance(b)
        if band(b.l,0xffff)>=0x3800 or b.h<0 then return false end
        if b.h>=0x7000 then
            M.emit(b,0xd,b.speed-0x13,0x80,0x6e00-b.h,0,true)
            return false
        end
        adjustSpeed(b)
        if not b.run.stopPathClock then
            b.imageClock=1-b.imageClock
            if b.imageClock==0 then b.imageFrame=b.imageFrame==3 and 1 or 3 end
        end
        return true
    end

    handlers[0x176896]=function(b)
        if not launch(b,0x176920) then return false end
        local angle=floor(band(b.angle+4,0xf8)/8)+1
        b.images=program.boss6.images.finalCrossing[program.arrowDirection[angle]]
        b.imageFrame,b.imageClock,b.offsetH,b.offsetL=3,0,-0x400,-0x200
        return true
    end

    -- 0x1779e2 和 0x177b8e 登记后续发弹。速度档位在两个端点之间往复。
    local function armorEmitter(b,moving,angle,minSpeed,offset)
        if moving then velocity(b) end
        advance(b)
        if expired(b) then return false end
        if not b.run.freeze then
            b.emitClock=b.emitClock-1
            if b.emitClock<0 then
                b.emitClock=b.emitPeriod
                M.emit(b,0xd,b.childSpeed+offset,angle,0,0,true)
                b.childSpeed=b.childSpeed+b.childStep
                if b.childSpeed==0 or b.childSpeed==minSpeed then b.childStep=-b.childStep end
            end
        end
        if not b.run.stopPathClock then b.imageFrame=b.imageFrame%4+1 end
        return true
    end

    handlers[0x1779e2]=function(b) return armorEmitter(b,true,0x80,-12,-1) end
    handlers[0x177b8e]=function(b) return armorEmitter(b,false,0,-8,-4) end

    local function armorEmitterLaunch(b,callback)
        if not launch(b,callback) then return false end
        b.images,b.offsetH,b.offsetL=program.boss1Core.chargeRing,-0x400,-0x200
        b.emitClock,b.childSpeed,b.childStep=1,-8,1
        return true
    end

    handlers[0x17795a]=function(b)
        b.emitPeriod=6
        return armorEmitterLaunch(b,0x1779e2)
    end
    handlers[0x177af2]=function(b)
        if not armorEmitterLaunch(b,0x177b8e) then return false end
        b.speed=band(b.speed-8,255)
        velocity(b)
        return true
    end

    -- 0x177380 给横移母弹写入剩余发射次数。它加速时保持原朝向，子弹另行自机狙。
    handlers[0x17740e] = function(b)
        local run=b.run
        b.flash=nil
        b.h,b.l=program.addPacked(b.h,b.l,b.dh*0x10000+band(b.dl-run.cameraStep,0xffff))
        if expired(b) then return false end
        if run.freeze then return true end
        if b.shots>0 then
            b.accelClock=b.accelClock-1
            if b.accelClock<0 then
                b.speed,b.accelClock=band(b.speed+1,255),0
                velocity(b)
            end
            b.fireClock=b.fireClock-1
            if b.fireClock<0 then
                b.fireClock=2
                local target=run.player
                if target and target.active then
                    local angle=program.angle8(b.h,b.l,target,0x80)
                    M.emit(b,25,b.childSpeed,angle,0,0,false)
                    b.childSpeed,b.shots=b.childSpeed+1,b.shots-1
                end
            end
        end
        if not run.stopPathClock then b.imageFrame=b.imageFrame%#b.images+1 end
        return true
    end

    handlers[0x17738c] = function(b)
        if not launch(b,0x17740e) then return false end
        b.images,b.offsetH,b.offsetL=program.boss4.images.finalProjectile[26],-0x400,-0x200
        b.accelClock,b.fireClock,b.childSpeed=0,0xc,1
        return true
    end

    -- 0x177590 每帧从部件槽取定点坐标。部件退出时原程序清空关联弹槽。
    handlers[0x177590] = function(b)
        local part=b.anchor
        if part.retired then return false end
        b.h,b.l=part.h,part.l
        if not b.run.stopPathClock then b.imageFrame=b.imageFrame%#b.images+1 end
        return true
    end

    handlers[0x177532] = function(b)
        local part=b.anchor
        if part.retired then return false end
        velocity(b)
        b.flags,b.callback=band(b.flags,0xfeff),0x177590
        b.update=handlers[b.callback]
        b.images,b.offsetH,b.offsetL,b.imageFrame=program.boss4.images.ringPoint[26],-0x400,-0x200,1
        b.h,b.l=part.h,part.l
        return true
    end

    -- 0x11c296 把触到自机的弹槽改挂到 0x16ffee。该动画按半速沿原方向移动。
    handlers[0x170020] = function(b)
        b.h,b.l = s16(b.h + b.dh),s16(b.l + b.dl - b.run.cameraStep)
        b.imageClock = b.imageClock - 1
        if b.imageClock >= 0 then return true end
        b.imageClock,b.imageFrame = 1,b.imageFrame + 1
        return b.imageFrame <= #b.images
    end

    handlers[0x16ffee] = function(b)
        b.flash,b.images = nil,program.bulletHitImages
        b.offsetH,b.offsetL,b.imageFrame,b.imageClock = -0x200,-0x200,1,1
        b.dh,b.dl = floor((b.dh or 0) / 2),floor((b.dl or 0) / 2)
        b.callback,b.update = 0x170020,handlers[0x170020]
        return b.update(b)
    end

    -- 0x170160 先在原槽显示分值，24 次位移中的最后一次之前登记道具。
    handlers[0x170160] = function(b,spawnGold)
        local c = b.conversion
        if c.wait > 0 then
            c.wait = c.wait - 1
            if c.wait == 0 then c.pilot.score = math.min(999999999,c.pilot.score + c.points) end
            return true
        end
        c.age = c.age + 1
        if c.age == 0x18 then spawnGold(b.run,c.kind,b.h,b.l) end
        if c.age > 0x20 then
            c.width = c.width - 2
            if c.width == 0 then return false end
        end
        b.h,b.l = s16(b.h + b.dh),s16(b.l + b.dl - b.run.cameraStep)
        return true
    end

    handlers[0x1700da] = function(b,spawnGold)
        local jitter = program.conversionJitter
        local dh,dl = b.dh or 0,b.dl or 0
        b.dh = dh - floor(dh / 4) - program.s8(program.random(b.run,jitter))
        b.dl = dl - floor(dl / 8) - program.s8(program.random(b.run,jitter))
        b.flash,b.callback,b.update = nil,0x170160,handlers[0x170160]
        if b.conversion.wait == 0 then
            local c = b.conversion
            c.pilot.score = math.min(999999999,c.pilot.score + c.points)
        end
        return b.update(b,spawnGold)
    end

    local Bullet = Class(object,{
        init = function(b,run,slot,origin,template,h,l,angle,modifier,precise)
            b.run,b.slot,b.origin = run,slot,origin
            b.flags,b.h,b.l,b.angle = template[3],h,l,angle
            if precise then b.flags = bor(b.flags,0x200) end
            b.speed = band(template[9] + modifier + run.bulletRank,255)
            b.baseSpeed,b.fastSpeed,b.speedClock = b.speed,band(b.speed + run.awakeningBoost,255),run.awakeningDelay
            b.callback = template[12]
            b.update = assert(handlers[b.callback],('尚未翻译敌弹回调 0x%06x'):format(b.callback))
            b.imageFrame,b.offsetH,b.offsetL = 1,template[4],template[5]
            b.x,b.y = program.world(h,l)
            b.layer,b.group,b.bound,b.colli = LAYER.ENEMY_BULLET,GROUP.ENEMY_BULLET,false,false
        end,
        render = function(b)
            local assets = b.run.art
            if not assets then return end
            local c = b.conversion
            if c then
                if c.age == 0 then return end
                if math.abs(b.l-c.pilot.l) < 0x800 and (b.run.bulletCapacity-b.slot) % 2 == b.run.frame % 2 then return end
                local image = assets.sprites[c.row[b.run.frame % 4 == 0 and 3 or 4]]
                if c.width == image[2] then art.draw(image,b.h,b.l,c.row[1],c.row[2])
                else art.drawWidth(image,b.h,b.l,c.row[1],c.row[2],c.width) end
                return
            end
            if not b.images then return end
            local id = b.flash or b.images[b.imageFrame]
            art.draw(assets.sprites[id],b.h,b.l,b.flash and b.flashH or b.offsetH,b.flash and b.flashL or b.offsetL)
        end,
    })

    function M.emit(origin,kind,modifier,angle,dh,dl,precise,extra)
        local run = origin.run
        if run.freeze or run.blockEnemyFire then return end
        local template = program.bulletTemplates[kind + 1]
        local initializer=template and template[11]
        assert(initializer==0 or initializer==0x177954
            or extra and (initializer==0x17752c or initializer==0x177380 or initializer==0x1775f8
                or initializer==0x177ae8),
            '此敌弹需要发射时附加设置')
        for slot = 1,run.bulletCapacity do
            if not run.bullets[slot] then
                local b = New(Bullet,run,slot,origin,template,s16(origin.h + dh),s16(origin.l + dl),
                    band(angle,255),modifier,precise)
                if initializer==0x17752c then b.anchor=extra
                elseif initializer==0x177380 then b.shots=extra
                elseif initializer==0x1775f8 then b.emitAngle,b.emitTurn=extra[1],extra[2]
                elseif initializer==0x177ae8 then b.emitPeriod=extra end
                run.bullets[slot] = b
                return b
            end
        end
    end

    function M.remove(b)
        b.run.bullets[b.slot] = nil
        object.RawDel(b)
    end

    function M.contact(b)
        b.flags = bor(b.flags,0x4000)
        b.callback,b.update = 0x16ffee,handlers[0x16ffee]
    end

    -- 0x1705fa 只扫描发射者指针相同的敌弹。超出连锁表后仍转换，分值保持末档。
    function M.convert(origin,p,kind)
        local run,count = origin.run,0
        for slot = 1,run.bulletCapacity do
            local b = run.bullets[slot]
            if b and b.origin == origin and b.callback ~= 0x170020 then
                local chain = p.cancelChain
                local row = program.goldFlash[chain+1]
                b.flags = bor(b.flags,0x4000)
                b.callback,b.update,b.origin = 0x1700da,handlers[0x1700da],p
                b.conversion = {pilot=p,kind=kind,points=4+chain*4,wait=floor(count/4),age=0,
                    row=row,width=program.spriteRects[row[3]][4]}
                if chain < 99 then p.cancelChain,count = chain + 1,count + 1 end
            end
        end
    end

    -- 0x11b168 设置清弹计时，0x17193e 每帧给新占用的敌弹槽改挂爆散回调。
    function M.clear(run,duration)
        run.bulletClearClock = duration
    end

    function M.step(run,spawnGold)
        local clearing = (run.bulletClearClock or 0) > 0
        if clearing then run.bulletClearClock = run.bulletClearClock-1 end
        for slot = 1,run.bulletCapacity do
            local b = run.bullets[slot]
            if b then
                if clearing and band(b.flags,0x4000) == 0 then M.contact(b) end
                if not b.update(b,spawnGold) then M.remove(b)
                else b.x,b.y = program.world(b.h,b.l) end
            end
        end
    end

    return M
end
