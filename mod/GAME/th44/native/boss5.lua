-- 0x1a2938 的关底机体。调度、移动、攻击、部件和绘制按原部件表的次序推进。
return function(program, bullets, effects, items, remove, hyper)
    local directory = 'mod/GAME/th44/native/'
    local scheduler = dofile(directory .. 'boss_tasks.lua')
    local attack = dofile(directory .. 'boss5_attacks.lua')(program,bullets)
    local loop2Attack = dofile(directory .. 'boss5_second_attacks.lua')(program,bullets)
    local attach,clear,stop,tick = scheduler.attach,scheduler.clear,scheduler.stop,scheduler.tick
    local bit = require('bit')
    local band,bor,bxor = bit.band,bit.bor,bit.bxor
    local s16,world,vector = program.s16,program.world,program.vector
    local min,max,floor = math.min,math.max,math.floor
    local data = program.boss5
    local M = {parts=16}
    local directors,components = {},{}
    local second
    local hitBoxes = {1,2,3,4,5,6,7,14}
    local colors,flashes = {16,17,18,22},{15,14,13,9}
    local deathEffects = {
        {13,0,0x1400,0},{0x85,2,0x1400,0x600,6,0x58},{13,2,0xc00,-0x200,6,0xa8},
        {0x85,6,0x400,-0x400,10,0x88},{13,4,0x600,0x400,10,0x78},
        {0x85,10,-0xa00,0xa00,10,0x70},{13,8,-0x1000,-0x200,5,0x88},
        {0x85,8,-0x2000,-0x400,4,0xa0},{13,8,-0x2800,0x400,4,0x60},
    }
    local sideEffects = {
        {13,0,0x2800,0},{0x85,2,0x2800,0x600,6,0x58},{13,2,0x2000,-0x200,6,0xa8},
        {0x85,6,0x1800,-0x400,10,0x88},{13,4,0x1a00,0x400,10,0x78},
        {0x85,10,0xa00,0xa00,10,0x70},{13,8,0x400,-0x200,5,0x88},
        {0x85,8,-0xc00,-0x400,4,0xa0},{13,8,-0x1400,0x400,4,0x60},
    }

    local function pose(p,h,l)
        p.h,p.l = s16(h),s16(l)
        p.x,p.y = world(p.h,p.l)
    end

    local function move(o)
        local run = o.run
        if o.entry then
            o.h,o.l = s16(0xb000),s16(0x1c00 - run.cameraOffset)
            local a = program.bossWideRandom(run)
            o.mainWave,o.topWave,o.lowerWave = a,band(a + 0x10,255),band(a + 0x40,255)
            o.entry = false
        end
        local place
        if run.loop ~= 0 then
            place = second.move(o)
            pose(o,o.h,o.l)
            if not place then return end
        else pose(o,o.h - run.groundScroll,o.l) end
        for i, anchor in ipairs(data.turretAnchors) do
            pose(o.boxes[i + 1],o.h + anchor[1],o.l + anchor[2])
        end
        for i = 11,14 do pose(o.boxes[i],o.h,o.l) end
    end

    local function updateDraws(o)
        if not o.drawHull or o.form == 2 then return end
        local low = vector(o.form == 1 and 0x1c or 0x1a,o.lowerWave)
        o.coreBob = vector(0x18,o.mainWave)
        o.lowerBob = low
        o.lowerWave,o.mainWave = band(o.lowerWave + (o.form == 1 and 3 or 2),255),band(o.mainWave + 2,255)
        o.tailBob,o.upperBob = vector(0x1a,o.lowerWave),vector(0x10,o.topWave)
        o.topWave = band(o.topWave + 2,255)
        o.front,o.back = 0x1400 + low,0x2200 - low
        local tail = o.boxes[14]
        tail.front,tail.back = -0x2200 + low,0x2600 - low
        for i = 2,7 do
            local p = o.boxes[i]
            p.front,p.back = 0xa00 + o.coreBob,0x600 - o.coreBob
        end
    end

    local function animation(field, delay)
        local function update(o,t)
            t.clock = t.clock - 1
            if t.clock < 0 then t.clock,o[field] = delay,(o[field] + 1) % 6 end
        end
        return {function(o,t) t.clock = 0; update(o,t) end,update}
    end

    components[0],components[1] = animation('upperFrame',1),animation('lowerFrame',2)
    local function aimTurrets(o,t)
        t.clock = t.clock - 1
        if t.clock >= 0 then return end
        t.clock = 1
        local p = o.run.player
        if not p or not p.active then return end
        for i = 2,7 do
            local part = o.boxes[i]
            if not part.held then
                local angle = program.angle(part.h,part.l,p.h,p.l,part.angle)
                part.angle = program.turn64(part.angle,angle)
            end
        end
    end
    components[2] = {function(o,t) t.clock = 0; aimTurrets(o,t) end,aimTurrets}

    local function setBoxes(o,flags)
        for _, i in ipairs(hitBoxes) do o.boxes[i].flags = flags end
    end

    local function intro(o,t)
        t.clock = t.clock - 1
        local run = o.run
        if t.clock == 0x100 and run.loop == 0 then
            o.health = 0x69000
            run.bossHyper,run.scoreOnlyKills = true,true
        end
        if t.clock ~= 0 then return end
        run.hyperDropsLocked = true
        if run.loop == 0 then run.beetlesUseBossHits = true end
        setBoxes(o,0xa001)
        attach(o.directors,6)
        o.directors[t.slot] = nil
    end
    directors[0] = {function(o,t)
        attach(o.components,0)
        attach(o.components,1)
        t.clock = 0x260
        intro(o,t)
    end,intro}

    local function chain(index,delay,rest,nextIndex)
        local function update(o,t)
            if t.clock > 0 then
                if o.run.enemyShotGrace > 0 then return end
                t.clock = t.clock - 1
                if t.clock > 0 then return end
                attach(o.attacks,index)
            end
            if scheduler.contains(o.attacks,index) then return end
            t.rest = t.rest - 1
            if t.rest > 0 then return end
            attach(o.directors,nextIndex)
            o.directors[t.slot] = nil
        end
        return {function(o,t)
            t.clock,t.rest = delay,rest
            if index == 0 then
                attach(o.components,2)
                attach(o.attacks,0)
            end
            update(o,t)
        end,update}
    end
    directors[6],directors[7] = chain(0,0,1,7),chain(1,0x60,1,8)
    directors[8],directors[9] = chain(2,0x60,1,9),chain(3,0x60,0x40,6)

    local function startReflection(o,t)
        if t.clock == 0 or o.run.enemyShotGrace > 0 then return end
        t.clock = t.clock - 1
        if t.clock == 0 then attach(o.attacks,4); o.protected = false end
    end
    directors[14] = {function(o,t)
        t.clock = 0x40
        for i = 2,7 do o.boxes[i].held = false end
        startReflection(o,t)
    end,startReflection}

    local function finish(o,t)
        t.clock = t.clock - 1
        if t.clock == 0 then o.finished = true; o.directors[t.slot] = nil end
    end
    directors[20] = {function(o,t) t.clock = 0x80; finish(o,t) end,finish}

    local function blast(o,t)
        t.clock = t.clock - 1
        if t.clock == 0 then
            if o.form == 0 then effects.close(o.run) end
            effects.emit(o,deathEffects)
            if o.form == 0 then
                for _, l in ipairs({-0xf00,0xf00}) do
                    effects.emit({run=o.run,h=s16(o.h - 0xc00),l=s16(o.l + l)},sideEffects)
                end
            end
            return true
        end
        t.flash = t.flash - 1
        if t.flash >= 0 then return end
        t.flash = 3
        local run = o.run
        program.bossWideRandom(run)
        local kind = data.deathKinds[band(program.bossWideRandom(run),7) + 1]
        local speed,angle = program.dropSpeedRandom(run) + 3,program.bossWideRandom(run)
        local h = program.bossJitter(run)
        local l = floor(program.bossJitter(run) / 2)
        effects.emit(o,{{kind,0,h + floor(h / 2) - 0x800,l,speed,angle}})
    end
    local function explode(o,t)
        if not blast(o,t) then return end
        if o.run.loop == 0 then
            bullets.clearWithChips(o.run,0)
            o.drawHull = false
            for _, offset in ipairs(data.deathPoints) do items.emit(o,0xc,offset[1],offset[2]) end
            attach(o.directors,20)
        else attach(o.directors,2) end
        o.directors[t.slot] = nil
    end
    directors[1] = {function(o,t) t.clock,t.flash = 0xc0,3; explode(o,t) end,explode}
    second = dofile(directory .. 'boss5_second.lua')(program,bullets,effects,scheduler,directors,components,blast,hyper)

    local function endFight(o,credit)
        local run,pilot = o.run,o.run.player
        if not pilot or not pilot.active then return false end
        clear(o.attacks)
        clear(o.directors)
        stop(o.components,2)
        attach(o.directors,1)
        o.health = -1
        if run.loop == 0 then
            o.dying,run.bossEnding = true,true
            pilot.protect = 0xff
        else o.transforming,o.timeout = true,0x6270 end
        o.colors = {unpack(colors)}
        setBoxes(o,0x8000)
        if run.loop ~= 0 then hyper.kill(run,credit,70000)
        elseif band(credit,pilot.hitFlags) ~= 0 then pilot.score = pilot.score + 70000 end
        bullets.clearWithFade(run)
        return true
    end

    local function hitState(o)
        if o.dying or o.transforming then return end
        if o.form ~= 0 then second.damage(o); return end
        local lowest,credit = 0x7fff,0
        for _, i in ipairs(hitBoxes) do
            local p = o.boxes[i]
            credit = bor(credit,band(p.flags,0x5c00))
            lowest = min(lowest,p.hp)
        end
        if credit == 0 then
            for i, bank in ipairs(colors) do o.colors[i] = o.health < 0x15000 and 25 or bank end
        else
            hyper.hit(o,credit)
            for _, i in ipairs(hitBoxes) do
                local p = o.boxes[i]
                p.flags,p.hp = band(p.flags,0xa3ff),0x7fff
            end
            for i, mask in ipairs(flashes) do
                o.colors[i] = bxor(o.colors[i] == 25 and colors[i] or o.colors[i],mask)
            end
            if not o.protected then o.health = o.health - (0x7fff - lowest) end
            if o.health < 0 then
                if endFight(o,credit) then return end
                o.health = 0x200
            end
        end
        if o.run.loop == 0 and not o.reflecting and o.health < 0x2a000 then
            o.reflecting,o.protected = true,true
            clear(o.attacks)
            clear(o.directors)
            attach(o.directors,14)
            bullets.clearWithFade(o.run)
        end
        if not o.run.freeze then
            o.timeout = o.timeout - 1
            if o.timeout == 0 and not endFight(o,0) then o.timeout = 0x78 end
        end
    end

    function M.init(o)
        o.boxes = {o,unpack(o.extraParts)}
        o.h,o.l,o.entry = 0x3800,0x1c00,true
        o.health,o.timeout = 0x3f000,0x6270
        o.form = 0
        o.loop2Ranks = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
        o.colors,o.drawHull = {unpack(colors)},true
        o.lowerFrame,o.upperFrame = 0,0
        o.arrowRank,o.arrowCycles,o.arrowGap,o.arrowRest,o.fanRank = 0,0,0,0,0
        o.sweepLength,o.sweepAimRank,o.sweepRank = 0,0,0
        o.reverseRank,o.reverseSpeed,o.gunRank,o.gunSpeed,o.gunGap = 0,0,0,0,0
        for i, p in ipairs(o.boxes) do
            local box = data.boxes[i]
            p.flags,p.front,p.back,p.right,p.left,p.hp,p.angle =
                0x8000,s16(box[2]),s16(box[3]),s16(box[4]),s16(box[5]),s16(box[6]),band(box[7],0x3f)
        end
        o.directors = {label='五面关底调度',limit=5,handlers=directors}
        o.attacks = {label='五面关底攻击',limit=10,handlers=o.run.loop == 0 and attack or loop2Attack}
        o.components = {label='五面关底部件',limit=10,unique=true,handlers=components}
        attach(o.directors,0)
        o.run.boss5 = o
        o.run.bulletCapacity = max(o.run.bulletCapacity,190)
        return true
    end

    function M.damage(p,amount,flags)
        p.flags,p.hp = bor(p.flags,flags),s16(p.hp - amount)
    end

    function M.step(o)
        local run = o.run
        if o.finished then
            run.boss5,run.stageCleared = nil,true
            remove(o)
            return
        end
        hitState(o)
        if not run.freeze then
            tick(o,o.directors)
            move(o)
            tick(o,o.attacks)
            tick(o,o.components)
        end
        updateDraws(o)
    end

    local function draw(o,p,key,color,frame,dh,dl)
        local image = o.run.art[data.images[key][color][frame + 1]]
        local x,y = world(program.addPacked(p.h,p.l,dh,dl))
        Render(image[1],floor(x) + image[2] / 2,floor(y) + image[3] / 2)
    end

    function M.render(o)
        if not o.run.art or not o.drawHull or o.entry then return end
        local boxes,c = o.boxes,o.colors
        if o.form == 2 then
            draw(o,o,'coreSecond',o.corePalette,o.coreFrame,-0xc00,-0x700)
            if o.shieldClock > 0 and o.run.frame % 2 == 1 then
                draw(o,o,'barrier',23,o.barrierFrame,-0x1080,-0x800)
            end
            return
        end
        if o.form == 1 then
            draw(o,o,'lower',c[3],o.lowerFrame,-0x2800 + o.lowerBob,-0xe00)
            draw(o,o,'bridge',c[2],0,-0xc00,-0xc40)
            draw(o,o,'tail',c[3],0,-0x3400 + o.tailBob,-0x700)
            if o.drawShell then draw(o,o,'shell',20,o.shellFrame or 0,-0x1c00,-0x2200) end
            if o.drawHatch then
                local image = o.run.art[data.hatches[(o.hatchFrame or 0) + 1]]
                local x,y = world(s16(o.h - 0x600),s16(o.l - 0x2000))
                Render(image[1],floor(x) + image[2] / 2,floor(y) + image[3] / 2)
            end
            draw(o,o,'upper',c[1],o.upperFrame,-0x1200 + o.upperBob,-0x1400)
            return
        end
        draw(o,o,'lower',c[3],o.lowerFrame,-0x3000 + o.lowerBob,-0xe00)
        draw(o,o,'core',c[2],0,-0x2400 + o.coreBob,-0x2400)
        draw(o,o,'tail',c[3],0,-0x3c00 + o.tailBob,-0x700)
        for _, i in ipairs({4,3,2,7,6,5}) do
            local p = boxes[i]
            draw(o,p,'turret',c[4],p.angle,-0xe00 + o.coreBob,-0xa00)
        end
        draw(o,o,'upper',c[1],o.upperFrame,-0x1200 + o.upperBob,-0x1400)
    end

    return M
end
