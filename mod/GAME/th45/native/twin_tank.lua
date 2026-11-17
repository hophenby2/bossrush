-- 0x1648b8 分配两处判定，0x1649f2 把两处的帧伤害累加到同一耐久。
return function(program,path,bullets,art,effects)
    local bit = require('bit')
    local band,bxor = bit.band,bit.bxor
    local floor = math.floor
    local M = {parts=2}
    local turretH,turretL = -0x1c0,{0x6c0,-0x7c0}

    local function positionParts(o)
        o.secondPart.h,o.secondPart.l = o.h,o.l
    end

    function M.init(o)
        local run = o.run
        if run.stageNumber == 1 and run.stageFlags[0] then return false end
        local body,base = unpack(program.twinTankParts)
        o.flags,o.hp,o.front,o.back,o.right,o.left = unpack(body)
        local second = {}
        second.flags,second.hp,second.front,second.back,second.right,second.left = unpack(base)
        o.secondPart,o.extraParts = second,{second}
        o.health = run.stageNumber == 5 and 0xc00 or program.twinTankHealth
        o.normalPalette,o.flashPalette = unpack(program.twinTankPalettes[(run.stageMode or 0) + 1])
        o.palette,o.trackPalette,o.track = o.normalPalette,10,15
        o.trackClock,o.fireClock,o.lifeClock = 4,0x30,0
        o.burstSize,o.shotGap,o.spread = 5,2,2
        o.bulletKind,o.bulletSpeed = 6,2
        if run.stageNumber == 1 and run.major >= 0x150 then
            o.burstSize,o.bulletSpeed = 7,1
        end
        o.burstRemaining,o.angleStep = o.burstSize,o.spread
        if not path.attach(o,o.row) then return false end
        local aim = program.angle(o.h,o.l,run.player,0x20)
        o.aims = {aim,aim}
        positionParts(o)
        return true
    end

    local function destroy(o,rows)
        effects.emitSequence(o,rows)
        return false
    end

    local function updateDamage(o)
        local second = o.secondPart
        if o.impact or second.impact then
            o.impact,second.impact = nil,nil
            o.flags,second.flags = band(o.flags,0xa6ff),band(second.flags,0xa6ff)
            o.health = o.health - band((o.damage or 0) + (second.damage or 0),0xffff)
            if o.health < 0 then return false end
            o.damage,second.damage = 0,0
            o.hp,second.hp = 0x7fff,0x7fff
            local palette,trackPalette = o.palette,o.trackPalette
            if palette == 25 then palette,trackPalette = o.normalPalette,10 end
            o.palette,o.trackPalette = bxor(palette,o.flashPalette),bxor(trackPalette,0x15)
        elseif o.health < 0x200 and band(o.run.frame,15) < 2 then
            o.palette,o.trackPalette = 25,25
        else
            o.palette,o.trackPalette = o.normalPalette,10
        end
        return true
    end

    local function fire(o)
        local run = o.run
        o.trackClock = o.trackClock - 1
        if o.trackClock < 0 then
            o.trackClock = 5
            if o.burstRemaining == o.burstSize then
                for index,dl in ipairs(turretL) do
                    local aim = o.aims[index]
                    o.aims[index] = program.towards(aim,program.angle(o.h + turretH,o.l + dl,run.player,aim))
                end
            end
        end
        if o.h < 0x3a00 then return end
        o.fireClock = o.fireClock - 1
        if o.fireClock >= 0 then return end
        o.fireClock = 5 - floor(run.volleyRank / 4)
        -- 0x164c84、0x164ce6 用两门炮各自的瞄准方向，弹道保留八位角。
        for index,dl in ipairs(turretL) do
            local aim = o.aims[index]
            local sign = index == 1 and -1 or 1
            local offset = program.twinTankMuzzles[floor(aim / 2) + 1] + turretH * 0x10000 + band(dl,0xffff)
            for ray = 1,3 do
                local angle = band(aim * 4 + sign * ray * o.angleStep,255)
                local muzzle = program.twinTankShotOffsets[floor(band(angle + 2,0xfc) / 4) + 1]
                local dh,horizontal = program.addPacked(0,0,offset + muzzle)
                bullets.emit(o,o.bulletKind,o.bulletSpeed,angle,dh,horizontal,true)
            end
        end
        o.angleStep = o.angleStep - 1
        o.burstRemaining = o.burstRemaining - 1
        if o.burstRemaining == 0 then
            o.burstRemaining,o.angleStep = o.burstSize,o.spread
            o.fireClock = 0x48 - run.lateFireRank
        end
    end

    function M.step(o)
        local run = o.run
        local timer = o.part[0x1e] or 0
        if timer ~= 0 and not run.freeze and not run.stopPathClock then
            o.lifeClock = o.lifeClock + 1
            if o.lifeClock >= (timer == 1 and 0x172 or 0xa7) then
                return destroy(o,program.twinTankTimeout)
            end
        end
        if not path.step(o,-run.groundScroll) then return false end
        if band(o.l + 0x1400 + run.cameraOffset,0xffff) < 0x6000 and band(o.h + 0x1400,0xffff) < 0x9800 then
            o.seen = true
        elseif o.seen then return false end
        positionParts(o)
        if not updateDamage(o) then return destroy(o,program.twinTankDestruction) end
        o.track = (o.track + 15) % 16
        o.visible = true
        if not run.freeze and not run.stopPathClock and not run.blockEnemyFire then fire(o) end
        return true
    end

    function M.render(o)
        local assets = o.run.art
        if not assets or not o.visible then return end
        local sprites = assets.sprites
        local body = program.twinTankImages[o.palette]
        art.draw(sprites[body[1]],o.h,o.l,-0x1000,-0xa00)
        local track = sprites[program.twinTankTracks[o.trackPalette][o.track + 1]]
        local h,l = program.addPacked(o.h,o.l,0x0380f4c0)
        art.draw(track,h,l,0,0)
        art.draw(track,h,o.l + 0x140,0,0,true)
        for index,dl in ipairs(turretL) do
            h,l = program.addPacked(o.h,o.l,(turretH - 0x600) * 0x10000 + band(dl,0xffff) + 0xfc00)
            art.draw(sprites[body[floor(o.aims[index] / 2) + 2]],h,l,0,0)
        end
    end

    return M
end
