-- 0x15998a 分配单部件地炮，0x159b3a 在同一部件上推进移速、炮塔和发射。
return function(program,path,bullets,art,effects)
    local bit = require('bit')
    local band,bxor = bit.band,bit.bxor
    local floor = math.floor
    local M,stationary = {parts=1},{parts=1}

    function M.init(o)
        local run = o.run
        local stage = run.stageNumber
        if run.stageFlags[0] and (stage == 1 or stage == 2 and run.major >= 0xce or stage == 3 or stage == 4
            or stage == 5 and run.major >= 0x10f and run.major <= 0x11a) then return false end
        o.flags,o.hp,o.palette = 0xa201,0x20,0x10
        o.front,o.back,o.right,o.left = 0x500,0x400,0x480,0x480
        o.shotClock,o.speedClock,o.speedPeriod = 0x28 - run.tankStartRank,1,2
        o.tread,o.treadClock = 0,0
        if not path.attach(o,o.row) then return false end
        o.turretTarget = band(o.direction + 0x20,0x3c)
        o.aim = program.angle(o.h,o.l,run.player,o.direction)
        return true
    end

    function stationary.init(o)
        if not M.init(o) then return false end
        o.aim = o.direction
        o.stationary = true
        o.turretSteps = (o.state[0x28] or 0) * 256 + (o.state[0x29] or 0)
        o.turnClock = 2
        return true
    end

    local function tickSpeed(o,limit,increment)
        if o.speed == limit then return false end
        o.speedClock = o.speedClock - 1
        if o.speedClock >= 0 then return false end
        o.speedClock,o.speed = o.speedPeriod,o.speed + increment
        return o.speed == limit
    end

    local function fire(o)
        if (o.part[0x1e] or 0) ~= 0 then return end
        o.shotClock = o.shotClock - 1
        if o.shotClock >= 0 then return end
        local run = o.run
        o.shotClock = 0x5a - run.tankFireRank
        if not program.fireBand(o) then return end
        local angle = program.angle(o.h,o.l,run.player)
        if not angle then return end
        local dh,dl = unpack(program.tankMuzzles[floor((o.stationary and o.aim or angle) / 2) + 1])
        bullets.emit(o,0,3,angle * 4,dh,dl)
    end

    function M.step(o)
        local run = o.run
        if o.impact then
            o.impact = nil
            if o.hp < 0 then
                effects.emit(o,2,band(o.speed + 8,255),o.direction * 4,0,true)
                return false
            end
            o.palette = bxor(o.palette,0x0f)
        else o.palette = 0x10 end
        local onscreen = band(o.l + 0xe00 + run.cameraOffset,0xffff) < 0x5400
            and band(o.h + 0x600,0xffff) < 0x7c00
        if onscreen then o.seen = true elseif o.seen then return false end
        if not run.freeze then
            local dh,dl = program.vector(o.speed,o.direction * 4,run.slowVectors)
            o.h,o.l = program.s16(o.h + dh),program.s16(o.l + dl)
            if o.stationary then
                if not run.stopPathClock then
                    if o.turretSteps > 0 then
                        o.turnClock = o.turnClock - 1
                        if o.turnClock < 0 then
                            o.turnClock,o.turretSteps = 2,o.turretSteps - 1
                            o.aim = program.towards(o.aim,program.angle(o.h,o.l,run.player,o.aim))
                        end
                    end
                    fire(o)
                end
            elseif o.turning then
                if not run.stopPathClock then
                    tickSpeed(o,0x1c,1)
                    if o.direction ~= o.turretTarget then
                        o.turnClock = o.turnClock - 1
                        if o.turnClock < 0 then
                            o.turnClock = 2
                            o.direction = band(o.direction + o.turnStep,0x3c)
                        end
                    end
                end
            elseif not run.stopPathClock then
                if tickSpeed(o,0,-1) then
                    o.speedClock,o.speedPeriod = 0,3
                    o.shotClock = 0x10
                    o.direction,o.turnClock = band(o.aim,0x3c),0x30
                    o.turnStep = o.direction > o.turretTarget and 4 or -4
                end
                o.aim = program.towards(o.aim,program.angle(o.h,o.l,run.player,o.aim))
                if o.speed == 0 then o.turning = true else fire(o) end
            end
        end
        o.drawTread = o.tread
        if not run.stopPathClock then
            o.treadClock = o.treadClock - 1
            if o.treadClock < 0 then o.treadClock,o.tread = 1,(o.tread + 1) % 4 end
        end
        return true
    end

    function M.render(o)
        if not o.run.art or not o.drawTread then return end
        local direction = o.turning and o.direction or o.aim
        local bank = program.tankImages[o.palette]
        local id = bank[floor(direction / 2) * 4 + o.drawTread + 1]
        art.draw(o.run.art.sprites[id],o.h,o.l,-0x800,-0x600)
    end

    stationary.step,stationary.render = M.step,M.render
    return M,stationary
end
