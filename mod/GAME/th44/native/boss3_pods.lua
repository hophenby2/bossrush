-- 0x19c9c8 与 0x19ce92 由关底攻击任务分配，各自维护移动、判定和退场。
return function(program, bullets, effects, items, remove)
    local bit = require('bit')
    local band, bor, bxor = bit.band, bit.bor, bit.bxor
    local s16, world = program.s16, program.world
    local floor = math.floor
    local data = program.boss3
    local Pod,Charge = {parts=2},{parts=1}

    local function damage(o, amount, flags)
        o.flags,o.hp = bor(o.flags,flags),s16(o.hp - amount)
    end
    Pod.damage,Charge.damage = damage,damage

    local function draw(o, id, dh, dl, flip)
        local image = o.run.art[id]
        local x,y = world(s16(o.h + dh),s16(o.l + dl))
        Render(image[1],floor(x) + image[2]/2,floor(y) + image[3]/2,0,1,flip and -1 or 1)
    end

    function Pod.init(o)
        local part = o.extraParts[1]
        local template = data.pod
        o.owner,o.side = o.row.owner,o.row.side
        if not o.owner or o.owner.dying then return false end
        o.h,o.l = o.row.h,o.row.l
        o.flags,part.flags = 0xa001,0xa000
        o.front,o.back,o.right,o.left = 0xe00,0xd00,0x2c0,0x2c0
        part.front,part.back,part.right,part.left = 0xf80,0xf80,0x600,0x600
        o.hp,part.hp = template[4],template[4]
        part.h,part.l = o.h,o.l
        o.speed,o.direction = 8,0
        o.palette,o.flashClock,o.pose = 17,0,0
        o.openClock,o.rotorClock,o.gainClock = 0,0,0x40
        o.firstShot,o.reload = floor(template[1]/256),band(template[1],255)
        o.gap,o.gain = o.run.loop == 0 and floor(template[2]/256) or 13,band(template[2],255)
        o.shotFlags,o.shotRow,o.fireCount = 0,9,8
        o.openIndex,o.rotorIndex = 0,8
        return true
    end

    local function depart(o, exploding)
        if exploding then
            effects.emit(o,{{10,4,0x600,0,o.speed,o.direction},{10,2,0,0,o.speed,o.direction},
                {10,0,-0x600,0,o.speed,o.direction}})
        end
        remove(o)
    end

    local function animate(o)
        if not o.deployed then
            o.openClock = o.openClock - 1
            if o.openClock < 0 then
                o.openClock,o.pose = 2,o.openIndex
                o.openIndex = o.openIndex + 1
                if o.openIndex == 8 then
                    o.deployed = true
                    o.speed,o.direction = floor(o.row.velocity/256),band(o.row.velocity,255)
                end
            end
            if not o.deployed then return end
        end
        o.rotorClock = o.rotorClock - 1
        if o.rotorClock < 0 then
            o.rotorClock = 1
            o.rotorIndex = (o.rotorIndex - 1) % 8
            o.pose = o.rotorIndex
        end
        o.gainClock = o.gainClock - 1
        if o.gainClock < 0 then o.gainClock,o.speed = o.gain,math.min(0x12,o.speed + 1) end
    end

    local function fire(o)
        o.firstShot = o.firstShot - 1
        if o.firstShot >= 0 then return end
        o.firstShot = o.gap
        local run,pilot = o.run,o.run.player
        if pilot and pilot.active then
            for i = o.shotRow * 2 - 1,o.shotRow * 2 do
                local at = data.podMuzzles[i]
                local h,l = s16(o.h + at[2]),s16(o.l + at[3])
                local a = program.angle256(h,l,pilot.h,pilot.l,0x80)
                bullets.emitPrecise(run,7,run.loop == 0 and 0 or 1,a,h,l)
            end
        end
        o.shotRow = (o.shotRow - 2) % 9 + 1
        o.fireCount = o.fireCount - 1
        if o.fireCount < 0 then
            o.fireCount,o.shotFlags = 8,1 - o.shotFlags
            o.firstShot = o.shotFlags == 1 and o.reload or o.gap
        end
    end

    function Pod.step(o)
        local run = o.run
        if o.flashClock > 0 then o.flashClock = o.flashClock - 1 end
        if o.owner.dying then depart(o,true); return end
        if not run.freeze then
            local dh,dl = program.vector(o.speed,o.direction)
            o.h,o.l = s16(o.h + dh),s16(o.l + dl)
        end
        local part = o.extraParts[1]
        part.h,part.l = o.h,o.l
        if band(o.h + 0x1000,0xffff) < 0x9000 then o.entered = true
        elseif o.entered then depart(o,false); return end
        local flags = band(bor(o.flags,part.flags),0x5c00)
        if flags == 0 then o.palette = o.hp < 0x180 and 25 or 17
        else
            o.flags,part.flags = band(o.flags,0xa3ff),band(part.flags,0xa3ff)
            o.speed,o.flashClock = math.max(3,o.speed - (band(flags,0x400) ~= 0 and 2 or 1)),2
            o.hp = math.min(o.hp,part.hp)
            part.hp = o.hp
            o.palette = bxor(o.palette == 25 and 17 or o.palette,14)
            if o.hp < 0 then depart(o,true); return end
        end
        animate(o)
        if o.deployed and not run.freeze and run.enemyShotGrace == 0 and o.h >= 0x1200 then fire(o) end
        o.x,o.y = world(o.h,o.l)
    end

    function Pod.render(o)
        if not o.run.art then return end
        local images = data.images[o.deployed and 'pod' or 'podFolded'][o.palette]
        draw(o,images[o.pose + 1],o.deployed and -0x1200 or -0x1000,-0x400,o.side == 2)
    end

    function Charge.init(o)
        if not o.row.owner then return false end
        o.owner = o.row.owner
        o.h,o.l,o.flags,o.hp = o.row.h,o.row.l,0x8001,0x7fff
        o.front,o.back,o.right,o.left = 0x100,0x80,0x200,0x200
        o.speed,o.direction,o.pose = o.row.velocity,0x80,o.row.frame
        o.clock = 0
        return true
    end

    function Charge.step(o)
        local run = o.run
        if o.fade then
            o.fade = o.fade + 1
            if o.fade == 16 then remove(o) end
            return
        end
        if o.owner.dying or run.clearBulletFade or run.clearBulletChips then
            if run.clearBulletFade then o.flags,o.fade = 0x8000,1
            else items.emit(o,0); remove(o) end
            return
        end
        if not run.freeze then
            local dh,dl = program.vector(o.speed,o.direction)
            o.h,o.l = s16(o.h + dh),s16(o.l + dl)
        end
        if band(o.h + 0x400,0xffff) < 0x7400 then o.entered = true
        elseif o.entered then remove(o); return end
        o.clock = o.clock - 1
        if o.clock < 0 then o.clock,o.pose = 1,(o.pose - 1) % 4 end
        o.x,o.y = world(o.h,o.l)
    end

    function Charge.render(o)
        if not o.run.art then return end
        if o.fade then draw(o,program.fade[1][o.fade],-0x400,-0x200)
        else draw(o,data.images.charge[26][o.pose + 1],-0x400,-0x300) end
    end

    return Pod,Charge
end
