-- 0x1228e6 读取原程序的方向键表。速度档在移动和限位之后更新。
return function(program,shots)
    local min,max = math.min,math.max
    local M = {}
    local Pilot = Class(object,{
        init = function(p,run,h,l,keys,protect)
            p.run,p.h,p.l,p.key = run,h,l,keys
            p.active,p.protect = true,protect
            p.front,p.back,p.right,p.left = 0xc0,0x80,0x80,0x80
            p.speed,p.fastSpeed,p.focusSpeed = 0x16,0x16,0x0c
            p.focusClock,p.speedClock = 0x19,0
            p.cameraMotion = 0
            p.power,p.shots,p.shotFrame = 0,{},1
            p.leftTilt,p.rightTilt,p.leftClock,p.rightClock = 0,0,2,2
            p.x,p.y = program.world(h,l)
            p.group,p.layer,p.bound,p.colli = GROUP.PLAYER,LAYER.PLAYER,false,false
        end,
    })

    function M.spawn(run,h,l,keys,protect)
        return New(Pilot,run,h,l,keys,protect or 0xf0)
    end

    function M.step(p)
        if not p.active or p.run.freeze then return end
        if p.pendingHit and p.protect == 0 then p.wasHit = true end
        p.pendingHit = false
        if p.protect > 0 and p.protect < 0xfe then p.protect = p.protect - 1 end
        local keys = p.key or KeyState
        local oldH,oldL = p.h,p.l
        local input = (keys.up and 1 or 0) + (keys.down and 2 or 0)
            + (keys.left and 4 or 0) + (keys.right and 8 or 0)
        local direction = program.pilotDirections:byte(input + 1)
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
        if keys.shoot and not p.shotHeld then shots.emit(p) end
        p.shotHeld = not not keys.shoot
        if not keys.shoot then
            p.focusClock,p.speed,p.focus = 0x19,p.fastSpeed,false
        elseif p.focusClock > 0 then
            p.focusClock = p.focusClock - 1
            p.focus = p.focusClock == 0
        else
            p.speedClock = p.speedClock - 1
            if p.speedClock < 0 then
                p.speedClock = 1
                if p.speed > p.focusSpeed then p.speed = p.speed - 1
                elseif p.speed < p.focusSpeed then p.speed = p.speed + 1 end
            end
        end
    end

    return M
end
