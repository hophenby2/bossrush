-- 0x16ac34 的八组机身帧和炮塔挂点由出场方向选定。开炮后保持六次连射的炮向。
return function(program,path,bullets,art,effects)
    local bit=require('bit')
    local band,bxor=bit.band,bit.bxor
    local floor,s16=math.floor,program.s16
    local data=program.stage5TurretShip
    local muzzle=program.stage3Heavy.muzzle
    local H={parts=1}

    function H.init(o)
        o.flags,o.front,o.back,o.right,o.left,o.hp=unpack(data.box)
        if not path.attach(o,o.row) then return false end
        o.variant=floor(band(o.direction,0x38)/8)+1
        o.pivot=data.ports[o.variant]
        o.palette,o.anim,o.animClock=20,0,1
        o.protection,o.fireClock,o.shots=0x30,0x40-o.run.tankFireRank,5
        local h,l=program.addPacked(o.h,o.l,o.pivot)
        o.aim=program.angle(h,l,o.run.player,band(o.direction,63))
        return true
    end

    local function attack(o)
        local run=o.run
        if o.shots==5 then
            local h,l=program.addPacked(o.h,o.l,o.pivot)
            o.aim=program.towards(o.aim,program.angle(h,l,run.player,o.aim))
        end
        if o.h<0x3000 or band(o.flags,0x2000)==0 or not program.atPatrolDistance(o) then return end
        o.fireClock=o.fireClock-1
        if o.fireClock>=0 or run.stopPathClock then return end
        local base=data.muzzles[floor(o.aim/2)+1]+o.pivot
        local speed=12-2*o.shots
        for delta=-0x10,0x10,0x10 do
            local angle=o.aim*4+delta
            local offset=base+muzzle[floor(band(angle+2,0xfc)/4)+1]
            bullets.emit(o,25,speed,angle,s16(floor(offset/0x10000)),s16(offset),true)
        end
        o.shots,o.fireClock=o.shots-1,5
        if o.shots<0 then o.shots,o.fireClock=5,0x28-run.volleyRank end
    end

    function H.step(o)
        local run=o.run
        if not path.step(o,-run.groundScroll) then return false end
        if band(o.h+0xc00,0xffff)<0x8800 and band(o.l+0x1000+run.cameraOffset,0xffff)<0x5800 then
            o.seen=true
        elseif o.seen then return false end
        if o.protection>=0 then
            o.protection=o.protection-1
            o.hp=o.protection<0 and 0x400 or 0x7fff
            o.damage=0
        end
        if o.impact then
            o.impact=nil
            o.palette=bxor(o.palette==25 and 20 or o.palette,11)
            if o.hp<0 then
                effects.emitSequence(o,data.blast)
                return false
            end
        else o.palette=o.hp<0x100 and not run.blockEnemyFire and 25 or 20 end
        if run.freeze or run.stopPathClock then return true end
        if o.direction<0x40 then
            o.animClock=o.animClock-1
            if o.animClock<0 then o.animClock,o.anim=1,(o.anim-1)%14 end
        end
        attack(o)
        return true
    end

    function H.render(o)
        local assets=o.run.art
        if not assets then return end
        local images=data.images[o.palette]
        art.draw(assets.sprites[images.hull[o.variant][o.anim+1]],o.h,o.l,-0xc00,-0x800)
        local h,l=program.addPacked(o.h,o.l,o.pivot+0xfc00fd00)
        art.draw(assets.sprites[images.guns[floor(o.aim/2)+1]],h,l,0,0)
    end

    return H
end
