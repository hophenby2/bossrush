-- 0x150818 在随机航点停车，锁定自机方向并发射四颗同向、不同速的箭弹。
return function(program,path,bullets,art,effects)
    local bit = require('bit')
    local band,bxor = bit.band,bit.bxor
    local floor,min,max,abs = math.floor,math.min,math.max,math.abs
    local s16 = program.s16
    local M = {parts=1}

    local function distance(o,h,l)
        local dh,dl = abs(s16(o.h - h)),abs(s16(o.l - l))
        dh = dh - floor(dh / 4)
        return max(dh,dl) + floor(min(dh,dl) / 2)
    end

    local function waypoint(o,mode)
        local run = o.run
        local h = 0x5c00 + floor(program.hovercraftRandom[program.nextRandom(run,127)] / 2)
        local dl = min(0x1400,abs(program.hovercraftRandom[program.nextRandom(run,127)]))
        local l = 0x1c00 + (o.l < 0x1c00 and dl or -dl)
        local clock,period,accel = unpack(program.hovercraftSpeeds[mode + 1])
        o.targetH,o.targetL = h,l
        o.speedClock,o.speedPeriod,o.accel = clock,period,accel
        l = l - run.cameraOffset
        o.brakeAt = floor(distance(o,h,l) / 2)
        o.direction = program.angle(o.h,o.l,{h=h,l=l,active=true},o.direction)
        o.braking = false
    end

    function M.init(o)
        o.flags,o.hp,o.front,o.back,o.right,o.left,o.speed = unpack(program.hovercraftBody)
        o.normalPalette,o.flashPalette = unpack(program.hovercraftPalettes[(o.run.stageMode or 0) + 1])
        o.palette = o.normalPalette
        o.mode,o.volleysRemaining = 0,8
        o.fireClock,o.burstClock,o.burstSize = 0x10 - floor(o.run.volleyRank / 2),0,0
        o.frameIndex,o.frameClock,o.tiltMode = 0,0,0
        o.tiltFrames,o.tiltClocks = {0,0},{0,0}
        if not path.attach(o,o.row) then return false end
        waypoint(o,3)
        return true
    end

    local function approach(o)
        local h,l = o.targetH,o.targetL - o.run.cameraOffset
        local direction = program.angle(o.h,o.l,{h=h,l=l,active=true},o.direction)
        o.direction = program.towards(program.towards(o.direction,direction),direction)
        local remaining = distance(o,h,l)
        o.speedClock = o.speedClock - 1
        if o.speedClock < 0 then
            o.speedClock = o.speedPeriod
            o.braking = remaining < o.brakeAt
            o.speed = max(0,o.speed + (o.braking and -o.accel or o.accel))
        end
        if remaining <= 0x200 or o.speed == 0 then o.mode = 1 end
    end

    local function fire(o)
        local run = o.run
        if o.speed > 0 then
            o.speedClock = o.speedClock - 1
            if o.speedClock < 0 then o.speedClock,o.speed = o.speedPeriod,o.speed - 1 end
        end
        if o.burstSize == 0 then
            if o.speed > 0 then return end
            o.fireClock = o.fireClock - 1
            if o.fireClock >= 0 then return end
            o.fireClock,o.burstSize = 0x14 - run.volleyRank,1
            o.fireAngle = program.angle(o.h - 0x7c0,o.l - 0x80,run.player,0x20) * 4
        end
        o.burstClock = o.burstClock - 1
        if o.burstClock >= 0 then return end
        o.burstClock = 2
        for modifier = -4,2,2 do bullets.emit(o,4,modifier,o.fireAngle,-0x7c1,-0x80) end
        o.burstSize = o.burstSize - 1
        if o.burstSize > 0 then return end
        o.mode = 0
        local mode = min(band(program.random(run,program.randomByte),3) + 1,3)
        waypoint(o,mode)
        o.volleysRemaining = o.volleysRemaining - 1
        if o.volleysRemaining == 0 or run.stageNumber == 1 and run.major >= 0x200 then
            o.mode,o.speed,o.direction = 2,8,0
        end
    end

    -- 0x1509be 只在加速转向时切入倾斜表，退出该表要倒播回正。
    local function animation(o)
        o.frameClock = o.frameClock - 1
        if o.frameClock < 0 then o.frameClock,o.frameIndex = 2,(o.frameIndex + 1) % 16 end
        local turn = 0
        if not o.braking and o.speed > 4 then
            local direction = o.direction
            if direction > 4 and direction < 0x1c then turn = 1
            elseif direction > 0x24 and direction < 0x3c then turn = 2 end
        end
        local frames,clocks = o.tiltFrames,o.tiltClocks
        if turn ~= 0 and frames[3 - turn] == 0 then
            o.tiltMode = turn
            clocks[turn] = clocks[turn] - 1
            if clocks[turn] < 0 then
                clocks[turn] = 2
                frames[turn] = frames[turn] == 15 and 8 or frames[turn] + 1
            end
            return
        end
        o.tiltMode = 0
        for index = 2,1,-1 do
            if frames[index] > 0 then
                o.tiltMode = index
                clocks[index] = clocks[index] - 1
                if clocks[index] < 0 then clocks[index],frames[index] = 1,frames[index] - 1 end
            end
        end
    end

    function M.step(o)
        local run = o.run
        if o.impact then
            o.flags = band(o.flags,0xa6ff)
            if o.hp < 0 then
                effects.emit(o,0x8f,0,0,0,false)
                return false
            end
            o.palette = bxor(o.palette,o.flashPalette)
            o.impact = nil
        else o.palette = o.normalPalette end
        if o.mode == 0 then approach(o) end
        if not run.freeze then
            local dh,dl = program.vector(o.speed,o.direction * 4,run.slowVectors)
            o.h,o.l = s16(o.h + dh),s16(o.l + dl)
        end
        if band(o.l + 0x1000 + run.cameraOffset,0xffff) < 0x5800 and band(o.h + 0xa00,0xffff) < 0x8400 then
            o.seen = true
        elseif o.seen then return false end
        if not run.freeze and not run.stopPathClock then
            if o.mode == 1 then fire(o) end
            animation(o)
        end
        o.visible = true
        return true
    end

    function M.render(o)
        local assets = o.run.art
        if not assets or not o.visible then return end
        local images = program.hovercraftImages[o.palette][o.tiltMode + 1]
        local index = o.tiltFrames[o.tiltMode] or o.frameIndex
        art.draw(assets.sprites[images[index + 1]],o.h,o.l,-0xc00,-0xc00)
    end

    return M
end
