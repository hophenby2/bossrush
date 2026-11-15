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
            if o.drawFrame > #o.images then o.drawFrame = o.kind == 0x13 and 5 or 1 end
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
        o.callback = ({[9]=0x180fc4,[11]=0x181092,[12]=0x1810ec,[13]=0x181146})[o.kind]
        o.animate = animate
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
        o.update, o.drawFrame, o.callback = release, 1, 0x18130c
    end

    local initializers = {
        [0x180b94]=initializeFan, [0x180c50]=initializeFan, [0x180d0c]=initializeFan,
        [0x180dc8]=initializeFan, [0x180e84]=initializeArrow,
        [0x180f88]=initializeSimple, [0x181048]=initializeSimple,
        [0x1810b0]=initializeSimple, [0x18110a]=initializeSimple, [0x1812d8]=initializeTurret,
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
        init = function(o, run, slot, kind, template, modifier, angle, h, l, flags, init)
            o.run, o.slot, o.kind = run, slot, kind
            o.group, o.layer, o.bound, o.colli = GROUP.ENEMY_BULLET, LAYER.ENEMY_BULLET, false, false
            o.h, o.l, o.x, o.y = h, l, world(h, l)
            o.angle, o.speed = band(angle, 0xff), band(template[2] + modifier + run.bulletRank, 0xff)
            o.flags, o.callback, o.update = bor(template[1], flags), template[4], init
            o.images = program.bullet[kind]
        end,
        render = function(o)
            local sprite = o.drawFrame and o.images[o.drawFrame]
            if not sprite or not o.run.art then return end
            local image = o.run.art[sprite]
            local x, y = world(o.h + o.drawH, o.l + o.drawL)
            Render(image[1], math.floor(x) + image[2] / 2, math.floor(y) + image[3] / 2)
        end,
    })

    local function emit(run, kind, modifier, angle, h, l, flags)
        if run.freeze or run.enemyShotGrace > 0 then return end
        local template = assert(program.bulletTemplates[kind], '未找到敌弹模板')
        local init = assert(initializers[template[4]], ('尚未翻译敌弹首帧回调 0x%06x'):format(template[4]))
        for i = 1, run.bulletCapacity do
            if not run.bullets[i] then
                local o = New(Bullet, run, i, kind, template, modifier, angle, h, l, flags, init)
                run.bullets[i] = o
                return o
            end
        end
    end

    function M.emit(run, kind, modifier, angle, h, l)
        return emit(run, kind, modifier, angle * 4, h, l, 0)
    end

    function M.emitPrecise(run, kind, modifier, angle, h, l)
        return emit(run, kind, modifier, angle, h, l, 0x0200)
    end

    -- 0x143e1a 按当时仍在槽内的弹记分，0x18048a 消费清弹标志并从弹位分配道具。
    function M.clearWithChips(run, flags)
        run.clearBulletChips = true
        if not run.player or band(flags, run.player.hitFlags) == 0 then return end
        for _ in pairs(run.bullets) do run.player.score = run.player.score + 23 end
    end

    -- 0x143d6e 请求 0x180756 的清弹动画，第一次移动用原速，之后折半。
    function M.clearWithFade(run)
        run.clearBulletFade = true
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
