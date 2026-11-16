-- 0x16ac58 推进机身航向、两翼炮门及机腹子机，再从历史位置写回翼部判定。
return function(program, bullets, effects, remove, hyper)
    local bit = require('bit')
    local band, bor, bxor = bit.band, bit.bor, bit.bxor
    local s16, world = program.s16, program.world
    local floor, abs = math.floor, math.abs
    local data = program.mid3
    local M, C = {parts=7}, {parts=1}

    local function damage(o, amount, flags)
        o.hp,o.flags = s16(o.hp - amount),bor(o.flags,flags)
    end
    M.damage,C.damage = damage,damage

    local function breakEffects(o, commands)
        local blasts = {}
        for i, row in ipairs(commands) do
            blasts[i] = {row[2],row[1],row[4],row[5],flip=band(row[3],0x40) ~= 0}
        end
        effects.emit(o,blasts)
    end

    function M.init(o)
        o.h,o.l,o.flags,o.hp,o.health = -0x1000,0x1c00,0x8000,0x7fff,0x7800
        o.front,o.back,o.right,o.left = 0xc00,0x700,0xb00,0xb00
        o.phase,o.phaseState,o.nextPhase,o.timeout = 0,0,0,0x708
        o.speed,o.direction,o.routeIndex = 8,0,1
        o.enterVelocity,o.hatchFrame,o.wingFrame,o.palette = 0x180,0,0,18
        o.hullDoor,o.childDoor,o.childWait = 0,0,0x60
        o.wingOpenWait,o.alternateGap = 0x80,0x1c
        o.deathClock,o.deathIndex,o.deathRounds = 8,1,2
        o.delayHistory,o.wings = {}, {o.extraParts[1],o.extraParts[2]}
        for i = 1,10 do o.delayHistory[i] = {o.h,o.l} end
        for i, part in ipairs(o.extraParts) do
            part.h,part.l,part.flags = o.h,o.l,0x8000
            if i <= 2 then
                part.hp,part.mountH,part.mountL = 0x4000,-0x1800 - (i - 1),i == 1 and 0x200 or -0x200
                part.front,part.back = 0xf00,0x1b80
                part.right,part.left = i == 1 and 0x500 or 0x200,i == 1 and 0x200 or 0x500
                part.palette,part.hatchPalette = 19,18
                part.l = part.l + (i == 1 and -0x1000 or 0x1000)
            end
        end
        local run = o.run
        run.mid3,run.mid3Children,run.mid3Backdrop = o,true,true
        return true
    end

    local function emit(o, kind, speed, angle, dh, dl)
        local h,l = s16(o.h + dh),s16(o.l + dl)
        bullets.emitPrecise(o.run,kind,speed,angle,h,l)
    end

    local function brokenWings(o)
        return (o.wings[1].broken and 1 or 0) + (o.wings[2].broken and 1 or 0)
    end

    local function breakWing(wing)
        if wing.broken then return end
        wing.broken,wing.flags = true,0x8000
        breakEffects(wing,data.wingBreak)
    end

    local function advance(o)
        o.phaseState = 0
        if o.timeout == 0 then
            o.run.mid3Children,o.phase = false,6
        elseif brokenWings(o) == 2 then
            o.phase = o.phase == 5 and 2 or 5
        else
            o.phase,o.nextPhase = o.nextPhase + 1,(o.nextPhase + 1) % 4
        end
    end

    local function move(o)
        local h,l = program.vector(o.speed,o.direction * 4)
        o.h,o.l = s16(o.h + h),s16(o.l + l)
    end

    local function follow(o)
        if o.dying then
            o.speed,o.direction = 4,0x20
            move(o)
            return
        end
        local h,l = unpack(data.route[o.routeIndex])
        o.direction = program.turn64(o.direction,program.angle(o.h,o.l,h,l,o.direction))
        move(o)
        local dh,dl = abs(s16(o.h - h)),abs(s16(o.l - l))
        dh = dh - floor(dh / 4)
        if math.max(dh,dl) + floor(math.min(dh,dl) / 2) <= 0x100 then
            o.routeIndex = o.routeIndex % #data.route + 1
        end
    end

    local function aim(o, dh, dl, precise)
        local pilot = o.run.player
        if not pilot or not pilot.active then return end
        local angle = precise and program.angle256 or program.angle
        return angle(s16(o.h + dh),s16(o.l + dl),pilot.h,pilot.l,precise and 0x80 or 0x20)
    end

    local function wingWeapons(o, alternate)
        if o.phaseState == 0 then
            local damaged = brokenWings(o) ~= 0
            o.phaseState,o.wingDoorClock = 1,0
            if alternate then
                o.fireClock = damaged and 0x10 or 0x40
                o.alternateGap = damaged and 8 or math.max(o.alternateGap - 4,0x10)
                o.volleyCount = damaged and 0x10 or 8
            else
                o.fireClock,o.frameClock = 0x10,4
                o.volleyCount = damaged and 0x20 or 6
            end
        end
        if brokenWings(o) == 2 then advance(o); return end
        follow(o)
        if o.phaseState == 1 and not alternate and o.wingOpenWait > 0 then
            o.wingOpenWait = o.wingOpenWait - 1
        elseif o.phaseState == 1 then
            o.wingDoorClock = o.wingDoorClock - 1
            if o.wingDoorClock < 0 then
                o.wingDoorClock,o.hatchFrame = 0,o.hatchFrame + 1
                if o.hatchFrame == 7 then
                    o.phaseState = 2
                    for _, wing in ipairs(o.wings) do
                        wing.aim = aim(wing,wing.mountH,wing.mountL,false) or 0x20
                    end
                end
            end
        end
        if o.phaseState == 2 then
            if not alternate then
                o.frameClock = o.frameClock - 1
                if o.frameClock < 0 then o.frameClock = 4; o.speed = math.min(o.speed + 1,8) end
            end
            o.fireClock = o.fireClock - 1
            if o.fireClock < 0 then
                o.fireClock = alternate and o.alternateGap or band(0x20 - program.rank(o.run,0x20,'groundRank'),0xff)
                for _, wing in ipairs(o.wings) do
                    if not wing.broken then
                        if alternate then
                            local a = (aim(wing,wing.mountH,wing.mountL,false) or 0x20) * 4
                            for _, offset in ipairs({-2,2}) do
                                emit(wing,3,8,a + offset,wing.mountH,wing.mountL)
                                if o.run.loop ~= 0 then emit(wing,3,14,a + offset,wing.mountH,wing.mountL) end
                            end
                        else
                            for a = wing.aim - 12,wing.aim + 12,4 do
                                local at = data.wingMuzzles[band(a,63) + 1]
                                local h,l = program.addPacked(wing.mountH,wing.mountL,at[1],at[2])
                                if o.run.loop == 0 then emit(wing,4,-4,a * 4,h,l)
                                else
                                    emit(wing,4,-4,a * 4 - 8,h,l)
                                    emit(wing,4,-4,a * 4 + 8,h,l)
                                end
                            end
                        end
                    end
                end
                o.volleyCount = o.volleyCount - 1
                if o.volleyCount == 0 then o.phaseState,o.wingDoorClock = 3,0x20 end
            end
        elseif o.phaseState == 3 then
            o.wingDoorClock = o.wingDoorClock - 1
            if o.wingDoorClock < 0 then
                o.wingDoorClock,o.hatchFrame = 0,o.hatchFrame - 1
                if o.hatchFrame == 0 then advance(o) end
            end
        end
    end

    local function releaseScroll(o)
        o.run.holdMajor = false
        o.run.mid3Children,o.run.mid3Backdrop = false,false
    end

    local function behavior(o)
        local phase = o.phase
        if phase == 0 then
            o.h = s16(o.h + o.enterVelocity)
            if o.h > 0x3c00 then
                o.enterVelocity = o.enterVelocity - 9
                if o.enterVelocity <= 0 then
                    advance(o)
                    o.flags = 0xa001
                    for _, wing in ipairs(o.wings) do wing.flags = 0xa001 end
                    local queue,run = o.run.spawnQueue,o.run
                    if #queue < 40 then
                        queue[#queue + 1] = {run.major,0,0x14,0,0,0x1642e0,0x164368}
                    end
                end
            end
        elseif phase == 1 or phase == 3 then wingWeapons(o,false)
        elseif phase == 2 or phase == 4 then wingWeapons(o,true)
        elseif phase == 5 then
            if o.phaseState == 0 then
                o.phaseState,o.fireClock,o.childDoor = 1,8,1
            end
            follow(o)
            if o.dying then return end
            o.fireClock = o.fireClock - 1
            if o.fireClock < 0 then
                o.fireClock = band(0x10 - floor(program.rank(o.run,0x20,'groundRank') / 4),0xff)
                local a = aim(o,0,0,true)
                if a then
                    for direction = a - 0x20,a + 0x20,8 do
                        local at = program.stage2Battleship.muzzles[band(direction + 2,0xfc) / 4 + 1]
                        emit(o,4,7,direction,at[1] - 0xa00,at[2])
                        if o.run.loop ~= 0 then emit(o,4,13,direction,at[1] - 0xa00,at[2]) end
                    end
                end
            end
        else
            if o.phaseState == 0 then
                o.phaseState,o.childDoor,o.speed,o.direction = 1,2,6,0
            end
            if o.phaseState == 1 then
                o.wingDoorClock = (o.wingDoorClock or 0) - 1
                if o.wingDoorClock < 0 then
                    o.hatchFrame,o.wingDoorClock = math.max(0,o.hatchFrame - 1),0
                    if o.hatchFrame == 0 then o.phaseState = 2 end
                end
            end
            if o.phaseState == 2 and o.h >= 0x6a00 then o.phaseState = 3; releaseScroll(o) end
            if o.phaseState == 3 and o.h > -0x6800 and o.h <= -0x6400 then o.departed = true end
            move(o)
        end
    end

    local function childBay(o)
        local run = o.run
        if not o.childState then o.childState,o.childClock,o.childCount = 1,0x10,5 end
        if o.timeout ~= 0 and o.childDoor == 0 and not o.dying then
            if o.childState == 1 then
                o.childWait = o.childWait - 1
                if o.childWait == 0 then o.childDoor,o.childState = 1,2 end
            elseif o.childState == 2 then
                o.childClock = o.childClock - 1
                if o.childClock < 0 then
                    o.childClock = 0x10
                    local angle = aim(o,0,0,true) or 0x80
                    local queue = run.spawnQueue
                    if #queue < 40 then
                        queue[#queue + 1] = {run.major,0,0x13,0,0,0x16bcb4,0x16bd2a,
                            h=s16(o.h - 0x800),l=o.l,angle=band(angle + program.bossRandom(run),0xff)}
                    end
                    o.childCount = o.childCount - 1
                    if o.childCount == 0 then o.childState,o.childWait = 3,0x40 end
                end
            end
        end
        if o.childState == 3 then
            o.childWait = o.childWait - 1
            if o.childWait == 0 then
                o.childDoor,o.childState,o.childWait = 2,1,0x60
                o.childCount = brokenWings(o) ~= 0 and 10 or 5
            end
        end
        if o.childDoor ~= 0 then
            if o.childDoor == 1 then o.hullDoor = math.min(7,o.hullDoor + 1)
            else o.hullDoor = math.max(0,o.hullDoor - 1) end
            if o.hullDoor == (o.childDoor == 1 and 7 or 0) then o.childDoor = 0 end
        end
    end

    local function death(o)
        if o.deathDelay then
            o.deathDelay = o.deathDelay - 1
            if o.deathDelay == 0 then
                if o.finalBlast then o.departed = true; releaseScroll(o)
                else
                    breakEffects(o,data.bodyBreak)
                    o.finalBlast,o.deathDelay = true,0x10
                end
            end
            return
        end
        o.deathClock = o.deathClock - 1
        if o.deathClock >= 0 then return end
        o.deathClock = 8
        breakEffects(o,{data.bodyFire[o.deathIndex]})
        o.deathIndex = o.deathIndex % #data.bodyFire + 1
        if o.deathIndex == 1 then
            o.deathRounds = o.deathRounds - 1
            if o.deathRounds == 0 then o.deathDelay = 0x10 end
        end
    end

    local function damageWings(o)
        for _, wing in ipairs(o.wings) do
            local flags = band(wing.flags,0x5c00)
            if flags == 0 then wing.palette,wing.hatchPalette = 19,18
            else
                wing.flags = band(wing.flags,0xa3ff)
                hyper.hit(o,flags)
                wing.palette,wing.hatchPalette = bxor(wing.palette,12),bxor(wing.hatchPalette,13)
                if o.timeout == 0 then wing.hp = 0x4000 end
                if wing.hp < 0 then hyper.kill(o.run,flags,173); breakWing(wing) end
            end
        end
    end

    function M.step(o)
        local run = o.run
        if not run.freeze then
            behavior(o)
            if not o.dying and o.timeout ~= 0 then
                if not o.forcedBreak and o.timeout <= 0x258 then
                    breakWing(o.wings[1]); breakWing(o.wings[2])
                    o.forcedBreak = true
                else
                    o.timeout = o.timeout - 1
                    if o.timeout == 0 then advance(o) end
                end
            end
            childBay(o)
            if o.dying then death(o) end
            if o.departed then run.mid3 = nil; remove(o); return end
        end
        local last = table.remove(o.delayHistory)
        last[1],last[2] = o.h,s16(o.l - run.cameraStep)
        for _, at in ipairs(o.delayHistory) do at[2] = s16(at[2] - run.cameraStep) end
        table.insert(o.delayHistory,1,last)
        local at = o.delayHistory[10]
        for i, wing in ipairs(o.wings) do
            wing.h,wing.l = at[1],s16(at[2] + (i == 1 and -0x1000 or 0x1000))
            wing.x,wing.y = world(wing.h,wing.l)
        end
        local flags = band(o.flags,0x5c00)
        if flags == 0 then o.palette = 18
        else
            o.flags,o.palette = band(o.flags,0xa3ff),bxor(o.palette,13)
            hyper.hit(o,flags)
            if o.timeout ~= 0 then o.health = o.health - band(0x7fff - o.hp,0xffff) end
            o.hp = 0x7fff
            if not o.forcedBreak and o.health <= 0x2800 then
                breakWing(o.wings[1]); breakWing(o.wings[2])
                o.forcedBreak = true
            elseif o.health < 0 and not o.dying then
                hyper.kill(run,flags,712)
                bullets.clearWithChips(run,flags)
                o.flags,o.dying,run.mid3Children = 0x8000,true,false
            end
        end
        damageWings(o)
        o.wingFrame = (o.wingFrame + 1) % 8
        o.right,o.left = unpack(data.bodyBoxes[o.hullDoor + 1])
        o.x,o.y = world(o.h,o.l)
    end

    local function draw(o, key, frame, bank, dh, dl)
        local image = o.run.art[data.images[key][bank][frame + 1]]
        local h,l = program.addPacked(o.h,o.l,dh,dl)
        local x,y = world(h,l)
        Render(image[1],floor(x) + image[2] / 2,floor(y) + image[3] / 2)
    end

    function M.render(o)
        if o.finalBlast or not o.run.art then return end
        draw(o,'hull',o.hullDoor,o.palette,-0xe00,-0xf00)
        local left,right = unpack(o.wings)
        if not left.broken then
            draw(left,'leftWing',o.wingFrame,left.palette,-0x1000,-0x700)
            draw(left,'leftHatch',o.hatchFrame,left.hatchPalette,-0x2200,-0x500)
        end
        if not right.broken then
            draw(right,'rightWing',o.wingFrame,right.palette,-0x1000,-0x700)
            draw(right,'rightHatch',o.hatchFrame,right.hatchPalette,-0x2201,-0x900)
        end
    end

    function C.init(o)
        if not o.run.mid3Children then return false end
        o.h,o.l = o.row.h,o.row.l
        o.angle = band(o.row.angle + program.bossRandom(o.run) * 2,0xff)
        o.flags,o.hp,o.speed,o.palette = 0xa001,0x400,0,10
        o.front,o.back,o.right,o.left = 0x400,0x400,0x400,0x400
        o.accelClock,o.lifeClock,o.fireClock,o.spriteClock,o.sprite = 0,6,4,1,0
        o.rotor,o.rotorClock = 0,0
        return true
    end

    function C.step(o)
        local run = o.run
        local flags = band(o.flags,0x5c00)
        if flags ~= 0 then hyper.hit(o,flags) end
        if not run.mid3Children or o.hp < 0 then
            effects.emit(o,{{2,0,0,0,o.speed,o.angle}})
            remove(o)
            return
        end
        o.flags,o.palette = band(o.flags,0xa3ff),flags == 0 and 10 or bxor(o.palette,21)
        local inside = band(o.l + run.cameraOffset + 0x1c00,0xffff) < 0x7000
            and band(o.h + 0x800,0xffff) < 0x8000
        if inside then o.entered = true
        elseif o.entered then remove(o); return end
        if not run.freeze then
            local dh,dl = program.vector(o.speed,o.angle)
            o.h,o.l = s16(o.h + dh),s16(o.l + dl)
            o.accelClock = o.accelClock - 1
            if o.accelClock < 0 then
                o.accelClock = 2
                if o.speed ~= 4 or o.lifeClock == 0 then o.speed = band(o.speed + 1,0xff) end
            end
            if o.h > 0x600 then
                if o.lifeClock > 0 and o.speed >= 4 then
                    o.fireClock = o.fireClock - 1
                    if o.fireClock < 0 then
                        o.fireClock = 8
                        local a = aim(o,0,0,true)
                        if a then
                            a = a + floor(program.bossRandom(run) / 2)
                            emit(o,0x16,0,a,0,0)
                            if run.loop ~= 0 then emit(o,0x16,6,a,0,0) end
                        end
                    end
                end
            elseif o.lifeClock > 0 then o.lifeClock = o.lifeClock - 1 end
            o.rotorClock = o.rotorClock - 1
            if o.rotorClock < 0 then o.rotorClock,o.rotor = 0,(o.rotor + 1) % 16 end
            o.spriteClock = o.spriteClock - 1
            if o.spriteClock < 0 then
                o.spriteClock = 1
                if o.sprite < 23 then
                    o.sprite = o.sprite + 1
                    o.front,o.back,o.right,o.left = o.front + 0x40,o.back + 0x40,o.right + 0x20,o.left + 0x20
                end
            end
        end
        o.x,o.y = world(o.h,o.l)
    end

    function C.render(o)
        if not o.run.art then return end
        local art = data.images.child[o.palette]
        local scale = data.childScale[o.sprite + 1] / 128
        local image = o.run.art[art[o.rotor + 1]]
        Render(image[1],o.x,o.y,0,scale,scale)
    end

    return M,C
end
