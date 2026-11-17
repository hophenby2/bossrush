-- 侦察机和两种巡逻机使用同一组路径字节，炮口与射击计时分属各自的控制器。
return function(program,path,bullets,art,effects,rewards)
    local bit = require('bit')
    local band,bxor = bit.band,bit.bxor
    local floor = math.floor
    local scout,patrol,heavy = {parts=1},{parts=1},{parts=1}

    local function retired(o,hBias,hEdge)
        local inside = band(o.l + 0xe00 + o.run.cameraOffset,0xffff) < 0x5400
            and band(o.h + hBias,0xffff) < hEdge
        if inside then o.seen = true end
        return not inside and o.seen
    end

    local function impact(o,flash)
        if not o.impact then o.palette = o.normalPalette; return false end
        o.impact = nil
        o.flags = band(o.flags,0xa6ff)
        o.palette = bxor(o.palette,flash)
        return o.hp < 0
    end

    local function killed(o,kind,offset)
        effects.emit(o,kind,0,0,offset,true)
        return false
    end

    function scout.init(o)
        o.flags,o.hp,o.normalPalette = 0xa200,0x10,0x12
        o.front,o.back,o.right,o.left = 0x200,0x200,0x200,0x200
        o.palette,o.animClock,o.shotClock,o.shotPeriod = o.normalPalette,0,2,2
        if not path.attach(o,o.row) then return false end
        local run = o.run
        o.firing = o.direction >= 0x40
        o.aim = o.firing and program.angle(o.h,o.l,run.player,0x20) or o.direction
        o.animation = band(program.random(run,program.randomByte),7)
        o.volleyCount,o.volleyDelay,o.volleySize = 0,0,0
        return true
    end

    local function scoutFire(o)
        local run = o.run
        if not o.firing then
            o.aim = o.direction
            if o.direction >= 0x40 then
                o.firing = true
                o.volleyDelay = band(program.random(run,program.randomNarrow) + 0x10,255)
                o.shotClock,o.shotPeriod,o.volleySize = 4,4,run.stageNumber
            end
        elseif o.direction < 0x40 then
            o.firing,o.aim = false,o.direction
        end
        if not o.firing then return end
        o.aim = program.towards(o.aim,program.angle(o.h,o.l,run.player,o.aim))
        if o.volleyCount == 0 then
            o.volleyDelay = o.volleyDelay - 1
            if o.volleyDelay >= 0 then return end
            o.volleyDelay,o.volleyCount = 0x44 - run.airFireRank,o.volleySize
            if o.volleyCount == 0 then return end
        end
        o.shotClock = o.shotClock - 1
        if o.shotClock >= 0 then return end
        o.shotClock,o.volleyCount = o.shotPeriod,o.volleyCount - 1
        if not program.patrolFireBand(o) then return end
        if run.stageNumber == 2 and run.major >= 0x100 and run.stageFlags[0] then return end
        local dh,dl = unpack(program.scoutMuzzles[floor(o.aim / 2) + 1])
        bullets.emit(o,4,-1,o.aim * 4,dh,dl)
    end

    function scout.step(o)
        if impact(o,0x0d) then
            rewards.drop(o,o.h-0x400,o.l,o.part[0x22] or 0,o.flags)
            return killed(o,13,0)
        end
        local run = o.run
        if run.stageNumber == 5 and run.stageFlags[2] then return killed(o,13,0) end
        if not path.step(o,-run.groundScroll) then return false end
        if not run.freeze and not run.stopPathClock then
            scoutFire(o)
            if retired(o,0x800,0x8000) then return false end
            o.animClock = o.animClock - 1
            if o.animClock < 0 then o.animClock,o.animation = 2,(o.animation + 1) % 8 end
        end
        o.visible = true
        return true
    end

    function scout.render(o)
        if not o.run.art or not o.visible then return end
        local images = program.scoutImages[o.palette]
        if o.firing then
            local id = images[2][floor(o.aim / 2) + 1]
            art.draw(o.run.art.sprites[id],o.h,o.l,-0x600,-0x400)
        else
            local id = images[1][floor(band(o.direction,63) / 4) * 8 + o.animation + 1]
            art.draw(o.run.art.sprites[id],o.h,o.l,-0x600,-0x500)
        end
    end

    local function startPatrol(o,hp,palette,flash,shotDelay)
        o.flags,o.hp,o.normalPalette,o.flashPalette = 0xa200,hp,palette,flash
        o.front,o.back,o.right,o.left = 0x600,0x600,0x480,0x480
        o.palette,o.trackPeriod = o.normalPalette,2
        if not path.attach(o,o.row) then return false end
        local run = o.run
        o.aim = o.direction
        o.trackClock = 7 - floor(run.patrolTrackRank / 16)
        o.shotClock = shotDelay - run.airFireRank + floor(program.random(run,program.randomHalf,127) / 2)
        return true
    end

    function patrol.init(o)
        return startPatrol(o,0x68,0x0f,0x10,0x38)
    end

    function heavy.init(o)
        local run = o.run
        if (run.stageNumber == 1 or run.stageNumber == 5) and run.stageFlags[0] then return false end
        local firstMode = (run.stageMode or 0) == 0
        o.burst,o.damageAnimation = 2,0
        return startPatrol(o,0xc0,firstMode and 0x15 or 0x0e,firstMode and 0x0a or 0x11,0x40)
    end

    local function ready(o,hBias)
        local run = o.run
        o.trackClock = o.trackClock - 1
        if o.trackClock < 0 then
            o.trackClock = o.trackPeriod
            if not run.player or not run.player.active then return end
            o.aim = program.towards(o.aim,program.angle(o.h + hBias,o.l,run.player,o.aim))
        end
        if band(o.flags,0x2000) == 0 then return end
        o.shotClock = o.shotClock - 1
        return o.shotClock == 0
    end

    local function fire(o,kind,muzzles,hBias)
        if not program.patrolFireBand(o) then return false end
        local aim = band(o.aim + 2,0x3c)
        local dh,dl = unpack(muzzles[floor(aim / 4) + 1])
        bullets.emit(o,kind,0,aim * 4,dh + hBias,dl)
        return true
    end

    local function stepPatrol(o,damageHp,damageOffset,killEffect,killOffset)
        local run = o.run
        if not path.step(o,-run.groundScroll) or retired(o,0x600,0x7c00) then return false end
        if impact(o,o.flashPalette) then
            if o.damaged then
                rewards.drop(o,o.h,o.l,o.part[0x22] or 0,o.flags)
                return killed(o,killEffect,killOffset)
            end
            o.damaged,o.hp = true,damageHp
            effects.emit(o,3,0,0,damageOffset,true)
        end
        o.visible = true
        return true
    end

    function patrol.step(o)
        if not stepPatrol(o,0x68,-0x1000000,7,-0x7f0080) then return false end
        local run = o.run
        if not o.damaged and not run.freeze and not run.stopPathClock and ready(o,0x300) then
            o.shotClock = 0xa4 - run.patrolFireRank
            fire(o,0,program.patrolMuzzles,0x300)
        end
        return true
    end

    function heavy.step(o)
        if not stepPatrol(o,0xe0,0,4,0x1000000) then return false end
        local run = o.run
        if o.damaged then
            if run.stopPathClock then o.damageAnimation = o.damageAnimation % 4 + 1 end
        elseif not run.freeze and not run.stopPathClock and ready(o,0x200) then
            o.shotClock = 7
            if fire(o,9,program.heavyPatrolMuzzles,0x200) then
                o.burst = o.burst - 1
                if o.burst < 0 then o.burst,o.shotClock = 2,0x3c - run.lateFireRank end
            end
        end
        return true
    end

    function patrol.render(o)
        local assets = o.run.art
        if not assets or not o.visible then return end
        local images = program.patrolImages[o.palette]
        local id = images[1][floor(band(o.direction,63) / 2) * 2 + 1]
        art.draw(assets.sprites[id],o.h,o.l,-0x800,-0x600)
        if not o.damaged then
            id = images[2][floor(band(o.aim,63) / 2) + 1]
            art.draw(assets.sprites[id],o.h,o.l,-0x300,-0x400)
        end
    end

    function heavy.render(o)
        local assets = o.run.art
        if not assets or not o.visible then return end
        local images = program.heavyPatrolImages[o.palette]
        local id = images[1][band(o.direction,0x3e) + 1]
        art.draw(assets.sprites[id],o.h,o.l,-0x800,-0x700)
        if not o.damaged then
            id = images[2][floor(band(o.aim,63) / 2) + 1]
            art.draw(assets.sprites[id],o.h,o.l,-0x600,-0x600)
        elseif o.run.stopPathClock and o.damageAnimation > 0 then
            id = program.heavyPatrolSmoke[o.damageAnimation]
            art.draw(assets.sprites[id],o.h,o.l,0x200,-0x200)
        end
    end

    return scout,patrol,heavy
end
