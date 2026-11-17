-- 0xb562c 的输入状态与 0xbb7d2 的自机弹槽。坐标沿用原程序的两条 1/64 像素轴。
return function(program, enemyBullets, items, display)
    local bit = require('bit')
    local band = bit.band
    local floor, min, max = math.floor, math.min, math.max
    local s16, word = program.s16, program.word
    local data = program.player
    local M = {}
    local deathFrames, missFrames = 32, 66

    local function draw(o, sprite, h, l, mirror)
        if not sprite then return end
        local image = o.run.art.sprites[sprite]
        Render(image[1], floor((o.l + l) / 64) - 112 + image[2] / 2,
            floor((o.h + h) / 64) - 224 + image[3] / 2, 0, mirror and -1 or 1, 1)
    end

    local function remove(o)
        o.pilot.shots[o.slot] = nil
        object.RawDel(o)
    end

    local function move(o, h, l)
        o.h, o.l = s16(o.h + h), s16(o.l + l)
        o.x, o.y = program.world(o.h, o.l)
    end

    local function randomHalf(run)
        return floor(program.random(run, data.jitter) / 2)
    end

    local impact
    local function flight(o)
        move(o, o.dh, o.dl)
        if band(o.h, 0xffff) >= 0x8000 or band(o.l + 0x400, 0xffff) >= 0x4000 then
            remove(o)
            return
        end
        o.sprite = o.motion[o.imageFrame]
        if o.chargeStep > 0 then
            o.imageFrame = (o.imageFrame - 2) % #o.motion + 1
        elseif o.imageFrame > 1 then
            o.imageFrame = o.imageFrame - 1
        end
    end

    local function hitFrame(o)
        o.imageFrame = o.imageFrame - 1
        if o.imageFrame == 0 then remove(o); return end
        if o.impactMoves then move(o, o.dh, o.dl) end
        o.sprite = o.motion[o.imageFrame]
    end

    local function retireShot(o)
        local offset = o.mode == 'lock' and -0x200 or 0
        local dh, dl = o.dh + randomHalf(o.run), o.dl + randomHalf(o.run)
        move(o, offset + dh, dl)
        return dh, dl
    end

    impact = function(o)
        local pilot = o.pilot
        local kind = o.chargeStep > 0 and (o.expired and 'lockFree' or 'lock') or o.mode
        local impactData = pilot.profile.hit[kind][o.level]
        local dh, dl = retireShot(o)
        o.drawH, o.drawL, o.motion = unpack(impactData)
        o.imageFrame = #o.motion
        o.impactMoves = kind ~= 'lockFree'
        local divisor = kind == 'lock' and 4 or 8
        o.dh, o.dl = floor(dh / divisor), floor(dl / divisor)
        o.update, o.damage, o.pendingHit = hitFrame, -1, false
        o.sprite = o.motion[o.imageFrame]
    end

    local function lockFlight(o)
        o.charge = o.charge + o.chargeStep
        if o.charge >= o.threshold - o.chargeStep * o.pilot.lockCount then
            o.expired = true
            impact(o)
        else
            flight(o)
        end
    end

    local function fireFrame(o)
        if not o.armed then
            o.armed = true
            return
        end
        local p = o.pilot
        if o.mode == 'normal' then
            move(o, p.deltaH, p.deltaL)
        end
        o.dh, o.dl = program.vector(o.speed, o.angle)
        local fly = p.profile.fly[o.mode][o.level]
        o.drawH, o.drawL = fly[1], fly[2]
        if o.chargeStep == 0 and fly[4] then o.h = s16(o.h + fly[4]) end
        o.update = flight
        if o.chargeStep > 0 then
            o.update = lockFlight
            if p.model == 1 then lockFlight(o) else flight(o) end
        else
            flight(o)
        end
    end

    local Shot = Class(object, {
        init = function(o, p, slot, mode, shot, anchor, target)
            o.run, o.pilot, o.slot = p.run, p, slot
            o.mode, o.level, o.target = mode, p.level, target
            o.scoreLock = band(shot[1],0x1000) ~= 0
            o.group, o.layer = GROUP.PLAYER_BULLET, LAYER.PLAYER_BULLET
            o.colli, o.bound = false, false
            o.h, o.l = s16(anchor.h + shot[2]), s16(anchor.l + shot[3])
            o.drawH, o.drawL = shot[4], shot[5]
            o.front, o.back, o.damage, o.right, o.left = shot[6], shot[7], shot[8], shot[9], shot[9]
            o.speed, o.angle = shot[10], shot[11]
            o.motion, o.chargeStep, o.threshold = shot[13], shot[15], shot[16]
            o.imageFrame, o.charge, o.dh, o.dl = #o.motion, 0, 0, 0
            local flash = mode == 'normal' and p.hullFlash or mode == 'lock' and p.lockFlash or p.optionFlash
            o.sprite = shot[12][flash % #shot[12] + 1]
            o.mirror = mode == 'option' and band(shot[17], 0x4000) ~= 0
            if mode == 'optionLock' then
                local turn = floor(band(anchor.angle, 0xf8) / 8)
                local offset = shot[14][turn + 1]
                o.h, o.l, o.angle = s16(anchor.h + offset[1]), s16(anchor.l + offset[2]), anchor.angle
                o.mirror = band(o.angle + 2, 0xff) > 0x80
            end
            o.armed = mode == 'option' or mode == 'optionLock'
            o.update = fireFrame
            o.x, o.y = program.world(o.h, o.l)
        end,
        render = function(o)
            -- 锁定僚机的飞行图由持续光束绘制，炮口闪光和命中仍随弹槽播放。
            if o.mode ~= 'optionLock' or o.update ~= flight then
                draw(o, o.sprite, o.drawH, o.drawL, o.mirror)
            end
        end,
    })

    local function shoot(p, mode, shot, anchor, target, first, count)
        for slot = first, first + count - 1 do
            if not p.shots[slot] then
                p.shots[slot] = New(Shot, p, slot, mode, shot, anchor, target)
                return true
            end
        end
    end

    local function validTarget(o)
        if not IsValid(o) or o.broken or (o.hp or 0) < 0 then return false end
        if o.flags and band(o.flags, 0xa001) ~= 0xa001 then return false end
        return band(o.h, 0xffff) < 0x8000 and o.l > -0x1000 and o.l < 0x4800
    end

    local function lockOn(p, o)
        if not validTarget(o) then return end
        local available
        for i = 1, p.optionCount do
            if p.targets[i] == o then return end
            if not p.targets[i] and not available then available = i end
        end
        if available then p.targets[available] = o end
    end
    M.lockOn = lockOn

    local function turnOption(pod, angle)
        local delta = band(angle - pod.angle + 128, 0xff) - 128
        local rate = pod.index > 2 and 11 or 7
        pod.angle = band(pod.angle + max(-rate, min(rate, delta)), 0xff)
    end

    local function bombFrames(o, frames, nextState)
        o.clock = o.clock - 1
        if o.clock >= 0 then return end
        o.clock = o.interval
        o.imageFrame = o.imageFrame + 1
        local frame = frames[o.imageFrame]
        if frame then
            o.drawH, o.drawL, o.sprite = unpack(frame)
        else
            o.state, o.imageFrame = nextState, 0
        end
    end

    -- 0xbe580 先播放子机起爆，推进到边界后切换大范围爆炸和残余动画。
    local function bombStep(o)
        if not o.started then o.started = true else o.tick = o.tick + 1 end
        o.l = s16(o.l - o.run.cameraStep)
        if o.state == 0 then
            bombFrames(o, data.bomb[1], 1)
            if o.state == 1 then
                o.front, o.back, o.left, o.right = 0xc00, 0xc00, 0x800, 0x800
                o.damage = 2
                o.drawH, o.drawL, o.imageFrame = -0x600, -0x400, 16
            end
        end
        if o.state == 1 then
            local dh, dl = program.vector(o.speed, o.angle)
            move(o, dh, dl)
            local wall = o.l <= 0 and o.angle >= 0x80 or o.l >= 0x3800 and o.angle < 0x80
            if wall and o.bounces > 0 then
                o.angle = band(-o.angle, 0xff)
                o.bounces, wall = o.bounces - 1, false
            end
            o.sprite = data.bomb[4][o.imageFrame][1]
            o.imageFrame = (o.imageFrame - 2) % 16 + 1
            if wall or band(o.h, 0xffff) >= 0x7000 or o.h <= 0x200 then
                o.state, o.imageFrame, o.interval, o.clock = 2, 0, 0, 0
                o.damage = 0x20
                o.front, o.back, o.left, o.right = 0x1600, 0x1600, 0x1000, 0x1000
            end
        end
        if o.state == 2 then
            bombFrames(o, data.bomb[2], 3)
            if o.state == 3 then
                o.drawH, o.drawL = -0x1400, -0xf00
                o.front, o.back, o.life, o.damage = 0x1400, 0x1400, 5, 0x70
                o.speed = floor(o.speed / 16)
            end
        end
        if o.state == 3 then
            local dh, dl = program.vector(o.speed, o.angle)
            move(o, dh, dl)
            if o.tick % 2 == 0 then
                local run = o.run
                local jh = program.random(run, program.randomSign) == 0 and -0x40 or 0x40
                local jl = program.random(run, program.randomSign) == 0 and -0x40 or 0x40
                move(o, jh, jl)
                o.sprite = data.bomb[5][8 - o.imageFrame][1]
                o.imageFrame = (o.imageFrame + 1) % 8
                if o.imageFrame == 0 then o.life = o.life - 1 end
                if o.life == 0 then o.state, o.interval, o.clock, o.imageFrame, o.damage = 4, 0, 0, 0, 0x10 end
            end
        elseif o.state == 4 then
            bombFrames(o, data.bomb[3], 5)
        end
        if o.state ~= 5 then
            enemyBullets.clearBox(o.run, o.h, o.l, o.front, o.back, o.right, o.left)
            if o.run.bombHit then o.run.bombHit(o.run, o) end
        end
    end

    local Bomb = Class(object, {
        init = function(o, p, pod)
            o.run, o.pilot = p.run, p
            o.group, o.layer, o.colli, o.bound = GROUP.GHOST, LAYER.PLAYER_BULLET, false, false
            o.h, o.l = p.h + floor((pod.h - p.h) * 9 / 8), p.l + floor((pod.l - p.l) * 9 / 8)
            o.angle, o.speed = pod.angle, pod.index <= 2 and 0x40 or 0x38
            o.front, o.back, o.left, o.right, o.damage = 0x1000, 0x1000, 0xa00, 0xa00, 0x30
            o.state, o.imageFrame, o.interval, o.clock = 0, 0, 0, 0
            o.bounces, o.tick = 1, 0
            o.x, o.y = program.world(o.h, o.l)
        end,
        render = function(o) draw(o, o.sprite, o.drawH, o.drawL) end,
    })

    local function updateBomb(p, pressed)
        if pressed and not p.bombHeld and p.bombs > 0 and not next(p.bombObjects) then
            p.bombs, p.protect = p.bombs - 1, 0xff
            p.clearHitbox = true
            p.run.bombsUsed = (p.run.bombsUsed or 0) + 1
            p.bombsUsed = min(99,p.bombsUsed+1)
            enemyBullets.clear(p.run)
            for i = 1, p.optionCount do p.bombObjects[i] = New(Bomb, p, p.options[i]) end
        end
        p.bombHeld = pressed
        local wasActive = next(p.bombObjects) ~= nil
        for index = 1, 4 do
            local bomb = p.bombObjects[index]
            if bomb then
                bombStep(bomb)
                if bomb.state == 5 then
                    p.bombObjects[index] = nil
                    object.RawDel(bomb)
                end
            end
        end
        if wasActive and not next(p.bombObjects) then p.protect = 0x5a end
    end

    local function optionAimL(pod, target)
        local gap = pod.index > 2 and 0x300 or 0x1c0
        local dl = pod.index % 2 == 1 and min(gap, target.left) or -min(gap, target.right)
        return target.l - dl
    end

    local function positionOption(pod)
        local p = pod.pilot
        local target = p.targets[pod.index]
        if target and not validTarget(target) then
            p.targets[pod.index], target = nil, nil
        end
        if p.inputShoot then
            pod.deployDelay = max(0, pod.deployDelay - 1)
            if pod.deployDelay == 0 and (pod.index < 3 or p.locked) then
                if target then
                    turnOption(pod, program.aimByte(pod.h, pod.l, target.h, optionAimL(pod,target), pod.angle, true))
                end
                pod.deploy = min(16, pod.deploy + 1)
            end
        else
            pod.deployDelay = 10
            pod.deploy = max(0, pod.deploy - 1)
            turnOption(pod, pod.restAngle)
        end
        local dh, dl = program.optionVector(pod.radius, pod.radial)
        local oh, ol = program.optionVector(pod.deploy * 7, pod.extendAngle)
        pod.h, pod.l = s16(p.h + pod.baseH + dh + oh), s16(p.l + dl + ol)
        pod.x, pod.y = program.world(pod.h, pod.l)
        local orientation = band(floor(band(pod.angle + 2, 0xff) / 4), 0x3e) / 2
        pod.sprite = display.options[p.model][orientation + 1][pod.animation]
        pod.animationClock = pod.animationClock - 1
        if pod.animationClock < 0 then
            pod.animationClock = pod.animationInterval
            pod.animation = (pod.animation - 2) % pod.frames + 1
        end
    end

    local Option = Class(object, {
        init = function(o, pilot, index)
            o.pilot, o.run, o.index = pilot, pilot.run, index
            o.group, o.layer, o.colli, o.bound = GROUP.GHOST, LAYER.PLAYER, false, false
            local params = pilot.profile.optionParams
            o.radial, o.extendAngle, o.restAngle = params:byte(6 + index),
                params:byte(20 + index), params:byte(24 + index)
            o.drawH, o.drawL, o.baseH = s16(word(params, 1)), s16(word(params, 3)), s16(word(params, 29))
            o.animationInterval, o.frames = params:byte(12), word(params, 13) / 4 + 1
            o.h, o.l, o.radius, o.angle = pilot.h, pilot.l, 0, o.restAngle
            o.animation, o.animationClock, o.deployDelay, o.deploy = o.frames, 0, 10, 0
        end,
        render = function(o)
            local p = o.pilot
            if not o.sprite or o.index > p.optionCount or p.respawn > 0 then return end
            local target = p.targets[o.index]
            local run = p.run
            local tx, ty
            if target and p.locked and not (run.stageEnding or run.stageCleared or run.practiceComplete or next(p.bombObjects))
                and validTarget(target) and target.colli and target.lockable ~= false then
                -- 在绘制时读两端坐标，使移动、卷轴和换相都使用本帧的位置。
                tx, ty = program.world(target.h, optionAimL(o,target))
            end
            display.option(o, tx, ty)
        end,
    })

    local function fireOptions(p, rising, pulse)
        local repeating = p.optionRepeating
        p.optionRepeating = false
        if p.locked then
            p.optionRepeat = p.optionRepeat - 1
            if p.optionRepeat >= 0 then return end
            p.optionRepeat = 0
        elseif pulse then
            p.optionBurst = 0
        elseif rising then
            p.optionBurst = p.level - 1 + p.optionTrail
            if repeating then p.optionDelay = 1; return end
        elseif p.optionBurst > 0 then
            p.optionDelay = p.optionDelay - 1
            if p.optionDelay ~= 0 then return end
            p.optionBurst = p.optionBurst - 1
            p.optionRepeating = true
        else
            return
        end
        if pulse and not p.locked then p.optionRepeating = true end
        p.optionDelay = p.level == 5 and 2 or p.optionInterval
        local mode = p.locked and 'optionLock' or 'option'
        for i = 1, p.optionCount do
            local pod, target = p.options[i], p.targets[i]
            if not p.locked then
                shoot(p, mode, p.profile.optionShot[p.level][i], pod, nil, (i - 1) * 7 + 1,
                    p.profile.optionShotLimit[p.level] + 1)
            elseif target then
                local direction = floor(band(pod.angle + 2, 0xff) / 4) % 32
                direction = direction <= 16 and direction or 32 - direction
                shoot(p, mode, p.profile.optionLock[p.level][direction + 1], pod, target, (i - 1) * 7 + 1, 7)
            end
        end
        p.optionFlash = p.optionFlash + 1
    end

    local function fireHull(p, rising, pulse)
        local repeating = p.hullRepeating
        p.hullRepeating = false
        if p.locked then
            p.hullBurst = 0
            p.lockDelay = p.lockDelay - 1
            if p.lockDelay >= 0 then return end
            p.lockDelay = 1
        elseif pulse then
            p.hullBurst = 0
            p.hullRepeating = true
        elseif rising then
            p.hullBurst = 2 * floor((p.level - 1) / 2) + p.hullTrail
            if repeating then p.hullDelay = 1; return end
        elseif p.hullBurst > 0 then
            p.hullDelay = p.hullDelay - 1
            if p.hullDelay ~= 0 then return end
            p.hullBurst = p.hullBurst - 1
            p.hullRepeating = true
        else
            return
        end
        p.hullDelay = p.level == 5 and 2 or p.hullInterval
        if p.locked then
            local slots = 14
            for i = 1, p.optionCount do
                if p.targets[i] then slots = slots - (i <= 2 and 2 or 1) end
            end
            if shoot(p, 'lock', p.profile.lock[p.level], p, nil, 29, slots) then p.lockFlash = p.lockFlash + 1 end
        else
            if shoot(p, 'normal', p.profile.normal[p.level], p, nil, 29, p.profile.shotLimit[p.level]) then
                p.hullFlash = p.hullFlash + 1
            elseif p.level < 5 then
                p.hullBurst, p.hullRepeating = 0, false
            end
        end
    end

    local function movePilot(p, keys)
        local direction = (keys.up and 1 or 0) + (keys.down and 2 or 0)
            + (keys.left and 4 or 0) + (keys.right and 8 or 0)
        local angle = data.directions:byte(direction + 1)
        local h, l, turn = p.h, p.l, p.turn
        if angle < 0x80 and not p.run.freeze then
            local dh, dl = program.vector(p.speed, angle * 4)
            p.h, p.l = max(0x900, min(0x6500, h + dh)), max(0x300, min(0x3500, l + dl))
        end
        p.deltaH, p.deltaL = p.h - h, p.l - l
        if angle >= 0x80 or band(direction, 12) == 0 then
            p.turn = turn < 0 and turn + 1 or max(0, turn - 1)
        elseif p.turnDelay == 0 then
            p.turnDelay = 2
            p.turn = max(-8, min(8, turn + (band(direction, 4) ~= 0 and -1 or 1)))
        else
            p.turnDelay = p.turnDelay - 1
        end
    end

    local Player = Class(object, {
        init = function(p, run, model, options)
            p.run, p.model, p.profile = run, model, data[model]
            p.group, p.layer, p.colli, p.bound = GROUP.PLAYER, LAYER.PLAYER, false, false
            p.h, p.l = options.h or 0x0de4, options.l or 0x0f80
            p.front, p.back, p.right, p.left = 0xc0, 0xc0, 0x80, 0x80
            p.life = options.life or program.item.initialLives[(options.lifeSetting or 0) + 1]
            p.bombs = options.bombs or 3
            p.score, p.extends, p.extendSetting = options.score or 0, options.extends or 0, options.extendSetting or 0
            p.misses, p.bombsUsed = options.misses or 0, options.bombsUsed or 0
            p.level = options.level or 1
            p.key, p.protect, p.respawn = options.keys, options.protect or 0xf0, 0
            p.shieldFrame = 0
            p.autofireEnabled, p.legacyInput = options.autofireEnabled ~= false, options.legacyInput
            p.clearHitbox = p.protect > 0
            p.deltaH, p.deltaL, p.turn, p.turnDelay = 0, 0, 0, 0
            p.inputShoot, p.locked, p.held = false, false, 0x19
            p.firing = false
            p.baseSpeed, p.lockSpeed, p.hullInterval, p.hullTrail = unpack(p.profile.profile)
            p.speed = p.baseSpeed
            p.slowDelay = 1
            p.optionCount, p.lockCount = p.level > 2 and 4 or 2, 0
            p.hullFlash, p.lockFlash, p.optionFlash = 0, 0, 0
            p.hullBurst, p.hullDelay, p.lockDelay, p.optionBurst, p.optionDelay, p.optionRepeat = 0, 0, 0, 0, 0, 0
            p.optionInterval, p.optionTrail = p.profile.optionParams:byte(31, 32)
            p.shots, p.targets, p.options, p.bombObjects = {}, {}, {}, {}
            p.x, p.y = program.world(p.h, p.l)
            for i = 1, 4 do p.options[i] = New(Option, p, i) end
        end,
        frame = function(p)
            -- 整关练习的通关提示需要玩家移动确认，此时关卡滚屏已停止。
            if p.run.moveAfterClear then
                local keys = p.key or KeyState
                if keys then
                    movePilot(p, keys)
                    p.x, p.y = program.world(p.h, p.l)
                    for _, pod in ipairs(p.options) do positionOption(pod) end
                end
            end
        end,
        render = function(p)
            if p.respawn > 0 then
                local row = data.death[missFrames-p.respawn+1]
                if row then draw(p,row[1],row[2],row[3]) end
                return
            end
            if p.protect > 0 then display.shield(p) end
            display.hull(p)
        end,
    })

    function M.spawn(run, model, options)
        assert(data[model], '未知绊地狱机体')
        return New(Player, run, model, options or {})
    end

    function M.weaponsStep(p)
        for i = 1, 42 do
            local shot = p.shots[i]
            if shot then
                shot.l = s16(shot.l - p.run.cameraStep)
                if shot.pendingHit then impact(shot) else shot.update(shot) end
                if shot.mode == 'optionLock' and not validTarget(shot.target) then shot.damage = -1 end
            end
        end
    end

    function M.step(p, hit)
        if p.defeated then return end
        if hit and p.protect == 0 then
            -- 0xb5e36 切入坠毁图表。0xb5f24 在图表结束后另等 0x20 帧。
            p.respawn, p.targets, p.locked = missFrames, {}, false
            -- 0xb5ece 读取备用残机和武器等级。末机掉大火力，其余掉小火力。
            if p.life == 0 then
                items.spawn(p.run, 4, p.h, p.l)
            else
                local count = floor((p.misses + 2*(p.level - 1)) / 2)
                p.misses = p.misses + 1
                for _ = 1, count do items.spawn(p.run, 0, p.h, p.l) end
            end
            p.level, p.run.weaponRank = 1, 0
            p.run.playerDeaths = (p.run.playerDeaths or 0) + 1
            return
        end
        if p.respawn > 0 then
            p.respawn = p.respawn - 1
            if p.respawn == missFrames-deathFrames-0x20 then
                -- 0xc9b5e 在坠毁结束后扣残机，同时登记 0x78 帧停止发弹。
                p.life = p.life - 1
                p.defeated = p.life < 0
                p.run.missShotDelay = 0x78
            end
            if p.respawn == 0 then
                p.h, p.l, p.protect, p.bombs = 0x1000,0x0e00,0xf0,3
                p.x, p.y = program.world(p.h, p.l)
                p.clearHitbox = true
                p.held,p.inputShoot,p.speed,p.slowDelay = 0x19,false,p.baseSpeed,1
                p.turn,p.turnDelay,p.optionCount = 0,0,2
                p.bombHeld,p.firing,p.hullRepeating,p.optionRepeating = false,false,false,false
                p.hullBurst,p.hullDelay,p.lockDelay = 0,0,0
                p.optionBurst,p.optionDelay,p.optionRepeat = 0,0,0
                for _, pod in ipairs(p.options) do pod.radius = 0 end
            end
            return
        end
        if p.protect ~= 0xff then p.protect = max(0, p.protect - 1) end
        p.shieldFrame = p.protect > 0 and p.shieldFrame+1 or 0
        p.clearHitbox = p.protect > 0
        local keys = p.key or KeyState
        if not keys then return end
        movePilot(p, keys)
        local ending = p.run.stageEnding
        local shot, auto = keys.slow, keys.shoot
        if p.legacyInput then shot, auto = keys.shoot, keys.special end
        local pressed = not ending and not not shot
        local rising = pressed and not p.inputShoot
        -- Z 对应原版 C。0xb5986 每两帧产生一次射击沿，锁定与展开由 Shift 对应的 A 键计时。
        local pulse = not ending and p.autofireEnabled and auto and not p.firing
        p.inputShoot = pressed
        if pressed then
            if p.held > 0 then
                p.held = p.held - 1
                if p.held == 0 then p.locked, p.targets = true, {} end
            else
                if p.slowDelay == 0 then
                    p.speed = max(p.lockSpeed, p.speed - 1)
                    p.slowDelay = 1
                else
                    p.slowDelay = p.slowDelay - 1
                end
            end
        else
            p.held, p.locked, p.speed, p.slowDelay = 0x19, false, p.baseSpeed, 1
            p.targets = {}
            p.lockDelay, p.optionRepeat = 0, 0
        end
        p.optionCount, p.lockCount = p.level > 2 and 4 or 2, 0
        p.run.weaponRank = p.level <= 2 and (p.level - 1) * 4 or (p.level - 1) * 8
        for i, pod in ipairs(p.options) do
            local cap = i <= 2 and 0x60 or (p.model == 1 and 0x70 or 0x7c)
            pod.radius = min(cap, pod.radius + 4)
            positionOption(pod)
            if p.targets[i] then p.lockCount = p.lockCount + 1 end
        end
        updateBomb(p, not ending and keys.spell)
        p.firing = p.locked or rising or not not pulse
        if not ending and not next(p.bombObjects) then
            fireHull(p, rising, pulse)
            fireOptions(p, rising, pulse)
        end
        p.x, p.y = program.world(p.h, p.l)
    end

    function M.close(p)
        for _, pod in ipairs(p.options) do if IsValid(pod) then object.RawDel(pod) end end
        for _, shot in pairs(p.shots) do remove(shot) end
        for _, bomb in pairs(p.bombObjects) do if IsValid(bomb) then object.RawDel(bomb) end end
        if IsValid(p) then object.RawDel(p) end
    end

    return M
end
