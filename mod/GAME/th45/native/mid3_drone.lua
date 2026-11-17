-- 0x1b79ba 在母舰的子机标志清除时引爆，受击反冲和减速转头各用独立计时。
return function(program,bullets,effects,art)
    local band,bxor = require('bit').band,require('bit').bxor
    local s16 = program.s16
    local data = program.mid3
    local H = {parts=2}

    local function fire(o,modifier,angle,offset)
        bullets.emit(o,13,modifier,angle,s16(math.floor(offset/0x10000)),s16(offset),true)
    end

    local function explode(o)
        local angle = program.random(o.run,program.randomByte)
        effects.emit(o,0x84,8,angle,0x06000000,false)
        return false
    end

    function H.init(o)
        o.h,o.l,o.direction,o.speed = o.row.h,o.row.l,o.row.angle,0x14
        o.second = {h=o.h,l=o.l}
        o.extraParts = {o.second}
        for i,p in ipairs({o,o.second}) do
            p.flags,p.front,p.back,p.right,p.left,p.hp = unpack(data.droneParts[i])
        end
        o.palette,o.health,o.animation,o.brake = 21,0xf00,0,0
        o.fireClock = 0
        return H.step(o)
    end

    function H.step(o)
        local run,p = o.run,o.second
        if not run.stageFlags[1] then return explode(o) end
        if o.steering and not run.freeze and o.direction~=0x80 then
            local d = band(0x80-o.direction,255)
            o.direction = band(o.direction+(d<0x80 and 1 or -1),255)
        end
        local dh,dl = program.vector(o.speed,o.direction,run.slowVectors)
        o.h,o.l = s16(o.h+dh),s16(o.l+dl)
        p.h,p.l = o.h,o.l
        if band(o.h+0x200,0xffff)<0x7400 then o.seen = true elseif o.seen then return false end
        if o.impact or p.impact then
            o.h = s16(o.h+(run.halfPathSpeed and 0x30 or 0x60))
            o.health = o.health-band((o.damage or 0)+(p.damage or 0),0xffff)
            if o.health<0 then return explode(o) end
            o.hp,p.hp,o.damage,p.damage,o.impact,p.impact = 0x7fff,0x7fff,0,0,nil,nil
            o.palette = bxor(o.palette==25 and 21 or o.palette,10)
            if o.direction==0x80 and not run.freeze then
                o.fireClock = o.fireClock-1
                if o.fireClock<0 then
                    o.fireClock = 3
                    fire(o,0,0x80,0xfc000400)
                    fire(o,0,0x80,0xfbfffc00)
                    if o.h>=0x2800 then fire(o,0,0x4c,0x01800400); fire(o,0,0xb4,0x017ffc00) end
                end
            end
        else o.palette = o.hp<0x3c0 and 25 or 21 end
        if not run.freeze then
            o.drawFrame,o.animation = o.animation,band(o.animation-1,7)
            if not o.steering then
                o.brake = o.brake-1
                if o.brake<0 then
                    o.brake,o.speed = 3,o.speed-1
                    if o.speed<=10 then o.steering = true end
                end
            end
        end
        return true
    end

    function H.render(o)
        local assets = o.run.art
        if assets and o.drawFrame then
            art.draw(assets.sprites[data.drones[o.palette][o.drawFrame+1]],o.h,o.l,-0xc00,-0x800)
        end
    end

    return H
end
