-- 0x1a4188 / 0x1a45b0。二周目两次击破依次更换实体的绘制、移动、攻击和受击入口。
return function(program,bullets,effects,scheduler,directors,components,blast,hyper)
    local attach,clear,stop = scheduler.attach,scheduler.clear,scheduler.stop
    local bit = require('bit')
    local band,bor,bxor = bit.band,bit.bor,bit.bxor
    local s16,vector = program.s16,program.vector
    local min,floor = math.min,math.floor
    local data = program.boss5
    local M = {}

    local function switchMove(o,index)
        o.moveIndex,o.moveInit,o.target = index,true,nil
    end

    local wander = {
        [2]={4,0x3c00,0x4c00,0x6000,0x6800,true},
        [4]={6,0x3600,0x5200,0x5e00,0x6200},
        [5]={8,0x3800,0x5000,0x6400,0x6c00,true},
        [6]={6,0x4000,0x4800,0x5400,0x5c00,true},
        [7]={nil,0x4200,0x4600,0x7b80,0x7c80},
        [8]={2,0x4000,0x4800,0x5200,0x5600},
        [9]={nil,0x4000,0x4800,0x6200,0x6600},
        [10]={4,0x3600,0x5200,0x5e00,0x6200},
        [11]={4,0x4000,0x4800,0x4800,0x5000,true},
    }
    local function drift(o)
        local h,l = vector(o.moveSpeed,o.heading * 4)
        o.h,o.l = s16(o.h + h),s16(o.l + l)
    end

    function M.move(o)
        local index = o.moveIndex
        if not index then
            o.h = s16(o.h - o.run.groundScroll)
            return true
        end
        if o.moveInit then
            o.moveInit = false
            if index == 1 then
                o.moveSpeed,o.heading,o.moveWait,o.moveClock,o.movePeriod = 0,0,0x40,8,8
            elseif index == 3 then
                o.moveSpeed,o.heading = 3,0x20
            else
                local motion = wander[index]
                o.moveSpeed = motion[1] or o.moveSpeed
                if motion[6] then o.heading = band(program.randomEnemy(o.run),63)
                elseif index == 7 then o.heading = band(floor(program.bossRandom(o.run) / 2),63) end
            end
        end
        if index == 3 then drift(o); return false end
        if index == 1 then
            if o.moveWait > 0 then
                o.moveWait = o.moveWait - 1
                if o.moveWait > 0 then return true end
                o.drawHatch,o.drawShell = true,true
                o.boxes[12].back = 0x1000
                attach(o.components,3)
                attach(o.components,4)
            end
            drift(o)
            o.moveClock = o.moveClock - 1
            if o.moveClock >= 0 then return true end
            o.moveClock = o.movePeriod
            if o.moveRisingDone then
                o.moveSpeed = o.moveSpeed - 1
                if o.moveSpeed == 4 then switchMove(o,2) end
            else
                o.movePeriod,o.moveSpeed = o.movePeriod - 1,o.moveSpeed + 1
                if o.moveSpeed == 8 then o.moveClock,o.movePeriod,o.moveRisingDone = 3,3,true end
            end
            return true
        end
        drift(o)
        if o.target then
            o.heading = program.turn64(o.heading,o.target)
            if o.heading == o.target then o.target = nil end
        end
        local r = wander[index]
        local a = program.bossRandom(o.run)
        local h,l = band(o.h,0xffff),band(o.l + 0x2800,0xffff)
        if l < r[2] then a = a + 0x10
        elseif l >= r[3] then a = a + 0x30
        elseif h >= r[5] then a = a + 0x20
        elseif h >= r[4] then return true end
        o.target = band(a,63)
        return true
    end

    local function paintStep(key,size,initialDelay)
        local function update(o,t)
            t.clock = t.clock - 1
            if t.clock < 0 then o[key],t.clock = (o[key] + 1) % size,initialDelay end
        end
        return {function(o,t) o[key],t.clock = 0,0; update(o,t) end,update}
    end
    components[3] = paintStep('shellFrame',3,0)
    components[4] = {
        function(o,t) o.hatchFrame = 0 end,
        function(o,t)
            o.hatchFrame = o.hatchFrame + 1
            if o.hatchFrame == #data.hatches then o.hatchFrame = 15 end
        end,
    }
    components[6] = paintStep('coreFrame',8,0)
    components[7] = paintStep('barrierFrame',16,0)

    local function refreshClock(o,t)
        t.clock = t.clock - 1
        if t.clock > 0 then return end
        attach(o.directors,t.next)
        o.directors[t.slot] = nil
    end
    local function install(index,delay,rest,nextIndex,onEnter,onArm,onExit)
        local function update(enemy,t)
            if t.delay > 0 then
                if enemy.run.enemyShotGrace > 0 then return end
                t.delay = t.delay - 1
                if t.delay > 0 then return end
                attach(enemy.attacks,index)
                if onArm then onArm(enemy) end
            end
            if scheduler.contains(enemy.attacks,index) then return end
            t.clock = t.clock - 1
            if t.clock > 0 then return end
            attach(enemy.directors,nextIndex)
            enemy.directors[t.slot] = nil
            if onExit then onExit(enemy) end
        end
        return {function(enemy,t)
            t.delay,t.clock = delay,rest
            if onEnter then onEnter(enemy) end
            update(enemy,t)
        end,update}
    end
    directors[10] = install(5,1,1,11,nil,function(o)
        switchMove(o,5)
        o.drawShell,o.boxes[12].back = false,0
    end,function(o)
        o.drawShell,o.boxes[12].back = true,0x1000
    end)
    directors[11] = install(6,0x40,1,12,nil,function(o) switchMove(o,6) end)
    directors[12] = install(7,0x50,1,13,function(o) switchMove(o,6) end)
    directors[13] = install(8,0x60,0x40,10,function(o)
        switchMove(o,7)
        o.moveSpeed = 0xc
    end,function(o) o.moveSpeed = 4 end,function(o) switchMove(o,2) end)
    directors[15] = install(9,0x60,1,17,nil,nil,function(o)
        switchMove(o,9)
        o.moveSpeed = 0xc
    end)
    directors[16] = install(10,0x60,1,15,nil,nil,function(o) switchMove(o,4) end)
    directors[17] = install(11,0x60,1,16,nil,function(o) o.moveSpeed = 4 end,function(o) switchMove(o,8) end)
    directors[18] = install(12,0x60,0x40,15,nil,nil,function(o) switchMove(o,4) end)
    directors[19] = {function(o,t) t.clock = 0x60 end,function(o,t)
        if t.clock == 0 or o.run.enemyShotGrace > 0 then return end
        t.clock = t.clock - 1
        if t.clock == 0 then attach(o.attacks,13); o.protected = false end
    end}

    -- 0x1a4188 的两个盒复用同一段耐久，0x1a45b0 改挂核心的单一判定。
    directors[2] = {function(o,t)
        o.form,o.health,o.timeout,o.protected = 1,0x23000,0x6270,false
        o.drawHatch,o.drawShell = false,false
        o.boxes[11].flags,o.boxes[12].flags = 0xa001,0xa001
        o.boxes[12].back = 0
        o.transforming = false
        switchMove(o,1)
        t.clock,t.next = 0x80,10
    end,refreshClock}
    directors[4] = {function(o,t)
        o.run.bossHyper,o.run.scoreOnlyKills,o.run.beetlesUseBossHits = true,true,true
        o.form,o.health,o.timeout,o.protected = 2,0x4d000,0x6270,false
        o.drawHatch,o.drawShell = false,false
        o.boxes[13].flags,o.shieldClock = 0xa001,0
        o.transforming,o.coreFrame,o.barrierFrame = false,0,0
        o.corePalette = 23
        o.run.bulletCapacity = 210
        switchMove(o,4)
        attach(o.components,6)
        attach(o.components,7)
        t.clock,t.next = 0x80,15
    end,refreshClock}

    local function breakout(o,t)
        if blast(o,t) then
            attach(o.directors,4)
            o.directors[t.slot] = nil
        end
    end
    directors[3] = {function(o,t)
        t.clock,t.flash = 0xc0,3
        switchMove(o,3)
        breakout(o,t)
    end,breakout}

    local function recolor(o,credit,limit,count)
        if credit == 0 then
            for i=1,count do o.colors[i] = o.health < limit and 25 or 15 + i end
        else
            for i,mask in ipairs({15,14,13}) do
                o.colors[i] = bxor(o.colors[i] == 25 and 15 + i or o.colors[i],mask)
            end
        end
    end

    local function poolDamage(o,first,last)
        local lowest,flags = 0x7fff,0
        for i=first,last do
            local part = o.boxes[i]
            flags = bor(flags,band(part.flags,0x5c00))
            lowest = min(lowest,part.hp)
        end
        if flags == 0 then return 0,0 end
        for i=first,last do
            local part = o.boxes[i]
            part.flags,part.hp = band(part.flags,0xa3ff),0x7fff
        end
        return 0x7fff - lowest,flags
    end

    local function exitForm(o,flags,nextDirector,score)
        local run,p = o.run,o.run.player
        if not p or not p.active then o.health = 0x200; return false end
        clear(o.attacks)
        clear(o.directors)
        attach(o.directors,nextDirector)
        o.health = -1
        if nextDirector == 5 then
            o.dying,run.bossEnding = true,true
            p.protect = 0xff
        else
            o.transforming,o.timeout = true,0x6270
        end
        if nextDirector == 3 then hyper.kill(run,flags,score)
        elseif band(flags,p.hitFlags) ~= 0 then p.score = p.score + score end
        bullets.clearWithFade(run)
        return true
    end

    function M.damage(o)
        if o.transforming or o.dying then return end
        if o.form == 1 then
            local amount,flags = poolDamage(o,11,12)
            hyper.hit(o,flags)
            recolor(o,flags,0xe000,3)
            if not o.protected then o.health = o.health - amount end
            if not o.run.freeze then o.timeout = o.timeout - 1 end
            if o.health < 0 or o.timeout == 0 then
                if exitForm(o,flags,3,80000) then
                    o.boxes[11].flags,o.boxes[12].flags = 0x8000,0x8000
                    o.drawShell,o.drawHatch = false,false
                elseif o.timeout == 0 then o.timeout = 0x78 end
            end
            return
        end
        local amount,flags = poolDamage(o,13,13)
        if o.run.bombMode and flags ~= 0 then o.shieldClock = 0x28 end
        local shield = o.shieldClock > 0
        if shield then
            o.shieldClock = o.shieldClock - 1
            o.boxes[13].right,o.boxes[13].left = 0x800,0x800
        else o.boxes[13].right,o.boxes[13].left = 0x500,0x500 end
        if flags == 0 or shield or o.run.enemyShotGrace > 0 then o.corePalette = o.health < 0x1eccc and 25 or 23
        else
            hyper.hit(o,flags)
            o.corePalette = bxor(o.corePalette == 25 and 23 or o.corePalette,8)
            if not o.protected then o.health = o.health - amount end
        end
        if o.health < 0 then
            if exitForm(o,flags,5,1000000) then o.boxes[13].flags = 0x8000; o.corePalette = 23; return end
        end
        if not o.finalDefense and o.health < 0x23000 then
            o.finalDefense,o.protected = true,true
            clear(o.attacks)
            clear(o.directors)
            attach(o.directors,19)
            switchMove(o,11)
            bullets.clearWithFade(o.run)
        end
        if not o.run.freeze then o.timeout = o.timeout - 1 end
        if o.timeout == 0 then
            if exitForm(o,0,5,0) then o.boxes[13].flags = 0x8000; o.corePalette = 23; return end
            o.timeout = 0x78
        end
    end

    local smoke = {{7,0,5},{4,1,7},{7,2,10},{4,3,14},{5,6,18},{4,8,22}}
    local function smokeBurst(o)
        local run = o.run
        local direction = program.bossWideRandom(run)
        local l = floor(program.bossJitter(run) / 4)
        local h = floor(program.bossJitter(run) / 2) - 0x1000
        local commands = {}
        for i,row in ipairs(smoke) do
            local a = direction + floor(program.bossRandom(run) / 4)
            commands[i] = {row[1],row[2],h,l,row[3],a}
        end
        effects.emit(o,commands)
    end

    -- 0x1a46c8 先循环爆炸表，再提高爆炸频率。0x158c6a 的九次更新后才散开最后一批碎片。
    local function ending(o,t)
        if t.phase == 4 then
            t.clock = t.clock - 1
            if t.clock == 0 then o.finished = true; o.directors[t.slot] = nil end
            return
        elseif t.phase == 3 then
            o.drawHull = false
            for i,row in ipairs(data.loop2Death) do
                effects.emit(o,{{row[1],i - 1,row[3],row[4],4 + t.speed + program.bossRandom(o.run),
                    program.bossWideRandom(o.run)}})
            end
            t.phase,t.clock = 4,0x80
            return
        elseif t.phase == 2 then
            t.clock = t.clock - 1
            if t.clock == 0 then t.phase = 3 end
            return
        end

        if t.phase == 1 then
            t.smoke = t.smoke - 1
            if t.smoke < 0 then t.smoke = 0x20; smokeBurst(o) end
            t.accel = t.accel - 1
            if t.accel < 0 then
                t.accel = 0x11
                if t.interval > 2 then t.interval,t.speed = t.interval - 1,t.speed + 1 end
            end
        end
        t.clock = t.clock - 1
        if t.clock >= 0 then return end
        t.clock = t.interval
        local row = data.loop2Death[t.cursor]
        local speed,angle = 0,0
        if t.phase == 1 then
            speed = 2 + floor(program.bossRandom(o.run) / 4) + floor(t.speed / 2)
            angle = program.bossWideRandom(o.run)
        elseif t.cursor % 2 == 1 then program.bossWideRandom(o.run) end
        effects.emit(o,{{row[1],0,row[3],row[4],speed,angle}})
        t.cursor = t.cursor % #data.loop2Death + 1
        if t.cursor ~= 1 then return end
        if t.phase == 0 then t.phase,t.clock,t.interval,t.accel,t.smoke = 1,0x20,0x10,0x11,0x20
        elseif t.interval == 2 then t.phase,t.clock = 2,9 end
    end
    directors[5] = {function(o,t)
        t.phase,t.clock,t.interval,t.cursor,t.speed = 0,1,1,1,0
        ending(o,t)
    end,ending}

    return M
end
