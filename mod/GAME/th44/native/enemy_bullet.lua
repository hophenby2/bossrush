-- 0x17fd16 分配敌弹，0x180592 按槽序调用弹体自身的回调。
return function(program)
    local bit = require('bit')
    local band, bor, bxor = bit.band, bit.bor, bit.bxor
    local s16, world = program.s16, program.world
    local M = {}

    local function remove(o)
        o.run.bullets[o.slot] = nil
        object.RawDel(o)
    end

    local function outside(o)
        return band(o.h, 0xffff) >= 0x7000 or band(o.l, 0xffff) >= 0x3800
    end

    local function move(o, camera)
        o.h, o.l = s16(o.h + o.dh), s16(o.l + o.dl - camera)
    end

    local function animate(o)
        o.drawFrame = o.drawFrame % #o.images + 1
    end

    local function halfRate(o)
        local advance = band(o.flags, 0x0800) == 0
        o.flags = bxor(o.flags, 0x0800)
        if advance then
            o.drawFrame = o.drawFrame + 1
            if o.drawFrame > #o.images then o.drawFrame = (o.kind == 0x13 or o.kind == 0x16) and 5 or 1 end
        end
    end

    local function flight(o)
        move(o, o.run.cameraStep)
        if outside(o) then
            remove(o)
        else
            o.animate(o)
        end
    end

    local function initializeSimple(o)
        o.dh, o.dl = program.vector(o.speed, o.angle)
        local offset = program.bulletOffsets[band(o.angle + 4, 0xf8) / 8 + 1]
        o.h, o.l = s16(o.h + offset[1]), s16(o.l + offset[2])
        o.drawH, o.drawL = o.kind == 0x0b and -0x400 or -0x200, -0x200
        o.flags = band(o.flags, 0xfeff)
        o.update, o.drawFrame = flight, 1
        -- 0x1810e2 与 0x18113c 各装入本样式的飞行回调。
        o.callback = ({
            [0]=0x1808e6,[1]=0x180946,[9]=0x180fc4,[0xa]=0x181024,[11]=0x181092,[12]=0x1810ec,
            [13]=0x181146,[0x14]=0x1813d2,[0x15]=0x182156,[0x17]=0x1815f2,
        })[o.kind]
        o.animate = animate
    end

    local function initializeSmall(o)
        initializeSimple(o)
        o.drawH,o.drawL = -0x200,o.kind == 0 and -0x100 or -0x200
        if o.kind == 0x14 then
            o.animate = function(b) if b.run.frame % 2 == 1 then animate(b) end end
        elseif o.kind == 0x15 then
            local direction = band(o.angle + 4,0xf8) / 8 + 1
            o.images,o.drawFrame = o.images[program.arrowColors[direction]],4
            o.animate = function(b)
                if b.run.frame % 2 == 1 then b.drawFrame = (b.drawFrame - 2) % 4 + 1 end
            end
        end
    end

    local function slide(o)
        move(o,o.run.cameraStep)
        if outside(o) then remove(o); return end
        if o.kind == 0x17 then animate(o)
        else
            if o.ready then
                if o.run.frame % 2 == 1 then o.drawFrame = o.drawFrame % #o.images + 1 end
            else
                o.ready = true
                o.dh,o.dl = program.vector(o.speed,o.angle)
                return
            end
        end
        if o.motionDuration > 0 then
            o.motionDuration = o.motionDuration - 1
            o.motionClock = o.motionClock - 1
            if o.motionClock < 0 then
                o.motionClock = o.motionPeriod
                o.dh = s16(o.dh - o.motionDelta)
            end
        end
    end

    -- 0x1815f2 与 0x181698 读各自弹槽中的位移增量，后者延迟一帧放行。
    local function initializeSlide(o)
        if o.kind == 0x17 then initializeSimple(o)
        else o.dh,o.dl,o.drawFrame,o.callback = 0,0,1,0x181698 end
        o.drawH,o.drawL = -0x400,-0x200
        o.flags = band(o.flags,0xfeff)
        o.update = slide
    end

    local function turnFlight(o)
        move(o,o.run.cameraStep)
        if outside(o) then remove(o); return end
        animate(o)
        if o.turnDuration == 0 then return end
        o.turnDuration = o.turnDuration - 1
        o.turnClock,o.accelClock = o.turnClock - 1,o.accelClock - 1
        local update
        if o.turnClock < 0 then
            o.angle,o.turnClock,update = band(o.angle + o.turnAmount,255),o.turnPeriod,true
        end
        if o.accelClock < 0 then
            o.speed,o.accelClock,update = band(o.speed + o.accelAmount,255),o.accelPeriod,true
        end
        if update then o.dh,o.dl = program.vector(o.speed,o.angle) end
    end

    local function initializeTurn(o)
        o.dh,o.dl,o.drawFrame = 0,0,1
        o.drawH,o.drawL = -0x400,-0x200
        o.flags = band(o.flags,0xfeff)
        o.turnDuration = 0x20
        o.update,o.callback = turnFlight,0x18193c
    end

    local function layChild(o)
        local run = o.run
        move(o,run.cameraStep)
        if outside(o) then remove(o); return end
        if o.childClock > 0 then
            o.childClock = o.childClock - 1
            if o.childClock == 0 then
                local p = run.player
                if p and p.active then
                    local angle = run.boss5ChildrenAim and program.angle256(o.h,o.l,p.h,p.l,o.angle) or o.angle + 0xb0
                    M.emitPrecise(run,o.childKind,o.childSpeed,angle,o.h,o.l)
                end
            end
        end
        o.drawFrame = o.drawFrame % #o.images + 1
    end

    local function initializeLayer(o)
        o.dh,o.dl = program.vector(o.speed,o.angle)
        o.drawH,o.drawL,o.drawFrame = -0x400,-0x200,1
        o.flags = band(o.flags,0xfeff)
        o.childClock,o.update,o.callback = 0x14,layChild,0x181a4a
    end

    local fanCallbacks = {[3]=0x180bc8, [4]=0x180c84, [5]=0x180d40, [6]=0x180dfc}

    local function initializeFan(o)
        o.dh, o.dl = program.vector(o.speed, o.angle)
        o.drawH, o.drawL = -0x400, -0x200
        o.flags = band(o.flags, 0xfeff)
        o.update, o.drawFrame, o.animate = flight, 1, halfRate
        o.callback = fanCallbacks[o.kind]
    end

    local function animateArrow(o)
        if o.arrowClock == 0 then
            o.drawFrame = o.drawFrame % #o.images + 1
            o.arrowClock = 1
        else
            o.arrowClock = o.arrowClock - 1
        end
    end

    local function initializeArrow(o)
        o.dh, o.dl = program.vector(o.speed, o.angle)
        local index = band(o.angle + 4, 0xf8) / 8 + 1
        local offset = program.bulletOffsets[index]
        o.h, o.l = s16(o.h + offset[1]), s16(o.l + offset[2])
        o.drawH, o.drawL = -0x400, -0x200
        o.images, o.arrowClock = o.images[program.arrowColors[index]], 1
        o.flags = band(o.flags, 0xfeff)
        o.update, o.drawFrame, o.animate, o.callback = flight, 1, animateArrow, 0x180ee0
    end

    -- 0x1812d8 暂存速度并显示炮口帧，0x18136e 在下一次更新时放行。
    local function release(o)
        move(o, o.run.cameraStep)
        if outside(o) then remove(o); return end
        o.dh, o.dl = program.vector(o.speed, o.angle)
        o.update, o.animate = flight, halfRate
    end

    local function initializeTurret(o)
        o.dh, o.dl = 0, 0
        o.drawH, o.drawL = -0x400, -0x200
        o.flags = band(o.flags, 0xfeff)
        o.update, o.drawFrame, o.callback = release, 1, o.kind == 0x16 and 0x18151e or 0x18130c
    end

    -- 0x18129e 把引信耗尽的弹槽转成 0x35 场景槽，下一帧由敌机循环消费。
    local function mine(o)
        local run = o.run
        move(o,run.cameraStep)
        if outside(o) then remove(o); return end
        o.fuse = o.fuse - 1
        if o.fuse < 0 then
            local kind = 0x35
            run.spawnQueue[#run.spawnQueue + 1] = {
                run.major,0,kind,0x20,false,false,program.actorCallbacks[kind][2],h=o.h,l=o.l,
            }
            remove(o)
        end
    end

    local function initializeMine(o)
        o.dh,o.dl = program.vector(o.speed,o.angle)
        local offset = program.bulletOffsets[band(o.angle + 4,0xf8) / 8 + 1]
        o.h,o.l = s16(o.h + offset[1]),s16(o.l + offset[2])
        o.drawH,o.drawL = -0x400,-0x200
        o.flags = band(o.flags,0xfeff)
        o.update,o.drawFrame,o.callback = mine,1,0x18129e
    end

    -- 0x181746 只允许一次反射。触边后切到第二组图像，移动仍走通用槽。
    local function bounce(o)
        move(o,o.run.cameraStep)
        if outside(o) then remove(o); return end
        if o.canBounce then
            if o.l < 0x200 or o.l > 0x3600 then
                o.angle,o.flipL = band(-o.angle,255),true
            elseif o.h > 0x6e00 then
                o.angle,o.flipH = band(0x80 - o.angle,255),true
            end
            if o.flipL or o.flipH then
                o.canBounce,o.drawFrame = false,o.drawFrame + 20
                o.dh,o.dl = program.vector(o.speed,o.angle)
            end
        end
        o.drawFrame = o.drawFrame + 1
        if o.drawFrame == 21 and o.canBounce then o.drawFrame = 5
        elseif o.drawFrame == 41 then o.drawFrame = 25 end
    end

    local function initializeBounce(o)
        o.dh,o.dl = program.vector(o.speed,o.angle)
        o.drawH,o.drawL = -0x400,-0x200
        o.flags = band(o.flags,0xfeff)
        o.images,o.drawFrame,o.canBounce = program.bounceBullet,1,true
        o.update,o.callback = bounce,0x181746
    end

    local initializers = {
        [0x1808ac]=initializeSmall,
        [0x18090a]=initializeSimple,
        [0x180b94]=initializeFan, [0x180c50]=initializeFan, [0x180d0c]=initializeFan,
        [0x180dc8]=initializeFan, [0x180e84]=initializeArrow,
        [0x180f88]=initializeSimple, [0x180fe8]=initializeSmall, [0x181048]=initializeSimple,
        [0x1810b0]=initializeSimple, [0x18110a]=initializeSimple, [0x181256]=initializeMine,
        [0x1812d8]=initializeTurret, [0x181396]=initializeSmall, [0x1813fe]=initializeSmall, [0x1814ea]=initializeTurret,
        [0x1815a8]=initializeSlide, [0x181664]=initializeSlide, [0x181716]=initializeBounce,
        [0x1818f0]=initializeTurn, [0x181a1a]=initializeLayer,
    }

    function M.contact(run, pilot)
        local front, back = pilot.h + pilot.front, pilot.h - pilot.back
        local right, left = pilot.l + pilot.right, pilot.l - pilot.left
        -- 0x144cfc 只用敌弹中心。命中在弹槽记 0x1000，下一帧由 0x180678 回收。
        for slot = 1, run.bulletCapacity do
            local o = run.bullets[slot]
            if o and band(o.flags, 0x5100) == 0 and o.h >= back and o.h <= front
                and o.l >= left and o.l <= right then
                o.flags, o.update = o.flags + 0x1000, remove
                return o
            end
        end
    end

    local Bullet = Class(object, {
        init = function(o, run, slot, kind, template, modifier, angle, h, l, flags, init, settings)
            o.run, o.slot, o.kind = run, slot, kind
            o.group, o.layer, o.bound, o.colli = GROUP.ENEMY_BULLET, LAYER.ENEMY_BULLET, false, false
            o.h, o.l, o.x, o.y = h, l, world(h, l)
            local rank = math.min(10,run.bulletRank + run.hyperBulletRank)
            o.angle, o.speed = band(angle, 0xff), band(template[2] + modifier + rank, 0xff)
            o.flags, o.callback, o.update = bor(template[1], flags), template[4], init
            o.images = program.bullet[kind]
            if settings then
                o.fuse = settings.clock
                o.motionClock,o.motionPeriod,o.motionDelta,o.motionDuration =
                    settings.motionFrom,settings.motionPeriod,settings.motionDelta,settings.motionDuration
                o.turnClock,o.turnPeriod,o.turnAmount = settings.turnPeriod,settings.turnPeriod,settings.turnAmount
                o.accelClock,o.accelPeriod,o.accelAmount = settings.accelPeriod,settings.accelPeriod,settings.accelAmount
                o.childKind,o.childSpeed = settings.childKind,settings.childSpeed
            end
        end,
        render = function(o)
            local sprite = o.drawFrame and o.images[o.drawFrame]
            if not sprite or not o.run.art then return end
            local image = o.run.art[sprite]
            local x, y = world(o.h + o.drawH, o.l + o.drawL)
            Render(image[1], math.floor(x) + image[2] / 2, math.floor(y) + image[3] / 2,0,
                o.flipL and -1 or 1,o.flipH and -1 or 1)
        end,
    })

    local function emit(run, kind, modifier, angle, h, l, flags, settings)
        if run.freeze or run.enemyShotGrace > 0 or run.bombMode == 'shot' then return end
        local template = assert(program.bulletTemplates[kind], '未找到敌弹模板')
        local init = assert(initializers[template[4]], ('尚未翻译敌弹首帧回调 0x%06x'):format(template[4]))
        for i = 1, run.bulletCapacity do
            if not run.bullets[i] then
                local o = New(Bullet, run, i, kind, template, modifier, angle, h, l, flags, init, settings)
                run.bullets[i] = o
                return o
            end
        end
    end

    function M.emit(run, kind, modifier, angle, h, l, settings)
        return emit(run, kind, modifier, angle * 4, h, l, 0, settings)
    end

    function M.emitPrecise(run, kind, modifier, angle, h, l, settings)
        return emit(run, kind, modifier, angle, h, l, 0x0200, settings)
    end

    -- 0x143e1a 按当时仍在槽内的弹记分，0x18048a 消费清弹标志并从弹位分配道具。
    function M.clearWithChips(run, flags)
        run.clearBulletChips = true
        if not run.player or band(flags, run.player.hitFlags) == 0 then return end
        for _ in pairs(run.bullets) do run.player.score = run.player.score + 23 end
    end

    -- 0x143d6e 请求 0x180756 的清弹动画，第一次移动用原速，之后折半。
    function M.clearWithFade(run, flags)
        run.clearBulletFade = true
        if flags and run.player and band(flags, run.player.hitFlags) ~= 0 then
            for _, o in pairs(run.bullets) do
                if not o.fadeFrame then run.player.score = run.player.score + 23 end
            end
        end
    end

    -- 0x144c68 对激光炸弹各段测试敌弹中心，地物挡住之后的部分保留敌弹。
    function M.eraseBomb(run, boxes, limit)
        for slot = 1,run.bulletCapacity do
            local o = run.bullets[slot]
            if o and o.h >= 0 and (not limit or o.h < limit) then
                for _, box in ipairs(boxes) do
                    if o.h <= box.h + box.front and o.h >= box.h - box.back
                        and o.l <= box.l + box.right and o.l >= box.l - box.left then
                        remove(o)
                        break
                    end
                end
            end
        end
    end

    local function fade(o)
        move(o, o.run.cameraStep)
        if o.fadeFrame == 0 then o.dh, o.dl = math.floor(o.dh / 2), math.floor(o.dl / 2) end
        o.fadeFrame = o.fadeFrame + 1
        if o.fadeFrame >= 16 then remove(o)
        else o.drawFrame = o.fadeFrame end
    end

    function M.step(run, items)
        for slot = 1, run.bulletCapacity do
            local o = run.bullets[slot]
            if o and run.clearBulletChips then
                items.emit(o, 0)
                remove(o)
            elseif o then
                if run.clearBulletFade and o.update ~= fade and band(o.flags,0x1000) == 0 then
                    if not o.drawFrame then o.update(o) end
                    o.images, o.fadeFrame, o.flags = program.fade[program.bulletTemplates[o.kind][6]], 0, bor(o.flags,0x4000)
                    o.drawH, o.drawL, o.callback, o.update = -0x400, -0x200, 0x180756, fade
                end
                o.update(o)
                if run.bullets[slot] then o.x, o.y = world(o.h, o.l) end
            end
        end
        run.clearBulletChips = false
        run.clearBulletFade = false
    end

    function M.close(run)
        for _, o in pairs(run.bullets) do remove(o) end
    end

    return M
end
