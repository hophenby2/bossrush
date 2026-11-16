-- 五面首个中 Boss。入场 0x16c69a 登记机身，机身 0x16c892 挂载移动和发弹。
return function(program, bullets, effects, remove, hyper)
    local bit = require('bit')
    local band,bor,bxor = bit.band,bit.bor,bit.bxor
    local s16,world = program.s16,program.world
    local floor,min,max,abs = math.floor,math.min,math.max,math.abs
    local data = program.mid5
    local Entry,Body,Flame = {parts=1},{parts=6},{parts=1}

    local function tick(o,key,period)
        o[key] = o[key] - 1
        if o[key] >= 0 then return false end
        o[key] = period
        return true
    end

    local function draw(o,id,h,l,flip)
        if not o.run.art then return end
        local art = o.run.art[id]
        local x,y = world(h,l)
        if flip then x = x - art[2] end
        Render(art[1],floor(x) + art[2] / 2,floor(y) + art[3] / 2,0,flip and -1 or 1)
    end

    local function drawAt(o,id,dh,dl,flip)
        local h,l = program.addPacked(o.h,o.l,dh,dl)
        draw(o,id,h,l,flip)
    end

    local function advance(o)
        local h,l = program.vector(o.speed,o.angle)
        o.h,o.l = s16(o.h + h),s16(o.l + l)
    end

    function Entry.init(o)
        o.h,o.l,o.flags = 0x3000,0x1c00 - o.run.cameraOffset,0x8000
        o.speed,o.angle,o.phase,o.pose = 0x24,0,0,1
        o.speedClock,o.poseClock = 1,2
        return true
    end

    function Entry.step(o)
        local run = o.run
        if run.freeze then return end
        if o.phase == 0 then o.h,o.phase = s16(o.h - run.groundScroll),1 end
        if o.phase == 1 then
            advance(o)
            if tick(o,'speedClock',1) then
                o.speed = o.speed - 1
                if o.speed == 2 then o.phase = 2 end
            end
        end
        if o.phase == 2 and tick(o,'poseClock',2) then
            o.pose = o.pose + 1
            if o.pose == 17 then remove(o); return end
            if o.pose == 16 then
                local q = run.spawnQueue
                q[#q + 1] = {run.major,0,0x44,0x80,0,0x16c7a8,0x16c892,h=o.h,l=o.l}
            end
        end
        o.x,o.y = world(o.h,o.l)
    end

    function Entry.render(o)
        drawAt(o,data.entry[o.pose],-0x1e00,-0x1a00)
    end

    function Body.init(o)
        o.h,o.l,o.flags,o.hp = o.row.h,o.row.l,0xa001,0x7fff
        o.front,o.back,o.right,o.left = 0xe00,0xb00,0x1180,0x1180
        o.speed,o.angle,o.health,o.palette = 0,0,0x15000,18
        o.moveMode,o.moveState,o.attackMode = 0,0,0
        o.deathState,o.deathClock,o.deathRounds,o.deathIndex = 0,8,2,1
        for i, part in ipairs(o.extraParts) do
            part.h,part.l,part.flags = o.h,o.l,i <= 2 and 0xa001 or 0x8000
            if i <= 2 then
                part.front,part.back,part.hp = 0x900,0x800,0x7fff
                part.right,part.left = i == 1 and 0x600 or 0x800,i == 1 and 0x800 or 0x600
                part.palette,part.kick = 18,0
            end
        end
        o.run.mid5 = o
        return true
    end

    function Body.damage(o,amount,flags)
        o.hp,o.flags = s16(o.hp - amount),bor(o.flags,flags)
    end
    Flame.damage = Body.damage

    local function distance(o,h,l)
        local dh,dl = abs(s16(o.h - h)),abs(s16(o.l - l))
        dh = dh - floor(dh / 4)
        return max(dh,dl) + floor(min(dh,dl) / 2)
    end

    local function speed(distance,thresholds,limit)
        for _, row in ipairs(thresholds) do
            if distance <= row[1] then return row[2] end
        end
        return limit
    end

    local function approach(from,to)
        if from == to then return from end
        return from + (from < to and 1 or -1)
    end

    local function aimAt(o,h,l)
        return program.angle256(o.h,o.l,h,l,o.angle),distance(o,h,l)
    end

    local function setMovement(o,mode)
        if o.moveMode ~= mode then o.moveMode,o.moveState = mode,0 end
    end

    local function patrol(o)
        if o.moveState == 0 then
            o.route,o.moveState = band(program.bossWideRandom(o.run),7) + 1,1
        end
        local h,l = unpack(data.patrol[o.route])
        local angle,dist = aimAt(o,h,l - o.run.cameraOffset)
        o.angle,o.speed = angle,approach(o.speed,speed(dist,data.patrolSpeed,5))
        if dist <= 0x80 then o.route = o.route % #data.patrol + 1 end
    end

    local function dive(o)
        local p = o.run.player
        if o.moveState == 0 then o.moveState = 1 end
        local dist = 0
        if o.moveState ~= 1 or p and p.active then
            if o.moveState == 1 then o.targetH,o.targetL = s16(p.h + 0x1e00),p.l end
            o.angle,dist = aimAt(o,o.targetH,o.targetL)
            if dist <= 0x600 then o.moveState = 2 end
        end
        if dist <= 0x100 then
            o.attackMode,o.attackReady = 1,false
            o.targetH,o.targetL,o.returnWait = o.h,o.l > 0x1c00 and 0 or 0x3800,0x50
        end
        o.speed = speed(dist,data.diveSpeed,0x32)
    end

    local function retreat(o)
        local run = o.run
        if o.moveState == 0 then
            o.speed,o.returnWait = 0,o.returnWait - 1
            if o.returnWait == 0 then o.returnHops,o.moveState = 2,1 end
        end
        if o.moveState == 1 then
            local angle,dist = aimAt(o,o.targetH,o.targetL - run.cameraOffset)
            o.angle,o.targetSpeed = angle,speed(dist,data.returnSpeed,0x12)
            if dist <= 0x80 then o.moveState,o.targetH = 2,min(0x5a00,o.targetH + 0x100) end
        end
        if o.moveState == 2 then
            local angle,dist = aimAt(o,o.targetH,o.targetL - run.cameraOffset)
            local diff = band(angle - o.angle,255)
            if diff ~= 0 then o.angle = band(o.angle + (diff < 0x80 and 1 or -1),255) end
            o.targetSpeed = 4
            if o.speed == 4 and dist <= 0x1000 then
                o.targetH,o.returnHops,o.moveState = s16(o.targetH + 0x1c00),o.returnHops - 1,1
                if o.returnHops == 0 then o.targetL,o.moveState = 0x1c00,3
                else o.targetL = o.l > 0x1c00 and 0 or 0x3800 end
            end
        end
        if o.moveState == 3 then
            local angle,dist = aimAt(o,o.targetH,o.targetL - run.cameraOffset)
            o.angle,o.targetSpeed = angle,0xa
            if dist <= 0x1000 then
                o.attackMode,o.attackReady,o.targetSpeed = nil,false,2
                if o.speed == 2 then o.returned,o.attackMode = true,0 end
            end
        end
        if run.aimPhase == 0 then o.speed = approach(o.speed,o.targetSpeed or 0) end
    end

    local function leave(o)
        o.run.mid5 = nil
        o.run.scrollSpeed[1],o.run.scrollSpeed[2] = 0x20,0x20
        remove(o)
    end

    local function blast(o,row,follow)
        local v = row[6]
        local sp,ang = floor(v / 0x100),band(v,255)
        if follow then sp,ang = o.speed,band(o.angle * 4,255) end
        effects.emit(o,{{row[2],row[1],row[4],row[5],sp,ang,flip=band(row[3],0x40) ~= 0}})
    end

    local function wreck(o)
        if o.deathState == 2 then o.leave = true; return end
        o.deathClock = o.deathClock - 1
        if o.deathState == 1 then
            if o.deathClock ~= 0 then return end
            for _, row in ipairs(data.wreckFinal) do blast(o,row) end
            o.deathState = 2
        elseif o.deathClock < 0 then
            o.deathClock = 8
            blast(o,data.wreckCycle[o.deathIndex],true)
            o.deathIndex = o.deathIndex % #data.wreckCycle + 1
            if o.deathIndex == 1 then
                o.deathRounds = o.deathRounds - 1
                if o.deathRounds == 0 then o.deathState,o.deathClock = 1,0x10 end
            end
        end
    end

    local function damage(o,parts)
        local flags = band(bor(o.flags,parts[1].flags,parts[2].flags),0x5c00)
        if flags == 0 then
            o.palette,parts[1].palette,parts[2].palette = 18,18,18
            return
        end
        local amount = 0
        hyper.hit(o,flags)
        for _, part in ipairs({o,parts[1],parts[2]}) do
            part.palette,part.flags = bxor(part.palette,13),band(part.flags,0xa3ff)
            amount = max(amount,band(0x7fff - part.hp,0xffff))
            part.hp = 0x7fff
        end
        if o.escaping then return end
        o.health = o.health - amount
        if o.health < 0 then
            o.dying,o.hitFlags,o.attackMode = true,flags,nil
            o.flags,parts[1].flags,parts[2].flags = 0x8000,0x8000,0x8000
            o.run.scrollSpeed[1],o.run.scrollSpeed[2] = 0x20,0x20
            bullets.clearWithFade(o.run,o.hitFlags)
            setMovement(o,3)
        end
    end

    local function muzzle(o,bank,angle)
        local m = program.shipFan[bank][band(angle + 2,0xfc) / 4 + 1]
        return s16(o.h + m[1]),s16(o.l + m[2])
    end

    local function firePatrol(o)
        local run = o.run
        if not o.attackReady then
            setMovement(o,0)
            o.attackReady,o.patternAngle,o.aimClock,o.ringClock = true,0x80,1,1
            o.patternLength = o.returned and 0x140 or 0x100
        end
        if tick(o,'ringClock',o.returned and 0x12 or 0x24) and run.enemyShotGrace == 0 then
            local a,advanced = o.patternAngle - 0x79,o.patternAngle + 0xe
            o.patternAngle = band(advanced,0xffff)
            if advanced < 0x10000 then
                for i = 0,22 do
                    local angle = a + i * 0xb
                    local h,l = muzzle(o,5,angle)
                    if run.loop == 0 then bullets.emitPrecise(run,11,-1,angle,h,l)
                    else
                        bullets.emitPrecise(run,11,-1,angle - 8,h,l)
                        bullets.emitPrecise(run,11,-1,angle + 8,h,l)
                    end
                end
            end
        end
        if tick(o,'aimClock',0x20) and run.enemyShotGrace == 0 and run.player and run.player.active then
            local a = program.angle256(o.h,o.l,run.player.h,run.player.l,0x80)
            for _, diff in ipairs({0,6,12,-6,-12}) do
                local angle = a + diff
                local h,l = muzzle(o,4,angle)
                bullets.emitPrecise(run,4,3,angle,h,l)
                if run.loop ~= 0 then bullets.emitPrecise(run,4,9,angle,h,l) end
            end
        end
        o.patternLength = o.patternLength - 1
        if o.patternLength == 0 then
            o.attackReady,o.attackMode = false,nil
            setMovement(o,1)
        end
    end

    local function fireFlame(o)
        local run = o.run
        if not o.attackReady then
            setMovement(o,2)
            o.attackReady,o.flameClock,o.flameSide = true,0x28,band(program.bossWideRandom(run),1)
        end
        if not tick(o,'flameClock',0x28) or run.enemyShotGrace ~= 0 then return end
        local q = run.spawnQueue
        q[#q + 1] = {run.major,0,0x53,0,0,0x16d450,0x16d4ba,host=o,side=o.flameSide}
        o.flameSide = 1 - o.flameSide
    end

    function Body.step(o)
        local run,parts = o.run,o.extraParts
        if run.freeze then return end
        if o.leave then leave(o); return end
        if not o.escaping and not o.dying and run.major == 0xe0 then
            o.escaping,o.attackMode = true,nil
            setMovement(o,4)
        end
        damage(o,parts)
        if o.dying then wreck(o) end
        local mode = o.moveMode
        if mode == 0 then patrol(o)
        elseif mode == 1 then dive(o)
        elseif mode == 2 then retreat(o)
        elseif mode == 3 then o.speed,o.angle = 4,0x80
        else
            if o.moveState == 0 then
                o.speed,o.angle,o.moveState = 12,o.l > 0x1c00 and 0x40 or 0xc0,1
            end
            if o.l >= 0x5400 or o.l <= -0x1c00 then o.leave = true end
        end
        advance(o)
        for i = 1,2 do
            local part = parts[i]
            part.h,part.l = program.addPacked(o.h,o.l,i == 1 and -0x901 or -0x900,i == 1 and -0x800 or 0x800)
            part.h = s16(part.h + part.kick)
        end
        if o.attackMode == 0 then firePatrol(o)
        elseif o.attackMode == 1 then fireFlame(o) end
        for i = 1,2 do parts[i].kick = max(0,parts[i].kick - 0x40) end
        o.x,o.y = world(o.h,o.l)
    end

    function Body.render(o)
        local hull = data.hull[o.palette]
        drawAt(o,hull[1],-0x1e00,-0x1a00)
        drawAt(o,hull[2],-0x1600,-0x1a00)
        for i = 1,2 do
            local part = o.extraParts[i]
            drawAt(part,data.hull[part.palette][i + 2],-0xa00,-0x800)
        end
    end

    function Flame.init(o)
        o.host,o.side = o.row.host,o.row.side
        o.h,o.l,o.flags,o.hp = o.host.h,o.host.l,0x8000,0x7fff
        o.front,o.back,o.right,o.left = 0,0,0,0
        o.flashClock,o.glowClock,o.flameClock = 0,2,2
        o.flashPose,o.glowPose,o.flamePose = 1,1,1
        return true
    end

    local function ignite(o)
        local host,run = o.host,o.run
        local side = o.side
        local angle = side == 1 and 0x1e or 0x22
        local step = side == 1 and -3 or 3
        local spread = run.loop == 0 and 0 or (side == 1 and 1 or -1)
        local layers = {2,3,4,5,6,6,6,5,4,3,2,1}
        for volley = run.loop == 0 and 2 or 1,#layers do
            local a = angle + (volley - 1) * step
            local h,l = muzzle(host,5,a * 4)
            local base = min(volley,5) * 4
            for i = 0,layers[volley] - 1 do bullets.emit(run,11,base - i * 4,a + spread * i,h,l) end
        end
        o.flags,o.ignite = 0x8001,true
    end

    function Flame.step(o)
        if not o.run.mid5 or o.host.dying then remove(o); return end
        if o.run.freeze then return end
        local flip = o.side == 1
        o.h,o.l = program.addPacked(o.host.h,o.host.l,flip and -0xe01 or -0xe00,flip and -0x780 or 0x780)
        if not o.ignite then
            if tick(o,'flashClock',0) then
                o.flashPose = o.flashPose + 1
                if o.flashPose > #data.fastFlash then ignite(o) end
            end
        end
        if o.ignite then
            if o.glowPose <= #data.glow and tick(o,'glowClock',2) then o.glowPose = o.glowPose + 1 end
            if tick(o,'flameClock',2) then
                o.flamePose = o.flamePose + 1
                local box = data.flameBounds[o.flamePose]
                if not box then remove(o); return end
                o.front,o.back,o.right,o.left = box[1],box[2],box[flip and 4 or 3],box[flip and 3 or 4]
            end
            local part = o.host.extraParts[flip and 1 or 2]
            if not o.kicked then
                part.kick = min(0x280,part.kick + 0x100)
                o.kicked = part.kick == 0x280
            end
        end
        o.x,o.y = world(o.h,o.l)
    end

    function Flame.render(o)
        local flip = o.side == 1
        if not o.ignite then drawAt(o,data.fastFlash[o.flashPose],-0x200,flip and 0x400 or -0x400,flip)
        else
            local glow,row = data.glow[o.glowPose],data.flame[o.flamePose]
            if glow then drawAt(o,glow[1],glow[2],(flip and 1 or -1) * glow[3] + 0x180 - (flip and 0x200 or -0x100),flip) end
            drawAt(o,row[1],row[2] + row[4],(flip and 1 or -1) * (row[3] + row[5]) + (flip and -0x280 or 0x280),flip)
        end
    end

    return Entry,Body,Flame
end
