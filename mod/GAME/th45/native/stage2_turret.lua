-- 0x166596 的地景炮台先爆破炮管，再保留可击破的底座。
return function(program,path,bullets,art,effects)
    local bit = require('bit')
    local band,bxor,bor = bit.band,bit.bxor,bit.bor
    local floor = math.floor
    local s16 = program.s16
    local data = program.stage2Turret
    local M = {parts=1}

    function M.init(o)
        local run = o.run
        o.flags,o.front,o.back,o.right,o.left,o.hp = unpack(data.body)
        o.normalPalette,o.flashMask = unpack(data.palettes[run.stageNumber])
        o.palette = o.normalPalette
        local initial,rest,shots,reload,track,trackGap = unpack(data.state)
        o.shotClock,o.breakClock = initial-run.lateFireRank+8,rest-run.lateFireRank
        o.burst,o.burstSize,o.trackClock,o.trackGap = shots,reload,track,trackGap
        if not path.attach(o,o.row) then return false end
        o.h = s16(o.h+0x140)
        o.aim = program.angle(o.h,o.l,run.player,o.direction%64)
        return true
    end

    local function fire(o)
        local run = o.run
        o.trackClock = o.trackClock-1
        if o.trackClock < 0 then
            o.trackClock = o.trackGap
            if o.burst == o.burstSize then o.aim = program.towards(o.aim,program.angle(o.h,o.l,run.player,o.aim)) end
        end
        if o.h < 0x3000 then
            o.burst,o.shotClock = o.burstSize,o.breakClock
            return
        end
        o.shotClock = o.shotClock-1
        if o.shotClock >= 0 then return end
        o.shotClock,o.burst = 4,o.burst-1
        local direction = band(o.aim,0x3e)
        local dh,dl = program.addPacked(0,0,data.muzzle[floor(direction/2)+1])
        local drift = floor(program.s8(program.random(run,program.randomNarrow))/2)
        bullets.emit(o,10,0,direction*4+drift,dh,dl,true)
        if o.burst < 0 then o.burst,o.shotClock = o.burstSize,o.breakClock end
    end

    local function damage(o)
        if not o.impact then
            o.palette = o.hp<0xc0 and not o.run.dual and 25 or o.normalPalette
            return true
        end
        o.impact,o.damage,o.flags = nil,0,band(o.flags,0xa6ff)
        local palette = o.palette==25 and o.normalPalette or o.palette
        o.palette = bxor(palette,o.flashMask)
        if o.hp >= 0 then return true end
        if o.wreck then
            effects.emit(o,0x88,0,0,0xfc00fe00,true)
            return false
        end
        o.wreck,o.hp,o.flags = true,data.body[6],bor(o.flags,0x80)
        effects.emit(o,0x84,0,0,0xfe00fe00,true)
        return true
    end

    function M.step(o)
        local run = o.run
        if not path.step(o,-run.groundScroll) then return false end
        if band(o.l+0xe00+run.cameraOffset,0xffff)<0x5400 and band(o.h+0xa00,0xffff)<0x8400 then
            o.seen = true
        elseif o.seen then return false end
        local wasWreck = o.wreck
        if not damage(o) then return false end
        if not wasWreck and not run.freeze and not run.stopPathClock then fire(o) end
        return true
    end

    function M.render(o)
        local assets = o.run.art
        if not assets then return end
        local group = data.images[o.palette]
        local id = o.wreck and group[2] or group[1][floor(o.aim/2)+1]
        art.draw(assets.sprites[id],o.h,o.l,-0xa00,-0x600)
    end

    return M
end
