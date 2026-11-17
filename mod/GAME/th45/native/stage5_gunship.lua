-- 0x16b26c 共用两处判定，舷炮和中央炮依次开舱。状态与炮口随 0x16b1e4 初始化。
return function(program,path,bullets,art,effects)
    local band=require('bit').band
    local floor,s16=math.floor,program.s16
    local packed=program.addPacked
    local data=program.stage5Gunship
    local muzzle=program.stage3Heavy.muzzle
    local H={parts=2}

    function H.init(o)
        local state=data.state
        local part={}
        o.extraParts={part}
        for i,p in ipairs({o,part}) do
            p.flags,p.front,p.back,p.right,p.left,p.hp=unpack(data.boxes[i])
        end
        if not path.attach(o,o.row) then return false end
        part.h,part.l=o.h,o.l
        o.health,o.protection=state[15],state[5]
        o.palette,o.rotorPalette=19,10
        o.phase,o.wingFrame,o.centerFrame,o.centerMoving=0,0,0,false
        o.wingClock,o.wingShots,o.wingBatches= floor(state[6]/256)-o.run.volleyRank,1,3
        o.centerClock,o.centerShots=0,0xf
        o.rotor,o.rotorClock,o.sideAnim,o.sideClock,o.centerAnim,o.centerAnimClock=29,1,7,1,0,1
        return true
    end

    local function shot(o,kind,modifier,angle,base)
        local offset=base+muzzle[floor(band(angle+2,0xfc)/4)+1]
        bullets.emit(o,kind,modifier,angle,s16(floor(offset/0x10000)),s16(offset),true)
    end

    local function wings(o)
        if o.h<0x1800 then return true end
        local pilot=o.run.player
        if o.wingShots==1 then
            if not pilot or not pilot.active then return false end
            local h=s16(o.h-0x1c0)
            o.rightAim=program.angle8(h,s16(o.l+0x580),pilot,0x80)
            o.leftAim=program.angle8(h,s16(o.l-0x580),pilot,0x80)
        end
        for i=-2,2 do shot(o,13,2,o.rightAim+0x12*i,0xfec004c0) end
        for i=2,-2,-1 do shot(o,13,2,o.leftAim+0x12*i,0xfec0fb00) end
        return true
    end

    local function central(o)
        if o.h<0x1800 then return true end
        local pilot=o.run.player
        if not pilot or not pilot.active then return false end
        local aim=program.angle8(s16(o.h-0x140),o.l,pilot,0x80)
        aim=aim+program.random(o.run,program.randomHalf,0x7f)-0x20
        local base=data.centerOffsets[o.centerFrame+1]+0xfec00000
        for i=-2,2 do shot(o,10,-4,aim+0x20*i,base) end
        return true
    end

    local function attack(o)
        local phase=o.phase
        if phase==0 then
            o.wingClock=o.wingClock-1
            if o.wingClock<0 then o.phase,o.wingClock=1,0 end
        elseif phase==1 then
            o.wingFrame=o.wingFrame+1
            if o.wingFrame==17 then o.phase,o.wingFrame=2,15 end
        elseif phase==2 then
            o.wingClock=o.wingClock-1
            if o.wingClock>=0 then return end
            o.wingClock=4
            if not wings(o) then return end
            o.wingShots=o.wingShots-1
            if o.wingShots>=0 then return end
            o.wingShots,o.wingBatches=1,o.wingBatches-1
            if o.wingBatches<0 then o.phase,o.wingClock,o.wingBatches=3,0,3 end
        elseif phase==3 then
            if o.wingClock>0 then o.wingClock=o.wingClock-1; return end
            o.wingFrame=o.wingFrame-1
            if o.wingFrame==0 then o.phase,o.wingClock=4,0x30-o.run.volleyRank end
        elseif phase==4 or phase==7 then
            if o.centerClock>0 then o.centerClock=o.centerClock-1; return end
            if phase==4 then o.phase,o.centerMoving=5,true
            else
                o.centerFrame=o.centerFrame-1
                if o.centerFrame==0 then o.phase,o.centerMoving,o.centerClock=0,false,4 end
            end
        elseif phase==5 then
            o.centerFrame=o.centerFrame+1
            if o.centerFrame==17 then o.phase,o.centerFrame=6,15 end
        else
            o.centerClock=o.centerClock-1
            if o.centerClock>=0 then return end
            o.centerClock=4
            if not central(o) then return end
            o.centerShots=o.centerShots-1
            if o.centerShots<0 then o.phase,o.centerShots,o.centerClock=7,0xf,0 end
        end
    end

    function H.step(o)
        local run=o.run
        if not path.step(o,-run.groundScroll) then return false end
        local visible=band(o.h+0xc00,0xffff)<0x8800 and band(o.l+0x1200+run.cameraOffset,0xffff)<0x5c00
        if visible then o.seen=true
        elseif o.seen then return false end
        local part=o.extraParts[1]
        part.h,part.l=o.h,o.l
        if o.protection>=0 then
            o.protection=o.protection-1
            o.damage,part.damage=0,0
        end
        if o.impact or part.impact then
            o.health=o.health-band((o.damage or 0)+(part.damage or 0),0xffff)
            if o.health<0 then effects.emitSequence(o,data.blast); return false end
            o.palette,o.rotorPalette=o.palette==31 and 19 or 31,o.rotorPalette==31 and 10 or 31
            for _,p in ipairs({o,part}) do p.impact,p.damage,p.hp=nil,0,0x7fff end
        else
            o.palette,o.rotorPalette=19,10
            if band(o.hp,0xffff)<0x600 and not run.blockEnemyFire then o.palette,o.rotorPalette=25,25 end
        end
        if run.freeze then return true end
        o.rotorClock=o.rotorClock-1
        if o.rotorClock<0 then o.rotorClock,o.rotor=1,(o.rotor-1)%30 end
        if run.stopPathClock then return true end
        if o.seen then attack(o) end
        o.sideClock=o.sideClock-1
        if o.sideClock<0 then o.sideClock,o.sideAnim=1,(o.sideAnim-1)%8 end
        if o.centerMoving then o.centerAnim=(o.centerAnim-1)%8
        else
            o.centerAnimClock=o.centerAnimClock-1
            if o.centerAnimClock<0 then o.centerAnimClock,o.centerAnim=1,(o.centerAnim-1)%8 end
        end
        return true
    end

    function H.render(o)
        local assets=o.run.art
        if not assets then return end
        local images=data.images[o.palette]
        local function draw(id,offset,flip)
            local h,l=packed(o.h,o.l,offset)
            art.draw(assets.sprites[id],h,l,0,0,flip)
        end
        draw(images.center[o.centerAnim+1],data.centerOffsets[o.centerFrame+1]+0xfa00fe00)
        draw(images.side[o.sideAnim+1],0xfa400380)
        draw(images.side[o.sideAnim+1],0xfa3ff880,true)
        draw(images.hatch[1],data.rightOffsets[o.wingFrame+1]+0xfa00fd40)
        draw(images.hatch[2],data.leftOffsets[o.wingFrame+1]+0xfa00fd40)
        draw(images.hull,0xf000fa00)
        local rotor=data.rotors[o.rotorPalette][o.rotor+1]
        draw(rotor[1],rotor[2])
        draw(rotor[1],rotor[2]+0xec0,true)
        draw(images.port,0x02c0fb80)
        draw(images.port,0x02c00080,true)
    end

    return H
end
