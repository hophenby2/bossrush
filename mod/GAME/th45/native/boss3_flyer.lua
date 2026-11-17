-- 0x195f92 按原版加速、转向和发射计时推进关底放出的游机。
return function(program,bullets,art,effects)
    local band = require('bit').band
    local floor = math.floor
    local s16 = program.s16
    local H = {parts=1}

    function H.init(o)
        local row = o.row
        o.boss,o.h,o.l,o.side = row.boss,row.h,row.l,row.side
        o.flags,o.front,o.back,o.left,o.right,o.hp = 0xa601,0x780,0x480,0x420,0x420,0x200
        local run = o.run
        local aim = program.angle8(o.h,o.l,run.player,0x80)
        o.angle,o.direction,o.speed = band(aim+program.s8(program.random(run,program.randomNarrow)),255),0x20,0
        o.flight,o.speedClock,o.turnClock,o.fireClock,o.shots,o.shotSpeed = 0x70,2,0x10,0,row.shots,0
        o.palette = 17
        return true
    end

    function H.step(o)
        local run = o.run
        if o.boss.phase>=2 or o.hp<0 or run.enemies[o.boss.slot]~=o.boss then
            effects.emit(o,0x8b,o.speed,o.direction*4,0,false)
            return false
        end
        o.palette = o.impact and (o.palette==17 and 31 or 17) or 17
        o.impact = nil
        if not run.freeze and o.flight>0 then
            o.flight = o.flight-1
            o.turnClock = o.turnClock-1
            o.speedClock = o.speedClock-1
            if o.turnClock<0 then o.turnClock,o.direction=0x10,band(o.direction+o.side,63) end
            if o.speedClock<0 then o.speedClock,o.speed=2,math.min(o.speed+1,0x30) end
        end
        local dh,dl = program.vector(o.speed,o.direction*4)
        local scale = run.freeze and 0.5 or 1
        o.h,o.l = s16(o.h+floor(dh*scale)),s16(o.l+floor(dl*scale))
        if band(o.l+0x1000+run.cameraOffset,65535)<0x5800 and band(o.h+0x800,65535)<0x8000 then
            o.seen = true
        elseif o.seen then return false end
        if not run.freeze and o.shots>0 then
            o.fireClock = o.fireClock-1
            if o.fireClock<0 then
                o.fireClock = 2
                for _,offset in ipairs({0,0x24,-0x24}) do
                    bullets.emit(o,14,o.shotSpeed,o.angle+offset,0,0,true)
                end
                o.angle,o.shotSpeed,o.shots = band(o.angle-o.side,255),o.shotSpeed+1,o.shots-1
            end
        end
        return true
    end

    function H.render(o)
        local artData = o.run.art
        if artData then
            local id = program.boss3.images.flyer[o.palette][floor(o.direction/2)+1]
            art.draw(artData.sprites[id],o.h,o.l,-0xa00,-0x700)
        end
    end

    return H
end
