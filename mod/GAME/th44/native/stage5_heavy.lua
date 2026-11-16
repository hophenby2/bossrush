-- 0x1676f8 在车体上分别推进转炮、七路扇射和车尾双炮。
return function(program,path,bullets,effects,items,remove,hyper)
    local bit = require('bit')
    local band,bor,bxor = bit.band,bit.bor,bit.bxor
    local s16,world,packed = program.s16,program.world,program.addPacked
    local floor = math.floor
    local data = program.fifthHeavy
    local M = {parts=2}

    local function tick(o,key,gap)
        o[key] = o[key] - 1
        if o[key] >= 0 then return false end
        o[key] = gap
        return true
    end

    local function aim(o,dh,dl,prior,precise)
        local pilot = o.run.player
        if not pilot or not pilot.active then return prior end
        local getAngle = precise and program.angle256 or program.angle
        return getAngle(s16(o.h + dh),s16(o.l + dl),pilot.h,pilot.l,prior)
    end

    function M.init(o)
        local run = o.run
        o.flags,o.hp,o.palette = 0xa000,0x1f00,21
        o.front,o.back,o.right,o.left = 0xc00,0xe00,0xb00,0xb00
        o.extraParts[1].flags = 0x8000
        if not path.attach(o) then return false end
        o.face = aim(o,0xb00,0,band(o.direction,63))
        o.trackClock,o.attackClock,o.attackCount = 2,0x40,3
        o.tailClock,o.tailCount = 0x60,0
        o.bob,o.wheel,o.wheelClock = 0,0,1
        return true
    end

    function M.damage(o,amount,flags)
        o.hp,o.flags = s16(o.hp - amount),bor(o.flags,flags)
    end

    local function fan(o)
        local run = o.run
        if tick(o,'trackClock',0) and o.attackCount == 3 then
            o.face = program.turn64(o.face,aim(o,0xb00,0,o.face))
        end
        if o.h < 0x1000 or not tick(o,'attackClock',run.difficulty <= 1 and 4 or 6) then return end
        local at = data.muzzles[band(o.face,0x3e) / 2 + 1]
        run.randomByte = band(run.randomByte + 1,255)
        local random = band(data.jitter:byte(run.randomByte + 1) + 0x80,255) - 0x80
        local h,l = packed(o.h,o.l,0xb00 + at[1],at[2])
        local base = o.face * 4 + random - 0x24
        for i = 0,6 do
            local angle = base + 0xc * i
            local m = program.shipFan[4][band(angle + 2,0xfc) / 4 + 1]
            local sh,sl = packed(h,l,m[1],m[2])
            bullets.emitPrecise(run,5,0,angle,sh,sl)
            if run.loop ~= 0 then bullets.emitPrecise(run,5,6,angle,sh,sl) end
        end
        o.attackCount = o.attackCount - 1
        if o.attackCount < 0 then o.attackCount,o.attackClock = 3,0x30 end
    end

    local function tail(o)
        local run = o.run
        if o.h < 0x1000 then return end
        local gap = run.difficulty <= 1 and 4 or 3
        if o.tailCount == 0 then
            if not tick(o,'tailClock',gap) then return end
            o.tailCount = 7
            o.tailLeft,o.tailRight = aim(o,-0x600,0x680,0x80,true),aim(o,-0x600,-0x680,0x80,true)
        end
        if not tick(o,'tailClock',gap) then return end
        for i, dl in ipairs({0x680,-0x680}) do
            local a = (i == 1 and o.tailLeft or o.tailRight) + floor(program.bossRandom(run) / 4)
            bullets.emitPrecise(run,0x16,run.loop == 0 and 2 or 6,a,s16(o.h - 0x600),s16(o.l + dl))
        end
        o.tailCount = o.tailCount - 1
    end

    function M.step(o)
        local run = o.run
        if not path.step(o,run.groundScroll) then remove(o); return end
        if band(o.h + 0x1000,0xffff) < 0x8200 then o.entered = true
        elseif o.entered then remove(o); return end
        local flags = band(o.flags,0x5c00)
        if flags == 0 then o.palette = o.hp < 0x7c0 and 25 or 21
        else
            o.flags,o.palette = band(o.flags,0xa3ff),bxor(o.palette == 25 and 21 or o.palette,10)
            hyper.hit(o,flags)
            if o.hp < 0 then
                hyper.kill(run,flags,550)
                effects.emit(o,{{13,0,0x400,0},{5,0,-0x800,0x600},{5,0,-0xa00,-0x600}})
                items.emit(o,0xc,-0x800,0)
                if run.difficulty == 4 and run.major < 0x2b0 then items.emit(o,0xc,0x800,0) end
                remove(o)
                return
            end
        end
        if not run.freeze then
            if o.direction < 0x40 then
                o.bob = band(o.bob + 0x20,255)
                if tick(o,'wheelClock',1) then o.wheel = (o.wheel + (o.direction == 0 and 1 or -1)) % 4 end
            end
            if run.enemyShotGrace == 0 then fan(o); tail(o) end
        end
        o.x,o.y = world(o.h,o.l)
    end

    local function draw(o,id,dh,dl)
        local art = o.run.art[id]
        local x,y = world(s16(o.h + dh),s16(o.l + dl))
        Render(art[1],floor(x) + art[2] / 2,floor(y) + art[3] / 2)
    end

    function M.render(o)
        if not o.run.art then return end
        local hull,turret = unpack(data.images[o.palette])
        draw(o,hull[o.wheel + 1],-0x1000 + band(o.bob,0x40),-0xc00)
        draw(o,turret[band(o.face,0x3e) / 2 + 1],0x500,-0x400)
    end

    return M
end
