-- 0x164fd8 推进重型地炮。机体、两条履带和跟踪炮塔共有一个受击槽。
return function(program,path,bullets,art,effects)
    local bit = require('bit')
    local band,bxor = bit.band,bit.bxor
    local floor = math.floor
    local M = {parts=1}

    function M.init(o)
        local run = o.run
        o.flags,o.hp,o.front,o.back,o.right,o.left = unpack(program.armoredCarBody)
        local palette = program.armoredCarPalettes[(run.stageMode or 0) + 1]
        o.normalPalette,o.flashPalette = unpack(palette)
        o.palette,o.trackPalette,o.trackFrame = o.normalPalette,10,16
        o.shotClock,o.trackClock,o.burst = 0x40 - run.lateFireRank,2,2
        if not path.attach(o,o.row) then return false end
        o.aim = program.angle(o.h + 0x580,o.l - 0x40,run.player,o.direction)
        return true
    end

    local function destroy(o)
        for _,entry in ipairs(program.armoredCarDestruction) do
            local kind,dh,dl,ground,velocity,delay = unpack(entry)
            effects.emit(o,kind,floor(velocity / 256),band(velocity,255),dh * 0x10000 + band(dl,0xffff),
                ground ~= 0,delay)
        end
        return false
    end

    local function fire(o)
        local run = o.run
        o.trackClock = o.trackClock - 1
        if o.trackClock < 0 then
            o.trackClock = 2
            o.aim = program.towards(o.aim,program.angle(o.h + 0x580,o.l - 0x40,run.player,o.aim))
        end
        if o.h < 0x1000 then return end
        o.shotClock = o.shotClock - 1
        if o.shotClock >= 0 then return end
        o.shotClock = 6
        local dh,dl = unpack(program.armoredCarMuzzles[floor(o.aim / 2) + 1])
        bullets.emit(o,0,-1,o.aim * 4,dh,dl)
        o.burst = o.burst - 1
        if o.burst < 0 then o.burst,o.shotClock = 2,0x50 - run.airFireRank end
    end

    function M.step(o)
        local run = o.run
        if not path.step(o,-run.groundScroll) then return false end
        if band(o.l + 0x1200 + run.cameraOffset,0xffff) < 0x5c00 and band(o.h + 0x1000,0xffff) < 0x9000 then
            o.seen = true
        elseif o.seen then return false end
        if o.impact then
            o.impact = nil
            o.flags = band(o.flags,0xa6ff)
            if o.hp < 0 then return destroy(o) end
            local palette = o.palette == 25 and o.normalPalette or o.palette
            local tread = o.palette == 25 and 10 or o.trackPalette
            o.palette,o.trackPalette = bxor(palette,o.flashPalette),bxor(tread,0x15)
        elseif o.hp < 0xc0 and not run.dual then
            o.palette,o.trackPalette = 25,25
        else
            o.palette,o.trackPalette = o.normalPalette,10
        end
        o.trackFrame = o.trackFrame == 1 and 16 or o.trackFrame - 1
        if not run.freeze and not run.stopPathClock and not run.blockEnemyFire then fire(o) end
        o.visible = true
        return true
    end

    function M.render(o)
        local assets = o.run.art
        if not assets or not o.visible then return end
        local images = program.armoredCarImages[o.palette]
        local sprites = assets.sprites
        art.draw(sprites[images[1][1]],o.h,o.l,-0x1000,-0x400)
        local id = program.armoredCarTracks[o.trackPalette][o.trackFrame]
        local h,l = program.addPacked(o.h,o.l,0xf2c1f580)
        art.draw(sprites[id],h,l,0,0)
        art.draw(sprites[id],h,o.l + 0x80,0,0,true)
        h,l = program.addPacked(o.h,o.l,0xff80fbc0)
        art.draw(sprites[images[2][floor(o.aim / 2) + 1]],h,l,0,0)
    end

    return M
end
