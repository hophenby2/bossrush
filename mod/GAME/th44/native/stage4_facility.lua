-- 0x17b0c0 推进机库舱门、升降台和共用耐久的两处碰撞盒。
return function(program, path, bullets, effects, items, remove, hyper)
    local bit = require('bit')
    local band,bor,bxor = bit.band,bit.bor,bit.bxor
    local s16,world = program.s16,program.world
    local floor = math.floor
    local art = program.stage4Facility
    local Facility,Smoke = {parts=3},{parts=1}
    local wreck = {
        {13,0,0x2800,0}, {0x85,2,0x2800,0x600}, {13,2,0x2000,-0x200},
        {0x85,6,0x1800,-0x400}, {13,4,0x1a00,0x400}, {0x85,10,0xa00,0xa00},
        {13,8,0x400,-0x200}, {0x85,8,-0xc00,-0x400}, {13,8,-0x1400,0x400},
        {0x85,10,-0x2400,-0x400}, {13,10,-0x2c00,0x400},
    }
    local wreckKinds = {13,0x85,9,5,0x84,12,10,4}

    function Facility.damage(o, amount, flags)
        o.flags,o.hp = bor(o.flags,flags),s16(o.hp - amount)
    end

    local function place(o)
        local door,hull = unpack(o.extraParts)
        o.x,o.y = world(o.h,o.l)
        door.h,door.l,hull.h,hull.l = s16(o.h - 0x2400),o.l,o.h,o.l
        door.x,door.y = world(door.h,door.l)
        hull.x,hull.y = o.x,o.y
    end

    function Facility.init(o)
        if not path.attach(o) then return false end
        local door,hull = unpack(o.extraParts)
        o.flags,door.flags,hull.flags = 0x8000,0x8000,0x8000
        o.hp,door.hp,hull.hp = 0x7800,0x7fff,0x7800
        o.front,o.back,o.right,o.left = 0x400,0x2400,0x1000,0x1000
        hull.front,hull.back,hull.right,hull.left = o.front,o.back,o.right,o.left
        door.front,door.back,door.right,door.left = 0x600,0x1e00,0xe00,0xe00
        o.phase,o.palette,o.protection = 0,19,0x12c
        o.lift,o.heightAdjustment = 0,0
        o.doorFrame,o.doorNext,o.doorClock,o.doorLoop,o.doorLimit = 0,0,0,0,2
        o.deathClock,o.smokeClock,o.wreckClock = 0xe0,3,0x2a
        place(o)
        return true
    end

    local function updateDoor(o)
        o.doorClock = o.doorClock - 1
        if o.doorClock < 0 then
            o.doorClock = 0
            o.doorFrame = o.doorNext
            o.doorNext = o.doorNext + 1
            if o.doorNext == o.doorLimit then o.doorNext = o.doorLoop end
        end
    end

    local function updatePhase(o)
        local door,hull = unpack(o.extraParts)
        local h = band(o.h,0xffff)
        if o.phase == 0 then
            if h <= 0x7000 then o.phase,o.lift = 1,-0x40 end
            return
        end
        if o.lift < 0x2400 then o.lift = o.lift + 0x40 end
        if o.phase == 1 then
            if h <= 0x5000 then o.phase = 2 end
            return
        end
        if band(o.flags,0x2000) == 0 then
            o.h = s16(o.h + 0x40)
            o.heightAdjustment = o.heightAdjustment + 0x40
            if o.heightAdjustment == 0x1040 then
                o.h,o.heightAdjustment = s16(o.h - 0x40),0x1000
                o.flags,hull.flags = 0xa000,0xa000
            end
        end
        h = band(o.h,0xffff)
        if o.phase == 2 then
            local queue = o.run.spawnQueue
            queue[#queue + 1] = {o.run.major,0,0xa4,0,0,0x17c332,0x17c3f2,anchor=door}
            if h <= 0x4600 then o.phase,o.doorLoop,o.doorLimit = 3,6,8 end
        elseif o.phase == 3 then
            if h <= 0x4000 then o.phase,o.doorLoop,o.doorLimit = 4,13,15 end
        elseif o.phase == 4 and o.doorFrame == 13 then
            door.flags,o.phase = 0xa001,5
        end
    end

    local function updateDeath(o)
        local run = o.run
        if o.deathClock > 0 then
            if o.deathClock == 1 then
                local l = o.l
                o.l = s16(l - 0xd80)
                effects.emit(o,wreck)
                o.l = s16(l + 0xd80)
                effects.emit(o,wreck)
                o.l = l
            else
                bullets.clearWithFade(run,o.credit)
                o.smokeClock = o.smokeClock - 1
                if o.smokeClock < 0 then
                    o.smokeClock = 3
                    program.bossWideRandom(run)
                    local kind = wreckKinds[band(program.bossWideRandom(run),7) + 1]
                    program.dropSpeedRandom(run)
                    program.bossWideRandom(run)
                    local dh = program.bossJitter(run)
                    dh = dh + floor(dh / 2) + floor(dh / 4) - 0x800
                    local dl = floor(program.bossJitter(run) / 2)
                    effects.emit(o,{{kind,0,dh,dl + floor(dl / 2)}})
                end
            end
            o.deathClock = o.deathClock - 1
        elseif o.wreckClock > 0 then
            bullets.clearWithFade(run,o.credit)
            o.wreckClock = o.wreckClock - 1
        end
    end

    function Facility.step(o)
        local run = o.run
        local door,hull = unpack(o.extraParts)
        if not path.step(o,run.groundScroll) then remove(o); return end
        if band(o.h + 0x3800,0xffff) < 0xe000 then o.entered = true
        elseif o.entered then remove(o); return end
        if o.dying then
            updateDeath(o)
            place(o)
            return
        end
        door.flags,door.hp = band(door.flags,0xa3ff),0x7fff
        if o.protection > 0 then o.protection,o.hp,hull.hp = o.protection - 1,0x7800,0x7800 end
        local flags = band(bor(o.flags,hull.flags),0x5c00)
        if flags == 0 then o.palette = o.hp < 0x1e00 and 25 or 19
        else
            o.flags,hull.flags = band(o.flags,0xa3ff),band(hull.flags,0xa3ff)
            hyper.hit(o,flags)
            o.palette = bxor(o.palette == 25 and 19 or o.palette,12)
            o.hp = math.min(o.hp,hull.hp)
            hull.hp = o.hp
            if o.hp < 0 then
                hyper.kill(run,flags,788)
                o.dying,o.flags,door.flags,hull.flags,o.palette,o.credit = true,0x8080,0x8000,0x8000,19,flags
                bullets.clearWithFade(run,flags)
                return
            end
        end
        if not run.freeze then updatePhase(o) end
        updateDoor(o)
        place(o)
    end

    local function draw(o,sprite,h,l,dh,dl)
        local image = o.run.art[sprite]
        local x,y = world(s16(h + dh),s16(l + dl))
        Render(image[1],floor(x) + image[2] / 2,floor(y) + image[3] / 2)
    end

    function Facility.render(o)
        if not o.run.art then return end
        local body = o.dying and o.deathClock == 0 and o.wreckClock == 0 and art.wreck[51][1] or art.body[o.palette][1]
        draw(o,body,o.h,o.l,-0x3800,-0x2400)
        if o.dying then return end
        local door = o.extraParts[1]
        if door.h > -0x800 then draw(o,art.door[21][o.doorFrame + 1],door.h,door.l,-0x1e00,-0x2400) end
        if o.lift < 0x2400 then draw(o,art.lift[20][1],o.h,o.l,-0x4800 - o.lift,-0xc00) end
    end

    function Smoke.init(o)
        local run = o.run
        o.anchor = o.row.anchor
        o.host,o.hostSlot = o.anchor.host,o.anchor.host.slot
        o.flags,o.h,o.l = 0x8000,o.anchor.h,o.anchor.l
        run.randomByte = band(run.randomByte + 1,0xff)
        o.speed = 0x70 + 2 * program.bossRandom(run)
        o.angle = band(program.bossWideRandom(run),0x7f) + 0x40
        run.randomByte = band(run.randomByte + 1,0xff)
        local set = string.byte(program.stage4Fleet.craftWreckRandom,band(run.randomByte,0x7f) + 1)
        o.poseEnd,o.clock = (set + 1) * 8,1
        o.pose = set * 8 + program.dropSpeedRandom(run) + 1
        return true
    end

    function Smoke.step(o)
        if o.run.enemies[o.hostSlot] ~= o.host then remove(o); return end
        if o.run.freeze then return end
        local direction = band(o.angle,0x3f)
        if band(o.angle,0x40) ~= 0 then direction = 64 - direction end
        local offset = (o.speed / 2 * 65 + direction) * 4 + 1
        local h,l = program.word(art.smokeVectors,offset),program.word(art.smokeVectors,offset + 2)
        local dh,dl = floor(h / 2),floor(l / 2)
        local tailH,tailL = floor(h / 8),floor(l / 8)
        if band(o.angle + 0x40,0x80) ~= 0 then dh,tailH = -dh,-tailH end
        if band(o.angle,0x80) ~= 0 then dl,tailL = -dl,-tailL end
        local anchor = o.anchor
        o.h,o.l = s16(anchor.h + 0x800 + 2 * dh),s16(anchor.l + 6 + dl)
        o.tailH,o.tailL = s16(anchor.h + 0x800 + tailH),s16(anchor.l + 6 + tailL)
        o.speed,o.clock = o.speed - 4,o.clock - 1
        if o.speed < 0 then remove(o); return end
        if o.clock < 0 then
            o.clock,o.pose = 1,o.pose + 1
            if o.pose > o.poseEnd then remove(o) end
        end
    end

    function Smoke.render(o)
        if not o.run.art then return end
        draw(o,art.smoke[21][o.pose],o.h,o.l,-0x400,-0x300)
        if o.tailH then draw(o,art.smoke[21][o.pose],o.tailH,o.tailL,-0x400,-0x300) end
    end

    return Facility,Smoke
end
