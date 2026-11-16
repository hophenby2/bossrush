-- 0x1487fc。0x14888a 推进自机位置，0x149140 随机体倾角更新精灵和碰撞盒。
return function(program, weapons, laser, bombs, hyper, supply)
    local byte = string.byte
    local min, max = math.min, math.max
    local M = {}
    -- V101 默认加命选项 0。0x186750 的首个门槛加上 0x186760 中登记的分差。
    local extendScore = {1000000,3000000}

    local function move(p, keys)
        local flag = (keys.up and 1 or 0) + (keys.down and 2 or 0)
            + (keys.left and 4 or 0) + (keys.right and 8 or 0)
        local angle = byte(program.directions, flag + 1)
        local h, l = p.h, p.l
        p.cameraMotion = 0
        if angle < 0x80 and not p.run.freeze then
            local dh, dl = program.vector(p.speed, angle * 4)
            p.h, p.l = max(0x800, min(0x6500, h + dh)), max(0x300, min(0x3500, l + dl))
            -- 0x15fcae 读取限位前的横向移动量，机身弹则跟随限位后的坐标。
            p.cameraMotion = dl
        end
        p.deltaH, p.deltaL = p.h - h, p.l - l
        local turn = p.turn
        if angle >= 0x80 or not (keys.left or keys.right) then
            p.turn = turn < 0 and turn + 1 or max(0, turn - 1)
        elseif turn ~= (keys.left and -8 or 8) then
            p.turnClock = p.turnClock - 1
            if p.turnClock < 0 then
                p.turnClock = 2
                p.turn = turn + (keys.left and -1 or 1)
            end
        end
        local box = program.pilotBoxes[p.turn + 9]
        p.right, p.left = box[1], box[2]
    end

    local Pilot = Class(object, {
        init = function(p, run, model, doll, options)
            p.run, p.profile = run, assert(program.pilot[model])
            p.model, p.doll = model, doll
            p.weapon = assert(program.pilotWeapons[model][doll])
            p.shots, p.shotLevel = {}, 1
            p.shotFlash, p.shotAnimation, p.shotBurst, p.shotClock = 0, 0, 0, 0
            p.group, p.layer, p.bound, p.colli = GROUP.PLAYER, LAYER.PLAYER, false, false
            p.h, p.l = options.h, options.l
            p.x, p.y = program.world(p.h, p.l)
            p.key, p.protect, p.active = options.keys, options.protect or 0xf0, true
            p.life, p.misses = options.life, 0
            p.stageMisses,p.fullBeeStages = 0,0
            p.maxBombs = options.maxBombs or program.pilotBombCount[doll]
            p.bombs,p.bombsUsed = options.bombs or p.maxBombs,0
            p.hyperStock,p.hyperClock,p.hyperGauge,p.hyperRank,p.hyperQueued = 0,0,0,0,0
            p.comboClock,p.comboHits,p.comboSeed,p.comboValue = 0,0,0,0
            p.bossComboClock,p.bossHits,p.hyperHitWait,p.laserHitWait = 0,0,0,0
            p.score, p.chips, p.stars, p.bees = 0, 0, 0, 0
            p.scoreExtends = 0
            p.baseSpeed, p.lockSpeed = unpack(assert(p.profile.speeds[doll]))
            p.speed, p.turn, p.turnClock = p.baseSpeed, 0, 0
            p.front, p.back = p.profile.front, p.profile.back
            p.right, p.left = unpack(program.pilotBoxes[9])
            p.hitFlags = 0x1000
        end,
        render = function(p)
            if not p.active or not p.run.art then return end
            local image = p.run.art[p.profile.images[p.turn + 9]]
            local recoil = p.bomb and p.bomb.recoil or 0
            local x, y = program.world(p.h - 0x600 + recoil, p.l - 0x400)
            Render(image[1], math.floor(x) + image[2] / 2, math.floor(y) + image[3] / 2)
        end,
    })

    local fly

    local function rebirth(p)
        p.rebirthDelay = p.rebirthDelay - 1
        if p.rebirthDelay > 0 then return end
        p.h, p.l = unpack(program.pilotStart)
        p.x, p.y = program.world(p.h, p.l)
        p.speed, p.turn, p.turnClock = p.baseSpeed, 0, 0
        p.right, p.left = unpack(program.pilotBoxes[9])
        p.shotFlash, p.shotAnimation, p.shotBurst, p.shotClock = 0, 0, 0, 0
        p.shootHeld = nil
        p.bombs = p.maxBombs
        p.protect, p.active, p.update = 0xf0, true, fly
    end

    local function crash(p)
        p.crashDelay = p.crashDelay - 1
        if p.crashDelay > 0 then return end
        p.h, p.l = 0, 0
        p.life = p.life - 1
        -- 0x15eb38 登记敌机停火时间，补机由下一次自机装载回调入场。
        p.run.enemyShotGrace = 0x78
        if p.life < 0 then
            p.defeated, p.update = true, nil
        else
            -- 0x14946e 用人形的两个装备位决定降级的武器。Hyper 中失误不增加炸弹上限。
            if p.doll ~= 2 then p.shotLevel = max(1,p.shotLevel - 1) end
            if p.doll ~= 1 then p.laserLevel = max(1,p.laserLevel - 1) end
            if not p.crashedInHyper then p.maxBombs = min(p.maxBombs + 1,program.pilotBombCount[p.doll] * 2) end
            p.rebirthDelay, p.update = 2, rebirth
        end
    end

    fly = function(p)
        if p.protect > 0 then
            if p.protect ~= 0xff then p.protect = p.protect - 1 end
        elseif p.pendingHit then
            -- 0x149412 把动画表挂到自机，0x149438 再注册 32 帧退场等待。
            p.misses, p.active, p.crashDelay, p.update = p.misses + 1, false, 38 + 32, crash
            p.stageMisses = p.stageMisses + 1
            p.pendingHit = nil
            p.crashedInHyper = p.hyperPower ~= nil
            laser.reset(p)
            hyper.miss(p)
            if p.life == 0 then
                supply.emit(p,4)
            else
                for _ = 1,3 do supply.emit(p,0) end
            end
            return
        end
        p.pendingHit = nil
        local keys = p.key or KeyState
        if keys then
            move(p, keys)
            bombs.recoil(p)
            if hyper.input(p,keys.spell) then bombs.input(p,true) end
            if p.run.bombMode ~= 'laser' then
                laser.input(p,keys.shoot)
                if not p.run.bossEnding then weapons.input(p, keys) end
            end
        end
        p.x, p.y = program.world(p.h, p.l)
    end

    function M.spawn(run, model, doll, options)
        local p = New(Pilot, run, model, doll, options)
        laser.bind(p)
        p.update = fly
        return p
    end

    function M.step(p)
        if p.update then p.update(p) end
    end

    -- 0x1827ae 只在本帧加分后检查门槛，达到残机上限时保留尚未领取的门槛。
    function M.extend(p,priorScore)
        local target = extendScore[p.scoreExtends + 1]
        if target and p.score > priorScore and p.score >= target and p.life >= 0 and p.life < 0x14 then
            p.life,p.scoreExtends = p.life + 1,p.scoreExtends + 1
        end
    end

    return M
end
