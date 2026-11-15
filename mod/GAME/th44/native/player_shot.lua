-- 0x148e3a 按按下边沿及余下的连发次数分配机体弹，0x152c7a 推进各弹槽。
return function(program)
    local bit = require('bit')
    local band = bit.band
    local floor, min = math.floor, math.min
    local s16, world = program.s16, program.world
    local M = {}

    local function remove(o)
        o.pilot.shots[o.slot] = nil
        object.RawDel(o)
    end

    local function move(o, h, l)
        o.h, o.l = s16(o.h + h), s16(o.l + l)
    end

    local function fly(o)
        local model = o.pilot.model
        move(o, o.dh, o.dl)
        if band(o.h, 0xffff) >= (model == 1 and 0x8000 or 0x7800)
            or band(o.l + (model == 1 and 0x400 or 0x800), 0xffff) >= (model == 1 and 0x4000 or 0x4800) then
            remove(o)
            return
        end
        o.sprite = o.motion[o.animation + 1]
        o.animation = 1 - o.animation
    end

    local function impactFrame(o)
        o.animation = o.animation - 1
        if o.animation < 0 then remove(o); return end
        move(o, o.dh, o.dl)
        o.sprite = o.impactFrames[o.animation + 1]
    end

    local function jitter(run)
        run.randomByte = band(run.randomByte + 1, 0xff)
        return floor(s16(program.pilotJitter[band(run.randomByte, 0x3f) + 1]) / 2)
    end

    local function hitOrFly(o)
        if not o.pendingHit then fly(o); return end
        local dh, dl = o.dh + jitter(o.run), o.dl + jitter(o.run)
        move(o, dh, dl)
        o.dh, o.dl = floor(dh / 4), floor(dl / 4)
        o.drawH, o.drawL = unpack(o.impactOffset)
        o.animation = #o.impactFrames
        o.update, o.damage = impactFrame, -1
        impactFrame(o)
    end

    local function launch(o)
        o.dh, o.dl = program.vector(o.speed, o.angle)
        if o.pendingHit then hitOrFly(o); return end
        o.drawH, o.drawL = unpack(o.flightOffset)
        o.h = s16(o.h + o.flightOffset[3])
        o.update = hitOrFly
        fly(o)
    end

    local function followPilot(o)
        local p = o.pilot
        move(o, p.deltaH or 0, p.deltaL or 0)
        o.update = launch
    end

    local function newborn(o)
        o.update = followPilot
    end

    local Shot = Class(object, {
        init = function(o, pilot, slot, record)
            o.pilot, o.run, o.slot = pilot, pilot.run, slot
            o.group, o.layer, o.bound, o.colli = GROUP.PLAYER_BULLET, LAYER.PLAYER_BULLET, false, false
            local shot, flightOffset, impactOffset, flash, motion, impactFrames = unpack(record)
            o.h, o.l = s16(pilot.h + shot[2]), s16(pilot.l + shot[3])
            o.x, o.y = world(o.h, o.l)
            o.drawH, o.drawL = shot[4], shot[5]
            o.front, o.back, o.right, o.left = shot[6], shot[7], shot[8], shot[9]
            o.damage, o.speed, o.angle = shot[10], shot[11], shot[12]
            o.flightOffset, o.impactOffset = flightOffset, impactOffset
            o.motion, o.impactFrames = motion, impactFrames
            o.sprite, o.animation = flash[pilot.shotFlash + 1], pilot.shotAnimation
            o.update = newborn
        end,
        render = function(o)
            if not o.run.art then return end
            local image = o.run.art[o.sprite]
            local x, y = world(o.h + o.drawH, o.l + o.drawL)
            Render(image[1], floor(x) + image[2] / 2, floor(y) + image[3] / 2)
        end,
    })

    local function free(shots, first, last)
        for slot = first, last do
            if not shots[slot] then return slot end
        end
    end

    local function emit(p, slot, record, last)
        p.shots[slot] = New(Shot, p, slot, record)
        p.shotFlash = (p.shotFlash + 2) % 3
        if last then p.shotAnimation = 1 - p.shotAnimation end
    end

    local function burst(p)
        local shots = p.shots
        local level = p.weapon.levels[p.shotLevel]
        local gap = p.shotLevel == 5 and p.model == 1 and 2 or p.weapon.delay
        p.shotClock = gap
        if p.doll == 2 then
            local slot = free(shots, 10, 10 + min(level.capacity + 2, 4))
            if slot then emit(p, slot, level[1], true); return true end
        elseif p.model == 1 then
            local limit = min(level.capacity, 3)
            local left, right = free(shots, 15, 15 + limit), free(shots, 22, 22 + limit)
            if left then emit(p, left, level[1], false) end
            if right then emit(p, right, level[2], true) end
            if left or right then return true end
        else
            local limit = 15 + min(2 * level.capacity + 1, 7)
            local left = free(shots, 15, limit)
            local right = left and free(shots, left + 1, limit)
            if right then
                emit(p, right, level[1], false)
                emit(p, left, level[2], true)
                return true
            end
        end
        if p.shotLevel < 5 then p.shotBurst = 0 end
    end

    function M.input(p, keys)
        local pressed = not not keys.shoot
        local justPressed = pressed and not p.shootHeld
        p.shootHeld = pressed
        if justPressed then
            p.shotBurst = p.weapon.burst + band(p.shotLevel - 1, 6)
            burst(p)
        elseif p.shotBurst > 0 then
            p.shotClock = p.shotClock - 1
            if p.shotClock == 0 then
                p.shotBurst = p.shotBurst - 1
                burst(p)
            end
        end
    end

    function M.step(p)
        for slot = 1, 36 do
            local o = p.shots[slot]
            if o then
                o.l = s16(o.l - p.run.cameraStep)
                o.update(o)
                if p.shots[slot] then o.x, o.y = world(o.h, o.l) end
            end
        end
    end

    function M.close(p)
        for _, o in pairs(p.shots) do remove(o) end
    end

    return M
end
