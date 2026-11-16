-- 0x1a1b92 和 0x1a1e3e 是关底任务生成的两个敌机回调。
return function(program, bullets, effects, remove, hyper)
    local bit = require('bit')
    local band,bor,bxor = bit.band,bit.bor,bit.bxor
    local s16,world = program.s16,program.world
    local abs,floor,max,min = math.abs,math.floor,math.max,math.min
    local data = program.boss4.images
    local Seed,Orb = {parts=1},{parts=5}

    local function damage(o, amount, flags)
        o.flags,o.hp = bor(o.flags,flags),s16(o.hp - amount)
    end
    Seed.damage,Orb.damage = damage,damage

    local function inBounds(o)
        return band(o.h + 0x800,0xffff) < 0x8000 and band(o.l + 0x1c00 + o.run.cameraOffset,0xffff) < 0x7000
    end

    local function draw(o, sprite, dh, dl)
        local art = o.run.art[sprite]
        local x,y = world(s16(o.h + dh),s16(o.l + dl))
        Render(art[1],floor(x) + art[2] / 2,floor(y) + art[3] / 2)
    end

    function Seed.init(o)
        o.flags,o.hp,o.owner = 0x8001,0x7fff,o.row.owner
        o.h,o.l,o.speed,o.dir = o.row.h,o.row.l,o.row.speed,band(o.row.dir,0x3f)
        o.front,o.back,o.right,o.left = 0x80,0x80,0x80,0x80
        o.turn,o.clock = o.dir,0
        return true
    end

    function Seed.step(o)
        local run = o.run
        if run.boss4 ~= o.owner or o.owner.dying then remove(o); return end
        if band(o.flags,0x5c00) ~= 0 then o.flags,o.hp = band(o.flags,0xa3ff),0x7fff end
        if inBounds(o) then o.entered = true
        elseif o.entered then remove(o); return end
        if not run.freeze then
            local dh,dl = program.vector(o.speed,o.dir * 4)
            o.h,o.l = s16(o.h + dh),s16(o.l + dl)
        end
        if not o.aimed then o.turn = (o.turn + 4) % 64 end
        o.clock = o.clock - 1
        if o.clock < 0 then
            o.clock = 0
            if o.aimed then o.speed = min(0x24,o.speed + 1)
            else
                o.speed = o.speed - 1
                if o.speed == 0 then
                    o.aimed = true
                    local pilot = run.player
                    if pilot and pilot.active then o.dir = program.angle(o.h,o.l,pilot.h,pilot.l,o.dir) end
                    o.turn = o.dir
                end
            end
        end
        o.x,o.y = world(o.h,o.l)
    end

    function Seed.render(o)
        if o.run.art then draw(o,data.seed[26][band(o.turn + 1,0x3e) / 2 + 1],-0x200,-0x200) end
    end

    local function point(o,p)
        local dh,dl = program.vector(o.radius,floor(o.angle / 16))
        return s16(p.h - 0x2000 + dh * 8),s16(p.l + dl * 8)
    end

    function Orb.init(o)
        local row = o.row
        o.owner = row.owner
        if o.run.boss4 ~= o.owner then return false end
        for _, part in ipairs(o.extraParts) do part.flags = 0x8000 end
        o.hp,o.front,o.back,o.right,o.left = 0x7fff,0x200,0x100,0x100,0x100
        o.angle,o.spin,o.radius,o.mode = row.angle * 16,row.orbit,row.velocity,row.mode
        o.final,o.guide = row.final,row.mode == 0x70 or row.mode == 0x71
        o.flags = 0x8000
        o.h,o.l = point(o,o.owner.boxes[2])
        o.pose,o.anim,o.angleClock,o.palette = 0,0,0,26
        o.volleyClock,o.volleyLeft,o.volleyAim = 2,0,0
        o.osc,o.oscClock,o.oscLimit,o.oscDirection = 0,4,10,1
        o.patternClock = 6
        o.fixed = row.angle == 0x10 or row.angle == 0x65 or row.angle == 0xbb
            or row.angle == 0xf0 or row.angle == 0x45 or row.angle == 0x9b
        return true
    end

    local function fire(o,kind,speed,a,split)
        local run = o.run
        if split and run.loop ~= 0 then
            bullets.emitPrecise(run,kind,speed,a - 8,o.h,o.l)
            bullets.emitPrecise(run,kind,speed,a + 8,o.h,o.l)
        else bullets.emitPrecise(run,kind,speed,a,o.h,o.l) end
    end

    local function arrive(o)
        local a = floor(o.angle / 16)
        if o.arrived or a > 1 and a < 0xfe then return end
        o.arrived,o.flags = true,0xa001
        o.owner.orbArrivals = (o.owner.orbArrivals or 0) + 1
    end

    local function updateSpin(o)
        if o.departClock and o.departClock > 0 then
            o.departClock = o.departClock - 1
            if o.departClock == 0 then o.spin = o.savedSpin end
        elseif o.departClock then
            o.radius = o.radius - 1
            if o.radius <= 8 then
                o.radius,o.departClock,o.leaving = 8,nil,true
            end
        elseif o.leaving then o.radius = o.radius + 2 end
        if not o.final or o.row.orbit < 0 then return end
        if o.osc == 0 and o.owner.orbPulse then o.osc = 1 end
        if o.osc == 0 then return end
        o.oscClock = o.oscClock - 1
        if o.oscClock < 0 then
            o.oscClock = 4
            local target = (o.spinTarget or o.row.orbit) - o.oscDirection
            o.spinTarget = target
            if o.osc == 1 and target <= 4 then o.osc,o.oscClock = 2,0x60
            elseif o.osc == 2 and abs(target) >= o.oscLimit then
                o.osc,o.oscDirection,o.oscLimit = 0,-o.oscDirection,min(16,o.oscLimit + 2)
            end
        end
    end

    local function updateFire(o)
        if not o.arrived then return end
        local a = floor(o.angle / 16)
        local owner,frame = o.owner,o.run.frame
        if o.final then
            if o.guide then
                owner.orbAngles[o.mode - 0x70 + 1] = a
            else
                o.patternClock = o.patternClock - 1
                if o.patternClock < 0 then
                    o.patternClock = 6
                    local delta = ({-16,-4,4,16})[o.mode % 4 + 1]
                    fire(o,7,-3,(owner.orbAngles[floor(o.mode / 4) + 1] or 0) + 0x80 + delta,abs(delta) == 16)
                end
            end
        elseif o.departClock or o.leaving then
            if frame % 4 == 0 and (not o.leaving or o.h > 0x600 and not o.fixed) then
                fire(o,7,o.leaving and -6 or 0,a + (o.leaving and 0x80 or 0),true)
            end
        else
            if o.volleyLeft == 0 and frame % 32 == 0 then o.volleyLeft,o.volleyAim = 4,a end
            if o.volleyLeft > 0 then
                o.volleyClock = o.volleyClock - 1
                if o.volleyClock < 0 then
                    o.volleyClock,o.volleyLeft = 2,o.volleyLeft - 1
                    fire(o,7,o.run.loop == 0 and 0 or 4,o.volleyAim)
                end
            end
        end
    end

    function Orb.step(o)
        local run,owner = o.run,o.owner
        if run.boss4 ~= owner or owner.dying or owner.final and not o.final then
            if o.arrived then effects.emit(o,{{2,0,0,0}}) end
            remove(o)
            return
        end
        local flags = band(o.flags,0x5c00)
        if flags ~= 0 then
            o.flags = band(o.flags,0xa3ff)
            hyper.hit(o,flags)
            local d = s16(0x7fff - o.hp)
            if d > owner.wingDamage then owner.wingDamage,owner.wingCredit = d,flags end
            o.hp,o.palette = 0x7fff,bxor(o.palette,12)
        else o.palette = 26 end
        if run.freeze then return end
        local p = owner.boxes[2]
        if owner.orbCommand == 1 and not o.departClock and not o.leaving then
            o.savedSpin,o.spin,o.spinTarget,o.departClock = o.spin,0,0,0x60
            o.anchor = {h=p.h,l=p.l}
        end
        if o.anchor then o.anchor.l = s16(o.anchor.l - run.cameraStep); p = o.anchor end
        local h,l = point(o,p)
        local dh,dl = abs(s16(o.h - h)),abs(s16(o.l - l))
        dh = dh - floor(dh / 4)
        local dist = max(dh,dl) + floor(min(dh,dl) / 2)
        local speed = dist <= 0x480 and min(0x12,max(1,2 * floor(dist / 0x40) - 2)) or 0x40
        local dir = program.angle256(o.h,o.l,h,l,0)
        local vh,vl = program.vector(speed,dir)
        o.h,o.l = s16(o.h + vh),s16(o.l + vl)
        o.angle = (o.angle + o.spin) % 0x1000
        o.angleClock = o.angleClock - 1
        if o.angleClock < 0 then
            o.angleClock = 0x18
            local target = o.spinTarget or o.row.orbit
            if o.spin ~= target then o.spin = o.spin + (o.spin < target and 1 or -1) end
        end
        arrive(o)
        if o.leaving and not inBounds(o) then remove(o); return end
        updateSpin(o)
        updateFire(o)
        o.anim = o.anim - 1
        if o.anim < 0 then o.anim,o.pose = 0,(o.pose + 1) % 8 end
        o.x,o.y = world(o.h,o.l)
    end

    function Orb.render(o)
        if o.run.art and o.arrived and not o.guide then draw(o,data.orb[o.palette][o.pose + 1],-0x600,-0x400) end
    end

    return Seed,Orb
end
