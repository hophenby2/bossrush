-- 0x1228e6 读取原程序的方向键表。速度档在移动和限位之后更新。
return function(program,shots,lasers,guards,art)
    local min,max,floor = math.min,math.max,math.floor
    local M = {}
    local loopStart = {[0]=1,[1]=29,[2]=29,[3]=13,[4]=13,[9]=1,[10]=29,[11]=29,[19]=1,[21]=1}
    local nextPose = {[5]=0,[6]=0,[7]=0,[8]=0,[12]=9,[13]=9,[14]=9,[15]=0,[18]=19,[20]=21,[22]=0}
    local mirrored = {[2]=true,[6]=true,[11]=true,[13]=true}

    local function lock(sys) sys.locked = true end

    local function setPose(p,pose,index)
        p.pose,p.poseIndex,p.poseClock = pose,index or 1,0
    end

    local function animate(p)
        p.poseClock = p.poseClock - 1
        if p.poseClock >= 0 then return end
        local sequence = program.agehaPose[p.form][p.pose]
        local index = p.poseIndex
        if index > #sequence then
            local pose = nextPose[p.pose]
            if pose then setPose(p,pose); sequence,index = program.agehaPose[p.form][pose],1
            else index = loopStart[p.pose] end
        end
        p.poseFrame,p.poseIndex,p.poseClock = sequence[index],index + 1,1
    end

    local function setForm(p,form)
        local properties = program.agehaForm[form]
        p.form = form
        p.front,p.back,p.right,p.left,p.fastSpeed,p.focusSpeed,p.shotDelay,p.shotExtra = unpack(properties)
        if form == 2 then
            local growth = p.overLevel * 0x10
            p.front,p.back,p.right,p.left = p.front+growth,p.back+growth,p.right+growth,p.left+growth
        end
        setPose(p,p.focus and 9 or 0)
    end

    -- 0x1228f8 回正时接续当前位置的帧，避免中途松开方向键时跳到完整摆幅。
    local function steerPose(p,direction)
        local previous = p.direction
        p.direction = direction
        if p.pose >= 14 then return end
        local motion = program.agehaMotion
        if direction < 0x80 then
            local pose = motion[p.focus and 4 or 3][floor(direction / 8) + 1]
            if pose ~= p.pose then setPose(p,pose) end
        elseif previous < 0x80 then
            local pose = motion[p.focus and 2 or 1][floor(previous / 8) + 1]
            setPose(p,pose,(p.poseFrame and p.poseFrame[4] or 0) + 1)
        end
    end

    local function updateAwakening(p)
        local run = p.run
        local mode = p.form == 1 and 0 or (p.gems > 0 and 2 or 1)
        if mode ~= p.awakeningMode then
            p.awakeningMode,p.awakeningTick = mode,false
            run.awakened,run.slowVectors,run.halfPathSpeed = mode ~= 0,mode == 2,mode == 2
            run.awakeningMode,run.awakeningReload = mode,true
        end
        p.awakeningTick = mode == 2 and not p.awakeningTick
    end

    -- 0x12522a 先走 14 帧变身计时，再切换射击和移动参数。
    local function awaken(p,pressed,activeButtons)
        if pressed and p.awakeClock <= 0x6c then
            p.awakeClock,p.awakeTarget = 0x114,3 - p.form
            p.cancelChain = 0
            lasers.clear(p)
        end
        local transforming = p.awakeClock > 0x6c
        if p.awakeClock > 0 then
            p.awakeClock = p.awakeClock - 0xc
            if p.awakeClock == 0x6c then
                setForm(p,p.awakeTarget)
                if p.focus then lasers.spawn(p) end
            end
        end
        local hadGems = p.gems > 0
        if p.form == 2 and hadGems then
            if p.awakeTarget == 1 and p.awakeClock > 0 then p.gems = p.gems - 1
            else
                p.gemClock = p.gemClock - 1
                if p.gemClock < 0 then p.gems,p.gemClock = p.gems - 1,5 end
            end
            if p.gems == 0 then p.cancelChain = 0 end
        end
        updateAwakening(p)
        if p.awakeningMode == 1 and not hadGems and p.overLevel < 3 then
            local increment = not activeButtons and p.overIdle == 64 and 4 or 1
            p.overIdle = activeButtons and 0 or min(64,p.overIdle + 1)
            p.overTime = p.overTime + increment
            if p.overTime >= 999 then
                p.overLevel,p.overTime = p.overLevel + 1,0
                p.front,p.back,p.right,p.left = p.front+0x10,p.back+0x10,p.right+0x10,p.left+0x10
            end
        end
        return transforming
    end

    local Pilot = Class(object,{
        init = function(p,run,h,l,keys,protect)
            p.run,p.h,p.l,p.key = run,h,l,keys
            p.active,p.protect = true,protect
            p.reserveLives = run.reserveLives or 2
            setForm(p,1)
            p.speed,p.focusClock,p.speedClock = p.fastSpeed,0x19,1
            p.gems,p.gemClock = run.initialGems or 0x64,2
            p.score,p.goldStock,p.cancelChain = 0,0,0
            p.guardEnergy,p.guardCharge = 0xfa0,0
            p.misses,p.guardsUsed,p._playersys = 0,0,{lock=lock}
            p.awakeClock,p.awakeTarget,p.awakeningMode = 0,1,0
            p.overLevel,p.overTime,p.overIdle = 0,0,0
            p.cameraMotion = 0
            p.power,p.shots,p.rays,p.shotFrame = 0,{},{},1
            p.burst,p.burstClock,p.direction = 0,0,0xff
            p.leftTilt,p.rightTilt,p.leftClock,p.rightClock = 0,0,2,2
            p.x,p.y = program.world(h,l)
            p.group,p.layer,p.bound,p.colli = GROUP.PLAYER,LAYER.PLAYER,false,false
        end,
        render = function(p)
            local loss,assets = p.loss,p.run.art
            if not assets then return end
            if loss then
                local frame = loss.pose
                if frame then art.draw(assets.sprites[frame[5]],p.h,p.l,frame[3],frame[4]) end
            elseif p.poseFrame then
                local frame = p.poseFrame
                art.draw(assets.sprites[frame[1]],p.h,p.l,frame[2],frame[3],mirrored[p.pose])
            end
        end,
    })

    function M.spawn(run,h,l,keys,protect)
        return New(Pilot,run,h,l,keys,protect or 0xf0)
    end

    -- 0x1233d0 经 0x1480b2 扣减备用机。0x1234d4 关闭自机判定并选择坠机流程。
    local function beginLoss(p)
        p.active,p.wasHit,p.cameraMotion = false,true,0
        p.misses = p.misses + 1
        p.deltaH,p.deltaL = 0,0
        lasers.clear(p)
        guards.clear(p)
        p.awakeClock,p.awakeTarget,p.burst,p.focus = 0,1,0,false
        p.overLevel,p.overTime,p.overIdle = 0,0,0
        p.goldStock,p.cancelChain = floor(p.goldStock/2),0
        setForm(p,1)
        updateAwakening(p)
        p.reserveLives = p.reserveLives - 1
        if p.reserveLives >= 0 then
            p.loss = {clock=0,index=0}
        else
            -- 0x12798c 的 32 步失误演出之后，0x123558 再等 32 帧。
            p.loss = {clock=64}
        end
    end

    local function stepLoss(p)
        local loss = p.loss
        loss.clock = loss.clock - 1
        if p.reserveLives < 0 then
            if loss.clock == 0 then p.loss,p.run.gameOver = nil,true end
            return false
        end
        if loss.waiting then
            if loss.clock > 0 then return false end
            -- 0x12275a 重置机体参数并给予 0xf0 帧保护，本帧进入通常更新。
            p.active,p.loss,p.protect = true,nil,0xf0
            p.power,p.shotFrame,p.shotHeld = 0,1,false
            p.gems,p.gemClock = 0x64,2
            p.guardEnergy,p.guardCharge = 0xfa0,0
            p.leftTilt,p.rightTilt,p.leftClock,p.rightClock = 0,0,2,2
            p.focusClock,p.speedClock,p.speed,p.direction = 0x19,1,p.fastSpeed,0xff
            return true
        end
        if loss.clock < 0 then
            loss.index = loss.index + 1
            local pose = program.agehaLoss[loss.index]
            if not pose then
                -- 0x12356a 清空旧机体槽。原程序在两帧后恢复输入。
                loss.waiting,loss.pose,loss.clock = true,nil,2
                return false
            end
            loss.pose,loss.clock = pose,pose[1]
        end
        p.h = max(0x700,p.h - loss.pose[2])
        p.x,p.y = program.world(p.h,p.l)
        return false
    end

    -- 0x122866 的受击路径和 0x122a12 的 C 键路径共用护罩，自动发动多扣一档槽量。
    local function startGuard(p,automatic)
        lasers.clear(p)
        p.focus,p.focusClock,p.speed,p.burst = false,0x19,p.fastSpeed,0
        p.awakeClock = 0
        p.guardsUsed = p.guardsUsed + 1
        setPose(p,18)
        guards.begin(p,automatic)
    end

    -- 0x122b18 长按 A 达到 25 帧才占用激光槽。0x122c74 的短点射会继续完成余下的发射。
    local function shoot(p,held)
        if not held then
            if p.focus then
                lasers.clear(p)
                setPose(p,15)
            end
            p.focusClock,p.speed,p.focus = 0x19,p.fastSpeed,false
        elseif p.focusClock > 0 then
            p.focusClock = p.focusClock - 1
            if p.focusClock == 0 then
                p.focus,p.burst = true,0
                setPose(p,14)
                lasers.spawn(p)
            end
        else
            p.speedClock = p.speedClock - 1
            if p.speedClock < 0 then
                p.speedClock = 1
                if p.speed > p.focusSpeed then p.speed = p.speed - 1
                elseif p.speed < p.focusSpeed then p.speed = p.speed + 1 end
            end
        end
        if p.focus then return end
        if held and not p.shotHeld then
            p.burst = p.form == 2 and program.agehaAwakeBurst[p.power + 1] or p.shotExtra + 1 + (p.power % 4) * 2
            p.burstClock = 0
        end
        if p.burst > 0 then
            p.burstClock = p.burstClock - 1
            if p.burstClock <= 0 then
                p.burstClock = (p.form == 2 or p.power == 4) and 2 or p.shotDelay
                if shots.emit(p) then p.burst = p.burst - 1
                elseif p.power ~= 4 then p.burst = 0 end
            end
        end
    end

    function M.step(p)
        if p.lock or p._playersys.locked then return end
        if p.loss and not stepLoss(p) then return end
        if not p.active or p.run.freeze then return end
        local lost = p.pendingHit and p.protect == 0
        p.pendingHit = false
        local automatic = lost and p.form == 2 and p.guardEnergy > 0
        if automatic then startGuard(p,true)
        elseif lost then beginLoss(p); return end
        if p.protect > 0 and p.protect < 0xfe then p.protect = p.protect - 1 end
        local keys = p.key or KeyState
        local oldH,oldL = p.h,p.l
        local input = (keys.up and 1 or 0) + (keys.down and 2 or 0)
            + (keys.left and 4 or 0) + (keys.right and 8 or 0)
        local direction = automatic and 0xff or program.pilotDirections:byte(input + 1)
        steerPose(p,direction)
        if direction < 0x80 then
            local h,l = program.vector(p.speed,direction * 4)
            p.cameraMotion = l
            p.h,p.l = max(0x700,min(0x6500,p.h + h)),max(0x300,min(0x3500,p.l + l))
        else
            p.cameraMotion = 0
            p.l = program.s16(p.l - (p.run.playerCameraStep or 0))
        end
        p.deltaH,p.deltaL = p.h - oldH,p.l - oldL
        if keys.left then
            p.leftClock = p.leftClock - 1
            if p.leftClock < 0 then p.leftClock,p.leftTilt = 2,min(32,p.leftTilt + 1) end
        else p.leftClock,p.leftTilt = 5,max(0,p.leftTilt - 2) end
        if keys.right then
            p.rightClock = p.rightClock - 1
            if p.rightClock < 0 then p.rightClock,p.rightTilt = 2,min(32,p.rightTilt + 1) end
        else p.rightClock,p.rightTilt = 5,max(0,p.rightTilt - 2) end
        p.x,p.y = program.world(p.h,p.l)
        if not p.guard and p.pose ~= 22 and keys.special and p.guardEnergy > 0 then startGuard(p,false) end
        local guarding = p.guard ~= nil or p.pose == 22
        local transforming = awaken(p,not guarding and keys.spell and not p.awakeHeld,keys.shoot or keys.spell or keys.special)
        p.awakeHeld = not not keys.spell
        if p.guard then
            local pose = guards.step(p,keys.special)
            if pose == 22 then setPose(p,pose)
            elseif pose then p.pose = pose end
        elseif not transforming and not guarding then
            if p.focus and keys.shoot then lasers.step(p) end
            shoot(p,keys.shoot)
        end
        p.shotHeld = not not keys.shoot
        animate(p)
    end

    function M.enterStage(p,run)
        for _,shot in pairs(p.shots) do shots.remove(shot) end
        lasers.clear(p)
        if p.guard then
            guards.clear(p)
            p.protect = 0x5a
        end
        p.run,p.pendingHit,p.cameraMotion = run,false,0
        p.focus,p.focusClock,p.speed,p.burst = false,0x19,p.fastSpeed,0
        p.awakeClock,p.guardCharge = 0,0
        p.awakeningMode = -1
        updateAwakening(p)
        setPose(p,0)
    end

    return M
end
