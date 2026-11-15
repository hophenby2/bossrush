-- 0xf2638 / 0xf32e8。飞行壳、展开中的炮体和四个随动炮口各自保存计时。
return function(program, path, bullets, effects, items, remove, score)
    local bit = require('bit')
    local band, bor, bxor = bit.band, bit.bor, bit.bxor
    local floor, min, max = math.floor, math.min, math.max
    local s16, word = program.s16, program.word
    local data = program.hover
    local nozzleAngles = {0x48,0xb8,0x18,0xe8}
    local M = {}

    local function tick(state, index)
        local timer = state[index]
        state[index] = (timer - 1) % 256
        return timer == 0
    end

    local function move(o, narrow)
        local angle = narrow and band(o.direction, 0x3f)*4 or o.direction
        local h, l = program.vector(o.speed, angle)
        o.h, o.l = s16(o.h+h), s16(o.l+l)
    end

    local function approach(value, target)
        if value == target then return value end
        return value + (value > target and -4 or 4)
    end

    local Nozzle = Class(object, {
        init = function(p, o, seed)
            p.host, p.h, p.l = o, o.h, o.l
            p.clock, p.reload, p.anim = seed[1], seed[2], seed[4]/4
            p.radius, p.heading, p.shot = seed[5], seed[6], seed[7]
            p.bankHeading = o.kind == 0x9a and p.shot or nil
            p.group, p.layer, p.bound, p.colli = GROUP.GHOST, LAYER.ENEMY, false, false
        end,
        render = function(p)
            if not p.atlas then return end
            local id = p.atlas[p.host.gunColor][p.drawHeading][p.drawFrame]
            local image = p.host.run.art.sprites[id]
            Render(image[1], floor((p.l - 0x200)/64)-112+image[2]/2, floor((p.h - 0x400)/64)-224+image[3]/2)
        end,
    })

    local function place(o)
        local box = o.attachments[1]
        box.h, box.l = o.h, o.l
        box.x, box.y = program.world(box.h, box.l)
    end

    function M.init(o)
        local run, state = o.run, o.state
        o.phase, o.tilt, o.glowNext = 0, 0, word(state, 0x30)/4
        o.hatchFrame, o.armor, o.vehicleHp = word(state, 0x2c)/12, word(state, 0x24), word(state, 0x1a)
        o.colorFrame, o.gunColor, o.turret = 1, 1, 0x20
        o.turnDelay = word(state, o.kind == 0x9a and 0x3a or 0x3c)
        o.aimClock = o.kind == 0x9b and state[0x3a] or 0
        local rank = program.rank(run)
        local quarter = floor(rank/4) - floor(rank/8)
        state[0x26] = 3
        state[0x20] = band(state[0x20] - quarter, 0xff)
        state[0x21] = band(state[0x21] - quarter - floor(rank/16), 0xff)
        if o.kind == 0x9a then
            local random = program.random(run, program.randomParity)
            if random >= 0x80 then o.flags = bxor(o.flags, 0x40) end
            if run.minor == 0 then run.hoverGate = true end
            run.capacity = 150
        end
        o.nozzles = {}
        for i, seed in ipairs(data[o.kind].nozzles) do o.nozzles[i] = New(Nozzle, o, seed) end
        place(o)
    end

    local function death(o)
        local run = o.run
        score.kill(score.source(o,o.attachments),o.kind == 0x9a and 0x5f0 or 0x69a,-0xc00,nil,o)
        if o.kind == 0x9b and run.stageNumber == 5 and run.minor == 0 and run.hoverGate then
            items.spawn(run, 12, min(0x6c00, band(o.h, 0xffff)), max(0x800, min(0x3000, o.l)))
        end
        local angle = o.direction * 4
        effects.spawn(run, o.h, o.l, {
            {0,0x85,0x10,0,0,o.speed,angle},
            {4,0x84,0x10,-0x400,0x400,o.speed+6,angle+program.random(run,program.effectRandom)},
            {8,0x87,0x10,-0x200,-0x400,o.speed+12,angle+program.random(run,program.effectRandom)},
        }, false, true)
        if run.onEnemyDeath then run.onEnemyDeath(o) end
        remove(o)
    end

    local function damage(o)
        local box = o.attachments[1]
        if band(bor(o.flags, box.flags), 0x5800) == 0 then
            local threshold = o.kind == 0x9a and 0x580 or 0x380
            o.colorFrame = o.vehicleHp < threshold and band(o.run.frame, 0x0e) == 0 and 3 or 1
            o.gunColor = o.colorFrame
            return false
        end
        o.flags, box.flags = band(o.flags, 0xa7ff), band(box.flags, 0xa7ff)
        o.colorFrame = o.colorFrame == 2 and 1 or 2
        o.gunColor = o.gunColor == 2 and 1 or 2
        local amount = band(0x7fff - min(o.hp, box.hp), 0xffff)
        o.hp, box.hp = 0x7fff, 0x7fff
        if o.phase ~= 2 then return false end
        if o.armor > 0 then
            o.armor = o.armor - 1
            return false
        end
        o.vehicleHp = o.vehicleHp - amount
        if o.vehicleHp < 0 then death(o); return true end
        return false
    end

    local function enter(o)
        if o.run.freeze then return end
        local state = o.state
        move(o, true)
        if o.speed == 0 and o.tilt == 0 then
            local bend = o.kind == 0x9a and 8 or 12
            local direction = o.direction + (o.direction < 0x20 and -bend or bend)
            o.speed, o.phase, o.flags = 6, 1, 0xa100
            o.direction = band(direction*4+program.random(o.run,program.effectRandom),0xff)
            state[0x34], state[0x35] = 1, 1
            return
        end
        if tick(state, 0x34) then
            state[0x34], o.speed = state[0x35], band(o.speed-1,0xff)
        end
        local target = 0
        if o.direction < 0x40 and o.speed > 8 then target = o.direction < 0x20 and 0x20 or -0x20 end
        o.tilt = approach(o.tilt, target)
    end

    local function turn256(current, target)
        local delta = band(target-current,0xff)
        if delta == 0 then return current end
        return band(current + (delta < 0x80 and 1 or -1),0xff)
    end

    local function steer(o)
        local run, state, wide = o.run, o.state, o.kind == 0x9b
        move(o, true)
        if o.turnDelay == 0 then
            o.speed, o.direction = 8, 0
            return
        end
        o.turnDelay = o.turnDelay - 1
        if wide then
            if (run.minor == 0x48 and run.major >= 0x240) or (run.minor ~= 0x48 and run.major >= 0x190) then
                o.aimClock = 0
            end
        elseif run.minor == 0x48 and run.major >= 0x1d0 then
            o.turnDelay = 0
        end
        if o.turningTo then
            if o.speed > (wide and 12 or 14) and tick(state,0x34) then
                state[0x34], o.speed = state[0x35], o.speed-1
            end
            o.direction = program.turnToward(o.direction, o.turningTo)
            if o.direction == o.turningTo then o.turningTo = nil end
        elseif o.speed < (wide and 0x12 or 0x14) then
            o.speed = o.speed+1
        end

        local random = program.random(run,program.effectRandom)
        local l = s16(o.l+0x2800)
        if l < (wide and 0x2c00 or 0x3400) then
            random = random+0x10
        elseif l >= (wide and 0x5c00 or 0x5400) then
            random = random+0x30
        elseif o.h >= 0x6400 then
            random = random+0x20
        elseif o.h >= (wide and 0x5200 or 0x6000) then
            return
        end
        o.turningTo = band(random,0x3f)
    end

    local function wideAim(o)
        local run, state = o.run, o.state
        if state[0x22] ~= state[0x23] then return end
        local clock = o.aimClock
        o.aimClock = band(clock-1,0xff)
        if clock ~= 0 then return end
        o.aimClock = data[o.kind].second:byte(14)
        if not run.pilotH then return end
        local heading = program.angle(o.h,o.l,run.pilotH,run.pilotL,o.turret)
        o.turret = program.turnToward(o.turret,heading)
        local target = program.aimByte(o.h,o.l,run.pilotH,run.pilotL,o.turret*4,true)
        local facing = data.cannonAngles[o.turret+1]
        for i, p in ipairs(o.nozzles) do
            p.shot = facing[i]
            p.heading = turn256(p.heading, target + nozzleAngles[i])
        end
    end

    local function fire(o)
        local run, state, wide = o.run, o.state, o.kind == 0x9b
        if run.bulletHold or o.h < 0x1000 or not tick(state, 0x20) then return end
        state[0x20] = state[0x26]
        if wide or run.pilotH then
            local speed = wide and 14-3*state[0x22] or 20-2*state[0x22]
            local emit = wide and bullets.emitAngle or bullets.emitFasterInLoop
            emit(run, 0xa, speed, wide and o.turret*4 or 0x80, s16(o.h-0x200),o.l)
            for _, p in ipairs(o.nozzles) do emit(run,0xa,speed,p.shot*4,p.h,p.l) end
        end
        if tick(state,0x22) then
            state[0x22], state[0x20] = state[0x23], 0x38-floor(program.rank(run)/16)
            if not wide then o.flags = bxor(o.flags,0x40) end
        end
    end

    local function nozzles(o)
        local wide = o.kind == 0x9b
        local frames = data[o.kind]
        for _, p in ipairs(o.nozzles) do
            if not p.extended then
                p.radius = band(p.radius+4,0xff)
                p.extended = p.radius >= (wide and 0xa0 or 0x80)
            end
            if p.clock == 0 then
                p.clock = p.reload
                if p.bankHeading then
                    p.atlas = p.live and frames.liveNozzle or frames.initialNozzle
                    p.drawHeading, p.drawFrame = floor(p.bankHeading/2)+1, p.anim+1
                end
                p.anim = (p.anim-1)%8
            else
                p.clock = p.clock-1
            end
            if wide then p.bankHeading, p.live = p.shot, true end
            local dh, dl = program.optionVector(p.radius, p.heading)
            p.h, p.l = s16(o.h+dh), s16(o.l+dl)
            p.x, p.y = program.world(p.h,p.l)
        end
    end

    local function active(o)
        if o.run.freeze then return end
        steer(o)
        if o.kind == 0x9a then
            local target = o.direction == 0 and 0 or o.direction < 0x20 and 0x20 or -0x20
            if o.tilt ~= target and tick(o.state,0x2a) then
                o.state[0x2a], o.tilt = o.state[0x2b], approach(o.tilt,target)
            end
        else
            wideAim(o)
        end
        fire(o)
        nozzles(o)
    end

    local function open(o)
        if o.run.freeze then return end
        move(o)
        if tick(o.state,0x2e) then
            o.state[0x2e], o.hatchFrame = o.state[0x2f], o.hatchFrame-1
        end
        if o.hatchFrame >= 0 then
            o.speed = data[o.kind].hatch[o.hatchFrame+1][3]
        else
            o.phase, o.direction, o.flags = 2, floor(o.direction/4), 0xa101
            if o.kind == 0x9b then
                for i, p in ipairs(o.nozzles) do p.shot = data.cannonAngles[0x21][i] end
            end
            active(o)
        end
    end

    function M.step(o)
        local run = o.run
        if o.phase ~= 1 then
            if run.minor == 0 and run.player and next(run.player.bombObjects) then run.hoverGate = nil end
            local visible = band(o.h+0x800,0xffff) < 0x8000 and band(o.l+0x1000+run.cameraOffset,0xffff) < 0x5800
            if o.entered and not visible then
                -- 0xf26a2 跳回调色板与弹槽容量分支，副卷轴非零时保留原槽。
                if o.kind == 0x9a and run.minor ~= 0 then
                    run.capacity, o.colorFrame = 150, 1
                    return
                end
                if run.minor == 0 then run.hoverGate = nil end
                remove(o)
                return
            end
            o.entered = o.entered or visible
        end
        place(o)
        if damage(o) then return end
        if o.phase == 0 then enter(o)
        elseif o.phase == 1 then open(o)
        else active(o) end
        if o.phase ~= 1 and run.frame % 2 == 1 then
            o.glowDraw, o.glowNext = o.glowNext, (o.glowNext-1)%4
        end
    end

    function M.render(o, renderSprite)
        local art, color = data[o.kind], o.colorFrame
        local i = o.tilt/4+9
        local function draw(sprite, h, l)
            local dh, dl = program.add(o.h,o.l,h,l)
            renderSprite(o,sprite,s16(dh-o.h),s16(dl-o.l))
        end
        if o.phase == 0 then
            draw(art.approach[color][i],-0x800,-0x400)
        else
            local row = o.phase == 1 and art.hatch[o.hatchFrame+1]
                or art.body[o.kind == 0x9b and floor(o.turret/2)+1 or i]
            draw(row[color+3],row[1],row[2])
        end
        if o.glowDraw == nil or o.phase == 1 or o.run.frame % 2 ~= 1 then return end
        local index = o.glowDraw+1
        if o.phase == 0 then
            draw(art.glow[color][i][index],-0x600,-0x600)
        elseif o.kind == 0x9a then
            draw(art.wake[color][i][index],-0x800,-0x700)
        else
            draw(art.wake[color][index],-0x800,-0x600)
        end
    end

    return M
end
