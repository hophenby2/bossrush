-- 小型敌机的移动和发弹计数挂在各自的 LuaSTG 对象上。
return function(program, path, bullets, effects, items, score)
    local bit = require('bit')
    local band, bor, bxor = bit.band, bit.bor, bit.bxor
    local floor = math.floor
    local s16, word = program.s16, program.word
    local M = {}

    local function remove(o)
        o.run.enemies[o.slot] = nil
        if o.run.largeVehicleLock == o then o.run.largeVehicleLock = nil end
        if o.ground59Flag and o.run.ground59Locks[o.ground59Flag] == o then
            o.run.ground59Locks[o.ground59Flag] = nil
        end
        if o.attachments then
            for _, part in ipairs(o.attachments) do object.RawDel(part) end
        end
        if o.nozzles then
            for _, nozzle in ipairs(o.nozzles) do object.RawDel(nozzle) end
        end
        object.RawDel(o)
    end

    local heavyTank = dofile('mod/GAME/th43/native/heavy_tank.lua')(program, path, bullets, effects, remove, score)
    local twinAircraft = dofile('mod/GAME/th43/native/twin_aircraft.lua')(program, path, bullets, effects, remove, score)
    local tripleAircraft = dofile('mod/GAME/th43/native/triple_aircraft.lua')(program, path, bullets, effects, remove, score)
    local patrol42 = dofile('mod/GAME/th43/native/patrol42.lua')(program, path, bullets, effects, remove, score)
    local ground98 = dofile('mod/GAME/th43/native/ground98.lua')(program, path, bullets, effects, remove, score)
    local largeVehicle = dofile('mod/GAME/th43/native/large_vehicle.lua')(program, path, bullets, effects, remove, score)
    local ground59 = dofile('mod/GAME/th43/native/ground59.lua')(program, path, bullets, effects, remove, score)
    local hover = dofile('mod/GAME/th43/native/hover.lua')(program, path, bullets, effects, items, remove, score)
    local raid = dofile('mod/GAME/th43/native/raid.lua')(program, path, bullets, effects, remove, score)
    local earlyVehicle = dofile('mod/GAME/th43/native/early_vehicle.lua')(program, path, bullets, effects, remove, score)
    local heavyHatch = dofile('mod/GAME/th43/native/heavy_hatch.lua')(program, path, bullets, effects, remove, score)
    local breakawayTank = dofile('mod/GAME/th43/native/breakaway_tank.lua')(program, path, bullets, effects, remove, score)
    local scenery = dofile('mod/GAME/th43/native/scenery.lua')(program, path, remove)
    local deckCarrier = dofile('mod/GAME/th43/native/deck_carrier.lua')(program, path, bullets, effects, remove, score)
    local platformCannon = dofile('mod/GAME/th43/native/platform_cannon.lua')(program, path, bullets, effects, remove, score)
    local risingTurret = dofile('mod/GAME/th43/native/rising_turret.lua')(program, path, bullets, effects, remove, score)
    local linkedCannon = dofile('mod/GAME/th43/native/linked_cannon.lua')(program, path, bullets, effects, remove, score)

    local function drawIndex(o)
        return band(o.direction, 0x3e) / 2 + 1
    end

    local function aim(o, current)
        local run = o.run
        if run.pilotH then return program.angle(o.h, o.l, run.pilotH, run.pilotL, current) end
    end

    local function countdown(state, offset)
        local timer = state[offset]
        state[offset] = band(timer - 1, 0xff)
        return timer == 0
    end

    local function steer(o)
        local state = o.state
        local remaining = word(state, 0x28)
        if remaining ~= 0 and countdown(state, 0x1a) then
            state[0x1a] = state[0x1b]
            remaining = remaining - 1
            state[0x28], state[0x29] = floor(remaining / 256), remaining % 256
            local angle = aim(o, o.direction)
            if angle then o.direction = program.turnToward(o.direction, angle) end
        end
    end

    local function fireSmall(o, aimedMuzzle)
        if o.part[0x1e] ~= 0 or not countdown(o.state, 0x18) then return end
        o.state[0x18] = band(0x5a - program.smallRank(o.run), 0xff)
        if not program.canFire(o.run.stageNumber, o.run.route, o.h, o.l) then return end
        local angle = aim(o, o.direction)
        if not angle then return end
        local direction = aimedMuzzle and angle or o.direction
        local muzzle = program.muzzle[band(direction + 1, 0x3e) / 2 + 1]
        local h, l = program.add(o.h, o.l, muzzle[1], muzzle[2])
        bullets.emit(o.run, 9, 3, angle, h, l)
    end

    local function flySmall(o)
        path.move(o)
        steer(o)
        fireSmall(o, false)
    end

    local function flyPath(o)
        if o.departing then
            path.move(o)
            steer(o)
        else
            if not path.step(o) then remove(o); return end
            if o.direction >= 0x40 then o.departing = true end
        end
        fireSmall(o, false)
    end

    -- 0xd0f80 / 0xd124e 先减速瞄准，到零速才换方向和加速离场。
    local function flyAndTurn(o)
        local state, kind = o.state, o.movementKind
        path.move(o)
        if o.departing then
            local limit = kind == 0x12 and 0x1c or 0x20
            if o.speed ~= limit and countdown(state, 0x24) then
                state[0x24] = state[0x25]
                o.speed = o.speed + (kind == 0x12 and 1 or 2)
            end
            if kind == 0x12 then
                if not o.returned and countdown(state, 0x1a) then
                    state[0x1a] = state[0x1b]
                    o.direction = band(o.direction + o.returnTurn, 0x3c)
                    o.returned = o.direction == o.returnDirection
                end
            else
                steer(o)
            end
            return
        end
        if o.speed ~= 0 and countdown(state, 0x24) then
            state[0x24] = state[0x25]
            o.speed = o.speed - 1
            if o.speed == 0 then
                state[0x24], state[0x25], state[0x18], state[0x1a] = 0, kind == 0x12 and 3 or 2, 16, 48
                o.direction = band(o.aimDirection, 0x3c)
                if kind == 0x12 then
                    o.returnTurn = o.direction < o.returnDirection and -4 or 4
                end
            end
        end
        local angle = aim(o, o.aimDirection)
        if angle then o.aimDirection = program.turnToward(o.aimDirection, angle) end
        o.departing = o.speed == 0
        fireSmall(o, true)
    end

    -- 0xd1504 只在减速到零时反转航向。离场用另一组时钟，炮口则始终追自机。
    local function flyBrakeAndExit(o)
        local run, state = o.run, o.state
        path.move(o)
        if o.part[0x1e] == 0 then
            state[0x18] = band(state[0x18] - 1, 0xff)
            if state[0x18] == 0 then
                state[0x18] = 0x5a - program.groundRank(run)
                if program.canFire(run.stageNumber, run.route, o.h, o.l) then
                    local angle = aim(o, o.direction)
                    if angle then
                        local muzzle = program.muzzle[band(angle + 1, 0x3e) / 2 + 1]
                        local h, l = program.add(o.h, o.l, muzzle[1], muzzle[2])
                        bullets.emit(run, 9, 0, angle, h, l)
                    end
                end
            end
        end
        if not o.departing then
            if countdown(state, 0x24) then
                state[0x24] = state[0x25]
                o.speed = o.speed - 1
                if o.speed == 0 then
                    o.departing, o.direction = true, o.returnDirection
                    state[0x24], state[0x25], state[0x18], state[0x19], state[0x1a] = 0, 2, 0x30, 8, 0x30
                end
            end
        elseif state[0x1a] > 0 then
            state[0x1a] = state[0x1a] - 1
        elseif o.speed ~= 0x20 and countdown(state, 0x24) then
            state[0x24] = state[0x25]
            o.speed = o.speed + 2
        end
        local angle = aim(o, o.aimDirection)
        if angle then o.aimDirection = program.turnToward(o.aimDirection, angle) end
    end

    local function turretAim(o, offsetH, offsetL)
        local run = o.run
        if run.pilotH then
            return program.angle(s16(o.h + offsetH), s16(o.l + offsetL), run.pilotH, run.pilotL, o.turret)
        end
    end

    local function aimTurret(o, timer, offsetH, offsetL)
        if countdown(o.state, timer) then
            o.state[timer] = o.state[timer + 1]
            local angle = turretAim(o, offsetH, offsetL)
            if angle then o.turret = program.turnToward(o.turret, angle) end
        end
    end

    local function fireGround(o, offsetH)
        local direction = band(o.turret, 0x3e)
        local muzzle = o.ground.muzzle[direction / 2 + 1]
        local h, l = program.add(muzzle[1], muzzle[2], offsetH, 0)
        bullets.emit(o.run, 9, 0, direction, o.h, o.l, h, l)
    end

    local function groundMove(o)
        if not path.step(o) then remove(o); return false end
        local far = o.groundKind == 0x85 or o.groundKind == 0x95
        local h = band(o.h + (far and 0x800 or 0x600), 0xffff)
        local padding = far and 0x1c00 or (o.groundKind == 0x24 and 0xe00 or 0x1000)
        local l = band(o.l + padding + o.run.cameraOffset, 0xffff)
        local onscreen = h < (far and 0x8000 or 0x7c00) and l < (far and 0x7000 or 0x6200 - padding)
        if not onscreen and o.entered then remove(o); return false end
        o.entered = o.entered or onscreen
        return true
    end

    -- 0xd3cd4 和 0xd4332 的车体跟随路径。炮塔朝向与车体方向独立。
    local function tank(o)
        if not groundMove(o) then return end
        local state = o.state
        local light = o.groundKind == 0x24
        local pivot = light and 0x400 or 0x300
        if not o.damaged then aimTurret(o, 0x1e, pivot, 0) end
        if o.damaged or band(o.flags, 0x2000) == 0 then return end
        state[0x18] = band(state[0x18] - 1, 0xff)
        if state[0x18] ~= 0 then return end
        if light then
            local _, delay = program.groundRank(o.run)
            state[0x18] = band(0xa4 - delay, 0xff)
            if program.groundCanFire(o.run, o.h, o.l) then fireGround(o, pivot) end
        else
            state[0x18] = state[0x1b]
            if program.groundCanFire(o.run, o.h, o.l) then
                local angle = turretAim(o, pivot, 0)
                if not angle then return end
                if band(angle, 0x3e) ~= band(o.turret, 0x3e) and state[0x1c] == state[0x1d] then return end
                fireGround(o, pivot)
                if not countdown(state, 0x1c) then return end
            end
            state[0x1c] = state[0x1d]
            local _, _, delay = program.groundRank(o.run)
            state[0x18] = band(0x40 - delay, 0xff)
        end
    end

    -- 0xd4f20 / 0xd552e 用车体路径、炮塔方向与受击阶段三组独立状态。
    local function tankWithWreck(o)
        if not path.step(o) then remove(o); return end
        local run, state = o.run, o.state
        local onscreen = band(o.h + 0x600, 0xffff) < 0x7c00
            and band(o.l + 0xe00 + run.cameraOffset, 0xffff) < 0x5400
        if not onscreen and o.entered then remove(o); return end
        o.entered = o.entered or onscreen

        if o.hp < 0 then
            if o.damaged then
                score.kill(o,o.groundKind==0x4c and 0xa0 or 0x8c)
                effects.spawn(run, o.h, o.l, {{0,0x88,0,0,0,0,0}}, false, true)
                if run.onEnemyDeath then run.onEnemyDeath(o) end
                remove(o)
                return
            end
            score.base(o,0x8c)
            o.hp, o.damaged, o.flame = word(state, 0x28), true, 0
            if run.frame >= (run.lastTankFire or 0) then
                effects.spawn(run, o.h, o.l, {{0,0x83,0,0,0,0,0}}, false, true)
                run.lastTankFire = run.frame + 3
            end
        end
        if o.damaged then
            if run.frame % 2 == 1 then o.flame = (o.flame + 1) % 4 end
            return
        end
        if countdown(state, 0x1e) then
            state[0x1e] = state[0x1f]
            local angle = turretAim(o, 0x400, 0)
            if not angle then return end
            o.turret = program.turnToward(o.turret, angle)
        end
        if band(o.flags, 0x2000) == 0 then return end
        state[0x18] = band(state[0x18] - 1, 0xff)
        if state[0x18] ~= 0 then return end
        state[0x18] = state[0x1b]
        local inRange = program.canFire(run.stageNumber, run.route, o.h, o.l)
        if run.stageNumber == 4 and run.major == 0x150 then
            inRange = band(o.h - 0x1c00, 0xffff) + 0xae00 < 0x10000
        end
        local minDistance = ({0x1c00,0x1c00,0x1c00,0x1800,0x1400})[run.stageNumber]
        if inRange and run.pilotH and program.distance(o.h, o.l, run.pilotH, run.pilotL) >= minDistance then
            local direction = band(o.turret, 0x3e)
            local offset = o.ground.muzzle[direction / 2 + 1]
            local dh, dl = 0x400 + offset[1], offset[2]
            bullets.emit(run, 9, 0, direction, o.h, o.l, dh, dl)
            if o.groundKind == 0x4d then
                bullets.emitLongPair(run, 9, 0, direction * 4, o.h, o.l, dh, dl)
            end
            if not countdown(state, 0x1c) then return end
        end
        state[0x1c] = state[0x1d]
        local _, delay = program.groundRank(run)
        state[0x18] = band(0xa4 - delay, 0xff)
    end

    -- 0xeb8ca 的固定炮塔。每轮的连发数和等待都由对象自己的计数器推进。
    local function turret(o)
        if not groundMove(o) or o.damaged then return end
        if o.run.suppressShots then return end
        aimTurret(o, 0x1e, 0x3c0, -0x80)
        if o.h < 0x1000 or not countdown(o.state, 0x1a) then return end
        local state = o.state
        state[0x1a] = 4
        if not program.groundCanFire(o.run, o.h, o.l) then return end
        fireGround(o, 0)
        if countdown(state, 0x1c) then
            state[0x1c] = state[0x1d]
            state[0x1a] = band(0x44 - program.groundRank(o.run), 0xff)
        end
    end

    -- 0xec02e 的两根炮管轮流用各自的炮口，打完一组才允许炮塔跟踪。
    local function heavyTurret(o)
        if not groundMove(o) then return end
        local state, run = o.state, o.run
        if not o.damaged and countdown(state, 0x1e) then
            state[0x1e] = state[0x1f]
            if state[0x1c] == state[0x1d] then
                local angle = turretAim(o, 0x3c0, -0x80)
                if angle then o.turret = program.turnToward(o.turret, angle) end
            end
        end
        if o.h < 0x1000 or not countdown(state, 0x1a) then return end
        state[0x1a] = 6
        if program.groundFireDistance(run, o.h, o.l) then
            local direction = band(o.turret, 0x3e)
            local muzzle = o.ground.muzzle[direction + 1 + band(state[0x1c], 1)]
            bullets.emit(run, 9, 2, direction, o.h, o.l, muzzle[1], muzzle[2])
        end
        if countdown(state, 0x1c) then
            state[0x1c] = state[0x1d]
            local _, delay = program.groundRank(run)
            state[0x1a] = band(0x40 - delay, 0xff)
        end
    end

    local railPivots = {{0xb80,0},{0x680,0x700},{0x100,0},{0x680,-0x700}}

    -- 0xe5008 的四门炮与机身舱盖各有计时器。88 指令只影响初始化时的分支。
    local function railFire(o)
        local run, state = o.run, o.state
        local ready = o.h >= s16(word(state, 0x1c)) and not run.suppressShots
        if state[0x2c] == 0 and ready and countdown(state, 0x2e) then
            state[0x2c], state[0x2e] = 1, state[0x2f]
        end
        if state[0x2c] == 1 and countdown(state, 0x30) then
            state[0x30], o.hatch = state[0x31], o.hatch + 1
            if o.hatch == 7 then state[0x2c], state[0x36] = 2, state[0x37] end
        end
        if state[0x2c] == 2 and countdown(state, 0x34) then
            state[0x34] = state[0x35]
            if ready then
                for angle = 0, 0xf0, 0x10 do
                    local h, l = unpack(o.ground.hatchMuzzle[angle / 4 + 1])
                    bullets.emitLongPair(run, 0x2d, 8 - state[0x36], angle, o.h, o.l, h + 0x700, l, {0x16})
                end
            end
            state[0x36] = band(state[0x36] - 4, 0xff)
            if state[0x36] == 0 then state[0x2c] = 3 end
        end
        if state[0x2c] == 3 and countdown(state, 0x30) then
            state[0x30], o.hatch = state[0x31], o.hatch - 1
            if o.hatch == 0 then state[0x2c] = 0 end
        end
        if not countdown(state, 0x28) then return end
        state[0x28] = state[0x29]
        if ready then
            for i, pivot in ipairs(railPivots) do
                local direction = band(state[0x1f + i] + o.turn, 0x3f)
                state[0x1f + i] = direction
                local h, l = unpack(o.ground.muzzle[band(direction, 0x3e) / 2 + 1])
                local modifier = s16(word(state, 0x36 + 2 * i))
                if i % 2 == 0 then
                    bullets.emitWidePair(run, 4, modifier, direction * 4, o.h, o.l, h + pivot[1], l + pivot[2])
                else
                    bullets.emitDirect(run, 4, modifier, direction, o.h, o.l, h + pivot[1], l + pivot[2])
                end
            end
        end
        state[0x2a] = band(state[0x2a] - 1, 0xff)
        if state[0x2a] == 0 then state[0x2a], o.turn = state[0x2b], -o.turn end
    end

    local function rail(o)
        local run = o.run
        local hit = band(o.flags, 0x5800) ~= 0
        o.flags = band(o.flags, 0xa7ff)
        if o.hp < 0 then
            score.kill(o,0x276,-0x600)
            effects.spawn(run, o.h, o.l, o.ground.breakup[run.stageNumber - 3], true, true)
            if run.onEnemyDeath then run.onEnemyDeath(o) end
            remove(o)
            return
        end
        o.colorFrame = hit and (o.colorFrame == 2 and 1 or 2)
            or (o.hp < 0xb55 and band(run.frame, 0x0e) == 0 and 3 or 1)
        if run.freeze then return end
        if not path.step(o) then remove(o); return end
        local h, l = band(o.h + 0x1200, 0xffff), band(o.l + 0x1600 + run.cameraOffset, 0xffff)
        local onscreen = h < 0x9400 and l < 0x6400
        if not onscreen and o.entered then remove(o); return end
        o.entered = o.entered or onscreen
        railFire(o)
    end

    local function gunshipFan(o, modifier, gap)
        local run = o.run
        if not run.pilotH then return end
        local angle = program.aimByte(o.h - 0x300, o.l, run.pilotH, run.pilotL, 0x80)
        for ray = -1, 1 do
            local a = angle + ray * gap
            local muzzle = o.ground.muzzleFan[band(a + 2, 0xfc) / 4 + 1]
            local h, l = s16(o.h - 0x300 + muzzle[1]), s16(o.l + muzzle[2])
            if run.route.loop == 1 then
                bullets.emitAngle(run, 7, modifier, a - 1, h, l)
                bullets.emitAngle(run, 7, modifier, a + 1, h, l)
            else
                bullets.emitAngle(run, 7, modifier, a, h, l)
            end
        end
    end

    local function retireGunship(o)
        local run = o.run
        local angle = o.direction * 4
        effects.spawn(run, o.h, o.l, {
            {0,0x85,0,0,0,o.speed,angle},
            {4,0x84,0,-0x400,0x400,o.speed,angle+0x18},
            {8,0x87,0,-0x200,-0x400,o.speed,angle+0x30},
        }, false)
        if not o.discharged then gunshipFan(o, -1, 0xc) end
    end

    -- 0xec82e 的舱门齐射与两门跟踪炮分别计时。命中两个部件时保留较低的耐久。
    local function gunship(o)
        if not path.step(o) then remove(o); return end
        local run, s = o.run, o.state
        local h, l = band(o.h + 0xa00, 0xffff), band(o.l + 0x1000 + run.cameraOffset, 0xffff)
        local visible = h < 0x8400 and l < 0x5800
        if not visible and o.entered then remove(o); return end
        o.entered = o.entered or visible
        o.second.flags = band(o.second.flags, 0xdffe) + band(o.flags, 0x2001)
        o.second.h, o.second.l = o.h, o.l
        o.second.x, o.second.y = program.world(o.h, o.l)
        if run.suppressShots then return end
        local phase = o.hatchPhase
        if o.entered and o.h >= 0x1000 then
            if phase == 0 and countdown(s, 0x1c) then
                o.hatchPhase, s[0x1c] = 1, 4
            elseif phase == 1 and countdown(s, 0x22) then
                s[0x22], o.hatch = s[0x23], o.hatch + 1
                if o.hatch == 7 then o.hatchPhase = 2 end
            elseif phase == 2 and countdown(s, 0x1c) then
                s[0x1c] = s[0x3c]
                local stageFive = run.stageNumber == 5
                gunshipFan(o, stageFive and 1 or 0, stageFive and 8 or 4)
                o.discharged = true
                if countdown(s, 0x1e) then
                    s[0x1e], s[0x1c], o.hatchPhase = s[0x1f], 4, 3
                end
            elseif phase == 3 then
                if s[0x1c] > 0 then
                    s[0x1c] = s[0x1c] - 1
                elseif countdown(s, 0x22) then
                    s[0x22], o.hatch = s[0x23], o.hatch - 1
                    if o.hatch == 0 then
                        s[0x1c], o.hatchPhase = 0x30 - floor(program.rank(run) / 32), 0
                    end
                end
            end
        end
        if countdown(s, 0x2e) then
            s[0x2e] = s[0x2f]
            if s[0x2c] == s[0x2d] and run.pilotH then
                o.aimBarrel = 3 - o.aimBarrel
                local i = o.aimBarrel
                local offset = i == 1 and 0x380 or -0x380
                local angle = program.angle(o.h - 0x200, o.l + offset, run.pilotH, run.pilotL, o.barrels[i])
                o.barrels[i] = program.turnToward(o.barrels[i], angle)
            end
        end
        if o.h < 0x1000 or not countdown(s, 0x2a) then return end
        s[0x2a] = 4
        for i, angle in ipairs(o.barrels) do
            local muzzle = o.ground.muzzle[band(angle, 0x3e) / 2 + 1]
            bullets.emitDirect(run, 9, -1, angle, o.h, o.l, muzzle[1] - 0x200,
                muzzle[2] + (i == 1 and 0x380 or -0x380))
        end
        if countdown(s, 0x2c) then
            local rank = program.rank(run)
            local adjustment = floor(rank / 8) + floor(rank / 16)
            s[0x2c], s[0x2a] = s[0x2d], math.max(0xc, 0x20 - adjustment)
        end
    end

    local function fireBurst(o)
        local s = o.state
        if (band(o.h, 0xffff) >= 0x7000 and not o.entered) or not countdown(s, 0x18) then return end
        s[0x18] = s[0x19]
        local muzzle = program.burstMuzzle[band(o.aimDirection, 0x3e) / 2 + 1]
        for delta = -3, 3, 2 do
            bullets.emitSpeedPair(o.run, 0x19, 4, o.aimDirection * 4 + delta, o.h, o.l, muzzle[1], muzzle[2])
        end
    end

    local function burstSpeed(o, delta)
        if not countdown(o.state, 0x32) then return false end
        o.state[0x32] = o.state[0x33]
        o.speed = band(o.speed + delta, 0xff)
        return true
    end

    -- 0xd1f46 的飞行器在减速、停火力位和离场之间循环。
    local function flyBurst(o)
        local s = o.state
        if s[0x30] == 0 then
            fireBurst(o)
            if burstSpeed(o, -1) and o.speed == 0 then
                s[0x30], s[0x34], s[0x35], o.direction = 1, 0, 0x40, 0
                s[0x3a], s[0x3b] = s[0x3b], math.min(10, s[0x3b] + 2)
            end
        end
        if s[0x30] == 1 then
            if s[0x3a] ~= 0 and countdown(s, 0x38) then
                s[0x38], s[0x3a] = s[0x39], s[0x3a] - 1
                local muzzle = program.burstMuzzle[band(o.aimDirection, 0x3e) / 2 + 1]
                bullets.emitDirect(o.run, 0x19, 9, o.aimDirection, o.h, o.l, muzzle[1], muzzle[2])
            end
            burstSpeed(o, o.speed == 2 and 0 or 1)
            s[0x35] = s[0x35] - 1
            if s[0x35] == 0 then
                s[0x30], s[0x18], s[0x19] = 2, 0x20, 0x30
            end
        end
        if s[0x30] == 2 then
            fireBurst(o)
            if burstSpeed(o, 1) and o.speed == 0x10 then
                local count = word(s, 0x28) - 1
                s[0x28], s[0x29], s[0x30] = floor(count / 256), count % 256, count == 0 and 3 or 0
            end
        end
        local direction = aim(o, o.aimDirection)
        if direction then o.aimDirection = program.turnToward(o.aimDirection, direction) end
        path.move(o)
    end

    local function retireRearShot(o)
        local run = o.run
        if not run.pilotH or run.stageNumber == 5 and run.minor == 0x48 and run.major >= 0x18f then return end
        local ura = run.route.ura
        local angle = program.aimByte(o.h, o.l, run.pilotH, run.pilotL, o.direction * 4)
        local kind, speed = ura and 0x0e or 0x25, ura and 0 or -17
        if run.stageNumber == 5 and run.minor == 0 and run.major >= 0x50 then
            local boost = run.route.loop == 1 and 4 or 0
            bullets.emitAcceleration(run, kind, speed + boost, angle, o.h, o.l, {1,1,1,0x1c})
            if not ura then
                if run.route.loop == 0 then
                    bullets.emitAcceleration(run, kind, speed + 2, angle, o.h, o.l, {1,1,1,0x1e})
                else
                    bullets.emitAcceleration(run, kind, speed + 2, angle - 0x12, o.h, o.l, {1,1,1,0x1e})
                    bullets.emitAcceleration(run, kind, speed + 2, angle + 0x12, o.h, o.l, {1,1,1,0x1e})
                end
            end
        else
            bullets.emitAcceleration(run, kind, speed, angle, o.h, o.l, {1,1,1,0x1c})
            if run.route.loop == 1 then bullets.emitAcceleration(run, kind, speed + 6, angle, o.h, o.l, {1,1,1,0x1c}) end
        end
    end

    -- 0xd2b46 直接跳到绘制回调。死亡时才进入 0xd2a50 的反击弹入口。
    local function flyRearShot(o)
        path.move(o)
        steer(o)
        o.animation = o.animation % 3 + 1
    end

    local function fireNose(o, modifier, angle, nozzle)
        if not angle or not program.canFire(o.run.stageNumber, o.run.route, o.h, o.l) then return end
        local muzzle = program.muzzle[band(nozzle + 1, 0x3e) / 2 + 1]
        local h, l = program.add(o.h, o.l, muzzle[1], muzzle[2])
        bullets.emit(o.run, 9, modifier, angle, h, l)
    end

    -- 0xd1984 的机体以当前航向减速，炮口在减速期间逐帧追自机。
    local function flyDecelerate(o)
        local state = o.state
        path.move(o)
        if not o.departing then
            state[0x28] = band(state[0x28] - 1, 0xff)
            if state[0x28] == 0 then
                state[0x28] = state[0x29]
                fireNose(o, 0, aim(o, o.aimDirection), o.aimDirection)
            end
            if countdown(state, 0x24) then
                state[0x24], o.speed = state[0x25], band(o.speed - 1, 0xff)
                if o.speed == 0 then
                    o.departing, o.direction = true, band(o.aimDirection, 0x3c)
                    state[0x24], state[0x25], state[0x18], state[0x1a] = 0, 2, 1, 48
                    o.returnTurn = o.direction > o.returnDirection and 4 or -4
                end
            end
            local direction = aim(o, o.aimDirection)
            if direction then o.aimDirection = program.turnToward(o.aimDirection, direction) end
        elseif o.part[0x1e] == 0 and state[0x27] ~= 0 then
            state[0x18] = band(state[0x18] - 1, 0xff)
            if state[0x18] == 0 then
                state[0x18], state[0x27] = state[0x19], state[0x27] - 1
                fireNose(o, 0, o.aimDirection, o.aimDirection)
            end
        else
            if o.speed ~= 0x1c and countdown(state, 0x24) then
                state[0x24], o.speed = state[0x25], o.speed + 1
            end
            if not o.returned and countdown(state, 0x1a) then
                state[0x1a] = state[0x1b]
                if o.direction ~= o.returnDirection then o.direction = band(o.direction + o.returnTurn, 0x3c) end
                o.returned = o.direction == o.returnDirection
                if not o.returned then o.aimDirection = aim(o, o.aimDirection) or o.aimDirection end
            else
                o.aimDirection = o.direction
            end
        end
    end

    -- 0xd1c80 在路径结束标记后保留航向继续移动，瞄准仍独立更新。
    local function flyPathAim(o)
        if o.departing then
            path.move(o)
            steer(o)
        else
            if not path.step(o) then remove(o); return end
            if o.direction >= 0x40 then o.direction, o.departing = o.direction - 0x40, true end
        end
        local angle = aim(o, o.aimDirection)
        if angle then o.aimDirection = program.turnToward(o.aimDirection, angle) end
        if o.part[0x1e] == 0 and countdown(o.state, 0x18) then
            o.state[0x18] = band(0x5a - program.smallRank(o.run), 0xff)
            fireNose(o, 3, angle, angle)
        end
    end

    local patrol = program.patrol43

    -- 0xddd0c 用同一瞄准角查两处炮口，往外展开时按序追加两种发射入口。
    local function patrolVolley(o)
        local run, state = o.run, o.state
        local h, l = o.h, o.l
        local limits = program.aimLimits[1][run.stageNumber]
        if band(h - limits[2], 0xffff) + limits[1] >= 0x10000 then return end
        local angle = o.aimDirection * 4
        local muzzle = patrol.muzzles[band(o.aimDirection, 0x3e) / 2 + 1]
        local modifier, fan = word(state, 0x3a), s16(word(state, 0x38))
        for side = 1, 2 do
            local sign = side == 1 and -1 or 1
            local dh, dl = muzzle[2 * side - 1], muzzle[2 * side]
            local base = angle + sign
            bullets.emitAngle(run, 4, modifier, base, h, l, dh, dl)
            if fan ~= 0 then
                bullets.emitLongPair(run, 4, modifier, base + sign * 8, h, l, dh, dl)
                if fan < 0 then
                    bullets.emitAngle(run, 4, modifier, base + sign * 16, h, l, dh, dl)
                    bullets.emitLongPair(run, 4, modifier, base + sign * 24, h, l, dh, dl)
                    bullets.emitAngle(run, 4, modifier, base + sign * 32, h, l, dh, dl)
                end
            end
        end
    end

    local function patrolCrash(o)
        local run, state = o.run, o.state
        o.aimDirection = band(o.aimDirection - 2, 0x3f)
        o.h = s16(o.h - 0xc0)
        o.zoom = math.min(7, o.zoom + 1)
        if countdown(state, 0x36) then
            state[0x36] = state[0x37]
            local kind = band(o.flags, 0x80) == 0 and 6 or 11
            o.flags = bxor(o.flags, 0x80)
            local offset = program.random(run, patrol.debris)
            local speed = bit.arshift(program.random(run, program.effectRandom) * 2 ^ 24, 25) + 8
            local heading = program.random(run, program.effectRandom) + o.aimDirection + 0x20
            effects.spawn(run, o.h, o.l, {{0,kind,0,offset[1],offset[2],speed,heading * 4}}, false, true)
        end
        state[0x1e] = band(state[0x1e] - 1, 0xff)
        if state[0x1e] == 0 then
            effects.spawn(run, o.h, o.l, patrol.crash, false, true)
            remove(o)
        end
    end

    -- 0xddafc 在同一个敌机槽内切到 0xdd9da 坠毁，残骸不再响应自机火力。
    local function patrol43(o)
        if o.crashing then patrolCrash(o); return end
        local run, state = o.run, o.state
        if state[0x35] ~= 0 then
            state[0x35] = state[0x35] - 1
            o.hp = state[0x35] == 0 and 0x800 or 0x7fff
        end
        local damaged = band(o.flags, 0x5800) ~= 0
        o.flags = band(o.flags, 0xa7ff)
        if o.hp < 0 then
            score.kill(o,0x172)
            effects.spawn(run, o.h, o.l, patrol.breakup, false, true)
            o.crashing, o.flags, o.colorFrame = true, 0x8000, 1
            if run.onEnemyDeath then run.onEnemyDeath(o) end
        else
            o.colorFrame = damaged and 2 or o.hp < 0x199 and run.frame % 16 < 2 and 3 or 1
        end
        if state[0x34] == 0 then
            local target = aim(o, o.aimDirection)
            if target then o.aimDirection = program.turnToward(o.aimDirection, target) end
        end
        if state[0x1f] == 0 and not path.step(o) then remove(o); return end
        if state[0x1f] == 1 then
            o.direction = band(o.direction, 0x3f)
            path.move(o)
            local left = band(word(state, 0x22) - 1, 0xffff)
            state[0x22], state[0x23] = floor(left / 256), left % 256
            if left == 0 then
                state[0x24], state[0x25], state[0x26], state[0x27] = 12,12,7,7
                state[0x1f] = 2
                o.turnStep = o.l < 0x1c00 and 1 or -1
                o.direction = band(o.direction + 8 * o.turnStep, 0x3f)
            end
        end
        if state[0x1f] == 2 then
            if countdown(state, 0x24) then
                state[0x24] = state[0x25]
                o.direction = band(o.direction + o.turnStep, 0x3f)
            end
            if countdown(state, 0x26) then
                state[0x26], o.speed = state[0x27], math.min(11, o.speed + 1)
            end
            path.move(o)
        end
        local box = patrol.boxes[band(o.aimDirection, 0x3e) / 2 + 1]
        o.front, o.back, o.right, o.left = unpack(box)
        local onscreen = band(o.h + 0x1000, 0xffff) < 0x8800
            and band(o.l + 0x1600 + run.cameraOffset, 0xffff) < 0x6400
        if not onscreen and o.entered then remove(o); return end
        o.entered = o.entered or onscreen
        if countdown(state, 0x2a) then
            state[0x2a] = state[0x2b]
            patrolVolley(o)
            state[0x2c] = band(state[0x2c] - 1, 0xff)
            -- 0xddddc 读取 0x81246e 的高字节。Rank 只更新低字节 0x81246f。
            if state[0x2c] == 0 then state[0x2a], state[0x2c] = 0x40, state[0x2d] end
        end
    end

    -- 0xd951e 使用路径控制航线。炮塔只在每轮开始前追踪自机。
    local patrol2a = program.patrol2a
    local function patrolTransport(o)
        local run, s = o.run, o.state
        if band(o.flags, 0x5800) ~= 0 then
            o.colorFrame = o.colorFrame == 2 and 1 or 2
        else
            o.colorFrame = o.hp < 0xd5 and 3 or 1
        end
        o.flags = band(o.flags, 0xa7ff)
        o.drawFrame = o.animation % 8 + 1
        o.animation = o.animation + 1
        if o.hp < 0 then
            -- 0xd9578 与 0xd999a 在击破回调里分别登记火力和炸弹。
            score.kill(o,0x6e,-0x400)
            effects.spawn(run, o.h, o.l, patrol2a.breakup, false, true)
            local kind = o.kind == 0x2a and 0 or 8
            items.spawn(run, kind, o.h, o.l)
            if run.onEnemyDeath then run.onEnemyDeath(o) end
            remove(o)
            return
        end
        if not path.step(o) then remove(o); return end
        local visible = band(o.h + 0xa00, 0xffff) < 0x8200
            and band(o.l + 0x1200 + run.cameraOffset, 0xffff) < 0x5c00
        if not visible and o.entered then remove(o); return end
        o.entered = o.entered or visible
        if s[0x22] == 0 then
            if run.frame % 2 == 1 then
                if not run.pilotH then return end
                local direction = program.angle(o.h - 1, o.l - 0xd80, run.pilotH, run.pilotL, o.aimDirection)
                o.aimDirection = program.turnToward(o.aimDirection, direction)
            end
            if not countdown(s, 0x1e) then return end
            s[0x1e], s[0x22] = s[0x1f], s[0x23]
        end
        if countdown(s, 0x20) then
            s[0x20], s[0x22] = s[0x21], s[0x22] - 1
            local range = program.aimLimits[run.route.loop + 1][run.stageNumber]
            if band(o.h - range[2], 0xffff) + range[1] < 0x10000 then
                local dh, dl = unpack(patrol2a.muzzle[floor(o.aimDirection / 2) + 1])
                for index = -1, 1 do
                    local a = o.aimDirection * 4 + index * 20
                    local mh, ml = unpack(program.boss1FanMuzzle[floor(band(a + 2, 0xff) / 4) + 1])
                    mh, ml = program.add(dh - 0x980, dl, mh, ml)
                    bullets.emitAngle(run, 6, run.route.loop == 1 and 4 or 0, a, o.h, o.l, mh, ml)
                end
            end
        end
    end

    local hatchPatrol, cannonData = program.hatchPatrol, program.fixedCannon

    local function hitPalette(o, threshold)
        local hit = band(o.flags, 0x5800) ~= 0
        o.flags = band(o.flags, 0xa7ff)
        if hit then
            o.colorFrame = o.colorFrame == 2 and 1 or 2
        else
            o.colorFrame = o.hp < threshold and band(o.run.frame, 0x0e) == 0 and 3 or 1
        end
    end

    -- 0xd87a0、0xd8c1a 和 0xd90ac 共用舱门和尾焰的计时结构。
    local function patrolHatch(o)
        local run, state = o.run, o.state
        hitPalette(o,0x155)
        if o.hp < 0 then
            score.kill(o,0x14a)
            effects.spawn(run, o.h, o.l, o.hatchData.breakup, true)
            if run.onEnemyDeath then run.onEnemyDeath(o) end
            remove(o)
            return
        end
        if run.freeze then return end
        if not path.step(o) then remove(o); return end
        local onscreen = band(o.h + 0xa00, 0xffff) < 0x8200
            and band(o.l + 0x1200 + run.cameraOffset, 0xffff) < 0x5c00
        if not onscreen and o.entered then remove(o); return end
        o.entered = o.entered or onscreen
        local limit = program.aimLimits[1][run.stageNumber]
        local canFire = band(o.h - limit[2], 0xffff) + limit[1] < 0x10000
        if state[0x20] == 0 then
            if state[0x1e] ~= 0 then
                if canFire then state[0x1e] = state[0x1e] - 1 end
            elseif countdown(state, 0x22) then
                state[0x22] = state[0x23]
                o.hatch = o.hatch + 1
                if o.hatch == 7 then state[0x20], state[0x1e] = 1, state[0x1f] end
            end
        end
        if state[0x20] == 1 and countdown(state, 0x26) then
            state[0x26] = state[0x27]
            if run.pilotH and not run.suppressShots then
                local angle = program.aimByte(o.h, o.l, run.pilotH, run.pilotL, 0x80)
                local speed = run.route.loop == 1 and 6 or 2
                for _, muzzle in ipairs(o.hatchData.muzzle) do
                    local spread = program.random(run, program.effectRandom)
                    if spread >= 0x80 then spread = spread - 0x100 end
                    if run.stageNumber ~= 5 then spread = floor(spread / 2) end
                    bullets.emitAngle(run, 7, speed, angle + spread, o.h, o.l, muzzle[1], muzzle[2])
                end
            end
            state[0x28] = state[0x28] - 1
            if state[0x28] == 0 then
                state[0x20], state[0x28], state[0x2a], state[0x2e] = 3, state[0x29], 0x30, 0
            end
        end
        if state[0x20] == 2 and countdown(state, 0x2a) then
            state[0x2a] = state[0x2b]
            if not canFire then
                state[0x20] = 3
            else
                local angle = aim(o, o.direction)
                if angle then
                    local offsets = o.hatchData.offsets
                    local h, l = program.add(o.h,o.l,offsets[5],offsets[6])
                    for i = 0, 6 do bullets.emit(run, 9, -4, angle + i*2, h, l) end
                    for i = 1, 6 do bullets.emit(run, 9, -4, angle - i*2, h, l) end
                end
                state[0x20] = 1
            end
        end
        if state[0x20] == 3 and o.hatch > 0 and countdown(state, 0x22) then
            state[0x22] = state[0x23]
            o.hatch = o.hatch - 1
            if o.hatch == 0 then state[0x20] = 0 end
        end
        if o.direction < 0x40 and o.speed > 0 and countdown(state, 0x1a) then
            state[0x1a] = o.speed <= 4 and 5 or (o.speed <= 8 and 1 or 0)
            o.exhaust = (o.exhaust + 1) % 4
        end
    end

    -- 0xf3fa8 先结算装甲时钟，再由两根炮管交替发射两发与四发。
    local function fixedCannon(o)
        local run, state = o.run, o.state
        if not path.step(o) then remove(o); return end
        local visible = band(o.h + 0xc00, 0xffff) < 0x8800
        if not visible and o.entered then remove(o); return end
        o.entered = o.entered or visible
        if o.armorClock >= 0 then
            local pilot = run.player
            local bombing = pilot and next(pilot.bombObjects)
            o.armorClock = o.armorClock - (bombing and 2 or 1)
            o.hp = o.armorClock < 0 and word(o.part, 0x18) or 0x7fff
        end
        hitPalette(o,0x500)
        if o.hp < 0 then
            score.kill(o,0x3de)
            effects.spawn(run, o.h, o.l, cannonData.breakup, true, true)
            if run.onEnemyDeath then run.onEnemyDeath(o) end
            remove(o)
            return
        end
        if run.freeze then return end
        if countdown(state, 0x22) then
            state[0x22] = state[0x23]
            if state[0x20] == state[0x21] and run.pilotH then
                o.turret = program.turnToward(o.turret, aim(o, o.turret))
            end
        end
        if band(o.flags, 0x80) ~= 0 or run.suppressShots or o.h < 0x1400 or not countdown(state, 0x1e) then return end
        state[0x1e] = 2
        local barrel = cannonData.barrel[band(o.turret, 0x3e)/2+1]
        local angle = band(o.turret, 0x3e)*4
        local narrow = band(state[0x20],1) ~= 0
        for index = 1, 2 do
            local h, l = program.add(o.h, o.l, barrel[2*index-1], barrel[2*index])
            local function shot(direction)
                local dh, dl = unpack(cannonData.muzzle[band(direction+2,0xfc)/4+1])
                bullets.emitAngle(run, 0x17, 3, direction, h, l, dh, dl)
            end
            if narrow then
                shot(angle + (index == 1 and -3 or 3))
            else
                shot(angle)
                shot(angle + (index == 1 and 8 or -8))
            end
        end
        if countdown(state, 0x20) then
            local _, delay = program.smallRank(run)
            state[0x20], state[0x1e] = state[0x21], 0x60-delay
        end
    end

    local controllers = {
        [0x0d08d2] = flySmall, [0x0d0d42] = flyPath, [0x0d0f80] = flyAndTurn,
        [0x0d124e] = flyAndTurn, [0x0d1504] = flyBrakeAndExit,
        [0x0d3cd4] = tank, [0x0d4332] = tank, [0x0eb8ca] = turret,
        [0x0d1f46] = flyBurst, [0x0d2990] = flyRearShot,
        [0x0d1984] = flyDecelerate, [0x0d1c80] = flyPathAim,
        [0x0ec02e] = heavyTurret, [0x0ec82e] = gunship,
        [0x0d4f20] = tankWithWreck, [0x0d552e] = tankWithWreck, [0x0ddafc] = patrol43,
        [0x0d951e] = patrolTransport,
        [0x0d9942] = patrolTransport,
        [0x0e5008] = rail,
        [0x0d87a0] = patrolHatch, [0x0d8c1a] = patrolHatch,
        [0x0d90ac] = patrolHatch,
        [0x0f3fa8] = fixedCannon,
        [0x0d7cdc] = heavyTank.step,
        [0x0e1168] = twinAircraft.step,
        [0x0deafc] = tripleAircraft.step, [0x0dff92] = tripleAircraft.step, [0x0e087a] = tripleAircraft.step,
        [0x0dd34e] = patrol42.step,
        [0x0ed00c] = ground98.step,
        [0x0db3c2] = largeVehicle.step, [0x0dbe1c] = largeVehicle.step,
        [0x0e3e52] = ground59.step,
        [0x0f2638] = hover.step, [0x0f32e8] = hover.step,
        [0x0ed9fa] = raid.step, [0x0d3334] = raid.step, [0x0d3750] = raid.step,
        [0x0d2fd6] = raid.step,
        [0x0ead90] = earlyVehicle.step, [0x0de4a6] = earlyVehicle.step,
        [0x0e7fd6] = earlyVehicle.step, [0x0e815a] = earlyVehicle.step,
        [0x0e3434] = earlyVehicle.step, [0x0e2f18] = earlyVehicle.step,
        [0x0e6ac8] = earlyVehicle.step, [0x0e7a8e] = earlyVehicle.step,
        [0x0e6e50] = earlyVehicle.step, [0x0e746e] = earlyVehicle.step,
        [0x0e5636] = heavyHatch.step, [0x0e5da0] = heavyHatch.step, [0x0e64fa] = heavyHatch.step,
        [0x0d9c1c] = breakawayTank.step, [0x0da402] = breakawayTank.step, [0x0dabec] = breakawayTank.step,
        [0x0f1704] = scenery.step, [0x0f18a4] = scenery.step,
        [0x0e1c24] = deckCarrier.step,
        [0x0f1a4c] = platformCannon.step,
        [0x0efe98] = risingTurret.step, [0x0f03f4] = risingTurret.step,
        [0x0f09bc] = risingTurret.step, [0x0f1080] = risingTurret.step,
        [0x0eed4a] = linkedCannon.step, [0x0ef614] = linkedCannon.step,
    }
    local ownDamage = {
        [patrol43]=true, [patrolTransport]=true, [rail]=true, [patrolHatch]=true,
        [fixedCannon]=true, [heavyTank.step]=true, [twinAircraft.step]=true, [tripleAircraft.step]=true,
        [patrol42.step]=true, [ground98.step]=true, [largeVehicle.step]=true, [ground59.step]=true, [hover.step]=true,
        [raid.step]=true, [earlyVehicle.step]=true, [heavyHatch.step]=true, [breakawayTank.step]=true,
        [scenery.step]=true, [deckCarrier.step]=true, [platformCannon.step]=true, [risingTurret.step]=true,
        [linkedCannon.step]=true,
    }
    local duringFreeze = {
        [rail]=true, [patrolHatch]=true, [fixedCannon]=true, [heavyTank.step]=true,
        [twinAircraft.step]=true, [tripleAircraft.step]=true, [patrol42.step]=true, [ground98.step]=true,
        [largeVehicle.step]=true, [ground59.step]=true, [hover.step]=true, [raid.step]=true, [earlyVehicle.step]=true,
        [heavyHatch.step]=true, [breakawayTank.step]=true, [scenery.step]=true, [deckCarrier.step]=true,
        [platformCannon.step]=true, [risingTurret.step]=true, [linkedCannon.step]=true,
    }
    local parameterKind = {
        [0x0d08d2]=0x10, [0x0d0d42]=0x11, [0x0d0f80]=0x12, [0x0d124e]=0x13, [0x0d1504]=0x14,
        [0x0d1f46]=0x18, [0x0d2990]=0x1a,
        [0x0d1984]=0x16, [0x0d1c80]=0x17,
    }
    local groundKind = {[0x0d3cd4]=0x24, [0x0d4332]=0x25, [0x0eb8ca]=0x85, [0x0ec02e]=0x95,
        [0x0ec82e]=0x96, [0x0d4f20]=0x4c, [0x0d552e]=0x4d}

    local function readInto(data, offset, bytes)
        for i = 1, #bytes do data[offset + i - 1] = bytes:byte(i) end
    end

    local function initGround(o)
        local state, run = o.state, o.run
        local short = program.groundRank(run)
        if o.update == rail then
            if o.part[0x1e] == 0 then
                o.hp, state[0x28], state[0x29] = 0x2200, 0, 6
                for i = 0x20, 0x23 do state[i] = program.random(run, program.enemyRandom) end
                for i, value in ipairs({4,2,-2,0}) do
                    state[0x36 + i * 2], state[0x37 + i * 2] = band(bit.arshift(value, 8), 0xff), band(value, 0xff)
                end
            elseif run.stageNumber == 5 and o.part[0x1e] >= 0x80 then
                state[0x1c] = 0x20
            end
            state[0x2a] = state[0x2b]
            o.turn = band(program.random(run, program.randomParity), 1) == 1 and 2 or -2
            -- 0xca4cc 把 rank/4-rank/8 的截断结果写入 0x81246f，正是 0xe4f6a 读取的低字节。
            local _, delay = program.smallRank(run)
            state[0x2e], state[0x2f] = band(state[0x2e] - delay, 0xff), band(state[0x2f] - delay, 0xff)
            o.hatch, o.colorFrame = 0, 1
        elseif o.update == tankWithWreck then
            local _, _, rank = program.groundRank(run)
            state[0x18] = band(state[0x18] - rank + floor(program.random(run, program.enemyRandom) / 2), 0xff)
            state[0x1e] = band(state[0x1e] - floor(program.rank(run) / 16), 0xff)
            o.turret = o.direction
        elseif o.groundKind == 0x96 then
            local rank = program.rank(run)
            local tick = floor(rank / 8) + floor(rank / 16)
            local reload = tick + floor(rank / 16)
            state[0x1c], state[0x1d] = band(state[0x1c] - tick, 0xff), band(state[0x1d] - reload, 0xff)
            state[0x2a], state[0x2b] = band(state[0x2a] - tick, 0xff), band(state[0x2b] - reload, 0xff)
            o.hatch, o.hatchPhase, o.aimBarrel = 0, 0, 2
            o.barrels = {}
            for i = 1, 2 do
                local offset = i == 1 and 0x380 or -0x380
                o.barrels[i] = run.pilotH and program.angle(o.h - 0x200, o.l + offset,
                    run.pilotH, run.pilotL, o.direction) or o.direction
            end
        elseif o.groundKind == 0x95 then
            state[0x1a] = band(state[0x1a] - short + 4, 0xff)
            o.turret = 0
            if run.stageNumber == 5 then o.hp = 0x300 end
            o.wreckHp = run.stageNumber == 5 and 0x200 or word(state, 0x26)
        elseif o.groundKind == 0x85 then
            state[0x1a] = band(state[0x1a] - short + 4, 0xff)
            o.turret = aim(o, o.direction) or o.direction
        else
            state[0x18] = band(state[0x18] - short, 0xff)
            local rank = floor(program.rank(run) / 256)
            if o.groundKind == 0x24 then
                state[0x18] = band(state[0x18] + floor(program.random(run, program.enemyRandom) / 2), 0xff)
                state[0x1e] = band(state[0x1e] - rank, 0xff)
            else
                local count = floor((run.stageNumber - 1) / 2) + 2
                state[0x1c], state[0x1d] = count, count
                state[0x1f] = band(state[0x1f] - rank, 0xff)
            end
            o.turret = o.direction
        end
    end

    local function mirror(o)
        if band(o.kind, 0x20) == 0 then return end
        -- 0xae632 将这类敌机镜像到自机的另一侧。
        local pilotLeft = (o.run.pilotL or 0) < 0x1c00
        local enemyLeft = band(o.l + 0x800, 0xffff) < 0x2400
        if pilotLeft == enemyLeft then o.l = s16(0x3800 - o.l) end
    end

    local function renderSprite(o, id, h, l, scaleX, scaleY, atlas)
        local image = id and (atlas or o.run.art.sprites)[id]
        if image then
            Render(image[1], floor((o.l + l) / 64) - 112 + image[2] * (scaleX or 1) / 2,
                floor((o.h + h) / 64) - 224 + image[3] * (scaleY or 1) / 2,
                0, scaleX or 1, scaleY or 1)
        end
    end

    local patrolScale = {}
    for i = 0, 7 do
        local mask, scale = patrol.zoom[i == 0 and 1 or 17 - i], 32
        for bitIndex = 0, 31 do scale = scale - band(bit.rshift(mask, bitIndex), 1) end
        patrolScale[i] = scale / 32
    end

    local function damage(o, value, kind)
        local required = kind == 'body' and 0x8001 or 0xa000
        if band(o.flags, required) ~= required or o.hp < 0 then return end
        o.hp = o.hp - value
        o.flags = bor(o.flags, kind == 'bomb' and 0x4000 or 0x1000)
    end

    local GunshipPart = Class(object, {
        init = function(p, o, source)
            p.run, p.h, p.l, p.hitPool = o.run, o.h, o.l, o.hitPool
            p.group, p.layer, p.bound, p.colli = GROUP.ENEMY, LAYER.ENEMY, false, false
            p.flags, p.hp, p.damage = word(source, 1), word(source, 21), damage
            p.front, p.back, p.right, p.left = word(source, 13), word(source, 15), word(source, 17), word(source, 19)
        end,
    })

    local Enemy = Class(object, {
        init = function(o, run, slot, row)
            o.run, o.slot, o.kind, o.spawnFlags = run, slot, row[3], row[4]
            o.movementKind = parameterKind[row[10]]
            o.groundKind = groundKind[row[10]]
            o.update, o.damage = controllers[row[10]], damage
            o.ground = o.update == rail and program.rail or program.ground[o.groundKind]
            o.group, o.layer = GROUP.ENEMY, LAYER.ENEMY
            o.bound, o.colli, o.rect = false, false, true
            o.state, o.part = {}, {}
            o.hatchData = o.update == patrolHatch and hatchPatrol[o.kind] or nil
            o.aircraftData = o.update == tripleAircraft.step and program.tripleAircraft[o.kind] or nil
            local definition = o.ground or o.hatchData or o.aircraftData or (o.update == fixedCannon and cannonData)
                or (o.update == heavyTank.step and program.heavyTank)
                or (o.update == twinAircraft.step and program.twinAircraft)
                or (o.update == patrol42.step and program.patrol42)
                or (o.update == ground98.step and program.ground98)
                or (o.update == largeVehicle.step and program.largeVehicle[o.kind])
                or (o.update == ground59.step and program.ground59)
                or (o.update == hover.step and program.hover[o.kind])
                or (o.update == raid.step and (program.raid[o.kind] or program.raid))
                or (o.update == earlyVehicle.step and program.earlyVehicle[o.kind])
                or (o.update == heavyHatch.step and program.heavyHatch[o.kind])
                or (o.update == breakawayTank.step and program.breakawayTank[o.kind])
                or (o.update == scenery.step and program.scenery[o.kind])
                or (o.update == deckCarrier.step and program.deckCarrier)
                or (o.update == platformCannon.step and program.platformCannon)
                or (o.update == risingTurret.step and program.risingTurret[o.kind])
                or (o.update == linkedCannon.step and program.linkedCannon[o.kind])
                or (o.update == patrol43 and patrol) or (o.update == patrolTransport and patrol2a)
            local partData = definition and definition.part or program.smallParts[o.movementKind]
            readInto(o.state, 0x16, definition and definition.state or program.small[o.movementKind])
            readInto(o.part, 0, partData:sub(1,2))
            readInto(o.part, 6, partData:sub(3))
            o.flags, o.hp, o.speed = word(o.part, 0), word(o.part, 0x18), o.part[0x1a]
            o.hitPool = band(o.spawnFlags, 0xa0) == 0 and 1 or 2
            o.front, o.back = word(o.part, 0x10), word(o.part, 0x12)
            o.right, o.left = word(o.part, 0x14), word(o.part, 0x16)
            o.a, o.b = (o.right + o.left) / 128, (o.front + o.back) / 128
            o.active = o.kind == 0x9e or path.init(o, row)
            local lock = run.largeVehicleLock or (run.ground59Locks and run.ground59Locks[1])
            if run.stageNumber == 5 and lock and (o.update == ground98.step or o.kind == 0x1a
                or o.kind == 0x1c or o.kind == 0x1d) then o.active = false end
            -- 0xd3be0 与 0xd86f6 在二面读同一字，路径参数 1 才使用双舱飞机的占位标志。
            if run.stageNumber == 2 and run.patrol42Block and o.state[0x36] == 1
                and (o.groundKind == 0x24 or o.kind == 0x28) then o.active = false end
            if o.active then
                if o.ground then
                    if o.groundKind == 0x4c and run.stageNumber == 3 and run.minor >= 1 and run.bossEngaged then
                        o.active = false
                    else
                        initGround(o)
                        if o.ground.second then
                            o.second = New(GunshipPart, o, o.ground.second)
                            o.attachments = {o.second}
                        end
                    end
                elseif o.update == heavyTank.step then
                    o.attachments = {}
                    for i, source in ipairs(definition.second) do o.attachments[i] = New(GunshipPart,o,source) end
                    heavyTank.init(o)
                elseif o.update == ground98.step then
                    o.attachments = {}
                    for i, source in ipairs(definition.second) do o.attachments[i] = New(GunshipPart,o,source) end
                    ground98.init(o)
                elseif o.update == largeVehicle.step then
                    largeVehicle.init(o)
                elseif o.update == ground59.step then
                    o.attachments = {New(GunshipPart,o,definition.second)}
                    ground59.init(o)
                elseif o.update == hover.step then
                    o.active = path.step(o)
                    if o.active then
                        o.attachments = {New(GunshipPart,o,definition.second)}
                        hover.init(o)
                    end
                elseif o.update == raid.step then
                    raid.init(o)
                elseif o.update == earlyVehicle.step then
                    if definition.second then
                        o.attachments = {}
                        for i, source in ipairs(definition.second) do o.attachments[i] = New(GunshipPart,o,source) end
                    end
                    earlyVehicle.init(o)
                elseif o.update == heavyHatch.step then
                    heavyHatch.init(o)
                elseif o.update == breakawayTank.step then
                    breakawayTank.init(o)
                elseif o.update == scenery.step then
                    scenery.init(o)
                elseif o.update == deckCarrier.step then
                    o.attachments = {}
                    for i,source in ipairs(definition.second) do o.attachments[i]=New(GunshipPart,o,source) end
                    deckCarrier.init(o)
                elseif o.update == platformCannon.step then
                    platformCannon.init(o)
                elseif o.update == risingTurret.step then
                    risingTurret.init(o)
                elseif o.update == linkedCannon.step then
                    o.attachments = {}
                    for i,source in ipairs(definition.second) do o.attachments[i]=New(GunshipPart,o,source) end
                    linkedCannon.init(o)
                elseif o.update == twinAircraft.step then
                    o.attachments = {New(GunshipPart,o,definition.second)}
                    twinAircraft.init(o)
                elseif o.aircraftData then
                    if tripleAircraft.canSpawn(run,o.kind) then
                        o.attachments = {}
                        for i, source in ipairs(definition.second) do o.attachments[i] = New(GunshipPart,o,source) end
                        tripleAircraft.init(o)
                    else
                        o.active = false
                    end
                elseif o.update == patrol42.step then
                    o.active = patrol42.init(o)
                    if o.active then o.attachments = {New(GunshipPart,o,definition.second)} end
                elseif o.hatchData then
                    o.hatch, o.exhaust, o.colorFrame = 0, 0, 1
                    o.hatchArt = o.hatchData.sprites[run.stageNumber] or o.hatchData.sprites[1]
                    if o.kind == 0x28 then
                        if run.stageNumber == 3 then o.hp = 0xa00 end
                        if run.stageNumber == 1 and run.major >= 0x200 then o.hp = 0xd00 end
                    elseif o.kind == 0x27 and run.stageNumber == 5 then
                        o.hp,o.state[0x28],o.state[0x29] = 0x1000,3,3
                    end
                elseif o.update == fixedCannon then
                    o.turret, o.colorFrame, o.armorClock = 0x20, 1, word(o.state, 0x1c)
                elseif o.update == patrolTransport then
                    o.transportArt = patrol2a.stages[(run.stageNumber - 1) * 2 + o.kind - 0x29]
                    o.aimDirection, o.animation, o.drawFrame, o.colorFrame = o.state[0x1c], 0, 1, 1
                elseif o.update == patrol43 then
                    local tick = floor(program.rank(run) / 16)
                    local state = o.state
                    state[0x2a], state[0x2b] = state[0x2a] - tick, state[0x2b] - floor(tick / 2)
                    if run.stageNumber == 5 then
                        local early = run.major < 0x17a
                        state[0x2c], state[0x2d] = early and 4 or 3, early and 4 or 3
                        state[0x38], state[0x39] = early and 0 or 0xff, early and 1 or 0xff
                        state[0x3a], state[0x3b] = 0, 0xb
                    end
                    o.aimDirection, o.zoom, o.colorFrame = aim(o, o.direction) or o.direction, 0, 1
                else
                    local _, rank = program.smallRank(run)
                    o.state[0x18] = band(o.state[0x18] - rank + 8, 0xff)
                    o.returnDirection = band(o.direction + 0x20, 0x3c)
                    o.aimDirection = aim(o, o.direction) or 0x20
                    if o.movementKind == 0x18 then
                        o.active = path.step(o)
                        mirror(o)
                        o.aimDirection = o.direction
                        if band(o.h, 0xffff) < 0x7000 then o.state[0x18] = band(o.state[0x18] + 12, 0xff) end
                        if run.stageNumber == 5 then
                            o.state[0x32], o.state[0x33] = o.direction == 0x20 and 16 or 0, 2
                        end
                    elseif o.movementKind == 0x1a then
                        mirror(o)
                        o.animation = 2
                    elseif o.movementKind == 0x16 or o.movementKind == 0x17 then
                        mirror(o)
                        o.aimDirection = aim(o, o.direction) or 0x20
                    end
                end
            end
            o.x, o.y = program.world(o.h, o.l)
        end,
        render = function(o)
            -- 对象回收在 AfterFrame，撤销分配的对象在这一帧仍可能收到绘制回调。
            if not o.active then return end
            if o.update == patrolTransport then
                local art, atlas = o.transportArt, o.run.art.transport
                renderSprite(o, art.body[o.colorFrame][o.drawFrame], -0x1000, -0x900, 1, 1, atlas)
                local angle = floor(o.aimDirection / 2) + 1
                renderSprite(o, art.turret[o.colorFrame][angle], -0xf80, -0x200, 1, 1, atlas)
                if o.run.route.loop == 0 and o.run.frame % 2 == 1 then
                    renderSprite(o, art.marker[1][1], -0x1c00, 0x400, 1, 1, atlas)
                end
            elseif o.ground then
                local ground = o.ground
                if o.update == rail then
                    local art = ground.art[o.run.stageNumber][o.colorFrame]
                    renderSprite(o, art.hull[o.hatch + 1], -0xc00, -0xa00)
                    for i, pivot in ipairs(railPivots) do
                        local index = band(o.state[0x1f + i], 0x3e) / 2 + 1
                        renderSprite(o, art.gun[index], pivot[1] - 0x200, pivot[2] - 0x300)
                    end
                    return
                elseif o.groundKind == 0x96 then
                    renderSprite(o, ground.hull, -0xa00, -0x800)
                    renderSprite(o, ground.body[o.hatch + 1], -0xa00, -0x200)
                    for i, angle in ipairs(o.barrels) do
                        renderSprite(o, ground.turret[band(angle, 0x3e) / 2 + 1], -0x500,
                            i == 1 and 0x200 or -0x500)
                    end
                    return
                elseif o.groundKind == 0x95 then
                    if o.damaged then
                        renderSprite(o, program.heavyTurretWreck, -0x800, -0x600)
                    else
                        renderSprite(o, ground.turret[band(o.turret, 0x3e) / 2 + 1], -0xa00, -0x700)
                    end
                    return
                elseif o.update == tankWithWreck then
                    local bodyFrame = (drawIndex(o) - 1) * 2 + (o.direction < 0x40 and floor(o.run.frame / 4) % 2 or 0) + 1
                    renderSprite(o, ground.body[bodyFrame], s16(word(o.part, 6)), s16(word(o.part, 8)))
                    if o.damaged then
                        if o.run.frame % 2 == 1 then renderSprite(o, ground.flame[o.flame + 1], 0x300, -0x200) end
                    else
                        local offset = ground.pivot[drawIndex(o)]
                        local index = band(o.turret, 0x3e) / 2 + 1
                        renderSprite(o, ground.turret[index], offset[1] - 0x400, offset[2] - 0x500)
                    end
                    return
                end
                local bodyFrame = (drawIndex(o) - 1) * 2 + floor(o.run.frame / 4) % 2 + 1
                renderSprite(o, ground.body[bodyFrame], s16(word(o.part, 6)), s16(word(o.part, 8)))
                local h, l = 0, 0
                if o.groundKind == 0x24 then l = -0x600 end
                if o.groundKind == 0x25 then h, l = -0x300, -0x700 end
                if o.groundKind == 0x85 then h, l = -0x800, -0x600 end
                renderSprite(o, ground.turret[band(o.turret, 0x3e) / 2 + 1], h, l)
            elseif o.update == heavyTank.step then
                heavyTank.render(o,renderSprite)
            elseif o.update == ground98.step then
                ground98.render(o,renderSprite)
            elseif o.update == largeVehicle.step then
                largeVehicle.render(o,renderSprite)
            elseif o.update == ground59.step then
                ground59.render(o,renderSprite)
            elseif o.update == hover.step then
                hover.render(o,renderSprite)
            elseif o.update == raid.step then
                raid.render(o,renderSprite)
            elseif o.update == earlyVehicle.step then
                earlyVehicle.render(o,renderSprite)
            elseif o.update == heavyHatch.step then
                heavyHatch.render(o,renderSprite)
            elseif o.update == breakawayTank.step then
                breakawayTank.render(o,renderSprite)
            elseif o.update == scenery.step then
                scenery.render(o,renderSprite)
            elseif o.update == deckCarrier.step then
                deckCarrier.render(o,renderSprite)
            elseif o.update == platformCannon.step then
                platformCannon.render(o,renderSprite)
            elseif o.update == risingTurret.step then
                risingTurret.render(o,renderSprite)
            elseif o.update == linkedCannon.step then
                linkedCannon.render(o,renderSprite)
            elseif o.update == twinAircraft.step then
                twinAircraft.render(o,renderSprite)
            elseif o.aircraftData then
                tripleAircraft.render(o,renderSprite)
            elseif o.update == patrol42.step then
                patrol42.render(o,renderSprite)
            elseif o.hatchData then
                local art = o.hatchArt[o.colorFrame]
                local offsets = o.hatchData.offsets
                renderSprite(o,art[o.hatch+1],offsets[1],offsets[2])
                renderSprite(o,art[o.exhaust+9],offsets[3],offsets[4])
            elseif o.update == fixedCannon then
                renderSprite(o, cannonData.sprites[o.colorFrame][band(o.turret,0x3e)/2+1],
                    s16(word(o.part,6)), s16(word(o.part,8)))
            elseif o.update == patrol43 then
                local image = patrol.stages[o.run.stageNumber][band(o.aimDirection, 0x3e) / 2 + 1]
                local scale = patrolScale[o.zoom]
                local sprite = o.run.art.sprites[image[o.colorFrame]]
                local h, l = program.add(o.h, o.l, image[4], image[5])
                local zoomH = floor(sprite[3] / 8) * o.zoom * 8
                local zoomL = floor(sprite[2] / 8) * o.zoom * 8
                renderSprite(o, image[o.colorFrame], s16(h - o.h + zoomH), s16(l - o.l + zoomL), scale, scale)
                if not o.crashing and o.run.frame % 2 == 1 then
                    renderSprite(o, patrol.exhaust[o.run.stageNumber][floor(o.run.frame / 2) % 4 + 1], -0x800, -0x700)
                end
            elseif o.movementKind == 0x18 then
                local bank = o.run.stageNumber <= 2 and 1 or o.run.stageNumber <= 4 and 2 or 3
                renderSprite(o, program.burstArt[bank][band(o.aimDirection, 0x3e) / 2 + 1],
                    s16(word(o.part, 6)), s16(word(o.part, 8)))
            elseif o.movementKind == 0x1a then
                renderSprite(o, program.rearShotArt[drawIndex(o)][o.animation],
                    s16(word(o.part, 6)), s16(word(o.part, 8)))
            elseif o.movementKind == 0x14 or o.movementKind == 0x16 or o.movementKind == 0x17 then
                renderSprite(o, program.smallArt[band(o.aimDirection, 0x3e) / 2 + 1],
                    s16(word(o.part, 6)), s16(word(o.part, 8)))
            else
                renderSprite(o, program.smallArt[drawIndex(o)], s16(word(o.part, 6)), s16(word(o.part, 8)))
            end
        end,
    })
    M.class = Enemy

    function M.supports(row)
        return controllers[row[10]] ~= nil
    end

    function M.spawn(run, row)
        for slot = 11, 58 do
            if not run.enemies[slot] and not (run.boss2 and run.boss2.children[slot - 10]) then
                local o = New(Enemy, run, slot, row)
                if o.active then run.enemies[slot] = o else object.RawDel(o) end
                return o
            end
        end
    end

    function M.step(run)
        for slot = 11, 58 do
            local o = run.enemies[slot]
            if o then
                if not ownDamage[o.update] then
                    o.flags = band(o.flags, 0xa7ff)
                end
                if o.second and math.min(o.hp, o.second.hp) < 0 then
                    score.kill(score.source(o,o.attachments),0x2a8,-0x800,nil,o)
                    retireGunship(o)
                    if run.onEnemyDeath then run.onEnemyDeath(o) end
                    remove(o)
                elseif o.update == tankWithWreck or ownDamage[o.update] then
                    if band(o.spawnFlags, 0x40) == 0 then o.l = s16(o.l - run.cameraStep) end
                    if not run.freeze or duringFreeze[o.update] then o.update(o) end
                    if run.enemies[slot] then o.x, o.y = program.world(o.h, o.l) end
                elseif o.hp < 0 and o.ground and not o.damaged then
                    if o.groundKind == 0x24 or o.groundKind == 0x25 then
                        score.base(o,o.groundKind==0x24 and 0x3c or 0xa0)
                    elseif o.groundKind == 0x85 or o.groundKind == 0x95 then
                        score.kill(o,o.groundKind==0x85 and 0x50 or 0xb4)
                        effects.spawn(run,o.h,o.l,{{0,0x84,0,-0x200,-0x200,0,0}},true,true)
                    end
                    o.damaged = true
                    o.hp = o.wreckHp or (o.groundKind == 0x85 and 0x200 or word(o.state, 0x28))
                elseif o.hp < 0 then
                    if o.groundKind == 0x24 or o.groundKind == 0x25 then
                        local light = o.groundKind == 0x24
                        score.kill(o,light and 0x64 or 0xa0)
                        effects.spawn(run,o.h,o.l,{{0,light and 7 or 4,0,light and 0x100 or -0x200,0,0,0}},true,true)
                    elseif o.groundKind == 0x85 or o.groundKind == 0x95 then
                        score.kill(o,o.groundKind==0x85 and 0x50 or 0xb4)
                    end
                    if o.movementKind == 0x1a then retireRearShot(o) end
                    -- 0xd08fc 等回调共用 0xa0，0xd1f7a 则从爆炸前缘结算。
                    if o.movementKind then
                        local burst = o.movementKind == 0x18
                        score.kill(o,burst and 0x118 or 0xa0,burst and -0x800 or 0)
                        if run.player or o.movementKind == 0x14 then
                            local kind = burst and 0x84 or 2
                            if o.movementKind == 0x1a and (run.route.loop == 1
                                or run.stageNumber == 5 and run.minor == 0x48 and run.major >= 0x1a2) then
                                kind = 0xa
                            end
                            effects.spawn(run,o.h,o.l,{{0,kind,0,0,0,o.speed+8,o.direction*4}},
                                false,true)
                        end
                    end
                    if run.onEnemyDeath then run.onEnemyDeath(o) end
                    remove(o)
                else
                    if o.second then
                        o.hp = math.min(o.hp, o.second.hp)
                        o.second.hp, o.second.flags = o.hp, band(o.second.flags, 0xa7ff)
                    end
                    if band(o.spawnFlags, 0x40) == 0 then o.l = s16(o.l - run.cameraStep) end
                    local h = band(o.h + 0x600, 0xffff)
                    local l = band(o.l + 0xe00 + run.cameraOffset, 0xffff)
                    local onscreen = h < 0x7c00 and l < 0x5400
                    if not o.ground and not onscreen and o.entered then
                        remove(o)
                    else
                        if not o.ground then o.entered = o.entered or onscreen end
                        if not run.freeze then o.update(o) end
                        if run.enemies[slot] then o.x, o.y = program.world(o.h, o.l) end
                    end
                end
            end
        end
    end

    function M.touch(run, h, l, front, back, right, left, pool)
        local function touch(o)
            if o and o.hitPool == pool and band(o.flags, 0x8001) == 0x8001
                and band(o.h + 0x2800 - o.back, 0xffff) < 0xf800
                and program.overlap(o, h, l, front, back, right, left) then
                damage(o, 1, 'body')
                return o
            end
        end
        for slot = 11, 58 do
            local o = run.enemies[slot]
            local part = touch(o)
            if part then return part end
            if o and o.attachments then
                for _, attachment in ipairs(o.attachments) do
                    local attached = touch(attachment)
                    if attached then return attached end
                end
            end
        end
    end

    function M.clear(run)
        for _, o in pairs(run.enemies) do remove(o) end
    end
    return M
end
