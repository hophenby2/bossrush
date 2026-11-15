-- 0xe3e52。载具的两个命中框、主炮卷射、外舱发射和坠毁分开推进。
return function(program, path, bullets, effects, remove, score)
    local bit = require('bit')
    local band, bor = bit.band, bit.bor
    local floor, max = math.floor, math.max
    local s16, word, add = program.s16, program.word, program.add
    local data = program.ground59
    local M = {}

    local function tick(state, index)
        local timer = state[index]
        state[index] = (timer - 1) % 256
        return timer == 0
    end

    local function setWord(state, index, value)
        state[index], state[index + 1] = floor(value / 256), value % 256
    end

    local function place(o)
        local side = o.attachments[1]
        side.h, side.l = o.h, o.l
        side.x, side.y = program.world(side.h, side.l)
    end

    local function earlyFour(run)
        return run.stageNumber == 4 and run.major >= 0x160
    end

    local function aim(o, h, l, state, seek)
        local run = o.run
        if not run.pilotH then return false end
        local angle = program.angle(h, l, run.pilotH, run.pilotL, state[0x1a])
        if seek then angle = program.turnToward(state[0x1a], angle) end
        state[0x1a] = angle
        return true
    end

    function M.init(o)
        local run, state = o.run, o.state
        o.vehicleHp, o.breakAt, o.colorFrame = word(state, 0x20), word(state, 0x3c), 1
        run.capacity = 150
        local flag = o.part[0x1e]
        if flag ~= 0 then
            run.ground59Locks = run.ground59Locks or {}
            run.ground59Locks[flag] = o
            o.ground59Flag = flag
            if run.stageNumber == 5 then state[0x3e] = 0x50 end
        end
        if earlyFour(run) then o.vehicleHp, o.breakAt, state[0x35] = 0x9a00, 0x5800, 0x44 end
        local rank = floor(program.rank(run) / 16)
        state[0x29], state[0x35] = band(state[0x29] - rank, 0xff), band(state[0x35] - rank, 0xff)
        aim(o, s16(o.h - 0x1100), o.l, state)
        place(o)
    end

    local function damage(o)
        local run, side = o.run, o.attachments[1]
        if band(bor(o.flags, side.flags), 0x5800) == 0 then
            o.colorFrame = o.vehicleHp < 0x20aa and band(run.frame, 0x0e) == 0 and 3 or 1
            return
        end
        o.flags, side.flags = band(o.flags, 0xa7ff), band(side.flags, 0xa7ff)
        o.colorFrame = o.colorFrame == 2 and 1 or 2
        local damage = max(band(0x7fff - o.hp, 0xffff), band(0x7fff - side.hp, 0xffff))
        o.vehicleHp, o.hp, side.hp = o.vehicleHp - damage, 0x7fff, 0x7fff
        local hit = score.source(o,o.attachments)
        if not o.weakened and o.vehicleHp <= o.breakAt then
            score.kill(hit,0x2da,nil,nil,o)
            o.weakened = true
            effects.spawn(run, o.h, o.l, data.breakup, true, true)
            if run.onBreakPart then run.onBreakPart(o) end
        end
        if o.vehicleHp < 0 then
            score.kill(hit,0x46a,nil,nil,o)
            o.flags, side.flags, o.crashing, o.colorFrame = 0x8000, 0x8000, true, 1
            effects.spawn(run, o.h, o.l, run.stageNumber == 5 and data.death5 or data.death4, true, true)
            bullets.clearFor(run, 0x200)
        end
    end

    local function retire(o)
        if o.run.stageNumber == 5 then o.run.capacity = 110 end
        remove(o)
    end

    local function crash(o)
        local run, state = o.run, o.state
        o.h = s16(o.h - 0x20)
        place(o)
        -- 0xe3ac8 的音效分支和发射器共用 ROM 随机字节。
        if band(run.frame, 3) == 0 then run.randomByte = (run.randomByte + 1) % 256 end
        state[0x3e] = state[0x3e] - 1
        if state[0x3e] ~= 0 then return end
        effects.spawn(run, o.h, o.l, data.wreck, true, true)
        bullets.clearFor(run, run.stageNumber == 5 and 0x40 or earlyFour(run) and 0x10 or 0x20)
        if run.onEnemyDeath then run.onEnemyDeath(o) end
        retire(o)
    end

    local function gunPosition(o, packed)
        local h, l = program.unpack(packed)
        return s16(o.h + h), s16(o.l + l)
    end

    local function mainGuns(o, canFire)
        local run, state = o.run, o.state
        if o.weakened then state[0x23] = 0; return end
        if state[0x23] == 0 and aim(o, s16(o.h - 0x1100), o.l, state, true)
            and canFire and tick(state, 0x28) then
            state[0x28], state[0x23], state[0x33], state[0x34] = state[0x29], 1, 1, 0
            setWord(state, 0x2c, 0)
        end
        local fifth, direction = run.stageNumber == 5, state[0x1a]
        local i = band(direction, 0x3e) / 2 + 1
        if band(state[0x23], 1) ~= 0 and tick(state, 0x2a) then
            local speed = word(state, 0x2c)
            state[0x2a] = state[0x2b]
            if canFire then
                local ah, al = gunPosition(o, data.muzzleA[i] + 0xef000000)
                bullets.emitDirect(run, 4, speed, direction, ah, al)
                if fifth then bullets.emitFasterInLoop(run, 4, speed, (direction - 1)*4, ah, s16(al + 0x200)) end
                local bh, bl = gunPosition(o, data.muzzleB[i] + 0xef000000)
                bullets.emitDirect(run, 4, speed, direction, bh, bl)
                if fifth then bullets.emitFasterInLoop(run, 4, speed, (direction + 1)*4, bh, s16(bl - 0x200)) end
            end
            if speed < 0x10 then
                speed = speed + 2
                setWord(state, 0x2c, speed)
                if speed == 0x10 then
                    state[0x23], state[0x32], state[0x30] = 3, 0, state[0x31]
                    if state[0x31] < 0x10 then state[0x31] = state[0x31] + 4 end
                end
            end
        end
        if band(state[0x23], 2) ~= 0 and tick(state, 0x2e) then
            state[0x2e] = state[0x2f]
            local spread, angle = state[0x32], direction * 4
            if canFire then
                local ah, al = gunPosition(o, data.spreadA[i] + 0xef000000)
                bullets.emitShortPair(run, 4, -2, (angle - spread)/4, ah, al)
                if fifth then bullets.emitFasterInLoop(run, 4, 2, angle + spread, ah, s16(al + 0x200)) end
                local bh, bl = gunPosition(o, data.spreadB[i] + 0xef000000)
                bullets.emitShortPair(run, 4, fifth and 2 or -2, (angle + spread)/4, bh, bl)
                if fifth then bullets.emitFasterInLoop(run, 4, 6, angle - spread, bh, s16(bl - 0x200)) end
            end
            state[0x32], state[0x30] = (spread + 6) % 256, state[0x30] - 1
            if state[0x30] == 0 then state[0x23] = 0 end
        end
    end

    local function fourthSideVolley(o, kind, start, step, offset)
        local run = o.run
        if o.weakened then start = start + program.random(run, program.effectRandom) end
        local h, l = gunPosition(o, offset)
        for i = 0, earlyFour(run) and 4 or 3 do
            bullets.emitLongPair(run, kind, 3 - 3*i, start + step*i, h, l)
        end
    end

    local function fifthSideVolley(o, kind, start, step, offset, mirror)
        for i = 0, o.weakened and 4 or 5 do
            local angle = start + step*i
            local a, b = data.radial[band(angle + 2, 0xfc) / 4 + 1], data.radial[band(-angle + 2, 0xfc) / 4 + 1]
            local ah, al = gunPosition(o, a + offset)
            local bh, bl = gunPosition(o, b + offset)
            bullets.emitWidePair(o.run, kind, 4 - 2*i, angle, ah, al)
            bullets.emitWidePair(o.run, kind, 4 - 2*i, -angle, bh, s16(bl + mirror))
        end
    end

    local function sideGuns(o, canFire)
        local run, state = o.run, o.state
        if not o.weakened and state[0x33] == 0 then return end
        if not tick(state, 0x34) then return end
        state[0x34], state[0x33] = state[0x35], 0
        if not canFire then return end
        if run.stageNumber == 5 then
            fifthSideVolley(o, 7, 0x80, 4, 0xfffff8c0, 0x400)
            fifthSideVolley(o, 8, 0x90, 6, 0xfffff7c0, 0)
            fifthSideVolley(o, 7, 0x80, -4, 0x740, -0x400)
            fifthSideVolley(o, 8, 0x70, -6, 0x840, 0)
        else
            fourthSideVolley(o, 7, 0x80, 4, 0xf7fff8c0)
            fourthSideVolley(o, 8, 0x90, 6, 0xf7fff7c0)
            fourthSideVolley(o, 7, 0x80, -4, 0xf8000740)
            fourthSideVolley(o, 8, 0x70, -6, 0xf8000840)
        end
    end

    local function coverGuns(o, canFire)
        local run, state = o.run, o.state
        if state[0x22] == 0 and o.weakened and canFire and tick(state, 0x26) then
            state[0x26] = state[0x27]
            state[0x25] = state[0x25] + 4
            if state[0x25] == 0x1c then state[0x22] = 1 end
        end
        if state[0x22] ~= 1 or not tick(state, 0x36) then return end
        state[0x36] = state[0x37]
        if not canFire or not run.pilotH then return end
        local angle = program.angle(o.h, o.l, run.pilotH, run.pilotL, 0x20)
        local function position(a)
            return gunPosition(o, data.radial[band(a, 0x3f)+1] + 0x08000000)
        end
        if run.stageNumber == 5 then
            for a = angle - 10, angle + 10, 2 do
                local h, l = position(a)
                bullets.emitFasterInLoop(run, 3, 1, a*4, h, l)
            end
            for a = angle - 9, angle + 9, 2 do
                local h, l = position(a)
                for speed = -6, 0, 3 do bullets.emitLongPair(run, 2, speed, a*4, h, l) end
            end
        else
            local count = word(state, 0x38)
            for a = angle - count + 1, angle + count - 1, 2 do
                local h, l = position(a)
                bullets.emitFasterInLoop(run, 3, 0, a*4, h, l)
            end
        end
        local count = word(state, 0x38)
        if count ~= 8 then setWord(state, 0x38, count + 1) end
    end

    function M.step(o)
        local run, state = o.run, o.state
        if o.crashing then crash(o); return end
        damage(o)
        if run.freeze then return end
        if not path.step(o) then retire(o); return end
        place(o)
        local visible = band(o.h + 0x1400, 0xffff) < 0x8c00
            and band(o.l + 0x1600 + run.cameraOffset, 0xffff) < 0x6400
        if o.entered and not visible then retire(o); return end
        o.entered = o.entered or visible
        local fifth = run.stageNumber == 5
        local canFire = not run.bulletHold and band(o.h - (fifth and 0x2c00 or 0x2e00), 0xffff) < (fifth and 0x4400 or 0x4000)
        mainGuns(o, canFire)
        sideGuns(o, canFire)
        coverGuns(o, canFire)
        if run.frame % 2 == 0 then state[0x1d] = 4 - state[0x1d] end
    end

    function M.render(o, renderSprite)
        local art, color, state = data.art[o.run.stageNumber], o.colorFrame, o.state
        local function draw(sprite, h, l)
            local dh, dl = add(o.h, o.l, h, l)
            renderSprite(o, sprite, s16(dh - o.h), s16(dl - o.l))
        end
        draw(art.hull[color][1], -0x1a00, -0xa00)
        draw(art.left[color][1], -0xb40, -0x1200)
        draw(art.right[color][1], -0xb3f, 0xa00)
        draw(art.cover[color][state[0x25] / 4 + 1], 0, -0x500)
        if o.run.frame % 2 == 0 then
            local exhaust = art.exhaust[state[0x1d] / 4 + 1]
            draw(exhaust[1], -0xd40, 0xb40)
            draw(exhaust[2], -0xd40, -0x1540)
        end
        if not o.weakened then draw(art.gun[color][band(state[0x1a], 0x3e) / 2 + 1], -0x1b00, -0x800) end
    end

    return M
end
