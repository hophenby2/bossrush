-- 敌弹实例把分配器选择的回调挂在对象上。更新、碰撞与消失共用定点坐标。
return function(program)
    local bit = require('bit')
    local band, bor = bit.band, bit.bor
    local floor = math.floor
    local s16, world = program.s16, program.world
    local M = {}
    local emit

    local function outside(h, l)
        return band(h, 0xffff) >= 0x7000 or band(l, 0xffff) >= 0x3800
    end

    local function remove(o)
        o.run.bullets[o.slot] = nil
        object.RawDel(o)
    end

    local function vanish(o)
        local interval = o.run.route.loop == 1 and 2 or 1
        o.fade = o.fade + interval
        if o.fade == 16 then remove(o); return end
        o.h, o.l = s16(o.h + o.dh), s16(o.l + o.dl)
        o.sprite = program.fade[o.palette][o.fade]
        o.drawH, o.drawL = -0x200, -0x200
    end

    local function beginVanish(o)
        o.dh, o.dl = floor(o.dh / 2), floor(o.dl / 2)
        o.fade, o.update = 0, vanish
        vanish(o)
    end

    local function fly(o)
        o.h, o.l = program.add(o.h, o.l, o.dh, s16(o.dl - o.run.cameraStep))
        if outside(o.h, o.l) then remove(o); return end
        return true
    end

    local function flyNine(o)
        if not fly(o) then return end
        o.drawH, o.drawL = -0x400, -0x200
        o.imageTimer = o.imageTimer - 1
        if o.imageTimer < 0 then
            o.imageTimer = 1
            o.imageFrame = o.nextImage
            o.nextImage = o.nextImage == 1 and 3 or 1
        end
        o.sprite = o.live[o.visualDirection][o.imageFrame]
    end

    local function flyTwo(o)
        if not fly(o) then return end
        o.drawH, o.drawL = -0x200, -0x200
        o.imageFrame = o.imageFrame % 6 + 1
        local frames = o.kind == 0 and program.bossRound or o.kind == 1 and program.bossRoundAlt
            or o.kind == 6 and program.chip.returnSprites or program.mid4Round[o.kind == 0x12 and 7 or o.kind]
            or program.roundBullet
        o.sprite = frames[o.imageFrame]
    end

    local function start(o)
        if outside(o.h, o.l) then remove(o); return end
        local run = o.run
        local flash = program.flash[o.palette][o.visualDirection]
        -- 0xf784e 先写出闪光，并以偏移的一半修改敌弹中心。
        local dh, dl = floor(flash[2] / 2), floor(flash[1] / 2)
        o.h, o.l = s16(o.h + dh), s16(o.l + dl)
        o.drawH, o.drawL = o.drawH + dh, o.drawL + dl
        o.sprite = flash[3 + run.bulletFlash]
        run.bulletFlash = (run.bulletFlash + 1) % 3
        o.dh, o.dl = program.vector(o.speed, o.angle)
        o.flags = band(o.flags, 0xfeff)
        return true
    end

    local function initNine(o)
        if not start(o) then return end
        o.update, o.imageFrame, o.imageTimer, o.nextImage = flyNine, 3, 1, 2
    end

    -- 0xf8ef2 直接按 32 方向取第 3 帧，0xf8f3c 再交替取第 1、3 帧。
    local function initHoverShot(o)
        if not start(o) then return end
        o.update, o.imageFrame, o.imageTimer, o.nextImage = flyNine, 3, 1, 3
    end

    local function initTwo(o)
        if not start(o) then return end
        o.update, o.imageFrame = flyTwo, 1
    end

    local function flyEight(o)
        if not fly(o) then return end
        o.drawH, o.drawL = -0x400, -0x200
        o.imageFrame = o.imageFrame % 4 + 1
        o.sprite = program.bossYellow[o.imageFrame]
    end

    local function initEight(o)
        if not start(o) then return end
        o.update, o.imageFrame = flyEight, 1
    end

    local function flyNeedle(o)
        if not fly(o) then return end
        o.drawH, o.drawL = -0x400, -0x200
        o.imageTimer = o.imageTimer - 1
        if o.imageTimer < 0 then
            o.imageTimer = 1
            o.imageFrame = 3 - o.imageFrame
        end
        o.sprite = program.mid4Needle[o.visualDirection][o.imageFrame]
    end

    local function initNeedle(o)
        if not start(o) then return end
        o.update, o.imageFrame, o.imageTimer = flyNeedle, 2, 1
    end

    -- 0xfaf9a 刹停时重新取自机方向，再逐帧提高速度索引。
    local function homeAfterBrake(o)
        if o.redirected then
            o.speed = band(o.speed + 1, 0xff)
        else
            o.speed = band(o.speed - 1, 0xff)
            if o.speed == 0 then
                o.redirected, o.speed = true, 1
                if o.run.pilotH then
                    o.angle = program.aimByte(o.h, o.l, o.run.pilotH, o.run.pilotL, o.angle)
                end
            end
        end
        o.dh, o.dl = program.vector(o.speed, o.angle)
        flyEight(o)
    end

    local function initHoming(o)
        if not start(o) then return end
        o.update, o.imageFrame = homeAfterBrake, 1
    end

    -- 0xf9d30 先降到速度索引 8，然后每次计数器下溢加 1。
    local function flyBoss3Sweep(o)
        if o.sweepBraked then
            o.sweepClock = o.sweepClock - 1
            if o.sweepClock < 0 then o.sweepClock, o.speed = 0, band(o.speed + 1, 0xff) end
        else
            o.speed = math.max(8, o.speed - 1)
            o.sweepBraked = o.speed == 8
        end
        o.dh, o.dl = program.vector(o.speed, o.angle)
        if not fly(o) then return end
        o.drawH, o.drawL = -0x400, -0x200
        if band(o.run.frame, 1) == 0 then o.imageFrame = o.imageFrame % 4 + 1 end
        o.sprite = program.bossYellow[o.imageFrame]
    end

    local function initBoss3Sweep(o)
        if not start(o) then return end
        o.update, o.imageFrame, o.sweepClock = flyBoss3Sweep, 1, 1
    end

    -- 0xfa660 的纵向修正和一次横边反射独立于相机横移。
    local function flyBoss3Reflect(o)
        o.h, o.l = program.add(o.h, o.l, o.dh - 0x40, o.dl)
        if band(o.l, 0xffff) >= 0x3800 then
            if o.reflected then remove(o); return end
            o.reflected = true
            o.angle = band(-o.angle, 0xff)
            o.dh, o.dl = program.vector(o.speed, o.angle)
        elseif band(o.h, 0xffff) >= 0x7000 then
            remove(o)
            return
        end
        o.drawH, o.drawL = -0x400, -0x200
        o.imageTimer = o.imageTimer - 1
        if o.imageTimer < 0 then
            o.imageTimer, o.imageFrame = 1, 4 - o.imageFrame
        end
        o.sprite = o.live[o.visualDirection][o.imageFrame]
    end

    local function initBoss3Reflect(o)
        if not start(o) then return end
        o.update, o.imageFrame, o.imageTimer = flyBoss3Reflect, 3, 1
    end

    -- 0xfb2c4 分开更新纵横速度分量，保留发射指令分别写入的两个计数器。
    local function flyDrift(o)
        o.driftHClock, o.driftLClock = o.driftHClock - 1, o.driftLClock - 1
        if o.driftHClock < 0 then
            o.driftHClock = o.driftHInterval
            o.dh = s16(o.dh + o.driftH)
        end
        if o.driftLClock < 0 then
            o.driftLClock = o.driftLInterval
            o.dl = s16(o.dl + o.driftL)
        end
        if not fly(o) then return end
        o.drawH, o.drawL = -0x400, -0x200
        o.imageFrame = o.imageFrame % 4 + 1
        o.sprite = program.mid4Round[0x28][o.imageFrame]
    end

    local function initDrift(o)
        if not start(o) then return end
        o.update, o.imageFrame = flyDrift, 1
    end

    local function updateSpeed(o)
        if o.speed ~= o.speedLimit then
            o.speedClock = o.speedClock - 1
            if o.speedClock < 0 then
                o.speedClock = o.speedInterval
                o.speed = band(o.speed + o.speedDelta, 0xff)
                if o.speed > o.speedLimit then o.speed = o.speedLimit end
                o.dh, o.dl = program.vector(o.speed, o.angle)
            end
        end
    end

    local function accelerate(o)
        updateSpeed(o)
        flyNine(o)
    end

    local function accelerateRound(o)
        updateSpeed(o)
        flyTwo(o)
    end

    -- 0xf9776 先移动、再更新速度索引，下一帧才用新速度。
    local function accelerateAfterMove(o)
        flyNine(o)
        if o.run.bullets[o.slot] == o then updateSpeed(o) end
    end

    local function initAcceleratingRound(o)
        initTwo(o)
        if o.update == flyTwo then o.update = accelerateRound end
    end

    local function initAccelerating(o)
        initNine(o)
        if o.update == flyNine then o.update = accelerate end
    end

    local function initDelayedAcceleration(o)
        initNine(o)
        if o.update == flyNine then o.update = accelerateAfterMove end
    end

    local function flyFour(o)
        if not fly(o) then return end
        o.drawH, o.drawL = -0x400, -0x200
        o.imageFrame = o.imageFrame % 4 + 1
        o.sprite = program.mid4Round[0x28][o.imageFrame]
    end

    local function initFour(o)
        if not start(o) then return end
        o.update, o.imageFrame = flyFour, 1
    end

    local function accelerateFour(o)
        updateSpeed(o)
        flyFour(o)
    end

    local function initAcceleratingFour(o)
        initFour(o)
        if o.update == flyFour then o.update = accelerateFour end
    end

    -- 0xf9b28 的母弹在移动前处理发射计数，子弹继续读取自己的纵向位移参数。
    local function flyBoss2Child(o)
        if not fly(o) then return end
        o.h = s16(o.h + o.extraStep)
        o.drawH, o.drawL = -0x400, -0x200
        o.imageFrame = o.imageFrame % 4 + 1
        o.sprite = program.mid4Round[0x14][o.imageFrame]
    end

    local function initBoss2Child(o)
        if not start(o) then return end
        o.update, o.imageFrame = flyBoss2Child, 1
    end

    local function flyBoss2Parent(o)
        o.childClock = o.childClock - 1
        if o.childClock < 0 then
            o.childClock = o.childInterval
            if band(o.h - 0x7800, 0xffff) >= 0x8800 then
                emit(o.run, 0x14, o.childSpeed, o.angle, o.h, o.l, nil, nil, false, {o.childStep})
            end
        end
        flyNine(o)
    end

    local function initBoss2Parent(o)
        initNine(o)
        if o.update == flyNine then
            o.update, o.imageFrame, o.nextImage = flyBoss2Parent, 3, 3
        end
    end

    -- 0xf87de 的三帧弹体每两次回调换一次图，首发闪光后先用第三帧。
    local function flyTurretRound(o)
        if not fly(o) then return end
        o.imageTimer = o.imageTimer - 1
        if o.imageTimer < 0 then
            o.imageTimer = 1
            o.imageFrame = (o.imageFrame + 1) % 3 + 1
        end
        o.sprite = program.turretRound[o.imageFrame]
    end

    local function initTurretRound(o)
        if not start(o) then return end
        o.drawH, o.drawL = -0x400, -0x200
        o.update, o.imageFrame, o.imageTimer = flyTurretRound, 3, 1
    end

    -- 0xfbf30、0xfbfe0、0xfc20c 与 0xfc2e8 共用减速阶段，刹停时分派各自的动作。
    local function brake(o)
        if not o.redirected then
            o.speed = band(o.speed - 1, 0xff)
            if o.speed == 0 then
                o.redirected = true
                local run, kind = o.run, o.kind
                if kind == 0x35 then
                    M.emitLongPair(run, 8, 2, o.angle, o.h, o.l)
                    o.angle = band(o.angle + 0x80, 0xff)
                elseif kind == 0x38 then
                    emit(run, 0x39, 10, o.angle - 0x40, o.h, o.l, nil, nil, false, {0x20})
                    o.angle = band(o.angle + 0x80, 0xff)
                end
                if o.redirectToPilot and run.pilotH then
                    o.angle = program.aimByte(o.h, o.l, run.pilotH, run.pilotL, o.angle)
                end
            end
        end
        if o.redirected and o.speed ~= o.speedLimit then o.speed = band(o.speed + 1, 0xff) end
        o.dh, o.dl = program.vector(o.speed, o.angle)
        if o.kind == 0x34 then flyTwo(o)
        elseif o.kind == 0x39 then flyEight(o)
        else flyFour(o) end
    end

    local function initBraking(o)
        if not start(o) then return end
        o.update, o.imageFrame = brake, 1
    end

    local function flyWithChild(o)
        if o.childClock > 0 then
            o.childClock = o.childClock - 1
            if o.childClock == 0 then
                local modifier = 4 + (o.run.route.loop == 1 and 4 or 0)
                emit(o.run, 0x25, modifier, o.angle, o.h, o.l, nil, nil, false, {1,1,-1,o.childLimit})
            end
        end
        flyNine(o)
    end

    local function initWithChild(o)
        initNine(o)
        if o.update == flyNine then o.update = flyWithChild end
    end

    -- 0xfa766 与 0xfa660 的弹体每帧受定值纵向偏移，两个边界分支各自处理。
    local function flyBoss3Lateral(o)
        o.h, o.l = program.add(o.h, o.l, o.dh - 0x40, o.dl)
        if outside(o.h, o.l) then remove(o); return end
        o.drawH, o.drawL = -0x400, -0x200
        o.imageTimer = o.imageTimer - 1
        if o.imageTimer < 0 then o.imageTimer, o.imageFrame = 1, 4 - o.imageFrame end
        o.sprite = o.live[o.visualDirection][o.imageFrame]
    end

    local function initBoss3Lateral(o)
        if not start(o) then return end
        o.update, o.imageFrame, o.imageTimer = flyBoss3Lateral, 3, 1
    end

    -- 0xfa890 先移动母弹，再用母弹当前坐标发出 0x0c。
    local function flyBoss3Carrier(o)
        flyNine(o)
        if o.run.bullets[o.slot] ~= o or o.bursts == 0 then return end
        if o.shots == 0 then
            o.outerClock = o.outerClock - 1
            if o.outerClock >= 0 then return end
            o.outerClock, o.shots = 0x10, 1
        end
        o.innerClock = o.innerClock - 1
        if o.innerClock >= 0 then return end
        o.innerClock, o.shots, o.bursts = 0, o.shots - 1, o.bursts - 1
        local angle = o.angle + o.childAngle
        M.emitFasterInLoop(o.run, 0xc, -4, angle, o.h, o.l)
        if o.run.route.loop == 1 then
            emit(o.run, 0xc, 4, angle, o.h, o.l)
            emit(o.run, 0xc, -4, angle, o.h, o.l)
        end
    end

    local function initBoss3Carrier(o)
        initNine(o)
        if o.update ~= flyNine then return end
        o.update, o.outerClock, o.innerClock, o.shots, o.bursts = flyBoss3Carrier, 4, 2, 0, 2
    end

    -- 0xfaa5c 每帧增加纵向位移项，敌弹原有的速度索引与角度仍参与向量移动。
    local function flyBoss3Accelerate(o)
        o.h = s16(o.h - o.drop)
        o.drop = o.drop + 0x10
        flyFour(o)
    end

    local function initBoss3Accelerate(o)
        initFour(o)
        if o.update == flyFour then o.update, o.drop = flyBoss3Accelerate, 0 end
    end

    -- 0xfaaca 由母弹保存反向出膛角，发射后以每发 0x0a 更新。
    local function flyBoss3Fan(o)
        if o.shots == 0 then
            o.outerClock = o.outerClock - 1
            if o.outerClock < 0 then o.outerClock, o.shots = 0, 0x40 end
        end
        if o.shots > 0 then
            o.innerClock = o.innerClock - 1
            if o.innerClock < 0 then
                o.innerClock, o.shots = o.childInterval, o.shots - 1
                M.emitFasterInLoop(o.run, 0xf, -18, o.childAngle, o.h, o.l, {0x14,1,1,0x14})
                o.childAngle = band(o.childAngle + (o.turn < 0 and 10 or -10), 0xff)
            end
        end
        flyFour(o)
    end

    local function initBoss3Fan(o)
        initFour(o)
        if o.update ~= flyFour then return end
        o.update, o.shots, o.outerClock = flyBoss3Fan, 0, 4
        o.childAngle = band(o.angle + 0x80, 0xff)
    end

    -- 0xfb036 的母弹按装填周期从自身发出 0x31，其方向取共用的原版随机表。
    local function flyBoss4Seed(o)
        o.childClock = o.childClock - 1
        if o.childClock < 0 then
            o.childClock = o.childInterval
            local a = program.random(o.run, program.boss4.randomByte)
            emit(o.run, 0x31, -20, a, o.h, o.l, nil,nil,false,{0x50,0x30,1,0x18})
        end
        flyEight(o)
    end

    local function initBoss4Seed(o)
        initEight(o)
        if o.update == flyEight then o.update = flyBoss4Seed end
    end

    local function yellowFrame(o)
        o.drawH, o.drawL = -0x400, -0x200
        if band(o.run.frame,1) == 0 then o.imageFrame = o.imageFrame % 4 + 1 end
        o.sprite = program.bossYellow[o.imageFrame]
    end

    -- 0xfb4ce 横边命中后将角改成 0x80，沿新方向发三颗折向子弹。
    local function flyBoss4Wall(o)
        if not o.wallAngle then
            if not fly(o) then return end
            if o.l <= 0x200 or o.l >= 0x3600 then
                o.wallAngle = o.l <= 0x200 and 0x40 or 0xc0
                o.speed, o.angle = 0x20, 0x80
                o.dh, o.dl = program.vector(o.speed, o.angle)
            end
        else
            o.h, o.l = program.add(o.h, o.l, o.dh, o.dl)
            if outside(o.h,o.l) then remove(o); return end
            o.childClock = o.childClock - 1
            if o.childClock < 0 then
                o.childClock = 4
                M.emitFasterInLoop(o.run,0x2c,0x15,o.wallAngle,o.h,o.l,{o.speed,0x80})
                o.childCount = o.childCount - 1
                if o.childCount == 0 then o.update = beginVanish end
            end
        end
        yellowFrame(o)
    end

    local function initBoss4Wall(o)
        initEight(o)
        if o.update == flyEight then
            o.update, o.childClock, o.childCount = flyBoss4Wall, 0, 3
        end
    end

    local function flyBoss4WallChild(o)
        if not fly(o) then return end
        o.h, o.l = s16(o.h + o.curveH), s16(o.l + o.curveL)
        o.curveL = s16(o.curveL + o.curveStep)
        yellowFrame(o)
    end

    local function initBoss4WallChild(o)
        initEight(o)
        if o.update == flyEight then
            local dh = program.vector(o.parentSpeed,o.parentAngle)
            o.update, o.curveH, o.curveL = flyBoss4WallChild, floor(dh/2)-floor(dh/8), 0
            o.curveStep = o.angle == 0x40 and -4 or 4
        end
    end

    local function flyBoss4Trail(o)
        updateSpeed(o)
        if not fly(o) then return end
        o.drawH, o.drawL = -0x200, -0x200
        if band(o.run.frame,1) == 0 then o.imageFrame = o.imageFrame % 6 + 1 end
        o.sprite = program.boss4.trail[o.imageFrame]
    end

    local function initBoss4Trail(o)
        local h,l = o.h,o.l
        if not start(o) then return end
        o.h, o.l, o.update, o.imageFrame = h,l,flyBoss4Trail,1
    end

    local function flyBoss4OrbitNeedle(o)
        flyNine(o)
        if o.run.bullets[o.slot] == o then updateSpeed(o) end
    end

    local function initBoss4OrbitNeedle(o)
        initNine(o)
        if o.update == flyNine then o.update = flyBoss4OrbitNeedle end
    end

    -- 0xfb7b2 刹停重瞄并派生 0x30。随后母弹才切换到消失处理。
    local function flyBoss4OrbitSeed(o)
        o.speed = band(o.speed - 1,0xff)
        if o.speed == 0 then
            local run, angle = o.run, o.angle
            if run.pilotH then angle = program.aimByte(o.h,o.l,run.pilotH,run.pilotL,angle) end
            emit(run,0x30,-20,angle,o.h,o.l,nil,nil,false,{0,0,1,0x20})
            o.update = beginVanish
        end
        o.dh,o.dl = program.vector(o.speed,o.angle)
        if not fly(o) then return end
        o.drawH,o.drawL = -0x200,-0x200
        if band(o.run.frame,1) == 0 then o.imageFrame = o.imageFrame % 6+1 end
        o.sprite = program.boss4.orbitSeed[o.imageFrame]
    end

    local function initBoss4OrbitSeed(o)
        if not start(o) then return end
        o.update,o.imageFrame = flyBoss4OrbitSeed,1
    end

    -- 0xfb696 刹停时读一次自机方向，随后按发射者写入的速度上限加速。
    local function flyRailRound(o)
        if o.redirected then
            if o.speed ~= o.speedLimit then o.speed = band(o.speed + 1, 0xff) end
        else
            o.speed = band(o.speed - 1, 0xff)
            if o.speed == 0 then
                o.redirected = true
                local run = o.run
                if run.pilotH then o.angle = program.aimByte(o.h, o.l, run.pilotH, run.pilotL, o.angle) end
            end
        end
        o.dh, o.dl = program.vector(o.speed, o.angle)
        if not fly(o) then return end
        o.drawH, o.drawL = -0x200, -0x200
        if band(o.run.frame, 1) == 0 then o.imageFrame = o.imageFrame % 6 + 1 end
        o.sprite = program.boss4.orbitSeed[o.imageFrame]
    end

    local function initRailRound(o)
        if not start(o) then return end
        o.update, o.imageFrame = flyRailRound, 1
    end

    -- 0xfc492 在边缘分出缓速转向弹，母弹停在原地走消失回调。
    local function flyBoss5Wall(o)
        if not fly(o) then return end
        local angle
        if o.l <= 0x100 then angle = 0x40
        elseif o.l >= 0x3700 then angle = 0xc0
        elseif o.h <= 0x800 then angle = 0 end
        if angle then
            local count = o.run.route.loop == 0 and 4 or 2
            for i = 0, count-1 do
                emit(o.run,0xf,-20+i,angle,o.h,o.l,nil,nil,false,{0x1c,3,1,0x20})
            end
            o.dh, o.dl, o.update = 0, 0, beginVanish
        end
        yellowFrame(o)
    end

    local function initBoss5Wall(o)
        if not start(o) then return end
        o.update, o.imageFrame = flyBoss5Wall, 1
    end

    local function flyBoss5Homing(o)
        local run = o.run
        if not o.redirected then
            o.speed = band(o.speed-1,0xff)
            o.redirected = o.speed == 2
            o.dh, o.dl = program.vector(o.speed,o.angle)
        else
            if o.aimClock > 0 then
                o.aimClock = o.aimClock-1
                if run.pilotH then
                    local direction = program.aimByte(o.h,o.l,run.pilotH,run.pilotL,o.angle)
                    local difference = band(direction-o.angle,0xff)
                    if difference ~= 0 then o.angle = band(o.angle+(difference < 0x80 and 1 or -1),0xff) end
                end
            end
            o.speedClock = o.speedClock-1
            if o.speedClock < 0 then
                o.speedClock, o.speed = 1, band(o.speed+1,0xff)
                o.dh, o.dl = program.vector(o.speed,o.angle)
            end
        end
        if not fly(o) then return end
        o.drawH, o.drawL = -0x400, -0x200
        if band(run.frame,1)==0 then o.imageFrame = o.imageFrame % 4 + 1 end
        o.sprite = program.boss5.homingRound[o.imageFrame]
    end

    local function initBoss5Homing(o)
        if not start(o) then return end
        o.update, o.imageFrame, o.aimClock, o.speedClock = flyBoss5Homing,1,0x14,0
    end

    local function flyBoss5Redirect(o)
        if not fly(o) then return end
        if o.turnClock > 0 then
            o.turnClock = o.turnClock-1
            if o.turnClock == 0 then
                o.angle = band((o.run.boss5Aim or o.angle)+o.turnOffset,0xff)
                o.speed = band(o.speed+1,0xff)
                o.dh, o.dl = program.vector(o.speed,o.angle)
            end
        end
        yellowFrame(o)
    end

    local function initBoss5Redirect(o)
        if not start(o) then return end
        o.update, o.imageFrame, o.turnClock = flyBoss5Redirect,1,4
    end

    -- 0xfc834 只在角度计数器下溢时转向，计数耗尽后继续直飞。
    local function flyBoss5Turn(o)
        if o.turnCount > 0 then
            o.turnClock = o.turnClock-1
            if o.turnClock < 0 then
                if o.run.pilotH then
                    local goal = program.aimByte(o.h,o.l,o.run.pilotH,o.run.pilotL,o.angle)
                    local delta = band(goal-o.angle,0xff)
                    if delta ~= 0 then o.angle = band(o.angle+(delta<0x80 and 1 or -1),0xff) end
                end
                o.visualDirection = band(o.angle+4,0xf8)/8+1
                o.dh, o.dl = program.vector(o.speed,o.angle)
                o.turnClock, o.turnCount = 0, o.turnCount-1
            end
        end
        flyNine(o)
    end

    local function initBoss5Turn(o)
        initNine(o)
        if o.update == flyNine then o.update, o.turnClock = flyBoss5Turn, 8 end
    end

    -- 0xfc8e0 减到零速后进入提速段，提速计数和弹体朝向分别保存。
    local function flyBoss5Brake(o)
        if not o.redirected then
            o.speed = math.max(0,o.speed-1)
            if o.speed == 0 then
                o.redirected = true
                o.speedClock = 1
            end
        end
        if o.redirected and o.speed < 0x20 then
            o.speedClock = o.speedClock-1
            if o.speedClock < 0 then o.speedClock,o.speed=1,o.speed+1 end
        end
        o.dh,o.dl = program.vector(o.speed,o.angle)
        flyNine(o)
    end

    local function initBoss5Brake(o)
        initNine(o)
        if o.update == flyNine then o.update = flyBoss5Brake end
    end

    -- 0xfc9d4 刹停后在静止母弹的位置发四颗速度不同的针弹。
    local function flyBoss5Split(o)
        local run = o.run
        if o.redirected then
            if run.suppressShots then
                o.update = beginVanish
            else
                o.childClock = o.childClock-1
                if o.childClock < 0 then
                    o.childClock=2
                    emit(run,0xb,o.childModifier,o.childAngle,o.h,o.l,nil,nil,false)
                    o.childModifier=o.childModifier+4
                    if o.childModifier == 12 then o.update=beginVanish end
                end
            end
        else
            o.childClock=o.childClock-1
            if o.childClock < 0 then
                o.childClock,o.speed=2,band(o.speed-1,0xff)
                o.dh,o.dl=program.vector(o.speed,o.angle)
                if o.speed == 0 then
                    o.redirected = true
                    o.childAngle = run.pilotH and program.aimByte(o.h,o.l,run.pilotH,run.pilotL,o.angle) or 0
                    if run.pilotH then o.childClock = 0 end
                end
            end
        end
        flyFour(o)
    end

    local function initBoss5Split(o)
        initFour(o)
        if o.update == flyFour then
            o.update,o.childClock,o.childModifier=flyBoss5Split,2,-4
        end
    end

    -- 0xfcb88 的母弹在限时内不断偏转，在第 33 次更新发出侧向子弹。
    local function flyBoss5Spiral(o)
        o.speed = band(o.speed+1,0xff)
        if o.turnClock > 0 then
            o.angle = band(o.angle+o.turnOffset,0xff)
            o.turnClock = o.turnClock-1
        end
        o.dh,o.dl = program.vector(o.speed,o.angle)
        o.childClock = o.childClock-1
        if o.childClock == -1 then
            local angle = o.angle+(o.turnOffset < 0 and 0xc0 or 0x40)
            M.emitLongPair(o.run,8,2,angle,o.h,o.l)
        end
        if fly(o) then yellowFrame(o) end
    end

    local function initBoss5Spiral(o)
        initEight(o)
        if o.update == flyEight then
            o.update,o.speed,o.turnClock,o.childClock = flyBoss5Spiral,2,0x50,0x20
        end
    end

    local function updateLastRound(o)
        if not o.redirected then
            o.speedClock=o.speedClock-1
            if o.speedClock < 0 then
                o.speedClock=o.kind == 0x45 and 1 or 0
                o.speed=band(o.speed-1,0xff)
                if o.speed == (o.kind == 0x45 and 2 or 0) then
                    o.redirected=true
                    if o.kind == 0x45 then
                        local run=o.run
                        if run.pilotH then o.angle=program.aimByte(o.h,o.l,run.pilotH,run.pilotL,o.angle) end
                        o.visualDirection=band(o.angle+4,0xf8)/8+1
                    else
                        o.angle=band(o.angle+o.turnOffset,0xff)
                    end
                end
            end
        end
        if o.redirected and o.speed ~= o.speedLimit then o.speed=band(o.speed+1,0xff) end
        o.dh,o.dl=program.vector(o.speed,o.angle)
    end

    local function flyLastNeedle(o)
        updateLastRound(o)
        flyNine(o)
    end

    local function flyLastRound(o)
        updateLastRound(o)
        if o.kind == 0x46 then flyFour(o)
        elseif fly(o) then yellowFrame(o) end
    end

    local function initLastNeedle(o)
        initNine(o)
        if o.update == flyNine then o.update,o.speedClock=flyLastNeedle,1 end
    end

    local function initLastRound(o)
        if not start(o) then return end
        o.update,o.imageFrame,o.speedClock=flyLastRound,1,0
    end

    local function flyLastSeed(o)
        local run = o.run
        local side = o.kind == 0x48 and 1 or 2
        if run.boss5Beat and run.boss5Beat[side] == 0 then
            emit(run,side==1 and 0x25 or 0xe,-16,o.angle+o.turnOffset,o.h,o.l,nil,nil,false,{1,1,1,0x30})
        end
        if side == 1 then flyFour(o)
        elseif fly(o) then yellowFrame(o) end
    end

    local function initLastSeed(o)
        if not start(o) then return end
        o.update,o.imageFrame=flyLastSeed,1
    end

    local update = {[0x0f8cb8] = initNine, [0x0f8578] = initTwo, [0x0fa3ce] = initNine, [0x0f8396] = initTwo,
        [0x0f8486] = initTwo, [0x0f8bc6] = initEight, [0x0f8ad4] = initTwo, [0x0f9f08] = initNeedle,
        [0x0faf86] = initHoming, [0x0fb2b6] = initDrift, [0x0fa994] = initAcceleratingRound,
        [0x0f9a54] = initAcceleratingRound,
        [0x0f8e56] = initHoverShot, [0x0f9182] = initNine, [0x0f9316] = initNine,
        [0x0f9590] = initAccelerating, [0x0fb0a0] = initAccelerating, [0x0f96d6] = initDelayedAcceleration,
        [0x0f866a] = initFour, [0x0f875c] = initTurretRound, [0x0f89e2] = initTwo,
        [0x0f9b1a] = initBoss2Parent, [0x0f9b92] = initBoss2Child,
        [0x0f94c4] = initAcceleratingFour,
        [0x0f9cae] = initBoss3Sweep, [0x0fa23a] = initNine, [0x0fa562] = initBoss3Reflect,
        [0x0fa6e6] = initBoss3Lateral, [0x0fa7f2] = initBoss3Carrier,
        [0x0faa48] = initBoss3Accelerate, [0x0faa92] = initBoss3Fan,
        [0x0fa09c] = initNine, [0x0fb01c] = initBoss4Seed, [0x0fb4a8] = initBoss4Wall,
        [0x0fb5e4] = initBoss4WallChild, [0x0fb9d4] = initBoss4Trail,
        [0x0fb682] = initRailRound, [0x0fb79e] = initBoss4OrbitSeed, [0x0fb858] = initBoss4OrbitNeedle,
        [0x0fbf1c] = initBraking, [0x0fbfcc] = initBraking, [0x0fc08a] = initWithChild,
        [0x0fc1f8] = initBraking, [0x0fc2d4] = initBraking,
        [0x0fc422] = initBoss5Wall, [0x0fc560] = initBoss5Homing, [0x0fc714] = initBoss5Redirect,
        [0x0fc820] = initBoss5Turn, [0x0fc8ba] = initBoss5Brake, [0x0fc9a8] = initBoss5Split,
        [0x0fcb56] = initBoss5Spiral, [0x0fcd72] = initLastNeedle, [0x0fce32] = initLastRound,
        [0x0fced8] = initLastRound, [0x0fcf74] = initLastSeed, [0x0fcfd4] = initLastSeed}
    local Bullet = Class(object, {
        init = function(o, run, slot, desc, speed, angle, h, l, motion)
            o.run, o.slot, o.kind, o.flags = run, slot, desc[1], desc[2]
            o.h, o.l, o.angle, o.speed = h, l, angle, speed
            o.drawH, o.drawL = -0x400, -0x300
            o.visualDirection = band(angle + 4, 0xf8) / 8 + 1
            o.palette, o.update = desc[4] + 1, update[desc[6]]
            o.live = program.live[o.kind] or program.boss3.live[o.kind]
            if o.kind == 0x17 then o.live = program.boss4.needle end
            if o.kind == 0x30 then o.live = program.boss4.orbitNeedle end
            if o.kind == 0x3e then o.live = program.boss5.turnArt end
            if o.kind == 0x3f then o.live = program.live[0xb] end
            if o.kind == 0x45 then o.live = program.boss4.orbitNeedle end
            o.dh, o.dl = 0, 0
            if o.update == initBoss4Seed then
                o.childClock, o.childInterval = unpack(motion)
            elseif o.update == initBoss4WallChild then
                o.parentSpeed, o.parentAngle = unpack(motion)
            elseif o.update == initRailRound then
                o.speedLimit = motion[1]
            elseif o.update == initBoss5Redirect then
                o.turnOffset = motion and motion[1] or 0
            elseif o.update == initBoss5Turn then
                o.turnCount = motion[1]
            elseif o.update == initBoss5Spiral then
                o.turnOffset = motion[1]
            elseif o.update == initLastRound then
                o.speedLimit,o.turnOffset = unpack(motion)
            elseif o.update == initLastNeedle then
                o.speedLimit = -1
            elseif o.update == initLastSeed then
                o.turnOffset = motion[1]
            elseif o.update == initBoss3Carrier then
                o.childAngle = motion[1]
            elseif o.update == initBoss3Fan then
                o.turn, o.innerClock, o.childInterval = unpack(motion)
            elseif motion and o.kind == 0x28 then
                o.driftH, o.driftHClock, o.driftHInterval, o.driftL, o.driftLClock, o.driftLInterval = unpack(motion)
            elseif o.update == initBraking then
                o.speedLimit, o.redirectToPilot = motion[1], o.kind == 0x39 or motion[2]
            elseif o.update == initWithChild then
                o.childClock, o.childLimit = unpack(motion)
            elseif o.update == initBoss2Parent then
                o.childClock, o.childInterval, o.childStep, o.childSpeed = unpack(motion or {0,0,0,0})
            elseif o.update == initBoss2Child then
                o.extraStep = motion and motion[1] or 0
            elseif motion then
                o.speedClock, o.speedInterval, o.speedDelta, o.speedLimit = unpack(motion)
            end
            o.group, o.layer = GROUP.ENEMY_BULLET, LAYER.ENEMY_BULLET
            -- 0xb109c 查弹心和自机盒。碰撞单独在原程序顺序中调用。
            o.bound, o.colli = false, false
            o.x, o.y = world(h, l)
        end,
        render = function(o)
            local image = o.sprite and o.run.art.sprites[o.sprite]
            if image then
                Render(image[1], floor((o.l + o.drawL) / 64) - 112 + image[2] / 2,
                    floor((o.h + o.drawH) / 64) - 224 + image[3] / 2)
            end
        end,
    })
    M.class = Bullet

    function M.init(run)
        run.bullets, run.bulletFlash, run.previousCapacity = {}, 0, run.capacity
    end

    emit = function(run, kind, modifier, angle, h, l, extraH, extraL, adjusted, motion)
        if run.freeze or run.suppressShots or run.practicePreparing then return end
        if run.bulletHold and not (run.player and run.player.clearHitbox) then return end
        local desc = program.bullet[kind + 1]
        assert(desc and update[desc[6]], ('尚未翻译敌弹类型 %02x'):format(kind))
        local slots = run.bullets
        for i = 1, run.capacity do
            if not slots[i] then
                h, l = s16(h + (extraH or 0)), s16(l + (extraL or 0))
                local speed = program.bulletSpeed(run, kind, modifier, adjusted)
                local bullet = New(Bullet, run, i, desc, speed, band(angle, 0xff), h, l, motion)
                slots[i] = bullet
                return bullet
            end
        end
    end

    function M.emit(run, kind, modifier, angle, h, l, extraH, extraL)
        return emit(run, kind, modifier, angle * 4, h, l, extraH, extraL, true)
    end

    function M.emitDirect(run, kind, modifier, angle, h, l, extraH, extraL)
        return emit(run, kind, modifier, angle * 4, h, l, extraH, extraL, false)
    end

    function M.emitAngle(run, kind, modifier, angle, h, l, extraH, extraL)
        return emit(run, kind, modifier, angle, h, l, extraH, extraL, false)
    end

    function M.emitReturn(run,ura,angle,h,l,dh,dl)
        local bullet = emit(run,ura and 1 or 6,ura and 2 or -1,angle,h,l,dh,dl,false)
        if bullet and ura then bullet.flags = bor(bullet.flags,0x200) end
        return bullet
    end

    function M.emitMotion(run, kind, modifier, angle, h, l, extraH, extraL, motion)
        return emit(run, kind, modifier, angle, h, l, extraH, extraL, false, motion)
    end

    -- 0xf6fce / 0xf6cc8 两条分支各分配一次。二周目把速度索引加 4。
    function M.emitFasterInLoop(run, kind, modifier, angle, h, l, motion)
        emit(run, kind, modifier + run.route.loop * 4, angle, h, l, nil, nil, false, motion)
    end

    -- 0xf7180 的二周目 0x81 分支在同一角度登记两种速度。
    function M.emitLongPair(run, kind, modifier, angle, h, l, extraH, extraL, motion)
        emit(run, kind, modifier, angle, h, l, extraH, extraL, false, motion)
        if run.route.loop == 1 then
            emit(run, kind, modifier + 6, angle, h, l, extraH, extraL, false, motion)
        end
    end

    function M.emitShortPair(run, kind, modifier, angle, h, l, extraH, extraL)
        local spread = run.route.loop == 1 and 2 or 0
        emit(run, kind, modifier, angle * 4 - spread, h, l, extraH, extraL, false)
        if spread > 0 then emit(run, kind, modifier, angle * 4 + spread, h, l, extraH, extraL, false) end
    end

    function M.emitAcceleration(run, kind, modifier, angle, h, l, motion, adjusted)
        return emit(run, kind, modifier, angle, h, l, nil, nil, adjusted, motion)
    end

    function M.emitDrift(run, modifier, angle, h, l, extraH, extraL, motion)
        return emit(run, 0x28, modifier, angle, h, l, extraH, extraL, false, motion)
    end

    -- 0xf702e 在二周目给同一角度追加一颗速度索引加 3 的弹。
    function M.emitSpeedPair(run, kind, modifier, angle, h, l, extraH, extraL, motion)
        emit(run, kind, modifier, angle, h, l, extraH, extraL, false, motion)
        if run.route.loop == 1 then
            emit(run, kind, modifier + 3, angle, h, l, extraH, extraL, false, motion)
        end
    end

    -- 0xf7064 取 256 方向角，二周目用左右各偏 4 的两颗弹。
    function M.emitSpread(run, kind, modifier, angle, h, l, extraH, extraL, motion)
        if run.route.loop == 0 then
            emit(run, kind, modifier, angle, h, l, extraH, extraL, false, motion)
        else
            emit(run, kind, modifier, angle - 4, h, l, extraH, extraL, false, motion)
            emit(run, kind, modifier, angle + 4, h, l, extraH, extraL, false, motion)
        end
    end

    -- 0xf7052 在二周目把中央弹换成左右各偏 8 的两颗。
    function M.emitWidePair(run, kind, modifier, angle, h, l, extraH, extraL, motion)
        if run.route.loop == 0 then
            emit(run, kind, modifier, angle, h, l, extraH, extraL, false, motion)
        else
            emit(run, kind, modifier, angle - 8, h, l, extraH, extraL, false, motion)
            emit(run, kind, modifier, angle + 8, h, l, extraH, extraL, false, motion)
        end
    end

    -- 0xf7106 保留中央弹，二周目再登记左右两颗。
    function M.emitCenterAndWide(run, kind, modifier, angle, h, l, extraH, extraL, motion)
        emit(run, kind, modifier, angle, h, l, extraH, extraL, false, motion)
        if run.route.loop == 1 then
            emit(run, kind, modifier, angle - 8, h, l, extraH, extraL, false, motion)
            emit(run, kind, modifier, angle + 8, h, l, extraH, extraL, false, motion)
        end
    end

    function M.step(run)
        if run.bulletClearTime then M.clear(run) end
        -- 0xf76f2 仍逐帧更新减容前占用的槽，直到余留段变空。
        -- 分配和自机碰撞分别在 0xf6de8 与 0xb10d8 使用减容后的上限。
        if run.previousCapacity > run.capacity then
            run.bulletTail = math.max(run.bulletTail or 0, run.previousCapacity)
        end
        run.previousCapacity = run.capacity
        local tail
        for i = 1, math.max(run.capacity, run.bulletTail or 0) do
            local bullet = run.bullets[i]
            if bullet then
                bullet.update(bullet)
                if run.bullets[i] then bullet.x, bullet.y = world(bullet.h, bullet.l) end
                if i > run.capacity then tail = i end
            end
        end
        run.bulletTail = tail
        if run.bulletClearTime then
            run.bulletClearTime = run.bulletClearTime - 1
            if run.bulletClearTime == 0 then run.bulletClearTime = nil end
        end
        if run.bulletHold then
            run.bulletHold = run.bulletHold - 1
            if run.bulletHold == 0 then run.bulletHold = nil end
        end
    end

    function M.hit(run, h, l, front, back, right, left, padding)
        -- 0x101d3e 先更新敌弹，之后 0xb109c 按槽位号挑第一颗命中弹。
        -- move.l #$06000800 后先用低字，随后 swap 到高字。
        local highPad, lowPad = padding and 0x800 or 0, padding and 0x600 or 0
        local hMin, hMax = band(h - back - highPad, 0xffff), band(h + front + highPad, 0xffff)
        local lMin, lMax = band(l - left - lowPad, 0xffff), band(l + right + lowPad, 0xffff)
        for i = 1, run.capacity do
            local o = run.bullets[i]
            if o and band(o.flags, 0x5100) == 0 then
                local bh, bl = band(o.h, 0xffff), band(o.l, 0xffff)
                if bh >= hMin and bh <= hMax and bl >= lMin and bl <= lMax then
                    o.flags, o.update = bor(o.flags, 0x4000), beginVanish
                    return o
                end
            end
        end
    end

    function M.clear(run, discard)
        for _, o in pairs(run.bullets) do
            if discard then
                remove(o)
            elseif band(o.flags, 0x4000) == 0 then
                o.flags, o.update = bor(o.flags, 0x4000), beginVanish
            end
        end
    end

    -- 0xb02d4 注册连续清弹，0xf72a8 在每次更新旧槽之前重新扫描。
    function M.clearFor(run, frames)
        run.bulletClearTime = frames > 0 and frames or nil
    end

    function M.clearBox(run, h, l, front, back, right, left)
        for i = 1, run.capacity do
            local o = run.bullets[i]
            if o and band(o.flags, 0x4100) == 0 and o.h >= h - back and o.h <= h + front
                and o.l >= l - left and o.l <= l + right then
                o.flags, o.update = bor(o.flags, 0x4000), beginVanish
            end
        end
    end
    return M
end
