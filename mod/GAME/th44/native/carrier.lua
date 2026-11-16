-- 0x17417c。0x174118 在同一机体上登记两个碰撞部件，炮口继续使用机体自身的指令。
return function(program, path, bullets, effects, remove, supply, hyper)
    local bit = require('bit')
    local band, bor, bxor = bit.band, bit.bor, bit.bxor
    local floor, min = math.floor, math.min
    local s16, world = program.s16, program.world
    local M = {parts=2}
    -- 0x174388、0x1743b4、0x1743da 依次分配三个爆炸槽。
    local destruction = {{5,0,0x200,0x200}, {12,0,-0xa00,0}, {0x84,0,-0x1200,-0x200}}

    local function position(o)
        local part = o.extraParts[1]
        part.h, part.l = o.h, o.l
        part.x, part.y = world(part.h, part.l)
        o.x, o.y = part.x, part.y
    end

    local function aim(o)
        local pilot = o.run.player
        if pilot and pilot.active ~= false then
            return program.angle(o.h - 0x700, o.l, pilot.h, pilot.l, o.face)
        end
    end

    function M.init(o)
        local part = o.extraParts[1]
        o.flags, part.flags = 0xa001, 0xa001
        o.hp, part.hp = 0x700, 0x700
        o.front, o.back, o.right, o.left = 0, 0xe00, 0x400, 0x400
        part.front, part.back, part.right, part.left = 0xc00, 0, 0x600, 0x600
        o.trackClock, o.salvoCount = 1, 2
        o.attackClock = band(0x40 - program.rank(o.run,0x1a,'carrierRank'), 0xff)
        o.palette = o.run.difficulty < 3 and 15 or 14
        if not path.attach(o) then return false end
        o.face = aim(o) or band(o.direction, 0x3f)
        position(o)
        return true
    end

    local function attack(o)
        local run = o.run
        if run.freeze or run.enemyShotGrace > 0 then return end
        o.trackClock = o.trackClock - 1
        if o.trackClock < 0 then
            o.trackClock = 1
            if o.salvoCount == 2 then
                local target = aim(o)
                if target then
                    local difference = band(target - o.face, 0x3f)
                    if difference ~= 0 then o.face = band(o.face + (difference < 0x20 and 1 or -1), 0x3f) end
                end
            end
        end
        if o.h < 0x1000 then return end
        o.attackClock = o.attackClock - 1
        if o.attackClock >= 0 then return end
        local offset = program.muzzles[0x85][band(o.face, 0x3e) / 2 + 1]
        bullets.emit(run, 0x0d, -1, o.face, s16(o.h + offset[1] - 0x700), s16(o.l + offset[2]))
        o.attackClock = 6
        o.salvoCount = o.salvoCount - 1
        if o.salvoCount < 0 then
            o.salvoCount = 2
            o.attackClock = band(0x50 - program.rank(run,0x1e,'tankRank'), 0xff)
        end
    end

    function M.step(o)
        if not path.step(o) then remove(o); return end
        local visible = band(o.l + o.run.cameraOffset + 0x1c00, 0xffff) < 0x7000
            and band(o.h + 0x1000, 0xffff) < 0x9000
        if visible then o.entered = true
        elseif o.entered then remove(o); return end
        local part = o.extraParts[1]
        local base = o.run.difficulty < 3 and 15 or 14
        local flags = band(bor(o.flags,part.flags),0x5c00)
        if flags == 0 then
            o.palette = o.hp < 0x1c0 and 25 or base
        else
            o.flags, part.flags = band(o.flags, 0xa3ff), band(part.flags, 0xa3ff)
            hyper.hit(o,flags)
            o.palette = bxor(o.palette == 25 and base or o.palette, base == 15 and 16 or 17)
            o.hp = min(o.hp, part.hp)
            part.hp = o.hp
            if o.hp < 0 then
                hyper.kill(o.run,flags,25)
                local drop = o.kind == 0x86 and 8 or 0
                supply.emit(o,drop)
                if o.run.dual and drop == 0 then supply.emit(o,drop) end
                effects.emit(o, destruction)
                remove(o)
                return
            end
        end
        position(o)
        attack(o)
    end

    local function draw(o, sprite, dh, dl)
        local image = o.run.art[sprite]
        local x, y = world(o.h + dh, o.l + dl)
        Render(image[1], floor(x) + image[2] / 2, floor(y) + image[3] / 2)
    end

    function M.render(o)
        if not o.run.art then return end
        local pose = program.carrier[o.palette]
        draw(o, pose[1], -0xe00, -0x700)
        draw(o, pose[2][band(o.face, 0x3e) / 2 + 1], -0xd00, -0x400)
    end

    function M.damage(part, amount, attackFlags)
        part.hp = s16(part.hp - amount)
        part.flags = bor(part.flags, attackFlags)
    end

    return M
end
