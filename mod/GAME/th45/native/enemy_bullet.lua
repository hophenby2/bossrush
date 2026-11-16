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

    local function move(b)
        local run = b.run
        b.flash = nil
        b.h,b.l = program.addPacked(b.h,b.l,b.dh * 0x10000 + band(b.dl - run.cameraStep,0xffff))
        if expired(b) then return false end
        local target = run.awakened and b.fastSpeed or b.baseSpeed
        if run.reloadBulletVelocity then velocity(b)
        elseif b.speed ~= target and not (run.awakened and run.slowVectors) then
            b.speedClock = b.speedClock - 1
            if b.speedClock < 0 then
                local speed = run.awakened and b.speed + 1 or b.speed - 2
                b.speed = run.awakened and math.min(speed,target) or math.max(speed,target)
                b.speedClock = 0
                velocity(b)
            end
        end
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

    handlers[0x1744ee] = function(b)
        if not launch(b,0x174578) then return false end
        local angle = floor(band(b.angle + 4,0xf8) / 8) + 1
        b.images = program.arrowImages[program.arrowDirection[angle]]
        b.offsetH,b.offsetL,b.imageFrame,b.imageClock = -0x400,-0x200,3,1
        return true
    end

    handlers[0x174578] = function(b)
        if not move(b) then return false end
        b.imageClock = b.imageClock - 1
        if b.imageClock < 0 then b.imageClock,b.imageFrame = 1,(b.imageFrame + 1) % 3 + 1 end
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
        b.dh,b.dl = floor(b.dh / 2),floor(b.dl / 2)
        b.callback,b.update = 0x170020,handlers[0x170020]
        return b.update(b)
    end

    local Bullet = Class(object,{
        init = function(b,run,slot,origin,template,h,l,angle,modifier)
            b.run,b.slot,b.origin = run,slot,origin
            b.flags,b.h,b.l,b.angle = template[3],h,l,angle
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
            if not assets or not b.images then return end
            local id = b.flash or b.images[b.imageFrame]
            art.draw(assets.sprites[id],b.h,b.l,b.flash and b.flashH or b.offsetH,b.flash and b.flashL or b.offsetL)
        end,
    })

    function M.emit(origin,kind,modifier,angle,dh,dl)
        local run = origin.run
        if run.freeze or run.blockEnemyFire then return end
        local template = program.bulletTemplates[kind + 1]
        assert(template and template[11] == 0,'此敌弹需要发射时附加设置')
        for slot = 1,run.bulletCapacity do
            if not run.bullets[slot] then
                local b = New(Bullet,run,slot,origin,template,s16(origin.h + dh),s16(origin.l + dl),angle,modifier)
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

    function M.step(run)
        for slot = 1,run.bulletCapacity do
            local b = run.bullets[slot]
            if b then
                if not b.update(b) then M.remove(b)
                else b.x,b.y = program.world(b.h,b.l) end
            end
        end
    end

    return M
end
