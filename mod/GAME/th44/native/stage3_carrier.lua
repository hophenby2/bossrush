-- 0x16250a 的两块本体盒累加伤害。炮台击破由共同耐久阈值触发。
return function(program, path, bullets, effects, remove, hyper)
    local bit = require('bit')
    local band, bor = bit.band, bit.bor
    local s16, world = program.s16, program.world
    local abs, floor = math.abs, math.floor
    local data = program.stage3Carrier
    local M = {parts=7}
    local offsets = {{0,0},{0xa00,-0x600},{0xa00,0x600},{-0x300,0},{-0x1000,0}}

    local function place(o)
        o.x,o.y = world(o.h,o.l)
        for i, at in ipairs(offsets) do
            local part = o.extraParts[i]
            part.h,part.l = s16(o.h + at[1]),s16(o.l + at[2])
            part.x,part.y = world(part.h,part.l)
        end
    end

    function M.init(o)
        local run = o.run
        if run.major == 0x26 and run.carrierAlternateClosed or run.major == 0x1b and run.carrierSecondClosed then
            return false
        end
        o.flags,o.hp,o.health = 0xa001,0x7fff,0x3000
        o.credit = 0
        o.front,o.back,o.right,o.left = 0x1b80,-0x400,0xa00,0xa00
        local rear = o.extraParts[1]
        rear.flags,rear.hp = 0xa001,0x7fff
        rear.front,rear.back,rear.right,rear.left = 0x800,0x1d00,0x380,0x380
        for i = 2,5 do o.extraParts[i].flags,o.extraParts[i].angle=0x8000,0x3f end
        o.extraParts[6].flags = 0x8000
        o.upperClock,o.middleClock,o.rearTrack,o.rearClock,o.rearShots = 0x20,0x30,0x20,8,0
        o.bodyPause,o.bodyRate,o.bodyShots,o.bodyMode,o.bodyAim = 0x10,0,0,false,0
        if not path.attach(o) then return false end
        o.alternate = run.major == 0x1b
        run.carrierPresent = true
        if o.alternate then run.carrierAlternateClosed=true
        elseif run.major ~= 0x26 then run.carrierAlternateClosed,run.carrierSecondClosed=true,true end
        place(o)
        return true
    end

    function M.damage(part, amount, flags)
        part.hp,part.flags = s16(part.hp - amount),bor(part.flags,flags)
    end

    local function aim(part, pilot, bias)
        return program.angle(part.h + (bias or 0),part.l,pilot.h,pilot.l,part.angle or 0)
    end

    local function track(part, pilot)
        local diff = band(aim(part,pilot) - part.angle,0x3f)
        if diff ~= 0 then part.angle = band(part.angle + (diff < 0x20 and 1 or -1),0x3f) end
    end

    local function shoot(o, part, kind, speed, angle, h, l, mode)
        local run = o.run
        h,l = s16(part.h + h),s16(part.l + l)
        if mode == 'split' and run.loop ~= 0 then
            bullets.emitPrecise(run,kind,speed,angle * 4 - 8,h,l)
            bullets.emitPrecise(run,kind,speed,angle * 4 + 8,h,l)
        else
            local change = mode == 'speed' and run.loop ~= 0 and 4 or 0
            bullets.emit(run,kind,speed + change,angle,h,l)
            if mode == 'double' and run.loop ~= 0 then bullets.emit(run,kind,speed + 6,angle,h,l) end
        end
    end

    local function fireBody(o,a,kind,speed,spread,mode)
        for _, delta in ipairs(spread) do
            local angle = band(a + delta,0x3f)
            local muzzle = program.boss2.arrowMuzzles[angle + 1]
            shoot(o,o,kind,speed,angle,0x400 + muzzle[1],muzzle[2],mode)
        end
    end

    local function armed(o,points)
        hyper.kill(o.run,o.credit,points)
    end

    local function breakTurret(o,index,kind)
        local part = o.extraParts[index]
        part.broken = true
        effects.emit(part,{{kind,0,0,0,o.speed,o.direction * 4}})
    end

    local function death(o, pilot)
        local run = o.run
        armed(o,174)
        for _, row in ipairs(data.wreck) do
            effects.emit(o,{{row[2],row[1],row[4],row[5],o.speed,o.direction * 4}})
        end
        if not o.bodyFired and o.h > 0x1000 and pilot and pilot.active then
            fireBody(o,aim(o,pilot,0x400),4,4,{0,2,4,6,-2,-4,-6},'split')
        end
        run.carrierPresent,run.carrierSecondClosed = false,false
        if o.alternate then run.carrierAlternateClosed = false end
        o.flags,o.extraParts[1].flags,o.deathClock = 0x8000,0x8000,0x10
    end

    function M.step(o)
        local run = o.run
        if o.h > -0x2400 then o.entered=true
        elseif o.entered then run.carrierPresent=false; remove(o); return end
        if not path.step(o) then run.carrierPresent=false; remove(o); return end
        if run.major >= 0x7f then run.carrierPresent,run.carrierSecondClosed=false,false end
        place(o)
        local pilot = run.player
        local rear = o.extraParts[1]
        if o.deathClock then
            o.deathClock = o.deathClock - 1
            if o.deathClock == 0 then remove(o) end
            return
        end
        o.credit = band(bor(o.flags,rear.flags),0x5c00)
        if o.credit ~= 0 then
            o.flags,rear.flags = band(o.flags,0xa3ff),band(rear.flags,0xa3ff)
            hyper.hit(o,o.credit)
            o.health = o.health - band(0x7fff - o.hp,0xffff) - band(0x7fff - rear.hp,0xffff)
            o.hp,rear.hp = 0x7fff,0x7fff
            if o.health <= 0x1000 and not o.extraParts[2].broken then
                armed(o,19)
                armed(o,19)
                breakTurret(o,2,0x83); breakTurret(o,3,0x83)
            end
            if o.health <= 0x2a00 and not o.extraParts[5].broken then armed(o,17); breakTurret(o,5,0x84) end
            if o.health <= 0x2000 and not o.extraParts[4].broken then armed(o,32); breakTurret(o,4,0x84) end
            if o.health < 0 then death(o,pilot); return end
        end
        if run.freeze or not pilot or not pilot.active then return end
        local wing1,wing2,mid,tail = unpack(o.extraParts,2,5)
        track(wing1,pilot); track(wing2,pilot)
        o.upperClock = o.upperClock - 1
        if o.upperClock < 0 then
            o.upperClock = 0x20 - program.rank(run,0x20,'tankRank')
            if wing2.h > 0x1800 and not wing1.broken and run.enemyShotGrace == 0 then
                for _, part in ipairs({wing1,wing2}) do
                    local base = program.boss2.smallMuzzles[band(part.angle + 1,0x3e) / 2 + 1]
                    local speed = program.bossRandom(run)
                    for _, delta in ipairs({0,-4,-8,-12,4,8,12}) do
                        local angle = band(part.angle + delta,0x3f)
                        local at = program.boss2.arrowMuzzles[angle + 1]
                        local h,l = program.addPacked(base[1],base[2],at[1],at[2])
                        shoot(o,part,5,speed,angle,h,l,'double')
                    end
                end
            end
        end
        if not mid.broken then
            track(mid,pilot)
            o.middleClock = o.middleClock - 1
            if o.middleClock < 0 then
                o.middleClock = 0x30 - program.rank(run,0x1e,'cannonRank')
                if mid.h > 0x1800 and run.enemyShotGrace == 0 then
                    local at = data.rearMuzzles[band(mid.angle,0x3e) + 1]
                    local a = band(mid.angle + 1,0x3e)
                    for _, delta in ipairs({0,2,-2}) do
                        shoot(o,mid,4,6,a + delta,at[1],at[2],'split')
                        shoot(o,mid,4,2,a + delta,at[1],at[2],'split')
                    end
                end
            end
        end
        if not tail.broken then
            if o.rearShots == 0 then
                track(tail,pilot)
                o.rearTrack = o.rearTrack - 1
                if o.rearTrack == 0 then o.rearTrack,o.rearShots=0x20,3 end
            end
            if o.rearShots > 0 then
                o.rearClock = o.rearClock - 1
                if o.rearClock < 0 then
                    o.rearClock = 8 - floor(program.rank(run,0x20,'tankRank') / 8)
                    if tail.h > 0x1800 and run.enemyShotGrace == 0 then
                        local a = band(tail.angle + 1,0x3e)
                        for i = 1,2 do
                            local at = data.rearMuzzles[a + i]
                            shoot(o,tail,5,1,a,at[1],at[2],'speed')
                        end
                        o.rearShots = o.rearShots - 1
                    end
                end
            end
        end
        if wing1.broken and wing2.broken and mid.broken and tail.broken then
            if o.bodyShots == 0 then
                o.bodyPause = o.bodyPause - 1
                if o.bodyPause >= 0 then return end
                o.bodyPause,o.bodyShots,o.bodyAim = 0x20,3,aim(o,pilot,0x400)
            end
            o.bodyRate = o.bodyRate - 1
            if o.bodyRate < 0 then
                o.bodyRate = 0x10 - floor(program.rank(run,0x20,'tankRank') / 4)
                if o.h > 0x1800 and run.enemyShotGrace == 0 then
                    fireBody(o,o.bodyAim,4,2,o.bodyShots % 2 == 0 and {0,4,8,-4,-8} or {2,6,-2,-6},'double')
                    o.bodyFired = o.bodyFired or o.bodyShots % 2 == 0
                    o.bodyShots = o.bodyShots - 1
                end
            end
        end
    end

    function M.render(o)
        if not o.run.art then return end
        local art = o.run.art
        local tiles = data.images[o.credit ~= 0 and 31 or 16]
        local function draw(id,part,h,l)
            local image = art[id]
            local x,y = world(s16(part.h + h),s16(part.l + l))
            Render(image[1],floor(x) + image[2] / 2,floor(y) + image[3] / 2)
        end
        draw(tiles[1],o,-0x2400,-0xa00)
        for i = 2,5 do
            local part = o.extraParts[i]
            if not part.broken then draw(tiles[i <= 3 and 2 or 3][band(part.angle + 1,0x3e)/2 + 1],part,-0x600,-0x400) end
        end
    end

    return M
end
