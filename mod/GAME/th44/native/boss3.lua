-- V101 三面关底 0x19a11e。共用耐久先结算，随后按原槽序推进调度、本体机动、攻击和部件。
return function(program, bullets, effects, remove, hyper)
    local directory = 'mod/GAME/th44/native/'
    local scheduler = dofile(directory .. 'boss_tasks.lua')
    local attach, clear, stop, tick = scheduler.attach, scheduler.clear, scheduler.stop, scheduler.tick
    local bit = require('bit')
    local band, bor, bxor = bit.band, bit.bor, bit.bxor
    local s16, world = program.s16, program.world
    local data = program.boss3
    local M = {parts=10}
    local bodyParts = {1,2,3,7,8}
    local normalColors = {16,17,18}
    local patrol = {
        [1]={0x3a00,0x4e00,0x5c00,0x6400},
        [2]={0x3600,0x5200,0x6600,0x6a00},
        [3]={0x3c00,0x4c00,0x5e00,0x6600},
    }

    local function place(o)
        o.x,o.y = world(o.h,o.l)
        for i, wing in ipairs(o.wings) do
            local side = i == 1 and -1 or 1
            wing.h,wing.l = s16(o.h - 0x800 + o.wingH),s16(o.l + side * (0xc00 - o.wingL))
            wing.x,wing.y = world(wing.h,wing.l)
            local shell = o.boxes[i + 6]
            shell.h,shell.l,shell.x,shell.y = wing.h,wing.l,wing.x,wing.y
        end
    end

    local function move(o)
        local h,l = program.vector(o.speed,o.direction * 4)
        o.h,o.l = s16(o.h + h),s16(o.l + l)
    end

    local function phase(o, index)
        o.pendingPhase = index
    end

    local function tickPhase(o)
        if o.pendingPhase then
            o.phase,o.pendingPhase,o.heading = o.pendingPhase,nil,nil
            if o.phase == 0 then
                o.h,o.l = 0x4400,-0x1400
                o.speed,o.direction,o.entryClock = 12,14,0x18
            end
        end
        if o.phase == 0 then
            o.entryClock = o.entryClock - 1
            if o.entryClock < 0 then
                o.entryClock = 0x18
                if o.speed > 4 then o.speed = o.speed - 1
                elseif not scheduler.contains(o.components,7) then
                    attach(o.directors,2)
                    place(o)
                    return
                end
            end
            move(o)
        else
            move(o)
            if o.heading then
                o.direction = program.turn64(o.direction,o.heading)
                if o.direction == o.heading then o.heading = nil end
            end
            local choice = program.bossRandom(o.run)
            local l = band(o.l + 0x2800,0xffff)
            local bounds = patrol[o.phase]
            if l < bounds[1] then choice = choice + 0x10
            elseif l >= bounds[2] then choice = choice + 0x30
            elseif band(o.h,0xffff) >= bounds[3] then
                if band(o.h,0xffff) < bounds[4] then place(o); return end
                choice = choice + 0x20
            end
            o.heading = band(choice,0x3f)
        end
        place(o)
    end

    local function setBoxes(o, enabled)
        for _, index in ipairs(bodyParts) do o.boxes[index].flags = enabled and 0xa001 or 0x8000 end
    end

    local function endFight(o)
        local run = o.run
        if not run.player or not run.player.active then return false end
        clear(o.attacks)
        clear(o.directors)
        stop(o.components,2)
        stop(o.components,3)
        attach(o.directors,1)
        o.health,o.dying,run.bossEnding = -1,true,true
        o.colors = normalColors
        run.player.protect = 0xff
        setBoxes(o,false)
        return true
    end

    local function damageState(o)
        if o.dying then return end
        local damage,flags = 0,0
        for _, index in ipairs(bodyParts) do
            local part = o.boxes[index]
            flags = bor(flags,band(part.flags,0x5c00))
            damage = math.max(damage,band(0x7fff - part.hp,0xffff))
        end
        if flags == 0 then
            o.colors = o.health < 0x8c00 and {25,25,25} or normalColors
        else
            hyper.hit(o,flags)
            local current = o.colors[1] == 25 and normalColors or o.colors
            o.colors = {bxor(current[1],15),bxor(current[2],14),bxor(current[3],13)}
            for _, i in ipairs(bodyParts) do
                local part = o.boxes[i]
                part.flags,part.hp = band(part.flags,0xa3ff),0x7fff
            end
            if not o.protected then o.health = o.health - damage end
            if o.health < 0 then
                o.credit = flags
                if not endFight(o) then o.health = 0x200 end
            end
        end
        if o.dying then return end
        if not o.final and o.health < 0x11800 then
            o.final,o.protected = true,true
            clear(o.attacks)
            clear(o.directors)
            attach(o.directors,9)
            o.run.bulletCapacity = math.max(o.run.bulletCapacity,190)
            bullets.clearWithFade(o.run)
        end
        if not o.run.freeze then
            o.timeout = o.timeout - 1
            if o.timeout == 0 and not endFight(o) then o.timeout = 0x78 end
        end
    end

    local callbacks = dofile(directory .. 'boss3_tasks.lua')(program, bullets, effects, scheduler, {
        phase=phase, setBoxes=setBoxes,
    })

    function M.init(o)
        o.run.bossHyper,o.run.scoreOnlyKills,o.run.hyperDropsLocked = true,true,true
        o.boxes = {o,unpack(o.extraParts)}
        o.wings = {o.boxes[2],o.boxes[3]}
        o.h,o.l,o.health,o.timeout = 0x3800,0x1c00,0x40c00,0x3840
        o.speed,o.direction,o.tailFrame,o.wingFrame = 0,0,0,0
        o.wingH,o.wingL,o.coverFrame,o.openingFrame = 0,0,0,0
        o.colors,o.draws = normalColors,{[9]=true}
        o.folded,o.turretAngles = {0,0},{0,0}
        o.coverWait = 0x70
        o.tuning = {wingRounds=0,wingGap=0,wingSpeed=0,podGap=0,podSpeed=0,outerSpeed=0,outerCount=0,
            outerSpread=0,sweepSpeed=0,largeCount=0,largeCycles=0,largeSpeed=0,coreSpeed=0,coreCycles=0,wingDelay=0}
        o.phase,o.protected = -1,true
        for i, part in ipairs(o.boxes) do
            part.h,part.l,part.flags = o.h,o.l,0x8000
            part.front,part.back,part.right,part.left,part.hp = unpack(data.boxes[i])
            part.front,part.back = s16(part.front),s16(part.back)
        end
        o.directors = {label='三面关底调度',limit=5,handlers=callbacks.directors}
        o.attacks = {label='三面关底攻击',limit=10,handlers=callbacks.attacks}
        o.components = {label='三面关底部件',limit=10,unique=true,handlers=callbacks.components}
        attach(o.directors,0)
        local run = o.run
        run.boss3 = o
        run.bulletCapacity = math.max(run.bulletCapacity,run.loop == 0 and 160 or 190)
        place(o)
        return true
    end

    function M.damage(part, amount, flags)
        part.flags,part.hp = bor(part.flags,flags),s16(part.hp - amount)
    end

    function M.step(o)
        local run = o.run
        if o.finished then
            run.boss3,run.stageCleared = nil,true
            remove(o)
            return
        end
        damageState(o)
        if run.freeze then return end
        tick(o,o.directors)
        tickPhase(o)
        tick(o,o.attacks)
        tick(o,o.components)
    end

    local function draw(o, part, key, bank, frame, dh, dl, flip)
        local image = o.run.art[data.images[key][bank][frame + 1]]
        local h,l = program.addPacked(part.h,part.l,dh,dl)
        local x,y = world(h,l)
        Render(image[1],math.floor(x) + image[2] / 2,math.floor(y) + image[3] / 2,0,1,flip and -1 or 1)
    end

    function M.render(o)
        local art = o.run.art
        if not art then return end
        local enabled = o.draws
        if enabled[9] then
            local row = data.images.opening[math.floor(o.openingFrame / 12) + 1]
            local image = art[row[1]]
            local h,l = program.addPacked(o.h,o.l,row[2] - 0x900,row[3])
            local x,y = world(h,l)
            Render(image[1],math.floor(x) + image[2] / 2,math.floor(y) + image[3] / 2)
        end
        local hull,wing,tail = unpack(o.colors)
        if enabled[0] then draw(o,o,'tail',tail,o.tailFrame,-0x2fc0,-0x1800) end
        if enabled[1] then draw(o,o,'body',hull,0,-0x2200,-0x1400) end
        if enabled[2] then draw(o,o,'podFolded',17,o.folded[1],-0xb40,-0xe00) end
        if enabled[3] then draw(o,o,'podFolded',17,o.folded[2],-0xb40,0x600,true) end
        if enabled[4] then draw(o,o.wings[1],'wingLeft',wing,o.wingFrame,-0x1c00,-0x900) end
        if enabled[5] then draw(o,o.wings[2],'wingRight',wing,o.wingFrame,-0x1c00,-0x900) end
        if enabled[6] then draw(o,o.wings[1],'turret',wing,math.floor(o.turretAngles[1] / 2),0xd00,-0x280) end
        if enabled[7] then draw(o,o.wings[2],'turret',wing,math.floor(o.turretAngles[2] / 2),0xd00,-0x380) end
        if enabled[8] then draw(o,o,'cover',wing,o.coverFrame,-0x13c0,-0xc00) end
        if o.wipe then
            local image = art[program.boss1.wipe[o.wipe]]
            local x,y = world(math.max(0,0x1c00 - o.wipe * 0x400),0)
            Render(image[1],math.floor(x) + image[2] / 2,math.floor(y) + image[3] / 2)
        end
    end

    return M
end
