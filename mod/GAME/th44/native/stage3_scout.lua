-- 0x163d14 使用两块重叠的判定盒。同一帧按其中较大的伤害扣耐久。
return function(program, path, bullets, effects, remove, hyper)
    local bit = require('bit')
    local band, bor = bit.band, bit.bor
    local s16, world = program.s16, program.world
    local floor, max = math.floor, math.max
    local M = {parts=2}

    function M.init(o)
        local run = o.run
        o.randomEntry = o.callback == 0x1640de
        if not o.randomEntry and run.major > 0x10 and run.major < 0x36 and run.carrierPresent then return false end
        o.flags,o.hp,o.health = 0xa201,0x7fff,0x100
        o.front,o.back,o.right,o.left = 0x500,0x400,0x400,0x400
        o.speed,o.face,o.trackClock,o.trackTime = 0x10,0x20,2,0x60
        o.fireClock,o.palette,o.rotor = 0xc,13,0
        local rear = o.extraParts[1]
        rear.flags,rear.hp = 0xa200,0x7fff
        rear.front,rear.back,rear.right,rear.left = 0xc00,0x1000,0x780,0x780
        if o.randomEntry and run.difficulty == 4 then
            o.h,o.l = 0x7400,0x1c00
        elseif not path.attach(o) then return false end
        if o.randomEntry then
            run.randomByte = band(run.randomByte + 1,0xff)
            o.l = s16(0x1c00 + program.boss2.jitter[band(run.randomByte,0x7f) + 1])
            o.speed,o.face,o.health = 0x28,0x20,0x50
            o.trackClock,o.fireClock = 4,8
            if run.difficulty == 4 then o.basePalette,o.flashMask = 15,16 end
        else o.face = band(o.direction,0x3f) end
        o.basePalette,o.flashMask = o.basePalette or 13,o.flashMask or 18
        o.palette = o.basePalette
        return true
    end

    function M.damage(o, amount, flags)
        o.hp,o.flags = s16(o.hp - amount),bor(o.flags,flags)
    end

    local function fire(o)
        local run = o.run
        o.fireClock = o.fireClock - 1
        if o.fireClock >= 0 then return end
        if o.randomEntry then
            o.fireClock = 0x40
            if not program.inAimHeight(run,o.h) then return end
            if run.difficulty == 4 then
                if run.loop == 0 then bullets.emit(run,12,-4,o.face,o.h,o.l)
                else
                    bullets.emitPrecise(run,12,-4,o.face * 4 - 8,o.h,o.l)
                    bullets.emitPrecise(run,12,-4,o.face * 4 + 8,o.h,o.l)
                end
                local speed = run.loop == 0 and -4 or 0
                bullets.emit(run,12,speed,o.face + 2,o.h,o.l)
                bullets.emit(run,12,speed,o.face - 2,o.h,o.l)
            elseif run.loop == 0 then bullets.emit(run,12,1,o.face,o.h,o.l)
            else
                bullets.emit(run,12,3,o.face,o.h,o.l)
                bullets.emitPrecise(run,12,1,o.face * 4 - 8,o.h,o.l)
                bullets.emitPrecise(run,12,1,o.face * 4 + 8,o.h,o.l)
            end
            return
        end
        o.fireClock = band(0x3a - program.rank(run,0x1c,'salvoRank'),0xff)
        if o.h < 0x2800 then return end
        local angle = o.face * 4
        local muzzle = program.stage2Battleship.muzzles[band(angle + 2,0xfc) / 4 + 1]
        local h,l = s16(o.h + muzzle[1]),s16(o.l + muzzle[2])
        local wide = run.loop ~= 0
        local function volley(kind, speed, facing)
            bullets.emitPrecise(run,kind,speed,facing,h,l)
            if wide then
                bullets.emitPrecise(run,kind,speed,facing - 8,h,l)
                bullets.emitPrecise(run,kind,speed,facing + 8,h,l)
            end
        end
        if run.difficulty == 4 then
            volley(12,6,angle)
            volley(12,6,angle + 8)
            volley(12,6,angle - 8)
            volley(13,4,angle + 4)
            volley(13,4,angle - 4)
        else
            volley(12,2,angle)
            bullets.emitPrecise(run,12,2,angle + 8,h,l)
            bullets.emitPrecise(run,12,2,angle - 8,h,l)
        end
    end

    function M.step(o)
        local run = o.run
        local inside = band(o.h + 0x800,0xffff) < 0x8000
            and band(o.l + 0x1c00 + run.cameraOffset,0xffff) < 0x7000
        if inside then o.entered = true
        elseif o.entered then remove(o); return end
        if not run.freeze then
            local dh,dl = program.vector(o.speed,o.face * 4)
            o.h,o.l = s16(o.h + dh),s16(o.l + dl)
            if o.trackTime > 0 then
                o.trackTime,o.trackClock = o.trackTime - 1,o.trackClock - 1
                if o.trackClock < 0 then
                    o.trackClock = o.randomEntry and 4 or 2
                    local pilot = run.player
                    if pilot and pilot.active then
                        local target = program.angle(o.h,o.l,pilot.h,pilot.l,o.face)
                        o.face = program.turn64(o.face,target)
                    end
                end
            end
        end
        local rear = o.extraParts[1]
        rear.h,rear.l = o.h,o.l
        local credit = band(bor(o.flags,rear.flags),0x5c00)
        if credit ~= 0 then
            o.palette = bit.bxor(o.basePalette,o.flashMask)
            o.flags,rear.flags = band(o.flags,0xa3ff),band(rear.flags,0xa3ff)
            hyper.hit(o,credit)
            o.health = o.health - max(band(0x7fff - o.hp,0xffff),band(0x7fff - rear.hp,0xffff))
            o.hp,rear.hp = 0x7fff,0x7fff
            if o.health < 0 then
                hyper.kill(run,credit,19)
                effects.emit(o,{{0x82,0,0,0,o.speed,o.face * 4}})
                if o.randomEntry and band(o.h,0xffff) >= 0x3200 then
                    if run.loop == 0 then bullets.emit(run,12,1,o.face,o.h,o.l)
                    else
                        bullets.emitPrecise(run,12,1,o.face * 4 - 8,o.h,o.l)
                        bullets.emitPrecise(run,12,1,o.face * 4 + 8,o.h,o.l)
                    end
                end
                remove(o)
                return
            end
        else
            o.palette = o.basePalette
        end
        fire(o)
        if run.frame % 2 ~= 0 then o.rotor = 1 - o.rotor end
        o.x,o.y = world(o.h,o.l)
        rear.x,rear.y = o.x,o.y
    end

    function M.render(o)
        if not o.run.art then return end
        local index = band(o.face + 1,0x3e) + o.rotor + 1
        local image = o.run.art[program.stage3Scout[o.palette][index]]
        local x,y = world(s16(o.h - 0x600),s16(o.l - 0x500))
        Render(image[1],floor(x) + image[2] / 2,floor(y) + image[3] / 2)
    end

    return M
end
