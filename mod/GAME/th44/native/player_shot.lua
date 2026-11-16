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
        local ceiling = o.isOption and (model == 1 and 0x7800 or 0x7400)
            or (model == 1 and 0x8000 or 0x7800)
        local side = model == 1 and 0x400 or (o.isOption and 0x600 or 0x800)
        local span = model == 1 and 0x4000 or (o.isOption and 0x4400 or 0x4800)
        move(o, o.dh, o.dl)
        if band(o.h, 0xffff) >= ceiling or band(o.l + side, 0xffff) >= span then
            remove(o)
            return
        end
        if o.isOption then o.sprite = o.motionImage
        else
            o.sprite = o.motion[o.animation + 1]
            o.animation = 1 - o.animation
        end
    end

    local function impactFrame(o)
        o.animation = o.animation - 1
        if o.animation < 0 then remove(o); return end
        if not o.isOption then move(o, o.dh, o.dl) end
        o.sprite = o.impactFrames[o.animation + 1]
    end

    local function jitter(run,divisor)
        run.randomByte = band(run.randomByte + 1, 0xff)
        return floor(s16(program.pilotJitter[band(run.randomByte, 0x3f) + 1]) / divisor)
    end

    local function hitOrFly(o)
        if not o.pendingHit then fly(o); return end
        local divisor = o.isOption and 4 or 2
        local dh, dl = o.dh + jitter(o.run,divisor), o.dl + jitter(o.run,divisor)
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
        if not o.isOption then
            local p = o.pilot
            move(o, p.deltaH or 0, p.deltaL or 0)
        end
        o.update = launch
    end

    local function newborn(o)
        o.update = followPilot
    end

    local Shot = Class(object, {
        init = function(o, pilot, slot, record, source, flashIndex)
            o.pilot, o.run, o.slot = pilot, pilot.run, slot
            o.group, o.layer, o.bound, o.colli = GROUP.PLAYER_BULLET, LAYER.PLAYER_BULLET, false, false
            local shot, flightOffset, impactOffset, flash, motion, impactFrames, orbit = unpack(record)
            local h,l = shot[2],shot[3]
            o.angle,o.motionImage = shot[12],motion[1]
            o.isOption = source ~= nil
            if source and orbit then
                local direction = band(source.angle,0x3e)
                o.mirror = direction > 0x20
                local row = orbit[(o.mirror and 64 - direction or direction) / 2 + 1]
                h,l,o.motionImage = unpack(row)
                if o.mirror then l,o.angle = -l,band(-o.angle,255) end
            elseif source then o.mirror = o.angle < 0x80 end
            source = source or pilot
            o.h, o.l = s16(source.h + h), s16(source.l + l)
            o.x, o.y = world(o.h, o.l)
            o.drawH, o.drawL = shot[4], shot[5]
            o.front, o.back, o.right, o.left = shot[6], shot[7], shot[8], shot[9]
            o.damage,o.speed = shot[10],shot[11]
            o.flightOffset, o.impactOffset = flightOffset, impactOffset
            o.motion, o.impactFrames = motion, impactFrames
            o.sprite, o.animation = flash[flashIndex or pilot.shotFlash + 1], pilot.shotAnimation
            o.update = newborn
        end,
        render = function(o)
            if not o.run.art then return end
            local image = o.run.art[o.sprite]
            local x, y = world(o.h + o.drawH, o.l + o.drawL)
            Render(image[1], floor(x) + image[2] / 2, floor(y) + image[3] / 2,0,o.mirror and -1 or 1,1)
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
        local weapon = p.hyperPower and program.pilotHyperWeapons[p.model][p.doll] or p.weapon
        local level = weapon.levels[p.shotLevel]
        local gap = p.shotLevel == 5 and p.model == 1 and 2 or weapon.delay
        p.shotClock = gap
        local capacity = level.capacity
        if p.doll == 2 then
            local limit = p.run.dual and min(capacity + 2,4) or capacity + 2
            local slot = free(shots, 10, 10 + limit)
            if slot then emit(p, slot, level[1], true); return true end
        elseif p.model == 1 then
            local limit = p.run.dual and min(capacity,3) or capacity
            local left, right = free(shots, 15, 15 + limit), free(shots, 22, 22 + limit)
            if left then emit(p, left, level[1], false) end
            if right then emit(p, right, level[2], true) end
            if left or right then return true end
        else
            local limit = 2 * capacity + 1
            limit = 15 + (p.run.dual and min(limit,7) or limit)
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
            p.shotBurst = p.weapon.burst + (p.hyperPower and 4 or band(p.shotLevel - 1,6))
            burst(p)
        elseif p.shotBurst > 0 then
            p.shotClock = p.shotClock - 1
            if p.shotClock == 0 then
                p.shotBurst = p.shotBurst - 1
                burst(p)
            end
        end
    end

    local function optionBurst(p,s,level)
        local shots,opts = p.shots,s.options
        local capacity = level.capacity + (p.doll == 2 and 2 or 0)
        if p.run.dual then capacity = min(capacity,4) end
        local function fire(slot,index,flash)
            if slot then shots[slot] = New(Shot,p,slot,level[index],opts[index],flash) end
        end
        if p.doll == 1 then
            local left,right = free(shots,1,1 + capacity),free(shots,8,8 + capacity)
            fire(left,1,s.supportFlash)
            fire(right,2,s.supportFlash)
        elseif p.doll == 2 then
            local first,second = 1,24
            if band(s.orbit + 16,63) < 32 then first,second = second,first end
            local left,right = free(shots,first,first + capacity),free(shots,second,second + capacity)
            if not left or not right then return end
            shots[left] = New(Shot,p,left,level[1],opts[1],s.supportFlash)
            s.supportFlash = (s.supportFlash + 1) % 3 + 1
            shots[right] = New(Shot,p,right,level[1],opts[2],s.supportFlash)
        else
            local last = 2 + 2 * capacity
            local left = free(shots,1,last)
            local right = left and free(shots,left + 1,last)
            if not right then return end
            fire(right,1,s.supportFlash)
            fire(left,2,s.supportFlash)
        end
        s.supportFlash = (s.supportFlash + 1) % 3 + 1
    end

    -- 0x14b778 的计数器属于副机，两个炮口申请原程序给各人形划定的机弹槽。
    function M.support(p,s)
        local start = s.held and not s.supportHeld
        s.supportHeld = s.held
        if s.merged then s.supportBurst = 0; return end
        local weapon = p.hyperPower and program.pilotHyperOptionWeapons[p.model][p.doll] or p.optionWeapon
        local level = weapon.levels[p.shotLevel]
        local gap = p.shotLevel == 5 and 2 or weapon.delay
        if start then
            s.supportBurst = weapon.burst + (p.hyperPower and 4 or p.shotLevel - 1)
            s.supportClock = gap
            optionBurst(p,s,level)
        elseif s.supportBurst > 0 then
            s.supportClock = s.supportClock - 1
            if s.supportClock == 0 then
                s.supportBurst,s.supportClock = s.supportBurst - 1,gap
                optionBurst(p,s,level)
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
