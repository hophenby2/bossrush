-- 0xdb3c2 与 0xdbe1c 共用车体损伤、履带和炮位时钟，炮口偏移随车体变化。
return function(program, path, bullets, effects, remove, score)
    local band = require('bit').band
    local word, s16, add = program.word, program.s16, program.add
    local data = program.largeVehicle
    local M = {}

    local offsets = {
        [0x2f] = {{0xa00,0}, {0x3bf,-0x940}, {0x3c0,0x8c0}},
        [0x40] = {{0x900,0x640}, {0x8bf,-0x7c0}, {-0x40,0x4c0}},
    }

    local function tick(state, index)
        local timer = state[index]
        state[index] = (timer - 1) % 256
        return timer == 0
    end

    local function earlyFour(run)
        return run.stageNumber == 4 and run.major >= 0x160
    end

    function M.init(o)
        local run = o.run
        o.vehicleHp, o.hullFrame, o.trackFrame, o.colorFrame = word(o.state, 0x3a), 0, 0, 1
        run.largeVehicleLock = o
        if o.kind == 0x2f then
            run.capacity = 110
            if earlyFour(run) then o.state[0x3d] = 9 end
        end
    end

    local function damage(o)
        local run = o.run
        if band(o.flags, 0x5800) == 0 then
            o.colorFrame = o.vehicleHp >= 0 and o.vehicleHp < 0x8aa and band(run.frame, 0x0e) == 0 and 3 or 1
            return true
        end
        o.flags = band(o.flags, 0xa7ff)
        o.colorFrame = o.colorFrame == 2 and 1 or 2
        o.vehicleHp, o.hp = o.vehicleHp - band(0x7fff - o.hp, 0xffff), 0x7fff
        if not o.weakened then
            if o.vehicleHp <= 0x3400 then
                score.kill(o,0x276,0x600)
                o.weakened = true
                effects.spawn(run, o.h, o.l, data[o.kind].breakup, true, true)
                if run.onBreakPart then run.onBreakPart(o) end
            end
        elseif o.vehicleHp < 0 then
            score.kill(o,0x60e)
            effects.spawn(run, o.h, o.l, data[o.kind].death, true, true)
            if run.onEnemyDeath then run.onEnemyDeath(o) end
            remove(o)
            return false
        end
        return true
    end

    local function aim(o, gun, snap)
        local run, state, muzzle = o.run, o.state, offsets[o.kind][gun]
        local counter = 0x20 + gun
        if snap then state[counter] = 0x20 end
        if not run.pilotH then return false end
        local h, l = add(o.h, o.l, muzzle[1], muzzle[2])
        local angle = program.angle(h, l, run.pilotH, run.pilotL, state[counter])
        state[counter] = snap and angle or program.turnToward(state[counter], angle)
        return true
    end

    local function center(o, canFire)
        local run, state, fifth = o.run, o.state, o.kind == 0x40
        if not canFire then return end
        if state[0x28] == 0 then
            if not aim(o, 1) or not tick(state, 0x24) then return end
            state[0x24], state[0x28], state[0x2a], state[0x2b] = state[0x25], state[0x29], 0, 0x2e
            state[0x35] = earlyFour(run) and 4 or 1
        end
        if not tick(state, 0x26) then return end
        state[0x26], state[0x28] = state[0x27], state[0x28] - 1
        local center = offsets[o.kind][1]
        local h, l = add(o.h, o.l, center[1], center[2])
        local direction = state[0x21]
        local muzzle = data.centerMuzzle[band(direction, 0x3e) / 2 + 1]
        h, l = s16(h + muzzle[1]), s16(l + muzzle[2])
        if state[0x2a] == 0 then
            state[0x2a] = 1
            local width = fifth and 8 or 4
            for a = direction - width, direction + width, 2 do
                bullets.emitLongPair(run, 3, state[0x35], a * 4, h, l)
            end
        else
            state[0x2b] = (state[0x2b] + 1) % 256
            local spread = state[0x2b]
            local speed = state[0x35] + (fifth and 2 or 0)
            local rays = fifth and 6 or 4
            for i = 0, rays - 1 do
                bullets.emitFasterInLoop(run, 2, speed, (direction + spread) * 4 - 12 + i * 8, h, l)
            end
            for i = 0, rays - 1 do
                bullets.emitFasterInLoop(run, 2, speed, (direction - spread) * 4 + 12 - i * 8, h, l)
            end
        end
    end

    local function side(o, canFire)
        local run, state = o.run, o.state
        if state[0x30] == 0 then
            aim(o, 2)
            aim(o, 3)
            if not tick(state, 0x2c) then return end
            state[0x2c], state[0x30] = state[0x2d], state[0x31]
        end
        if not tick(state, 0x2e) then return end
        state[0x2e] = state[0x2f]
        if canFire then
            local gun = state[0x32] == 0 and 3 or 2
            local base, direction = offsets[o.kind][gun], state[0x20 + gun]
            local h, l = add(o.h, o.l, base[1], base[2])
            local muzzle = data.sideMuzzle[band(direction, 0x3e) / 2 + 1]
            bullets.emitFasterInLoop(run, 0x16, word(state, 0x3c), direction * 4,
                s16(h + muzzle[1]), s16(l + muzzle[2]))
        end
        state[0x30] = state[0x30] - 1
        if state[0x30] == 0 then state[0x32] = 1 - state[0x32] end
    end

    local function damagedVolley(o, gun, speed)
        local run, state, base = o.run, o.state, offsets[o.kind][gun]
        local h, l = s16(o.h + base[1]), s16(o.l + base[2])
        local direction = state[0x20 + gun] * 4
        if o.kind == 0x40 then
            bullets.emitFasterInLoop(run, 8, speed, direction, h, l)
            for _, delta in ipairs({9,18,-9,-18}) do bullets.emitFasterInLoop(run, 7, speed, direction + delta, h, l) end
            bullets.emitFasterInLoop(run, 8, speed, direction - 27, h, l)
            bullets.emitFasterInLoop(run, 8, speed, direction + 27, h, l)
        else
            direction = direction + program.random(run, program.effectRandom)
            bullets.emitFasterInLoop(run, 8, speed, direction, h, l)
            bullets.emitFasterInLoop(run, 7, speed, direction + 7, h, l)
            bullets.emitFasterInLoop(run, 7, speed, direction - 7, h, l)
            if earlyFour(run) then
                bullets.emitFasterInLoop(run, 7, speed, direction - 14, h, l)
                bullets.emitFasterInLoop(run, 7, speed, direction + 14, h, l)
            end
        end
    end

    local function damaged(o, canFire)
        local state = o.state
        if state[0x1e] == 0 then
            if state[0x33] ~= 0 then
                state[0x33] = state[0x33] - 1
            elseif o.run.frame % 4 == 0 then
                o.hullFrame = o.hullFrame + 1
                if o.hullFrame == 7 then
                    state[0x1e], state[0x24], state[0x25] = 1, 0, 0x20
                    state[0x26], state[0x27], state[0x28], state[0x29] = 3, 3, 0, 0xd
                end
            end
        end
        if state[0x1e] ~= 1 then return end
        if state[0x28] == 0 then
            if not tick(state, 0x24) then return end
            state[0x24], state[0x28], state[0x34], state[0x35] = state[0x25], state[0x29], 0xff, 0xff
            aim(o, 2, true)
            aim(o, 3, true)
        end
        if not tick(state, 0x26) then return end
        state[0x26], state[0x28] = state[0x27], state[0x28] - 1
        local speed = s16(word(state, 0x34))
        if canFire then
            damagedVolley(o, 2, speed)
            damagedVolley(o, 3, speed)
        end
        local nextSpeed = band(speed + 3, 0xffff)
        state[0x34], state[0x35] = math.floor(nextSpeed / 256), nextSpeed % 256
    end

    function M.step(o)
        local run, state = o.run, o.state
        if not damage(o) or run.freeze then return end
        if not path.step(o) then remove(o); return end
        local visible = band(o.h + 0xc00, 0xffff) < 0x8800
            and band(o.l + 0x1600 + run.cameraOffset, 0xffff) < 0x6400
        if o.entered and not visible then remove(o); return end
        o.entered = o.entered or visible
        local minHeight = o.kind == 0x40 and 0x2c00 or 0x2e00
        local canFire = not run.bulletHold and band(o.h - minHeight, 0xffff) < (o.kind == 0x40 and 0x4400 or 0x4000)
        if o.weakened then
            damaged(o, canFire)
        else
            center(o, canFire)
            side(o, canFire)
        end
        if o.direction < 0x40 and o.speed ~= 0 and tick(state, 0x1a) then
            state[0x1a] = o.speed <= 4 and 5 or o.speed <= 8 and 1 or 0
            o.trackFrame = (o.trackFrame + 1) % 4
        end
    end

    function M.render(o, renderSprite)
        local art, color = data[o.kind], o.colorFrame
        local function draw(sprite, h, l)
            local dh, dl = add(o.h, o.l, h, l)
            renderSprite(o, sprite, s16(dh - o.h), s16(dl - o.l))
        end
        local fifth = o.kind == 0x40
        draw(art.hull[color][o.hullFrame + 1], -0x1000, fifth and -0x1100 or -0x1300)
        draw(art.track[color][o.trackFrame + 1], fifth and -0x1240 or -0x1100, fifth and -0x1100 or -0x900)
        if o.weakened then return end
        for gun, base in ipairs(offsets[o.kind]) do
            local i = band(o.state[0x20 + gun], 0x3e) / 2 + 1
            local offset = gun == 1 and 0x800 or 0x400
            local h, l = add(base[1], base[2], -offset, gun == 1 and -0x900 or -0x400)
            draw((gun == 1 and art.center or art.side)[color][i], h, l)
        end
    end

    return M
end
