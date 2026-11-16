-- 0x17a030 先处理机身，再处理左右翼，最后更新中央舱门。
return function(program, path, bullets, effects, remove, supply, hyper)
    local bit = require('bit')
    local band,bor,bxor = bit.band,bit.bor,bit.bxor
    local s16,world = program.s16,program.world
    local abs,floor = math.abs,math.floor
    local art = program.mid4
    local M,Daughter = {parts=3},{parts=1}
    local wingOffsets = {-0x1780,0x1780}
    local wreck = {
        {13,0,0x1400,0}, {0x85,2,0x1400,0x600}, {13,2,0xc00,-0x200},
        {0x85,6,0x400,-0x400}, {13,4,0x600,0x400}, {0x85,10,-0xa00,0xa00},
        {13,8,-0x1000,-0x200}, {0x85,8,-0x2000,-0x400}, {13,8,-0x2800,0x400},
    }
    local sparks = {{13,0,-0x600,0x600},{13,0,-0x200,-0x800},{13,0,0x800,0x800}}
    local sparkHealth = {0x3d72,0x2cb0,0x1bee}
    local wreckKinds = {13,0x85,9,5,0x84,12,10,4}

    local function damage(o, amount, flags)
        o.flags,o.hp = bor(o.flags,flags),s16(o.hp - amount)
    end
    M.damage,Daughter.damage = damage,damage

    local function placeWings(o)
        for i, wing in ipairs(o.wings) do
            wing.h,wing.l = s16(o.h - 0x1400),s16(o.l + (i == 1 and -0x1400 or 0x1400))
            wing.x,wing.y = world(wing.h,wing.l)
        end
    end

    function M.init(o)
        o.flags,o.hp,o.palette = 0xa000,0x7000,15
        o.front,o.back,o.right,o.left = 0x1c00,0x3400,0xe00,0xe00
        if not path.attach(o) then return false end
        o.wings = o.extraParts
        for i, wing in ipairs(o.wings) do
            wing.flags,wing.hp,wing.palette = 0xa000,0x2200,15
            wing.front,wing.back = 0x2800,0x1800
            wing.right,wing.left = i == 1 and 0x800 or 0x1000,i == 1 and 0x1000 or 0x800
            wing.angle,wing.wreckClock = 0,0x2a
        end
        o.phase,o.hatch,o.overlay = 0,0,3
        o.attackClock,o.openClock,o.openGap = 0x90,0,1
        o.wingClock,o.wingGap,o.wingRound,o.waveRound = 0x1c,0x1c,2,1
        o.protection,o.deathClock,o.rewardClock,o.smokeClock,o.sparkIndex = 0x78,0xc0,0x40,3,1
        -- 0x179be2 在入场时打开第一组扩展弹槽，保留道中仍在场的敌弹。
        o.run.bulletCapacity = math.max(o.run.bulletCapacity,110)
        o.run.mid4 = o
        placeWings(o)
        return true
    end

    local function updateHit(o, palette, flash, threshold)
        local flags = band(o.flags,0x5c00)
        if flags == 0 then
            o.palette = o.hp < threshold and 25 or palette
        else
            o.flags = band(o.flags,0xa3ff)
            hyper.hit(o,flags)
            o.palette = bxor(o.palette == 25 and palette or o.palette,flash)
        end
        return flags
    end

    local function breakWing(wing)
        wing.flags,wing.palette = 0x8080,15
        effects.emit(wing,wreck)
    end

    local function tickWreck(wing)
        if wing.wreckClock > 0 then wing.wreckClock = wing.wreckClock - 1 end
    end

    local function aim(o, dh, dl, previous)
        local pilot = o.run.player
        if not pilot or not pilot.active then return end
        return program.angle256(s16(o.h + dh),s16(o.l + dl),pilot.h,pilot.l,previous)
    end

    local function wingFire(o, wing, index)
        if band(wing.flags,0x80) ~= 0 then tickWreck(wing); return end
        local run,pilot = o.run,o.run.player
        local dl = wingOffsets[index]
        if o.wingClock == 0 and pilot and pilot.active and abs(s16(o.l + dl - pilot.l)) < 0xc00 then
            local h,l = s16(o.h - 0x1f00),s16(o.l + dl)
            if run.loop == 0 then bullets.emitPrecise(run,11,6,wing.angle,h,l)
            else
                bullets.emitPrecise(run,11,6,wing.angle - 8,h,l)
                bullets.emitPrecise(run,11,6,wing.angle + 8,h,l)
            end
        end
        local flags = updateHit(wing,15,16,0x880)
        if flags ~= 0 and wing.hp < 0 then
            hyper.kill(run,flags,385)
            breakWing(wing)
        end
    end

    local function volley(o)
        local run = o.run
        local target = aim(o,-0x2a00,0,0)
        if not target then return end
        local muzzles = program.stage2Battleship.muzzles
        local function muzzle(angle)
            local at = muzzles[band(angle + 2,0xfc) / 4 + 1]
            return s16(o.h - 0x2a00 + at[1]),s16(o.l + at[2])
        end
        local function shot(kind, angle, modifier, h, l, split)
            bullets.emitPrecise(run,kind,modifier,angle,h,l)
            if split and run.loop ~= 0 then bullets.emitPrecise(run,kind,modifier + 6,angle,h,l) end
        end
        if o.waveRound ~= 0 then
            for i = 0,6 do
                local angle = target - 0xc + i * 4
                local h,l = muzzle(angle)
                shot(4,angle,-10,h,l,true)
                if i < 6 then shot(4,angle + 2,-6,h,l) end
                shot(4,angle,-2,h,l,true)
                if i < 6 then shot(4,angle + 2,2,h,l) end
            end
        else
            local side = s16(o.h - 0x2a00) < run.player.h and -0x38 or 0x48
            for i = 0,0x1c do
                local angle = side + i * 4
                local h,l = muzzle(angle)
                shot(3,angle,i % 2 == 0 and -4 or -2,h,l,i % 2 == 0)
            end
        end
    end

    local function updateHatch(o)
        local run = o.run
        if run.freeze then return end
        if o.phase == 0 then
            if run.major >= 0x21c then return end
            o.attackClock = o.attackClock - 1
            if o.attackClock < 0 then o.phase = 1 end
            return
        end
        o.openClock = o.openClock - 1
        if o.openClock >= 0 then return end
        o.openClock = o.openGap
        o.hatch = o.hatch + 1
        if o.phase == 1 then
            if o.hatch == 9 then
                volley(o)
                o.phase = 2
            end
            return
        end
        o.overlay = o.overlay - 1
        if o.hatch == 10 then
            local queue = run.spawnQueue
            queue[#queue + 1] = {run.major,0,0x9e,0,0,0x17ab2c,0x17aba2,
                h=s16(o.h + 0x1e00),l=s16(o.l - run.cameraOffset)}
        elseif o.hatch == 16 then
            o.hatch,o.overlay,o.phase,o.openClock,o.openGap = 0,3,1,0,0
            o.waveRound = o.waveRound - 1
            if o.waveRound < 0 then
                o.waveRound,o.attackClock = 1,band(0xa0 - program.rank(run,0x16,'hatchOpenRank'),255)
                o.openClock,o.openGap,o.phase = 1,1,0
            end
        end
    end

    local function updateDeath(o)
        local run = o.run
        for _, wing in ipairs(o.wings) do tickWreck(wing) end
        if o.deathClock > 0 then
            bullets.clearWithChips(run,o.credit)
            o.deathClock = o.deathClock - 1
            if o.deathClock == 0 then
                effects.emit(o,wreck)
            else
                o.smokeClock = o.smokeClock - 1
                if o.smokeClock < 0 then
                    o.smokeClock = 3
                    program.bossWideRandom(run)
                    local kind = wreckKinds[band(program.bossWideRandom(run),7) + 1]
                    program.dropSpeedRandom(run)
                    program.bossWideRandom(run)
                    local dh = floor(program.bossJitter(run) * 1.5) - 0x800
                    local dl = floor(program.bossJitter(run) / 2)
                    effects.emit(o,{{kind,0,dh,dl}})
                end
            end
            return
        end
        if o.rewardClock > 0 then
            o.rewardClock = o.rewardClock - 1
            if o.rewardClock == 0 then supply.emit(o,0x10,math.max(0x1000 - o.h,0)) end
        end
    end

    function M.step(o)
        local run = o.run
        if not path.step(o,run.groundScroll) or band(o.h + 0x3400,0xffff) >= 0xd800 and o.entered then
            if run.mid4 == o then run.mid4 = nil end
            remove(o)
            return
        end
        if band(o.h + 0x3400,0xffff) < 0xd800 then o.entered = true end
        o.x,o.y = world(o.h,o.l)
        placeWings(o)
        if o.dying then updateDeath(o); return end
        if o.protection > 0 then
            o.protection,o.hp = o.protection - 1,0x7000
            for _, wing in ipairs(o.wings) do wing.hp = 0x2200 end
        end
        local flags = updateHit(o,15,16,0x1c00)
        if flags ~= 0 and o.hp < 0 then
            hyper.kill(run,flags,683)
            bullets.clearWithChips(run,flags)
            o.flags,o.palette,o.dying,o.credit = 0x8080,15,true,flags
            for _, wing in ipairs(o.wings) do
                if band(wing.flags,0x80) == 0 then breakWing(wing); o.rewardClock = 0 end
            end
            return
        end
        o.wingClock = o.wingClock - 1
        if o.wingClock < 0 then
            o.wingClock,o.wingRound = 4,o.wingRound - 1
            if o.wingRound < 0 then
                o.wingRound,o.wingClock = 2,o.wingGap
                for i, wing in ipairs(o.wings) do
                    local target = aim(o,-0x1f00,wingOffsets[i],wing.angle)
                    if target then wing.angle = target else o.wingClock = 4 end
                end
            end
        end
        for i, wing in ipairs(o.wings) do wingFire(o,wing,i) end
        while sparks[o.sparkIndex] and o.hp <= sparkHealth[o.sparkIndex] do
            effects.emit(o,{sparks[o.sparkIndex]})
            o.sparkIndex = o.sparkIndex + 1
        end
        updateHatch(o)
    end

    local function draw(o, sprite, dh, dl, flip)
        local image = o.run.art[sprite]
        local x,y = world(s16(o.h + dh),s16(o.l + dl))
        Render(image[1],floor(x) + image[2] / 2,floor(y) + image[3] / 2,0,1,flip and -1 or 1)
    end

    function M.render(o)
        if not o.run.art then return end
        for i, wing in ipairs(o.wings) do
            local frame = wing.wreckClock == 0 and i + 2 or i
            draw(wing,art.wings[wing.palette][frame],-0x2800,-0x1000)
        end
        if not o.dying or o.deathClock > 0 then
            draw(o,art.hull[o.palette][o.hatch + 1],-0x3400,-0x1600)
        end
        if not o.dying and o.phase == 2 and o.overlay >= 0 then
            draw(o,art.cover[17][o.overlay + 1],-0x4800,-0xe00)
        end
    end

    function Daughter.init(o)
        o.flags,o.hp,o.palette = 0xa001,0x400,16
        o.h,o.l = o.row.h,s16(o.row.l + o.run.cameraOffset)
        o.front,o.back,o.right,o.left = 0xe00,0xe00,0x600,0x600
        o.dh,o.dl = 0x600,0x20 + 8 * program.bossRandom(o.run)
        o.flip = program.bossWideRandom(o.run) >= 0x80
        if o.flip then o.dl = -o.dl end
        o.phase,o.pose,o.travel = 0,1,0
        return true
    end

    function Daughter.step(o)
        local run = o.run
        local flags = updateHit(o,16,15,0x100)
        if not run.mid4 or run.mid4.dying or flags ~= 0 and o.hp < 0 then
            hyper.kill(run,flags,0)
            effects.emit(o,{{0x85,12,0,0}})
            remove(o)
            return
        end
        local moving = band(o.flags,0x20) ~= 0
        o.flags = bor(o.flags,0x20)
        if moving then
            o.h = s16(o.h + o.dh)
            if o.phase == 0 then
                o.travel = o.travel + o.dh
                if o.travel >= 0x1600 then o.phase = 1 end
            end
            if o.phase ~= 0 then
                if o.dh > -0x200 then o.dh = o.dh - 0x80 end
                o.pose = (o.pose - 2) % 32 + 1
                if o.phase == 1 then
                    o.travel = o.travel + o.dh
                    if o.travel >= 0x3000 then o.phase = 2 end
                end
                if o.phase == 2 then o.l = s16(o.l - o.dl) end
            end
            if o.dh <= -0x200 then
                local inside = band(o.l + 0xa00,0xffff) < 0x4c00 and band(o.h + 0xe00,0xffff) < 0x8c00
                if inside then o.entered = true
                elseif o.entered then remove(o); return end
            end
        end
        if o.h < 0 then o.flags = band(o.flags,0xfffe) else o.flags = bor(o.flags,1) end
        o.x,o.y = world(o.h,o.l)
    end

    function Daughter.render(o)
        if o.run.art and o.h >= 0 then
            draw(o,art.daughter[o.palette][o.pose],-0xe00,-0xa00,o.flip)
        end
    end

    return M,Daughter
end
