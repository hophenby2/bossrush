-- 三面战舰 0xa0。母体的移动指令持有炮位；判定盒共用各自的甲板或核心血量。
return function(program, path, bullets, effects, items, score)
    local emitters = dofile('mod/GAME/th43/native/mid3_emitters.lua')(program, bullets)
    local band = require('bit').band
    local floor, max, min = math.floor, math.max, math.min
    local s16 = program.s16
    local data = program.mid3
    local M = {}

    local gunBreakH = {-0x27c0,-0x1980,0x22c0,0x2fc0}
    local zonePoints = {0x500,0x500,0x2da,0x28a,0x898}
    local deathGroups = {
        {parts={17,18,19}, hp=0x1c00, danger=0x4aa, requirement={5,6}, name='side1',
            h=-0x3600,l=0x2200, time=0x2d},
        {parts={20,21}, hp=0x1c00, danger=0x4aa, requirement={4,11,12,13,14}, name='side2',
            h=0x2c00,l=-0x1100, time=0x2d},
        {parts={25}, hp=0x3c00, danger=0xa00, name='deck1', h=-0x200,l=0xc00,time=0xc},
        {parts={26}, hp=0x3a00, danger=0x9aa, name='deck2', h=0x1c00,l=-0x100,time=0xc},
        {parts={27,28,29}, hp=0x7000, danger=0x2199, requirement={25,26}, name='core'},
    }

    local Part = Class(object, {
        init = function(p, host, row)
            p.host, p.offset = host, row[2]
            p.group, p.layer, p.bound, p.colli = GROUP.ENEMY, LAYER.ENEMY, false, false
            p.front, p.back, p.right, p.left = row[3], row[4], row[5], row[6]
            p.hp, p.hitPool, p.damagePending = 0x7fff, 2, 0
            p.direction, p.palette = 0, 1
            p.damage = function(part, value)
                part.damagePending = part.damagePending + value
            end
        end,
    })

    local function moveParts(o)
        for _, p in ipairs(o.parts) do p.h, p.l = program.add(o.h, o.l, program.unpack(p.offset)) end
    end

    local function drawAt(o, h, l, sprite)
        local image = o.run.art.sprites[sprite]
        if l < 0x3a00 and l + image[2] * 64 > -0x200 then
            Render(image[1], floor(l / 64) - 112 + image[2] / 2, floor(h / 64) - 224 + image[3] / 2)
        end
    end

    local function drawPiece(o, row, palette)
        local h, l = program.add(o.h, o.l, program.unpack(row[1]))
        drawAt(o, h, l, row[palette + 1])
    end

    local Mid = Class(object, {
        init = function(o, run, row)
            o.run, o.group, o.layer, o.bound, o.colli = run, GROUP.GHOST, LAYER.ENEMY, false, false
            o.part, o.state, o.spawnFlags = {}, {}, row[4]
            assert(path.init(o, row), '战舰入场路径缺少移动指令')
            o.h, o.l = s16(o.h + 0x5400), s16(o.l - 0x3800)
            o.parts, o.byIndex, o.guns, o.zones, o.emitters = {}, {}, {}, {}, {}
            for _, partRow in ipairs(data.parts) do
                local index = partRow[1]
                local p = New(Part, o, partRow)
                o.parts[#o.parts + 1], o.byIndex[index] = p, p
                if index <= 14 then
                    o.guns[index] = p
                    p.life = data.gunHp[index]
                end
            end
            for i, row in ipairs(deathGroups) do o.zones[i] = {hp=row.hp, palette=1} end
            o.tick, o.entry, o.prop, o.propClock = 0, 0x100, 1, 4
            o.aimBig, o.aimSmall = 0, 0
            o.shutterFrame, o.coreGate = 0, 0
            o.extendEligible = true
            run.capacity = 150
            moveParts(o)
        end,
        render = function(o)
            if o.hideHull then return end
            local art, zones = data.art, o.zones
            local core = zones[5]
            for _, row in ipairs(art.ends) do drawPiece(o, row, core.palette) end
            for i, row in ipairs(art.center) do
                if o.shutterFrame == 15 and (i == 3 or i == 4) then row = art.wreck[i - 2] end
                drawPiece(o, row, core.palette)
            end
            if o.shutterFrame > 0 and o.shutterFrame < 15 then
                drawPiece(o, art.open[o.shutterFrame * 2 - 1], core.palette)
                drawPiece(o, art.open[o.shutterFrame * 2], core.palette)
            end
            if not zones[1].hide and not (o.run.minor >= 0x6c and o.run.major >= 0x7c) then
                for _, row in ipairs(art.side1) do drawPiece(o, row, zones[1].palette) end
            end
            if not zones[2].hide then
                for _, row in ipairs(art.side2) do drawPiece(o, row, zones[2].palette) end
            end
            if not zones[3].hide then drawPiece(o, art.deck1[1], zones[3].palette) end
            if not zones[4].hide then drawPiece(o, art.deck2[o.prop], zones[4].palette) end
            for i, p in ipairs(o.guns) do
                if not p.hidden then
                    local sprites = i <= 4 and art.largeGun or art.smallGun
                    local dh, dl = i <= 4 and -0xa00 or -0x600, i <= 4 and -0xa00 or -0x400
                    local h, l = program.add(p.h, p.l, dh, dl)
                    drawAt(o, h, l, sprites[band(p.direction, 0x3e) / 2 + 1][p.palette])
                end
            end
        end,
    })

    local function showParts(o, parts, active)
        for _, i in ipairs(parts) do o.byIndex[i].colli = active end
    end

    local function blast(o, name, h, l)
        effects.spawn(o.run, h, l, data.blasts[name], true, true)
    end

    local function hitPalette(state, damage, hp, limit)
        if damage > 0 then state.palette = state.palette == 2 and 1 or 2
        else state.palette = hp < limit and 3 or 1 end
    end

    local function breakGun(o, p, i)
        p.broken, p.colli, p.palette = true, false, 1
        p.hideAt = o.tick + 1 + (i <= 4 and 0x12 or 3)
    end

    local function startDeath(o)
        -- 0x13680c 要求全炮位、两舷和两甲板均击破，且炸弹资格标志仍在。
        local canDrop = o.extendEligible and not (o.run.player and next(o.run.player.bombObjects))
        for _, p in ipairs(o.guns) do canDrop = canDrop and p.broken end
        for i = 1, 4 do canDrop = canDrop and o.zones[i].broken end
        if canDrop then
            items.spawn(o.run, 12, min(0x6c00, band(o.h,0xffff)), max(0x800,min(0x3000,o.l)))
        end
        o.emitters, o.event, o.shutter = {}, nil, nil
        o.death = {phase=0, point=1, cycle=4, clock=4, waveClock=0, wave=3, ramp=0x11}
        bullets.clearFor(o.run, 0x400)
        blast(o, 'hull', o.h, o.l)
    end

    -- 0x135386。共用血量只取本帧损伤最高的判定盒；击破条件是血量低于零。
    local function damage(o)
        local decksBroken = o.byIndex[25].broken and o.byIndex[26].broken
        local bomb = o.run.player and next(o.run.player.bombObjects)
        if bomb and not o.entry then o.extendEligible = false end
        for i, p in ipairs(o.guns) do
            if not p.broken then
                local value = p.damagePending
                p.life, p.damagePending = p.life - value, 0
                hitPalette(p, value, p.life, i <= 4 and 0x3d5 or 0x100)
                local forced = i <= 4 and decksBroken
                if p.life < 0 or o.death or forced then
                    if forced then o.extendEligible = false
                    elseif p.life < 0 then score.kill(p,i <= 4 and 0x244 or 0x1a4) end
                    breakGun(o, p, i)
                end
            end
        end
        for i, row in ipairs(deathGroups) do
            local zone = o.zones[i]
            if not zone.broken then
                local value, hit = 0
                for _, index in ipairs(row.parts) do
                    local p = o.byIndex[index]
                    if p.damagePending > value then value, hit = p.damagePending, p end
                    p.damagePending = 0
                end
                hitPalette(zone, value, zone.hp, row.danger)
                if o.death and i <= 2 then value = zone.hp + 1 end
                if value > 0 and i == 5 then
                    if o.retreatGate or o.tick < o.coreOpenAt then value = 0
                    elseif o.coreGate > 0 then
                        o.coreGate = o.coreGate - (bomb and 2 or 1)
                        if o.coreGate >= 0 then value = 0 else o.coreGate = 0 end
                    end
                end
                zone.hp = zone.hp - value
                if zone.hp < 0 then
                    if hit then score.kill(hit,zonePoints[i]) end
                    zone.broken, zone.palette = true, 1
                    for _, index in ipairs(row.parts) do o.byIndex[index].broken = true end
                    showParts(o, row.parts, false)
                    if i == 5 then
                        startDeath(o)
                    else
                        zone.hideAt = o.tick + row.time + 1
                        if i <= 2 then bullets.clearFor(o.run, 0x40)
                        else o.run.bulletHold = 0x10 end
                    end
                end
            end
        end
        if o.death then return end
        for i, row in ipairs(deathGroups) do
            local zone = o.zones[i]
            if row.requirement and not zone.open then
                local open = true
                for _, index in ipairs(row.requirement) do open = open and o.byIndex[index].broken end
                if open then
                    zone.open = true
                    if i == 5 then
                        o.coreOpenAt = o.tick + 134
                        o.coreGate = o.run.minor < 0x30 and 0x47 or 0
                    end
                    showParts(o, row.parts, true)
                end
            end
        end
    end

    local function stepBreaks(o)
        for i, p in ipairs(o.guns) do
            if p.hideAt then
                local delay = i <= 4 and 0x12 or 3
                if o.tick == p.hideAt - delay then
                    local h, l = program.unpack(p.offset + 0x8000)
                    if i <= 4 then h = gunBreakH[i] end
                    blast(o, i <= 4 and 'largeGun' or 'smallGun', s16(o.h + h), s16(o.l + l - 0x8000))
                end
                if o.tick == p.hideAt then p.hidden = true end
            end
        end
        for i = 1, 4 do
            local s, row = o.zones[i], deathGroups[i]
            if s.hideAt then
                if o.tick == s.hideAt - row.time then blast(o, row.name, s16(o.h + row.h), s16(o.l + row.l)) end
                if o.tick == s.hideAt then s.hide = true end
            end
        end
    end

    local function updateEvent(o)
        if o.entry then
            o.entry = o.entry - 1
            if o.entry == 0 then
                for i = 1, 5 do emitters.start(o, i) end
                for _, p in ipairs(o.guns) do p.colli = true end
                showParts(o, {25,26}, true)
                o.entry, o.event = nil, 'decks'
                o.eventAt = o.tick + 1
            end
        elseif o.event == 'decks' and o.tick == o.eventAt then
            emitters.start(o, 6)
            emitters.start(o, 7)
        elseif o.event == 'decks' and not o.emitters[6] and not o.emitters[7] then
            o.event, o.shutter, o.shutterClock = 'open', 'open', 0x40
        elseif o.event == 'open' and not o.shutter then
            emitters.start(o, 8)
            o.event = 'core'
        elseif o.event == 'core' and not o.emitters[8] and not o.shutter then
            o.event, o.eventAt = 'decks', o.tick + 1
        end
    end

    local function stepArt(o)
        if o.tick == 1 then return end
        o.aimBig = (o.aimBig + 1) % 2
        local small = o.emitters[5]
        local smallFree = not (small and small.locked)
        if smallFree then o.aimSmall = (o.aimSmall + 1) % 2 end
        if o.run.pilotH then
            for i, p in ipairs(o.guns) do
                local emitter = o.emitters[i <= 4 and i or 5]
                local aimFrame = i <= 4 and o.aimBig or o.aimSmall
                if aimFrame == 1 and not (emitter and emitter.locked) then
                    local h, l = program.unpack(p.offset + 0x8000)
                    local aimL = s16(o.l + l - 0x8000)
                    local a = program.angle(s16(o.h + h), aimL, o.run.pilotH, o.run.pilotL, p.direction)
                    p.direction = program.turnToward(p.direction, a)
                end
            end
        end
        o.propClock = o.propClock - 1
        if o.propClock < 0 then o.prop, o.propClock = o.prop % 16 + 1, 4 end
        if o.shutter then
            o.shutterClock = o.shutterClock - 1
            if o.shutterClock < 0 then
                local opening = o.shutter == 'open'
                o.shutterFrame = o.shutterFrame + (opening and 1 or -1)
                o.shutterClock = 1
                if o.shutterFrame == (opening and 15 or 0) then o.shutter = nil end
            end
        end
    end

    local function deathPoint(o, d)
        local p = data.deathPoints[d.point]
        local h, l = program.add(o.h, o.l, program.unpack(data.deathCycle[d.cycle]))
        local speed, angle = 0, 0
        if d.phase ~= 0 then
            local random = program.random(o.run, program.effectRandom)
            speed = floor((random < 0x80 and random or random - 0x100) / 2) + 7
                + floor((4 - (d.interval or 4)) / 2)
            angle = program.random(o.run, program.randomParity)
        elseif d.point % 2 == 1 then
            program.random(o.run, program.randomParity)
        end
        effects.spawn(o.run, h, l, {{0,p[1],p[2],p[3],p[4],speed,angle}}, true, true)
        d.cycle, d.point = (d.cycle + 2) % 4 + 1, d.point % 16 + 1
    end

    local function stepDeath(o)
        local d = o.death
        if d.phase == 4 then
            d.clock = d.clock - 1
            if d.clock == 0 then
                bullets.clearFor(o.run, 0x20)
                o.retire = true
            end
        elseif d.phase == 3 then
            blast(o, 'final', s16(o.h + 0x1800), s16(o.l + 0x600))
            d.phase, d.clock = 4, 0x80
        elseif d.phase == 0 then
            d.clock = d.clock - 1
            if d.clock < 0 then
                deathPoint(o, d)
                d.clock = 4
                if d.point == 1 then d.phase = 1 end
            end
        else
            if d.phase == 1 then
                d.waveClock = d.waveClock - 1
                if d.waveClock < 0 then
                    local h, l = program.add(o.h, o.l, program.unpack(data.deathCenters[d.wave]))
                    blast(o, 'hull', h, l)
                    d.wave, d.waveClock = d.wave - 1, 0x30
                    if d.wave == 0 then d.phase = 2 end
                end
            elseif d.phase == 2 then
                d.waveClock = d.waveClock - 1
                if d.waveClock < 0 then
                    o.hideHull, d.phase = true, 3
                    return
                end
            end
            d.ramp, d.clock = d.ramp - 1, d.clock - 1
            if d.ramp < 0 then
                d.ramp, d.interval = 0x11, max(1, (d.interval or 4) - 1)
            end
            if d.clock < 0 then
                deathPoint(o, d)
                d.clock = d.interval or 4
            end
        end
    end

    -- 0x1344ec 以关卡卷轴判断航线，转向后使用原速度 4 / 方向 0x18。
    local function move(o)
        local run = o.run
        if o.death and o.death.phase == 4 then
            o.h, o.l = s16(o.h - run.scrollStep * 64), s16(o.l - run.cameraStep)
            if band(o.l + 0x1800 + run.cameraOffset, 0xffff) >= 0x5800 then o.retire = true end
        elseif run.minor < 0x6c then
            return path.step(o)
        elseif run.major >= 0x9d then
            o.retire = true
        else
            if run.major == 0x8c then o.retreatGate = true end
            local dh, dl = program.vector(4, 0x18 * 4)
            o.h, o.l = s16(o.h + dh - run.scrollStep * 64), s16(o.l + dl)
        end
        return true
    end

    function M.spawn(run, row)
        run.mid3 = New(Mid, run, row)
        return run.mid3
    end

    function M.close(o)
        o.run.mid3 = nil
        for _, p in pairs(o.parts) do object.RawDel(p) end
        object.RawDel(o)
    end

    function M.step(o)
        if o.retire then
            if (o.run.bulletClearTime or 0) >= 0x10 then bullets.clearFor(o.run, 1) end
            o.run.capacity = 110
            M.close(o)
            return
        end
        if o.run.freeze then return end
        o.tick = o.tick + 1
        o.l = s16(o.l - o.run.cameraStep)
        stepArt(o)
        stepBreaks(o)
        if o.death then stepDeath(o) else updateEvent(o) end
        if o.tick > 1 then assert(move(o), '战舰移动指令提前结束') end
        moveParts(o)
        emitters.step(o)
        damage(o)
    end

    return M
end
