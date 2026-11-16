-- 0x16452c 把舱内舰艇登记到生成队列，由舰艇各自推进开舱、发射和击破。
return function(program, path, bullets, effects, remove, hyper)
    local bit = require('bit')
    local band, bor, bxor = bit.band, bit.bor, bit.bxor
    local s16, world = program.s16, program.world
    local floor = math.floor
    local data = program.stage3After
    local Flypast, Gate, WideGate = {parts=1}, {parts=2}, {parts=4}
    local slices = {{0,-0x2800},{0,0},{-0x2c00,-0x2000},{-0x2c00,0x400}}

    local function draw(o, sprite, h, l)
        local image = o.run.art[sprite]
        local x,y = world(h,l)
        Render(image[1],floor(x) + image[2] / 2,floor(y) + image[3] / 2)
    end

    function Flypast.init(o)
        o.group,o.layer = GROUP.GHOST,LAYER.BG + 0.2
        o.flags,o.hp,o.speed = 0x8000,0x100,0x10
        if not path.attach(o) then return false end
        local run = o.run
        local kind = run.major == 0x168 and 0x18 or 0x17
        local h,l = program.addPacked(o.h,o.l,0x1000,0x400)
        local queue,command = run.spawnQueue,program.actorCallbacks[kind]
        if #queue < 40 then
            queue[#queue + 1] = {run.major,0,kind,kind == 0x18 and 0x80 or 0x20,0,command[1],command[2],
                h=h,l=l,angle=o.direction,speed=o.speed}
        end
        return true
    end

    function Flypast.step(o)
        local inside = o.h > -0x3c00 and o.l > -0x2800 and o.l < 0x6000
        if inside then o.entered = true
        elseif o.entered then remove(o); return end
        if not path.step(o,o.run.groundScroll) then remove(o); return end
        o.x,o.y = world(o.h,o.l)
    end

    function Flypast.render(o)
        if not o.run.art then return end
        for i, at in ipairs(slices) do
            local h,l = program.addPacked(o.h,o.l,at[1],at[2])
            if l > (i <= 2 and -0x2800 or -0x2400) and l < 0x3900
                and h > (i <= 2 and -0x3c00 or -0x4000) and h < 0x7000 then
                draw(o,data.flypast[i],h,l)
            end
        end
    end

    local function init(o)
        local wide = o.kind == 0x18
        o.h,o.l,o.direction,o.speed = o.row.h,o.row.l,o.row.angle,o.row.speed
        o.flags,o.hp = 0xa000,0x2400
        local width = wide and 0xc00 or 0x1000
        o.front,o.back,o.right,o.left = 0x2900,0x800,width,width
        for _, part in ipairs(o.extraParts) do part.flags = 0x8000 end
        o.basePalette,o.flashMask = wide and 20 or 21,wide and 11 or 10
        o.palette,o.phase,o.hatchFrame = o.basePalette,0,0
        o.hatchGap,o.attackGap,o.departGap = wide and 2 or 4,wide and 0x18 or 0x10,4
        o.hatchClock,o.departClock,o.attackClock = o.hatchGap,0,0x10
        o.departVelocity,o.departTime = 0,0xe0
        o.attack,o.sideClock,o.sideIndex,o.side = 1,0,1,{}
        for i = 1,6 do o.side[i] = {0,0} end
        o.run.bulletCapacity = math.max(o.run.bulletCapacity,110)
        return true
    end
    Gate.init,WideGate.init = init,init

    local function damage(o, amount, flags)
        o.hp,o.flags = s16(o.hp - amount),bor(o.flags,flags)
    end
    Gate.damage,WideGate.damage = damage,damage

    local function aim(o, dh, dl, previous)
        local pilot = o.run.player
        if not pilot or not pilot.active then return previous end
        return program.angle256(s16(o.h + dh),s16(o.l + dl),pilot.h,pilot.l,previous or 0x80)
    end

    local function emit(o, kind, speed, a, dh, dl, mode)
        local run = o.run
        local h,l = s16(o.h + dh),s16(o.l + dl)
        if run.loop ~= 0 and mode == 'spread' then
            bullets.emitPrecise(run,kind,speed,a - 8,h,l)
            bullets.emitPrecise(run,kind,speed,a + 8,h,l)
        else
            bullets.emitPrecise(run,kind,speed + (run.loop ~= 0 and mode == 'fast' and 4 or 0),a,h,l)
            if run.loop ~= 0 and mode == 'paired' then bullets.emitPrecise(run,kind,speed + 6,a,h,l) end
        end
    end

    local function turn(a, target, step)
        local delta = band(target - a + 0x80,0xff) - 0x80
        return band(a + math.max(-step,math.min(step,delta)),0xff)
    end

    local function startAttack(o, wide)
        if not aim(o,0,0) then return end
        if wide and o.attack == 1 then
            o.fireClock,o.fireGap,o.rounds,o.modifier = 0,2,14,4
            o.center = aim(o,0,0)
        elseif not wide and o.attack == 1 then
            o.fireClock,o.fireGap,o.rounds = 0,4,8
            o.frontAim,o.backAim = aim(o,-0x300,0) - 0x40,aim(o,-0xb00,0) + 0x38
        elseif not wide and o.attack == 3 then
            o.fireClock,o.fireGap,o.rounds = 0,2,22
            o.center = aim(o,0,0)
            o.frontAim,o.backAim = o.center - 0x30,o.center + 0x30
        elseif not wide then
            o.fireClock,o.fireGap,o.rounds = 0,4,16
            o.frontAim,o.backAim = aim(o,-0x7c0,-0x440),aim(o,-0x7c0,0x440)
        else
            o.fireClock,o.fireGap,o.rounds = 0,0,1
        end
    end

    local function forward(o, wide)
        if not o.rounds then
            o.attackClock = o.attackClock - 1
            if o.attackClock >= 0 then return end
            o.attackClock = o.attackGap
            startAttack(o,wide)
            if not o.rounds then return end
        end
        o.fireClock = o.fireClock - 1
        if o.fireClock >= 0 then return end
        o.fireClock = o.fireGap
        if wide and o.attack == 1 then
            o.center = turn(o.center,aim(o,0,0,o.center),1)
            for _, l in ipairs({-0x300,0x300,0x640,-0x640}) do
                emit(o,7,o.modifier,o.center,0x1340 - (l < 0 and 1 or 0),l,'fast')
            end
            o.modifier = o.modifier + 4
        elseif wide then
            local a = aim(o,0,0,0x80)
            for _, speed in ipairs({0x10,0xa}) do
                emit(o,7,speed,a,0x133f,-0x540,'spread')
                emit(o,7,speed,a,0x1340,0x540,'spread')
            end
        elseif o.attack == 1 then
            for _, l in ipairs({0,-0x100,0x100}) do
                emit(o,7,4,o.frontAim,-0x300 - (l < 0 and 1 or 0),l,'paired')
            end
            for _, l in ipairs({0,-0x100,0x100}) do
                emit(o,7,4,o.backAim,-0xb00 - (l < 0 and 1 or 0),l,'paired')
            end
            o.frontAim,o.backAim = o.frontAim + 0x14,o.backAim - 0x14
        elseif o.attack == 3 then
            o.frontAim,o.backAim = turn(o.frontAim,o.center,2),turn(o.backAim,o.center,2)
            emit(o,7,0x16,o.frontAim,0x780,0x5c0)
            emit(o,7,0x16,o.frontAim + 6,0x780,0x5c0,'fast')
            emit(o,7,0x16,o.backAim,0x77f,-0x5c0)
            emit(o,7,0x16,o.backAim - 6,0x77f,-0x5c0,'fast')
        else
            emit(o,7,0,o.frontAim,-0x7c1,-0x440,'spread')
            emit(o,7,0,o.backAim,-0x7c0,0x440,'spread')
        end
        o.rounds = o.rounds - 1
        if o.rounds == 0 then o.rounds,o.attack = nil,o.attack % (wide and 2 or 4) + 1 end
    end

    local function sidefire(o)
        o.sideClock = o.sideClock - 1
        if o.sideClock < 0 then
            o.sideClock = 8
            local nozzle = o.side[o.sideIndex]
            nozzle[1],nozzle[2] = 4,0
            o.sideIndex = o.sideIndex % #o.side + 1
        end
        for i = 1,6 do
            local nozzle = o.side[i]
            if nozzle[1] ~= 0 then
                nozzle[2] = nozzle[2] - 1
                if nozzle[2] < 0 then
                    nozzle[1],nozzle[2] = nozzle[1] - 1,4
                    local at = data.gateMuzzles[7 - i]
                    emit(o,5,0,data.gateAngles[7 - i],at[1],at[2],'spread')
                end
            end
        end
    end

    local function destroyFrame(o)
        o.h = s16(o.h - 0x26)
        o.destructionClock = o.destructionClock - 1
        if o.destructionClock < 0 and o.destructionIndex <= #data.gateWreck then
            local row = data.gateWreck[o.destructionIndex]
            effects.emit(o,{{row[2],row[1],row[4],row[5],flip=band(row[3],0x40) ~= 0}})
            o.destructionIndex,o.destructionClock = o.destructionIndex + 1,3
        end
        o.dying = o.dying - 1
        if o.dying == 0 then remove(o) end
    end

    local function step(o)
        local run = o.run
        local wide = o.kind == 0x18
        if not run.freeze then path.move(o) end
        if o.dying then destroyFrame(o); return end
        local flags = band(o.flags,0x5c00)
        if flags == 0 then o.palette = o.basePalette
        else
            o.palette,o.flags = bxor(o.palette,o.flashMask),band(o.flags,0xa3ff)
            hyper.hit(o,flags)
            if o.phase ~= 2 then o.hp = 0x2400 end
            if o.hp < 0 then
                hyper.kill(run,flags,wide and 563 or 234)
                o.flags,o.dying,o.destructionClock,o.destructionIndex = 0x8000,0x40,3,1
                bullets.clearWithFade(run,flags)
                destroyFrame(o)
                return
            end
        end
        if not run.freeze then
            if o.h >= 0 and o.h <= (wide and 0x5a00 or 0x6400) then o.departing = true end
            if o.departing then
                o.departClock = o.departClock - 1
                if o.departClock < 0 then
                    o.departClock,o.departVelocity = o.departGap,math.min(0x80,o.departVelocity + 1)
                end
                o.departTime = math.max(0,o.departTime - 1)
                o.h = s16(o.h + o.departVelocity)
                if band(o.h,0xffff) >= 0x9800 then remove(o); return end
            end
            if o.phase == 0 and o.h >= 0 and o.h <= 0x6600 then o.phase = 1 end
            if o.phase == 1 then
                o.hatchClock = o.hatchClock - 1
                if o.hatchClock < 0 then
                    o.hatchClock,o.hatchFrame = o.hatchGap,o.hatchFrame + 1
                    if o.hatchFrame == 15 then o.phase = 2 end
                end
            end
            if o.phase == 2 then
                if wide then sidefire(o) end
                forward(o,wide)
            end
        end
        o.x,o.y = world(o.h,o.l)
    end
    Gate.step,WideGate.step = step,step

    local function render(o)
        if not o.run.art or o.destructionIndex and o.destructionIndex > #data.gateWreck then return end
        local wide = o.kind == 0x18
        local images = data.hulls[wide and 2 or 1][o.palette]
        local h,l = program.addPacked(o.h,o.l,wide and -0x2a00 or -0x2800,wide and -0x1000 or -0xe00)
        draw(o,images[o.hatchFrame + 1],h,l)
    end
    Gate.render,WideGate.render = render,render

    return Flypast,Gate,WideGate
end
