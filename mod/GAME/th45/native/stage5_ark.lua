-- 0x164166 在 0xb2 与 0xfe 出场。前舱轮转时中央炮独立跟踪自机。
return function(program,path,bullets,art,effects)
    local bit=require('bit')
    local band,bxor=bit.band,bit.bxor
    local floor,s16=math.floor,program.s16
    local data=program.stage5Ark
    local H={parts=2}

    function H.init(o)
        o.extraParts={{}}
        for i,part in ipairs({o,o.extraParts[1]}) do
            part.flags,part.front,part.back,part.right,part.left,part.hp=unpack(data.boxes[i])
        end
        if not path.attach(o,o.row) then return false end
        o.extraParts[1].h,o.extraParts[1].l=o.h,o.l
        o.health,o.palette,o.rotorPalette=data.health,12,10
        o.phase,o.wing,o.wingAnim,o.rotor=0,0,0,15
        o.wingClock,o.wingAnimClock,o.wingDelay,o.wingLeft=0x38,1,1,8
        o.centerClock,o.centerLeft,o.trackClock=0x24,8,0
        o.rotorClock,o.portClock,o.portFrame=1,1,0
        o.aim=program.angle(o.h,o.l,o.run.player,0x20)
        o.run.stageFlags[0]=true
        return true
    end

    local function emit(o,kind,speed,angle,offset,ports)
        offset=offset+ports[floor(band(angle+2,0xfc)/4)+1]
        bullets.emit(o,kind,speed,angle,s16(floor(offset/0x10000)),s16(offset),true)
    end

    local function wingAttack(o)
        if o.h<0x1800 or not o.seen then return end
        if o.phase==0 then
            o.wingClock=o.wingClock-1
            if o.wingClock<0 then o.phase,o.wingClock=1,4 end
            return
        end
        if o.phase==2 then
            o.wingClock=o.wingClock-1
            if o.wingClock>=0 then return end
            o.wingClock=0xa
            local p=o.run.player
            if p and p.active then
                for _,side in ipairs({0x900,-0x900}) do
                    local aim=program.angle8(s16(o.h-0xe00),s16(o.l+side),p,0x80)
                    local offset=0xf2000000+band(side,0xffff)
                    for i=-3,3 do emit(o,13,-4,aim+12*i,offset,program.stage3Heavy.muzzle) end
                end
            end
            o.wingLeft=o.wingLeft-1
            if o.wingLeft<0 then o.phase,o.wingClock,o.wingLeft=3,4,8 end
            return
        end
        if o.phase==3 and o.wingClock>0 then o.wingClock=o.wingClock-1; return end
        o.wingDelay=o.wingDelay-1
        if o.wingDelay>=0 then return end
        o.wingDelay=1
        if o.phase==1 then
            o.wing=o.wing+1
            if o.wing==20 then o.phase,o.wing=2,18 end
        else
            o.wing=o.wing-1
            if o.wing==0 then o.phase,o.wingClock=0,0x80-o.run.tankFireRank end
        end
    end

    local function central(o)
        local run=o.run
        o.trackClock=o.trackClock-1
        if o.trackClock<0 then
            o.trackClock=0
            o.aim=program.towards(o.aim,program.angle(s16(o.h-0xb00),o.l,run.player,o.aim))
        end
        if o.h<0x1800 or run.freeze or run.stopPathClock then return end
        o.centerClock=o.centerClock-1
        if o.centerClock>=0 then return end
        o.centerClock=8-floor(run.volleyRank/4)
        local offset=0xf5000000+data.muzzles[floor(o.aim/2)+1]
        for i=0,4 do emit(o,2,2,o.aim*4-0x18+i*0xb,offset,program.mid2.muzzle0) end
        o.centerLeft=o.centerLeft-1
        if o.centerLeft<0 then o.centerLeft,o.centerClock=8,0x60-run.sweepFireRank end
    end

    local function leave(o)
        o.run.stageFlags[0]=false
        return false
    end

    function H.step(o)
        local run=o.run
        if not path.step(o,-run.groundScroll) then return leave(o) end
        if band(o.h+0x1c00,0xffff)<0xa800 and band(o.l+0x1400+run.cameraOffset,0xffff)<0x6000 then
            o.seen=true
        elseif o.seen then return leave(o) end
        local p=o.extraParts[1]
        p.h,p.l=o.h,o.l
        if o.impact or p.impact then
            o.health=o.health-band((o.damage or 0)+(p.damage or 0),0xffff)
            if o.health<0 then
                bullets.clear(run,1)
                effects.emitSequence(o,data.blast)
                return leave(o)
            end
            o.palette=bxor(o.palette==25 and 12 or o.palette,0x13)
            o.rotorPalette=bxor(o.rotorPalette==25 and 10 or o.rotorPalette,0x15)
            for _,part in ipairs({o,p}) do part.impact,part.damage,part.hp=nil,0,0x7fff end
        else o.palette,o.rotorPalette=12,10 end
        o.rotorClock,o.portClock=o.rotorClock-1,o.portClock-1
        if o.rotorClock<0 then o.rotorClock,o.rotor=1,(o.rotor-1)%16 end
        if o.portClock<0 then o.portClock,o.portFrame=1,(o.portFrame-1)%8 end
        wingAttack(o)
        central(o)
        return true
    end

    function H.render(o)
        local assets=o.run.art
        if not assets then return end
        local images=data.images[o.palette]
        local function draw(id,offset,flip)
            local h,l=program.addPacked(o.h,o.l,offset)
            art.draw(assets.sprites[id],h,l,0,0,flip)
        end
        draw(images.hull,0xe400f400)
        local rotor=data.rotors[o.rotorPalette][o.rotor+1]
        draw(rotor,0xf800ea00)
        draw(rotor,0xf8000200,true)
        draw(images.ports[o.portFrame+1],0xec8006c0)
        draw(images.ports[o.portFrame+1],0xec7ff540)
        local wingOffset=data.wingOffsets[o.wing+1]
        draw(images.wing,wingOffset+0xf800fd00)
        draw(images.wing,0xf800fd00+floor(wingOffset/0x10000)*0x10000-band(wingOffset,0xffff))
        draw(images.guns[floor(o.aim/2)+1],0xed00f900)
    end

    return H
end
