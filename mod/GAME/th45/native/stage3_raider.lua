-- 0x155514 先用两侧炮口狙击，再用中央炮口逐轮提高五路圆弹的速度。
return function(program,path,bullets,art,effects)
    local bit = require('bit')
    local band,bxor = bit.band,bit.bxor
    local data = program.stage3Raider
    local s16,addPacked = program.s16,program.addPacked
    local bodyPalette,flash = unpack(data.palette)
    local roundAngles = {0x80,0x90,0xa0,0x70,0x60}
    local H = {parts=2}

    function H.init(o)
        o.otherSide = {}
        o.extraParts = {o.otherSide}
        for i,p in ipairs({o,o.otherSide}) do
            p.flags,p.front,p.back,p.right,p.left,p.hp = unpack(data.parts[i])
        end
        if not path.attach(o,o.row) then return false end
        o.otherSide.h,o.otherSide.l = o.h,o.l
        o.palette,o.rotorPalette,o.health = bodyPalette,10,data.health
        o.phase,o.reload,o.shotClock = 0,8,0
        o.rotor,o.rotorClock,o.tips,o.tipClock,o.tipPeriod = 0,0,0,0,0
        return true
    end

    local function damage(o)
        local p = o.otherSide
        if o.impact or p.impact then
            o.health = o.health-band((o.damage or 0)+(p.damage or 0),0xffff)
            if o.health < 0 then
                effects.emitSequence(o,data.destruction)
                return false
            end
            o.hp,p.hp = 0x7fff,0x7fff
            o.damage,p.damage,o.impact,p.impact = 0,0,nil,nil
            if o.palette == 25 then o.palette,o.rotorPalette = bodyPalette,10 end
            o.palette,o.rotorPalette = bxor(o.palette,flash),bxor(o.rotorPalette,0x15)
        elseif o.health < 0x155 then
            o.palette,o.rotorPalette = 25,25
        else
            o.palette,o.rotorPalette = bodyPalette,10
        end
        return true
    end

    local function fire(o)
        local run = o.run
        o.tipClock = o.tipClock-1
        if o.tipClock < 0 then
            o.tipClock,o.tips = o.tipPeriod,band(o.tips+1,7)
        end
        local inRange = o.h >= 0x2400
        if o.phase == 0 and inRange then
            o.reload = o.reload-1
            if o.reload < 0 then
                o.reload,o.phase,o.shotClock,o.remaining = 0x58-run.tankStartRank,2,8,5
                o.startedArrow = false
            end
        end
        if o.phase == 2 then
            if inRange then
                o.shotClock = o.shotClock-1
                if o.shotClock >= 0 then return end
                o.shotClock = 6
                if not run.blockEnemyFire then
                    if not o.startedArrow then o.tipClock,o.tipPeriod,o.startedArrow = 0,0,true end
                    if not run.player or not run.player.active then return end
                    local h = s16(o.h-0x100)
                    local right = program.angle8(h,s16(o.l+0x400),run.player,0x80)
                    local left = program.angle8(h,s16(o.l-0x400),run.player,0x80)
                    bullets.emit(o,13,-1,right,-0x100,0x400,true)
                    bullets.emit(o,13,-1,left,-0x101,-0x400,true)
                end
                o.remaining = o.remaining-1
            end
            if o.remaining == 0 or not inRange then
                o.tipClock,o.tipPeriod,o.shotClock,o.remaining,o.phase = 0,3,16,6,3
            end
        end
        if o.phase == 3 then
            if not inRange then o.phase = 0; return end
            o.shotClock = o.shotClock-1
            if o.shotClock >= 0 then return end
            o.shotClock = 4
            for _,angle in ipairs(roundAngles) do bullets.emit(o,1,15-2*o.remaining,angle,-0x400,0) end
            o.remaining = o.remaining-1
            if o.remaining == 0 then o.phase = 0 end
        end
    end

    function H.step(o)
        local run = o.run
        if not damage(o) or not path.step(o,-run.groundScroll) then return false end
        o.otherSide.h,o.otherSide.l = o.h,o.l
        if band(o.h+0x800,0xffff) < 0x8000 and band(o.l+0x1000+run.cameraOffset,0xffff) < 0x5800 then
            o.seen = true
        elseif o.seen then return false end
        if not run.freeze and not run.stopPathClock then fire(o) end
        o.rotorClock = o.rotorClock-1
        if o.rotorClock < 0 then o.rotorClock,o.rotor = 1,band(o.rotor-1,15) end
        o.visible = true
        return true
    end

    function H.render(o)
        local assets = o.run.art
        if not assets or not o.visible then return end
        local function draw(image,offset,flip)
            local h,l = addPacked(o.h,o.l,offset)
            art.draw(assets.sprites[image],h,l,0,0,flip)
        end
        local body = data.images[o.palette]
        local rotor = data.rotors[o.rotorPalette][o.rotor+1]
        local tip = body[o.tips+2]
        draw(body[1],0xf800f900)
        draw(rotor,0xfbc0f600)
        draw(rotor,0xfbc00000,true)
        draw(tip,0xfc80fa00)
        draw(tip,0xfc800200,true)
    end

    return H
end
