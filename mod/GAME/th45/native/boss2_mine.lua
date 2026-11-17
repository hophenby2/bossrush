-- 0x192c58 的分离雷由敌机队列登记，自己飞行、发射和接收伤害。
return function(program,bullets,art,effects)
    local band = require('bit').band
    local floor = math.floor
    local s16 = program.s16
    local data = program.boss2
    local M = {parts=1}

    function M.init(o)
        local row = o.row
        o.h,o.l,o.speed,o.angle,o.boss = row.h,row.l,row.speed,row.angle,row.boss
        o.turn = row.turn
        o.flags,o.front,o.back,o.right,o.left,o.baseHp = unpack(data.minePart)
        o.hp,o.guard,o.animation,o.shotClock,o.shots = o.baseHp,0x20,0,8,6
        return true
    end

    local function explode(o)
        effects.emit(o,0x8b,o.speed+8,o.angle,0,false)
        return false
    end

    function M.step(o)
        local run,boss = o.run,o.boss
        if boss.dying then return explode(o) end
        if o.guard > 0 then
            o.guard = o.guard-1
            o.hp,o.damage = o.guard == 0 and o.baseHp or 0x7fff,0
        end
        if o.impact then
            o.impact = nil
            o.flash = not o.flash
            if run.enemies[boss.slot] == boss then
                boss.mineDamage = (boss.mineDamage or 0)+floor(s16(o.damage or 0)/16)
            end
            o.damage = 0
            if o.hp < 0 then return explode(o) end
        else
            o.flash = false
        end
        if not run.stopPathClock then
            local dh,dl = program.vector(o.speed,o.angle,run.slowVectors)
            o.h,o.l = s16(o.h+dh),s16(o.l+dl)
        end
        if band(o.l + 0x1c00 + run.cameraOffset,0xffff) < 0x7000
            and band(o.h + 0x800,0xffff) < 0x8000 then
            o.entered = true
        elseif o.entered then
            return false
        end
        if o.shots > 0 and not run.freeze then
            o.shotClock = o.shotClock-1
            if o.shotClock < 0 then
                o.shotClock = 0x10
                local angle = band(o.angle+0xc0+(o.turn < 0 and 0x80 or 0),255)
                if angle >= 0x20 and angle <= 0xe0 and band(o.h,0xffff) < 0x5a00 then
                    bullets.emit(o,13,-8,angle,0,0,true)
                    o.shots = o.shots-1
                end
            end
        end
        o.animation = (o.animation+1)%8
        o.visible = true
        return true
    end

    function M.render(o)
        local assets = o.run.art
        if not assets or not o.visible then return end
        local image = data.images.mine[o.flash and 31 or 14][o.animation+1]
        local h,l = program.addPacked(o.h,o.l,0xfa00fc00)
        art.draw(assets.sprites[image],h,l,0,0)
    end

    return M
end
