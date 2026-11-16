-- 0x19e386 的调度先于机身更新，部件表 0x19f6c2 在攻击槽之后运行。
return function(program, bullets, effects, items, scheduler, phase)
    local attacks = dofile('mod/GAME/th44/native/boss4_attacks.lua')(program,bullets,scheduler)
    local attach,contains,stop = scheduler.attach,scheduler.contains,scheduler.stop
    local bit = require('bit')
    local band = bit.band
    local s16 = program.s16
    local floor = math.floor
    local data = program.boss4
    local D,C = {},{}
    local M = {directors=D,components=C,attacks=attacks}

    local function done(o,t) o.directors[t.slot] = nil end
    local function donePart(o,t) o.components[t.slot] = nil end
    local function effect(o,p,key,random)
        for _, row in ipairs(data.effects[key]) do
            local delay,kind,flip,h,l = unpack(row)
            local speed,angle = o.speed,o.dir * 4
            if random then
                h = h + floor(program.bossJitter(o.run) / 2)
                l = l + floor(program.bossJitter(o.run) / 2)
                speed,angle = 0x10 + program.bossRandom(o.run),program.bossWideRandom(o.run)
            end
            -- 效果指令的计时控制动画与引信，位置使用拆下部件当帧的坐标。
            effects.emit(p,{{kind,delay,h,l,speed,angle,flip=flip ~= 0}})
        end
    end

    local function debris(o,p,kind,dh,dl)
        local run = o.run
        local angle = program.bossRandom(run) * 2
        local h = dh + floor(program.bossJitter(run) / 8)
        local l = dl + floor(program.bossJitter(run) / 8)
        effects.emit(p,{{kind,0,h,l,0x10,angle}})
    end

    -- 0x18980e 的五块碎片各自再取一次角度扰动。
    local function shards(o,p,base,h,l)
        local commands = {}
        for i, row in ipairs({{4,0,5},{7,1,7},{4,2,10},{5,3,14},{5,6,18}}) do
            commands[i] = {row[1],row[2],h,l,row[3],base + floor(program.bossRandom(o.run) / 4)}
        end
        effects.emit(p,commands)
    end

    local function timed(t,key,period)
        t[key] = t[key] - 1
        if t[key] >= 0 then return false end
        t[key] = period
        return true
    end

    local function setBox(o,i,enabled)
        o.boxes[i].flags = enabled and 0xa001 or 0x8000
    end

    local function breakWings(o)
        if o.wingsBroken then return end
        o.wingsBroken = true
        for i = 5,6 do
            local wing = o.boxes[i]
            setBox(o,i,false)
            o.draws[i + 2] = nil
            wing.hp,wing.palette = -1,19
            effect(o,wing,i == 5 and 'leftWing' or 'rightWing')
            local dir = program.bossWideRandom(o.run)
            shards(o,wing,dir,0,0)
        end
    end
    M.breakWings = breakWings

    D[0] = {function(o,t) o.draws[10] = true; phase(o,0); done(o,t) end,done}

    local function transform(o,t)
        local p = o.boxes
        if t.hullSmoke and timed(t,'hullSmoke',2) then debris(o,p[9],1,-0x200,0) end
        if t.cannonSmoke and timed(t,'cannonSmoke',4) then
            debris(o,p[7],16,-0x400,0)
            debris(o,p[8],16,-0x400,0)
        end
        if t.step == 0 and timed(t,'clock',0) then
            t.step,t.clock,t.hullSmoke = 1,8,0
            effect(o,p[9],'turret')
            o.draws[5] = nil
        end
        if t.step == 1 and timed(t,'clock',0) then
            t.step,t.clock,t.cannonSmoke = 2,8,0
            local a = program.bossWideRandom(o.run)
            shards(o,p[7],a,0,0)
            effect(o,p[7],'cannons')
            effect(o,p[8],'cannons')
            o.draws[3],o.draws[4] = nil,nil
        end
        if t.step == 2 and timed(t,'clock',0) then
            t.step,t.clock = 3,0x60
            effect(o,p[4],'cover')
            o.draws[2] = nil
        end
        if t.step == 3 and timed(t,'clock',0) then
            local left = 0x30 + 2 * program.bossRandom(o.run)
            shards(o,p[4],left,-0x1000,0x400)
            local right = 0xd0 + program.bossRandom(o.run)
            shards(o,p[4],right,-0x1400,-0x400)
            effect(o,p[3],'armor')
            o.draws[1] = nil
            phase(o,3)
            done(o,t)
        end
    end
    D[1] = {
        function(o,t)
            o.protected = true
            setBox(o,3,false)
            setBox(o,4,false)
            phase(o,2)
            t.step,t.clock = 0,1
            transform(o,t)
        end,
        transform,
    }

    local function death(o,t)
        local p = o.boxes[2]
        if t.smokeA and timed(t,'smokeA',2) then debris(o,p,1,-0xa00,0x400) end
        if t.smokeB and timed(t,'smokeB',4) then debris(o,p,16,-0xc00,-0x600) end
        if t.step == 5 then
            t.clock = t.clock - 1
            if t.clock == 0 then o.finished = true; done(o,t) end
            return
        elseif t.step == 4 then
            effect(o,p,'death')
            effect(o,p,'death',true)
            local a = 0x10 + 2 * program.bossRandom(o.run)
            shards(o,p,a,-0x800,0x400)
            local b = 0xf0 + 2 * program.bossRandom(o.run)
            shards(o,p,b,0x200,-0x600)
            t.step,t.clock = 5,0x80
            return
        elseif t.step == 3 then
            t.wipe = t.wipe - 1
            if t.wipe == 0 then t.step = 4 end
            return
        end
        if t.step == 0 or t.clock > 0 then t.clock = t.clock - 1 end
        if timed(t,'pulse',t.pulseGap) then t.pulseIndex = (t.pulseIndex + 1) % 8 end
        if t.step == 0 then
            if t.clock < 0 then
                effect(o,p,'death')
                t.smokeA,t.smokeB,t.step,t.clock,t.pulse,t.pulseGap = 0,0,1,0x50,0x10,0
            end
        elseif t.clock == 0 and timed(t,'burst',t.burstGap) then
            local row = data.effects.deathCycle[t.cursor]
            local speed,angle = o.speed,o.dir * 4
            if t.step == 2 then speed,angle = 0x10 + program.bossRandom(o.run),program.bossWideRandom(o.run) end
            effects.emit(p,{{row[2],0,row[4],row[5],speed,angle,flip=row[3] ~= 0}})
            t.cursor = t.cursor + 1
            if t.cursor > #data.effects.deathCycle then
                t.cursor = 1
                if t.step == 1 then
                    t.step,t.burst,t.burstGap,t.pulse,t.pulseGap = 2,6,6,8,0
                else
                    t.cycles = t.cycles - 1
                    if t.cycles == 0 then
                        t.step,t.wipe,t.smokeA,t.smokeB = 3,9,nil,nil
                        o.draws[9] = nil
                    end
                end
            end
        end
    end
    D[2] = {
        function(o,t)
            phase(o,5)
            t.step,t.clock,t.burst,t.burstGap,t.cursor,t.cycles = 0,0x10,0xc,0xc,1,3
            t.pulse,t.pulseGap,t.pulseIndex = 4,4,0
            death(o,t)
        end,
        death,
    }

    local function fired(o,t,index,mode)
        attach(o.attacks,index,{mode=mode})
    end

    local function updateCannons(o,t)
        local p,q = o.boxes[7],o.boxes[8]
        if t.step == 0 then
            local aligned = p.turn == t.left and q.turn == t.right
            if p.turn ~= t.left then p.turn = (p.turn + 1) % 24 end
            if q.turn ~= t.right then q.turn = (q.turn - 1) % 24 end
            if not aligned then return end
            t.step = 1
        end
        if t.step == 1 and timed(t,'clock',t.gap) then
            if timed(t,'ramp',1) and t.gap ~= 6 then t.gap = t.gap - 1
            else
                t.repeatCount = t.repeatCount - 1
                if t.repeatCount == 0 then t.step,t.pause = 2,0x60 end
            end
            fired(o,t,t.nextSide,0)
            t.nextSide = 3 - t.nextSide
        end
        if t.step == 2 or t.step == 3 then
            if t.pause > 0 then t.pause = t.pause - 1; return end
            local primary = t.step == 2 and 1 or 2
            local other = 3 - primary
            if t.step == 3 or not contains(o.attacks,primary) then
                if timed(t,'clock',t.gap) then fired(o,t,primary,1) end
            end
            if not contains(o.attacks,other) and timed(t,'pauseClock',8) then
                t.sideRounds[primary] = t.sideRounds[primary] - 1
                if t.sideRounds[primary] > 0 then
                    fired(o,t,other,2)
                else
                    t.sideRounds[primary] = 2
                    t.cannonRounds = t.cannonRounds - 1
                    t.step = t.cannonRounds == 0 and 4 or 5 - t.step
                    if t.step == 4 then t.pause = 0x10 end
                end
            end
        end
        if t.step == 4 then
            t.pause = t.pause - 1
            if t.pause == 0 then
                fired(o,t,1,3)
                fired(o,t,2,3)
                t.step = 5
            end
        end
        if t.step == 5 and not contains(o.attacks,1) and not contains(o.attacks,2) then
            done(o,t)
            attach(o.directors,4)
        end
    end
    D[3] = {
        function(o,t)
            t.step,t.clock,t.gap,t.ramp,t.repeatCount,t.nextSide = 0,0x20,0xc,1,0x20,1
            t.left,t.right = band(program.bossWideRandom(o.run),15),band(program.bossWideRandom(o.run),15)
            t.pause,t.pauseClock,t.cannonRounds,t.sideRounds = 0x10,8,2,{2,2}
            updateCannons(o,t)
        end,
        updateCannons,
    }

    local function updateLauncher(o,t)
        if t.step == 0 or t.step == 1 or t.step == 4 then
            t.clock = t.clock - 1
            if t.clock ~= 0 then return end
            if t.step == 0 then attach(o.attacks,3); t.step,t.clock = 1,31
            elseif t.step == 1 then attach(o.components,1); t.step,t.clock = 2,15
            else done(o,t); attach(o.directors,3) end
        end
        if t.step == 2 then
            if t.clock > 0 then t.clock = t.clock - 1; return end
            if contains(o.attacks,5) then return end
            local row = data.launcher[t.cursor]
            attach(o.attacks,5,{mask=row[1],count=row[3],clock=row[4],gap=row[5]})
            t.cursor = t.cursor + 1
            if t.cursor > #data.launcher then t.step = 3 end
        end
        if t.step == 3 and not contains(o.attacks,5) then
            stop(o.attacks,3)
            attach(o.components,2)
            t.step,t.clock = 4,0x7f
        end
    end
    D[4] = {function(o,t) t.step,t.clock,t.cursor = 0,0x20,1 end,updateLauncher}

    local function wingSpeed(o,i,speed)
        local p = o.boxes[4 + i]
        if speed == 0 or speed < 0 and p.h <= 0x5a00 or speed > 0 and p.h >= 0x6400 then
            local a = speed == 0 and (program.bossRandom(o.run) < 0 and 0x80 or 0) or (speed < 0 and 0 or 0x80)
            return program.vector(4 + floor(program.bossRandom(o.run) / 2),a)
        end
        return speed
    end

    local function hatches(o,t,which)
        local status = t[which]
        if status == 1 and not contains(o.components,6) and not contains(o.components,8) then
            attach(o.components,5)
            attach(o.components,7)
            t[which] = 2
        elseif status == 2 and not contains(o.components,5) and not contains(o.components,7) then
            if which == 'open' then attach(o.attacks,8) end
            t[which] = nil
        end
    end

    local function updateWings(o,t)
        if not t.split then
            t.velocity = t.velocity + 4
            o.leftL,o.rightL = o.leftL - t.velocity,o.rightL + t.velocity
            if o.rightL < 0xe00 then return end
            o.leftL,o.rightL = -0xe00,0xe00
            t.split,t.stage,t.clock,t.wingV = true,0,0x10,{wingSpeed(o,1,0),wingSpeed(o,2,0)}
            t.delay,t.orbitSide = 4,0
        end
        hatches(o,t,'open')
        hatches(o,t,'secondOpen')
        t.wingV[1],t.wingV[2] = wingSpeed(o,1,t.wingV[1]),wingSpeed(o,2,t.wingV[2])
        o.leftH,o.rightH = s16(o.leftH + t.wingV[1]),s16(o.rightH + t.wingV[2])
        if t.stage == 0 then
            if contains(o.components,4) then return end
            if t.clock > 0 then
                t.clock = t.clock - 1
                if t.clock ~= 0 then return end
                stop(o.attacks,8)
                attach(o.attacks,6)
                attach(o.attacks,10)
                t.secondOpen = 1
                return
            end
            if contains(o.attacks,10) then return end
            stop(o.attacks,6)
            stop(o.attacks,7)
            attach(o.components,6)
            attach(o.components,8)
            t.stage,t.clock = 1,0x40
        end
        if t.stage == 1 then
            t.clock = t.clock - 1
            if t.clock == 0 then
                t.open = 1
                attach(o.components,3)
                phase(o,7)
                t.stage = 2
            end
        end
        if t.stage == 2 and not contains(o.components,3) and not contains(o.attacks,9) then
            if timed(t,'delay',0) then
                attach(o.attacks,9,{side=t.orbitSide})
                t.orbitSide,t.stage,t.clock = 1 - t.orbitSide,3,0xe0
            end
        end
        if t.stage == 3 and not contains(o.attacks,9) then
            t.clock = t.clock - 1
            if t.clock == 0 then
                phase(o,4)
                attach(o.components,4)
                t.stage,t.clock = 0,0x40
            end
        end
    end
    D[5] = {
        function(o,t) t.velocity = 0; phase(o,4); updateWings(o,t) end,
        updateWings,
    }

    local function final(o,t)
        if not contains(o.components,3) and not t.open then
            attach(o.attacks,11)
            t.open = true
        end
        if t.open then
            o.orbPulse = false
            t.pulse = t.pulse - 1
            if t.pulse == 0 then
                o.orbPulse = true
                t.pulse = 0x1c0 + band(program.bossWideRandom(o.run),0x7f)
            end
        end
        if t.wave == 0 and not contains(o.attacks,13) then
            t.clock = t.clock - 1
            if t.clock == 0 then
                attach(o.attacks,14,{count=t.long})
                t.wave,t.clock = 1,0x30
            end
        end
        if t.wave == 1 and not contains(o.attacks,14) then
            t.clock = t.clock - 1
            if t.clock == 0 then
                attach(o.attacks,13,{count=t.short})
                t.wave,t.clock = 0,0x40
                t.short = math.min(o.run.loop == 0 and 3 or 5,t.short + 1)
            end
        end
    end
    D[6] = {
        function(o,t)
            breakWings(o)
            o.orbCommand = 2
            phase(o,8)
            stop(o.components,4)
            attach(o.components,3)
            for i = 6,10 do stop(o.attacks,i) end
            t.pulse,t.wave,t.clock,t.short,t.long = 0x180,0,0x100,o.run.loop == 0 and 1 or 3,8
            final(o,t)
        end,
        final,
    }

    C[0] = {
        function(o,t) t.clock = 2; o.hullFrame = 0; o.draws[0],o.draws[6] = nil,true end,
        function(o,t)
            if not timed(t,'clock',2) then return end
            o.hullFrame = o.hullFrame + 1
            if o.hullFrame == 15 then
                o.hullFrame = 0
                o.draws[6],o.draws[7],o.draws[8],o.draws[9] = nil,true,true,true
                local p = o.boxes[2]
                p.front,p.back,p.right,p.left = 0xc00,0xd80,0x900,0x900
                setBox(o,5,true)
                setBox(o,6,true)
                o.protected = false
                donePart(o,t)
            end
        end,
    }

    local function animation(index,field,delta,finish,gap,saturate)
        local function update(o,t)
            if not timed(t,'clock',gap) then return end
            local part = index >= 5 and o.boxes[index <= 6 and 5 or 6] or o
            local frame = (part[field] or 0) + delta
            if saturate and (frame - finish) * delta >= 0 then frame = finish end
            part[field] = frame
            if frame == finish then donePart(o,t) end
        end
        return {function(o,t) t.clock = index <= 2 and 2 or 0; update(o,t) end,update}
    end
    C[1],C[2] = animation(1,'coverFrame',1,7,2),animation(2,'coverFrame',-1,0,2)
    -- 0x19f7fc 至 0x19f90e 允许在端点再次挂载，写回端点并立即注销任务。
    C[3],C[4] = animation(3,'hullFrame',1,15,1,true),animation(4,'hullFrame',-1,0,1,true)
    C[5],C[6] = animation(5,'hatch',1,8,1,true),animation(6,'hatch',-1,0,1,true)
    C[7],C[8] = animation(7,'hatch',1,8,1,true),animation(8,'hatch',-1,0,1,true)

    local function aimTurret(o)
        local p,pilot = o.boxes[9],o.run.player
        if pilot and pilot.active then
            p.turn = program.turn64(p.turn,program.angle(p.h,p.l,pilot.h,pilot.l,p.turn))
        end
    end
    local function engineFrames(o)
        for i = 2,6 do
            if i ~= 4 then o.boxes[i].frame = (o.boxes[i].frame + 1) % 8 end
        end
    end
    C[9],C[10] = {aimTurret,aimTurret},{engineFrames,engineFrames}

    return M
end
