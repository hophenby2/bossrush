-- 0x168576、0x168b6e、0x168e70、0x1690ec、0x1695b4 共用坦克判定和炮口表。
return function(program, path, bullets, effects, remove, hyper)
    local bit = require('bit')
    local band, bor = bit.band, bit.bor
    local s16, world = program.s16, program.world
    local M = {parts=1}

    local function target(o)
        local pilot = o.run.player
        if pilot and pilot.active ~= false then
            return program.angle(o.h, o.l, pilot.h, pilot.l, o.aim)
        end
    end

    function M.init(o)
        local run = o.run
        if run.disableTank or run.difficulty == 1 and run.mid1 and not run.mid1.released then return false end
        -- 0x168b3c 与 0x168b52 分别是敌机状态和主部件初值。
        o.flags, o.hp, o.speed = 0xa201, 0x20, 0x1d
        o.front, o.back, o.right, o.left = 0x780, 0x400, 0x480, 0x480
        o.variant = band(o.kind, 0x1f)
        o.brakes = o.variant ~= 5
        o.attackClock = o.variant == 7 and run.difficulty == 2 and 0x0a or band(0x28 - program.rank(run,0x1e,'tankRank'), 0xff)
        o.throttleClock, o.throttleInterval = 1, 2
        if o.variant == 0xb then
            o.speed, o.throttleClock, o.throttleInterval = 0x24, 0, 1
            o.rapidShots, o.approachClock = 4, 0x20
        end
        if not o.brakes then o.state[0x28], o.state[0x29] = 0, 0x32 end
        if not path.attach(o) then return false end
        if band(o.kind, 0x20) ~= 0 then
            local pilotL = run.player and band(run.player.l, 0xffff) or 0
            if (pilotL < 0x1c00) == (band(o.l + 0x800, 0xffff) < 0x2400) then
                o.l = s16(0x3800 - o.l)
            end
        end
        if o.brakes then
            o.exitAngle = o.variant == 8 and (o.state[0x22] or 0) or band(o.direction + 0x20, 0x3c)
            o.aim = target(o) or 0x20
        else
            o.steerClock, o.steerInterval = 2, 2
        end
        return true
    end

    local function inView(o)
        return band(o.l + o.run.cameraOffset + 0x1c00, 0xffff) < 0x7000
            and band(o.h + 0x800, 0xffff) < 0x8000
    end

    local function emit(o, aim, muzzle, modifier)
        local run = o.run
        if not program.inAimBounds(run, o.h, o.l) then return end
        if not aim then return end
        local offset = program.muzzles[7][band(muzzle + 1, 0x3e) / 2 + 1]
        local h, l = program.addPacked(o.h, o.l, offset[1], offset[2])
        bullets.emit(run, 0x0d, modifier, aim, h, l)
    end

    local function fire(o)
        o.attackClock = o.attackClock - 1
        if o.variant == 9 then
            if o.attackClock ~= 0 then o.attackClock = band(o.attackClock, 0xff); return end
        elseif o.attackClock >= 0 then
            return
        end
        o.attackClock = band(0x5a - program.rank(o.run,0x18,'largeRank'), 0xff)
        local aim = target(o)
        if aim then emit(o, aim, o.brakes and aim or o.direction, o.variant == 9 and 0 or 3) end
    end

    local function steer(o)
        local remaining = (o.state[0x28] or 0) * 0x100 + (o.state[0x29] or 0)
        if remaining ~= 0 then
            o.steerClock = o.steerClock - 1
            if o.steerClock < 0 then
                o.steerClock = o.steerInterval
                remaining = remaining - 1
                o.state[0x28], o.state[0x29] = math.floor(remaining / 0x100), band(remaining, 0xff)
                local angle = target(o)
                if not angle then return end
                local difference = band(angle - o.direction, 0x3f)
                if difference ~= 0 then o.direction = band(o.direction + (difference < 0x20 and 1 or -1), 0x3f) end
            end
        end
        fire(o)
    end

    local function advanceThrottle(o)
        o.throttleClock = o.throttleClock - 1
        if o.throttleClock >= 0 then return false end
        o.throttleClock = o.throttleInterval
        return true
    end

    local function exit(o)
        if o.speed ~= 0x1c and advanceThrottle(o) then o.speed = o.speed + 1 end
        if o.exitAligned then return end
        o.steerClock = o.steerClock - 1
        if o.steerClock < 0 then
            o.steerClock = 4
            o.direction = band(o.direction + o.steerDelta, 0x3c)
            o.exitAligned = o.direction == o.exitAngle
        end
    end

    local function track(o)
        if o.run.aimPhase ~= 0 then return end
        local angle = target(o)
        if angle then
            local difference = band(angle - o.aim, 0x3f)
            if difference ~= 0 then o.aim = band(o.aim + (difference < 0x20 and 1 or -1), 0x3f) end
        end
    end

    local function stop(o, interval, clock)
        o.throttleClock, o.throttleInterval, o.attackClock = 0, interval, clock
        o.direction, o.steerClock = band(o.aim, 0x3c), 0x30
        o.steerDelta = o.direction == o.exitAngle and 0 or (o.direction < o.exitAngle and -4 or 4)
        o.departing = true
    end

    local function approach(o)
        if o.speed ~= 0 and advanceThrottle(o) then
            o.speed = o.speed - 1
            if o.speed == 0 then
                stop(o, o.variant == 7 and 3 or 2, 0x10)
                if o.variant == 8 then o.steerDelta = 0 end
            end
        end
        -- 0x168c68 只在全局四帧计数归零时更新炮口瞄准方向。
        track(o)
        fire(o)
    end

    local function passAndLeave(o)
        fire(o)
        if not o.departing then
            if advanceThrottle(o) then
                o.speed = o.speed - 1
                if o.speed == 0 then stop(o, 2, o.attackClock) end
            end
        elseif o.steerClock > 0 then
            o.steerClock = o.steerClock - 1
        elseif o.speed ~= 0x20 and advanceThrottle(o) then
            o.speed = o.speed + 2
        end
        track(o)
    end

    local function fireWhileStopped(o)
        if not o.departing then
            o.approachClock = o.approachClock - 1
            if o.approachClock == 0 then
                o.approachClock = 0x50
                emit(o, target(o), o.aim, 0)
            end
            if advanceThrottle(o) then
                o.speed = o.speed - 1
                if o.speed == 0 then stop(o, 2, 1) end
            end
            track(o)
        elseif o.rapidShots ~= 0 then
            o.attackClock = o.attackClock - 1
            if o.attackClock == 0 then
                o.attackClock, o.rapidShots = 4, o.rapidShots - 1
                emit(o, o.aim, o.aim, 0)
            end
        else
            exit(o)
        end
    end

    function M.step(o)
        local flags = band(o.flags,0x5c00)
        o.flash = flags ~= 0
        if o.flash then
            o.flags = band(o.flags, 0xa3ff)
            hyper.hit(o,flags)
            if o.hp < 0 then
                hyper.kill(o.run,flags,8)
                -- 0x1685aa 与 0x168ba2 以坦克当时的速度和方向登记爆炸槽。
                effects.emit(o, {{2,0,0,0,o.speed + 8,o.direction * 4}})
                remove(o)
                return
            end
        end
        if inView(o) then o.entered = true
        elseif o.entered then remove(o); return end
        if not o.run.freeze then
            path.move(o)
            if not o.brakes then steer(o)
            elseif o.variant == 9 then passAndLeave(o)
            elseif o.variant == 0xb then fireWhileStopped(o)
            elseif o.departing then exit(o)
            else approach(o) end
        end
        o.x, o.y = world(o.h, o.l)
    end

    function M.render(o)
        if not o.run.art then return end
        local poses = program.tank[o.flash and 2 or 1]
        local image = o.run.art[poses[band(o.direction, 0x3e) / 2 + 1]]
        local x, y = world(o.h - 0x600, o.l - 0x500)
        Render(image[1], math.floor(x) + image[2] / 2, math.floor(y) + image[3] / 2)
    end

    function M.damage(o, amount, attackFlags)
        o.hp = s16(o.hp - amount)
        o.flags = bor(o.flags, attackFlags)
    end

    return M
end
