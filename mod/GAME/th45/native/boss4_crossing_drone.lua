-- 0x19d312 共用两处判定。游机先减速悬停，然后转为向上离场。
return function(program,bullets,effects,art)
    local s16=program.s16
    local data=program.boss4
    local H={parts=2}

    function H.init(o)
        local row=o.row
        o.owner,o.h,o.l=row.owner,row.h,row.l
        o.speed,o.direction,o.turn=0x10,row.direction,row.turn
        o.health,o.palette,o.frame=0x100,20,0
        o.motion,o.moveClock,o.fireClock,o.artClock=0,4,1,1
        local secondary={h=o.h,l=o.l}
        o.extraParts={secondary}
        for i,part in ipairs({o,secondary}) do
            part.flags,part.front,part.back,part.right,part.left,part.hp=unpack(data.crossingDroneBoxes[i])
        end
        o.aim=0x80
        return true
    end

    function H.step(o)
        local run=o.run
        local secondary=o.extraParts[1]
        if o.impact or secondary.impact then
            o.health=o.health-(o.damage or 0)-(secondary.damage or 0)
            o.palette=o.palette==20 and 31 or 20
            for _,part in ipairs({o,secondary}) do
                part.impact,part.damage,part.hp=nil,0,0x7fff
            end
        else o.palette=20 end
        if o.health<0 or o.h>=0x6400 or o.owner.phase>0 or run.boss4~=o.owner then
            effects.emit(o,0x8b,o.speed,o.direction*4,0,false,12)
            return false
        end
        if run.stopPathClock then return true end
        if not run.freeze then
            o.moveClock=o.moveClock-1
            if o.moveClock<0 then
                if o.motion==0 then
                    o.speed,o.moveClock=o.speed-1,4
                    if o.speed==0 then o.motion,o.moveClock,o.direction=1,2,0 end
                else
                    o.speed,o.moveClock=math.min(8,o.speed+1),2
                end
            end
        end
        local dh,dl=program.vector(o.speed,o.direction*4,run.slowVectors)
        o.h,o.l=s16(o.h+dh),s16(o.l+dl)
        secondary.h,secondary.l=o.h,o.l
        if not run.freeze then
            o.fireClock=o.fireClock-1
            if o.fireClock<0 then
                o.fireClock=1
                bullets.emit(o,13,0x10,o.aim,0x100,0,true)
                o.aim=(o.aim+o.turn)%256
            end
            o.artClock=o.artClock-1
            if o.artClock<0 then o.artClock,o.frame=1,(o.frame+1)%8 end
        end
        return true
    end

    function H.render(o)
        local assets=o.run.art
        if assets then
            local image=data.images.crossingDrone[o.palette][o.frame+1]
            art.draw(assets.sprites[image],o.h,o.l,-0x800,-0x400)
        end
    end

    return H
end
