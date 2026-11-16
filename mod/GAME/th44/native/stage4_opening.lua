-- 0x177246 写入四面场景的脉冲。0x179596 与 0x17b918 使用各自的路径及地面碰撞。
return function(program, path, bullets, effects, remove, hyper)
    local bit = require('bit')
    local band,bor,bxor = bit.band,bit.bor,bit.bxor
    local s16,world = program.s16,program.world
    local floor = math.floor
    local data = program.stage4Opening
    local Pulse, Bridge, Hatches, Turret = {parts=1},{parts=2},{parts=1},{parts=1}
    local function draw(o,id,dh,dl,flip)
        local image = o.run.art[id]
        local x,y = world(s16(o.h + dh),s16(o.l + dl))
        Render(image[1],floor(x) + image[2] / 2,floor(y) + image[3] / 2,0,1,flip and -1 or 1)
    end

    function Pulse.init(o)
        o.flags,o.h,o.l,o.clock,o.sign = 0x8000,0,0,7,1
        return true
    end

    function Pulse.step(o)
        local run = o.run
        if run.major >= 0x2e0 then run.stage4Pulse = 0; remove(o); return end
        if run.freeze then return end
        run.stage4Pulse = 0
        o.clock = o.clock - 1
        if o.clock < 0 then
            local rank = math.min(10,run.bulletRank + run.hyperBulletRank)
            o.clock = 7 - (rank > 0 and floor(rank / 7) + 1 or 0)
            run.stage4Pulse,o.sign = o.sign,-o.sign
        end
    end

    function Pulse.render() end

    local function damage(o,amount,flags)
        o.flags,o.hp = bor(o.flags,flags),s16(o.hp - amount)
    end
    Bridge.damage,Hatches.damage,Turret.damage = damage,damage,damage

    function Bridge.init(o)
        if not path.attach(o) then return false end
        local part = o.extraParts[1]
        part.h,part.l = o.h,s16(o.l - 0x800 - o.run.cameraOffset)
        o.l = s16(o.l + 0x1600)
        o.flags,part.flags,o.hp,part.hp = 0xa000,0xa000,0x7fff,0x7fff
        o.front,o.back,o.right,o.left = 0x2000,0x1c00,0x1600,0x1000
        part.front,part.back,part.right,part.left = 0x2000,0x1c00,0xe00,0x1400
        o.palette = o.part[0x1d] or 22
        o.slide = 0
        return true
    end

    function Bridge.step(o)
        local run = o.run
        if not path.step(o,run.groundScroll) then remove(o); return end
        local inside = band(o.h + 0x2000,0xffff) < 0xb000
        if inside then o.entered = true
        elseif o.entered then remove(o); return end
        local part = o.extraParts[1]
        part.h,part.l = o.h,s16(part.l - run.cameraStep)
        local flags = band(bor(o.flags,part.flags),0x5c00)
        if flags ~= 0 then
            o.flags,part.flags = band(o.flags,0xa3ff),band(part.flags,0xa3ff)
            hyper.hit(o,flags)
            o.hp,part.hp = 0x7fff,0x7fff
        end
        if o.part[0x1e] and o.part[0x1e] ~= 0 and not run.freeze then
            o.slide = o.slide + 0x40
            if o.slide >= 0x2a80 then remove(o); return end
            o.l,part.l = s16(o.l + 0x40),s16(part.l - 0x40)
        end
        o.x,o.y = world(o.h,o.l)
    end

    function Bridge.render(o)
        if not o.run.art then return end
        local images = data.bridge[o.palette]
        draw(o,images[1],-0x2000,-0x1600)
        if o.slide < 0x2680 then draw(o.extraParts[1],images[2],-0x2000,-0x1400) end
    end

    function Hatches.init(o)
        local run = o.run
        o.flags,o.hp = 0xa000,0x1600
        o.front,o.back,o.right,o.left = 0x1400,0x1a00,0x800,0x800
        if not path.attach(o) then return false end
        o.basePalette,o.flashMask = unpack(data.palettes[run.stageNumber])
        o.palette = o.basePalette
        o.openClock,o.pose,o.poseClock = band(0x60 - program.rank(run,0x1c,'hatchOpenRank'),255),0,0
        o.phase,o.burst,o.angleStep,o.alternate = 0,5,0,false
        o.driftShots = 0x1f
        o.mirrored = (o.part[0x1e] or 0) ~= 0
        return true
    end

    local function fire(o)
        local run = o.run
        local sign = o.mirrored and -1 or 1
        local dh,dl = o.alternate and -0xd00 or -0xf00,sign * (o.alternate and 0x300 or 0x4c0)
        local a = sign * (0x40 + (o.alternate and 1 or -1) *
            (o.narrow and (o.driftShots * 2 + 0x10) or o.angleStep * 8))
        local h,l = s16(o.h + dh),s16(o.l + dl)
        if run.loop == 0 then bullets.emitPrecise(run,5,4,a,h,l)
        else
            bullets.emitPrecise(run,5,4,a - 8,h,l)
            bullets.emitPrecise(run,5,4,a + 8,h,l)
        end
        o.alternate = not o.alternate
        o.openClock = 1
        if o.narrow then
            o.driftShots = o.driftShots - 1
            if o.driftShots < 0 then
                o.driftShots,o.narrow,o.angleStep,o.openClock,o.phase = 0x1f,false,0,0x10,3
            end
        else
            o.burst = o.burst - 1
            if o.burst < 0 then
                o.burst,o.openClock,o.angleStep = 5,4,o.angleStep + 1
                if o.angleStep == 0xb then o.openClock,o.narrow = 0x10,true end
            end
        end
    end

    function Hatches.step(o)
        local run = o.run
        if not path.step(o,run.groundScroll) then remove(o); return end
        local inside = band(o.h + 0x1c00,0xffff) < 0xa800
        if inside then o.entered = true
        elseif o.entered then remove(o); return end
        if o.dying then
            o.dying = o.dying - 1
            if o.dying < 0 then remove(o) end
            return
        end
        local flags = band(o.flags,0x5c00)
        if flags == 0 then o.palette = o.hp < 0x580 and 25 or o.basePalette
        else
            o.flags = band(o.flags,0xa3ff)
            hyper.hit(o,flags)
            o.palette = bxor(o.palette == 25 and o.basePalette or o.palette,o.flashMask)
            if o.hp < 0 then
                hyper.kill(run,flags,46)
                o.flags,o.dying,o.palette = 0x8080,0x10,o.basePalette
                effects.emit(o,{{13,0,-0x1400,0},{13,0,-0x400,0},{0x85,0,0xc00,0}})
                return
            end
        end
        if not run.freeze and o.h >= 0x1000 then
            if o.phase == 1 or o.phase == 3 and o.openClock == 0 then
                o.poseClock = o.poseClock - 1
                if o.poseClock < 0 then
                    o.poseClock = 1
                    o.pose = o.pose + (o.phase == 1 and 1 or -1)
                    if o.pose == 22 then o.phase = 2
                    elseif o.pose == 14 and o.phase == 3 then
                        o.openClock,o.phase = band(0x40 - program.rank(run,0x1a,'salvoRank'),255),0
                    end
                end
            else
                o.openClock = o.openClock - 1
                if o.openClock < 0 then
                    if o.phase == 0 then o.openClock,o.phase = 0x10,1
                    else fire(o) end
                end
            end
        end
        o.x,o.y = world(o.h,o.l)
    end

    function Hatches.render(o)
        if not o.run.art then return end
        draw(o,data.hatch[o.palette][o.pose + 1],-0x1c00,-0xb00,o.mirrored)
    end

    function Turret.init(o)
        local run = o.run
        o.flags,o.hp = 0xa201,0x70
        o.front,o.back,o.right,o.left = 0x600,0x600,0x400,0x400
        if not path.attach(o) then return false end
        local pilot = run.player
        o.face = pilot and pilot.active and program.angle(o.h,o.l,pilot.h,pilot.l,o.direction) or o.direction
        o.palette,o.flashMask = unpack(data.turretPalettes[run.stageNumber])
        o.basePalette = o.palette
        return true
    end

    function Turret.step(o)
        local run = o.run
        if not path.step(o,run.groundScroll) then remove(o); return end
        local inside = band(o.l + run.cameraOffset + 0xe00,0xffff) < 0x5400
            and band(o.h + 0x600,0xffff) < 0x7c00
        if inside then o.entered = true
        elseif o.entered then remove(o); return end
        local flags = band(o.flags,0x5c00)
        local pilot = run.player
        if flags == 0 then o.palette = o.hp < 0x1c and 25 or o.basePalette
        else
            o.flags = band(o.flags,0xa3ff)
            hyper.hit(o,flags)
            o.palette = bxor(o.palette == 25 and o.basePalette or o.palette,o.flashMask)
            if o.hp < 0 then
                hyper.kill(run,flags,11)
                if run.loop ~= 0 and pilot and pilot.active then
                    local a = program.angle256(o.h,o.l,pilot.h,pilot.l,0x80)
                    bullets.emitPrecise(run,12,1,a,o.h,o.l)
                    bullets.emitPrecise(run,12,7,a,o.h,o.l)
                end
                effects.emit(o,{{2,0,0,0,o.speed + 8,o.direction * 4}})
                remove(o)
                return
            end
        end
        if not run.freeze and run.enemyShotGrace == 0 then
            if pilot and pilot.active then
                o.face = program.turn64(o.face,program.angle(o.h,o.l,pilot.h,pilot.l,o.face))
            end
            if o.h >= 0x1000 and (run.stage4Pulse or 0) ~= 0 then
                local at = data.turretMuzzles[floor(o.face / 2) + 1]
                local speed = run.difficulty == 3 and run.major >= 0x240 and -2 or 3
                bullets.emit(run,7,speed + (run.loop == 0 and 0 or 6),o.face,s16(o.h + at[1]),s16(o.l + at[2]))
            end
        end
        o.x,o.y = world(o.h,o.l)
    end

    function Turret.render(o)
        if not o.run.art then return end
        local frame = floor(o.face / 2) + 1
        draw(o,data.turret[o.palette][frame],-0x800,-0x500)
        if o.run.aimPhase % 2 == 1 then draw(o,data.flame[frame],-0x1200,0x200) end
    end

    return Pulse,Bridge,Hatches,Turret
end
