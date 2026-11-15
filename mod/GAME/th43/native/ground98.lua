-- 五面 0xecde0 / 0xed00c。装甲、五处判定和内外炮组共用同一条移动指令流。
return function(program, path, bullets, effects, remove, score)
    local band = require('bit').band
    local min = math.min
    local s16, word = program.s16, program.word
    local data = program.ground98
    local M = {}

    local function tick(state, index)
        local timer = state[index]
        state[index] = (timer - 1) % 256
        return timer == 0
    end

    local function place(o)
        for _, part in ipairs(o.attachments) do
            part.h, part.l = o.h, o.l
            part.x, part.y = program.world(part.h, part.l)
        end
    end

    function M.init(o)
        o.hullFrame, o.sideFrame, o.colorFrame = 0, 0, 1
        o.lift = 0
        o.liftClock, o.liftReload = data.second[3]:byte(25, 26)
        o.armor, o.vehicleHp = word(o.state, 0x30), word(o.state, 0x36)
        o.state[0x33] = 4
        for _, part in ipairs(o.attachments) do
            part.front, part.back = s16(part.front), s16(part.back)
            part.right, part.left = s16(part.right), s16(part.left)
        end
        place(o)
    end

    local sideBreakup = {
        {0,0x85,0x10,0,0xc00,0,0}, {4,0x84,0x10,-0x400,0x1000,0,0},
        {0,0x85,0x10,0,-0xa00,0,0}, {4,0x84,0x10,-0x400,-0xe00,0,0},
    }

    local function damage(o)
        local hit = band(o.flags, 0x5800) ~= 0
        local lowest = o.hp
        for _, part in ipairs(o.attachments) do
            hit = hit or band(part.flags, 0x5800) ~= 0
            lowest = min(lowest, part.hp)
        end
        if not hit then
            o.colorFrame = o.vehicleHp >= 0 and o.vehicleHp < 0x500 and band(o.run.frame, 0x0e) == 0 and 3 or 1
            return false
        end
        o.flags = band(o.flags, 0xa7ff)
        for _, part in ipairs(o.attachments) do part.flags = band(part.flags, 0xa7ff) end
        o.colorFrame = o.colorFrame == 2 and 1 or 2

        if band(o.part[0x1e], 0x80) ~= 0 or o.lift ~= 0 then
            o.vehicleHp = 0x7fff
        elseif o.armor > 0 then
            o.armor = o.armor - 1
            if o.armor == 0 then
                -- 0xed0e6 越过五处伤害暂存的清理，留到下一次有效命中一起结算。
                o.vehicleHp = word(o.state, 0x36)
                return false
            end
            o.vehicleHp = 0x7fff
        else
            o.vehicleHp = o.vehicleHp - band(0x7fff - lowest, 0xffff)
        end
        o.hp = 0x7fff
        for _, part in ipairs(o.attachments) do part.hp = 0x7fff end

        if not o.attachments[1].broken and o.vehicleHp < 0x800 then
            local hit = score.source(o,o.attachments)
            score.kill(hit,0x1e0,-0x400,0xc00,o)
            score.kill(hit,0x1e0,-0x401,-0xa00,o)
            o.attachments[1].broken, o.attachments[2].broken = true, true
            effects.spawn(o.run, o.h, o.l, sideBreakup, false, true)
            if o.state[0x18] >= 4 then o.state[0x18] = 0 end
            if o.run.onBreakPart then
                o.run.onBreakPart(o.attachments[1])
                o.run.onBreakPart(o.attachments[2])
            end
            return false
        end
        return o.vehicleHp < 0
    end

    local function lift(o, protected)
        local target = 0
        if protected and o.direction < 0x40 then
            target = o.direction < 0x20 and 0x14 or -0x14
        elseif o.lift == 0 then
            return
        end
        if o.liftClock > 0 then
            o.liftClock = o.liftClock - 1
            return
        end
        o.liftClock = o.liftReload
        if o.lift ~= target then o.lift = o.lift + (o.lift < target and 4 or -4) end
    end

    local function centerVolley(o)
        local run = o.run
        if not run.pilotH then return end
        local aim = program.aimByte(s16(o.h + 0x180), o.l, run.pilotH, run.pilotL, 0x80, true)
        for i = -2, 2 do
            local angle = aim + i * 7
            local packed = data.radial[band(angle + 2, 0xfc) / 4 + 1]
            local h, l = program.unpack(packed + 0x01800000)
            bullets.emitAngle(run, 7, 4, angle, s16(o.h + h), s16(o.l + l))
        end
    end

    local function sideVolley(o, muzzles, step)
        local run = o.run
        for i, muzzle in ipairs(muzzles) do
            local h, l = s16(o.h + muzzle[1]), s16(o.l + muzzle[2])
            if i <= 2 then
                local aim = program.aimByte(h, l, run.pilotH, run.pilotL, 0x80, true)
                bullets.emitFasterInLoop(run, 0xc, 5, aim, h, l)
            else
                bullets.emitFasterInLoop(run, 0x16, 6, 0x80 + (i - 4) * step, h, l)
            end
        end
    end

    local function center(o)
        local state = o.state
        local phase = state[0x18]
        if phase == 0 then
            if tick(state, 0x1c) then state[0x1c], state[0x18] = 4, 1 end
        elseif phase == 1 then
            if tick(state, 0x22) then
                state[0x22], o.hullFrame = state[0x23], o.hullFrame + 1
                if o.hullFrame == 7 then state[0x18] = 2 end
            end
        elseif phase == 2 then
            if tick(state, 0x1c) then
                state[0x1c] = state[0x32]
                centerVolley(o)
                if tick(state, 0x1e) then state[0x1c], state[0x1e], state[0x18] = 4, state[0x1f], 3 end
            end
        elseif phase == 3 then
            if state[0x1c] ~= 0 then
                state[0x1c] = state[0x1c] - 1
            elseif tick(state, 0x22) then
                state[0x22], o.hullFrame = state[0x23], o.hullFrame - 1
                if o.hullFrame == 0 then
                    local _, _, rank = program.groundRank(o.run)
                    state[0x1c] = 0x38 - rank
                    state[0x18] = o.attachments[1].broken and o.attachments[2].broken and 0 or 4
                end
            end
        end
    end

    local function sides(o)
        local state = o.state
        local phase = state[0x18]
        if phase == 4 then
            if tick(state, 0x26) then state[0x26], state[0x18] = 4, 5 end
        elseif phase == 5 then
            if tick(state, 0x2c) then
                state[0x2c], o.sideFrame = state[0x2d], o.sideFrame + 1
                if o.sideFrame == 7 then state[0x18] = 6 end
            end
        elseif phase == 6 then
            if tick(state, 0x26) then
                state[0x26] = state[0x33]
                if o.run.pilotH then
                    sideVolley(o, data.leftFire, -16)
                    sideVolley(o, data.rightFire, 16)
                end
                if tick(state, 0x28) then state[0x26], state[0x28], state[0x18] = 4, state[0x29], 7 end
            end
        elseif phase == 7 then
            if state[0x26] ~= 0 then
                state[0x26] = state[0x26] - 1
            elseif tick(state, 0x2c) then
                state[0x2c], o.sideFrame = state[0x2d], o.sideFrame - 1
                if o.sideFrame == 0 then
                    local _, _, rank = program.groundRank(o.run)
                    state[0x26], state[0x18] = 0x38 - rank, 0
                end
            end
        end
    end

    function M.step(o)
        local run = o.run
        if not path.step(o) then remove(o); return end
        local visible = band(o.h + 0x1000, 0xffff) < 0x9000
            and band(o.l + 0x1800 + run.cameraOffset, 0xffff) < 0x6800
        if o.entered and not visible then remove(o); return end
        o.entered = o.entered or visible
        place(o)
        if damage(o) then
            score.kill(score.source(o,o.attachments),0x500,-0xc00,nil,o)
            effects.spawn(run, o.h, o.l, data.breakup, false, true)
            if run.onEnemyDeath then run.onEnemyDeath(o) end
            remove(o)
            return
        end

        local protected = band(o.part[0x1e], 0x80) ~= 0
        if protected or o.lift ~= 0 then
            lift(o, protected)
        elseif not run.freeze and not run.bulletHold and o.entered and o.h >= 0x1000 then
            -- 0xed2fa 在中央炮关闭的当帧进入外侧炮计时。
            center(o)
            sides(o)
        end
    end

    function M.render(o, renderSprite)
        local art, color = data.art, o.colorFrame
        local pulse = o.run.frame % 2 == 1
        local light = art.lights[math.floor((o.run.frame + 1) / 2) % 2 + 1]
        if o.lift == 0 then
            if pulse then
                renderSprite(o, light[1], 0x3c0, 0x240)
                renderSprite(o, light[2], 0x3c0, -0x640)
            end
            local i = o.sideFrame + 1
            renderSprite(o, art.hull[color][o.hullFrame + 1], -0x1000, -0x200)
            renderSprite(o, o.attachments[1].broken and art.wreckLeft[color] or art.left[color][i], -0xe40, 0x600)
            renderSprite(o, o.attachments[2].broken and art.wreckRight[color] or art.right[color][i], -0x1000, -0x1200)
        else
            local i = o.lift / 4 + 6
            if pulse then
                local offset = data.raisedLights[i]
                local h1, l1 = program.add(o.h, o.l, offset[1], offset[2])
                local h2, l2 = program.add(o.h, o.l, offset[3], offset[4])
                h1, l1 = program.add(h1, l1, -0x200, -0x200)
                h2, l2 = program.add(h2, l2, -0x200, -0x200)
                renderSprite(o, light[1], s16(h1 - o.h), s16(l1 - o.l))
                renderSprite(o, light[2], s16(h2 - o.h), s16(l2 - o.l))
            end
            local h, l = program.add(o.h, o.l, -0x1200, -0x1200)
            renderSprite(o, art.lifted[color][i], s16(h - o.h), s16(l - o.l))
        end
        if pulse and o.run.route.loop == 0 then renderSprite(o, art.marker, -0x2800, -0x100) end
    end

    return M
end
