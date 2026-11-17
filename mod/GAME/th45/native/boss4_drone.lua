-- 0x19f156 从后舱两边轮流落下，纵向速度取自舰体输送带。
return function(program,bullets,effects,art)
    local floor=math.floor
    local s16,s8=program.s16,program.s8
    local data=program.boss4
    local H={parts=1}

    function H.init(o)
        local row=o.row
        o.owner,o.h,o.l,o.turn=row.owner,row.h,row.l,row.turn
        if not o.owner then return false end
        o.flags,o.front,o.back,o.right,o.left,o.hp=unpack(data.droneBox)
        local run=o.run
        o.palette,o.angle,o.frame=19,0,0
        o.delay=0x10+s8(program.random(run,program.randomNarrow))
        o.count=9+data.droneWaveNoise[program.nextRandom(run)]
        o.shots,o.fireClock,o.artClock=0,0,0
        return true
    end

    function H.step(o)
        local run,owner=o.run,o.owner
        if owner.phase>=2 or run.boss4~=owner or o.hp<0 then
            effects.emit(o,0x8b,0x10,0x80,0)
            return false
        end
        o.palette=o.impact and (o.palette==19 and 31 or 19) or 19
        o.impact=nil
        if run.stopPathClock then return true end
        local speed=owner.engineOffset
        if run.freeze then speed=floor(speed/2) end
        o.h,o.l=s16(o.h-speed),s16(o.l+owner.deltaL)
        if o.h<=0 then return false end
        if run.freeze then return true end
        if o.shots==0 then
            o.delay=o.delay-1
            if o.delay<0 then o.delay,o.shots=7,o.count end
        end
        if o.shots>0 then
            o.fireClock=o.fireClock-1
            if o.fireClock<0 then
                o.fireClock,o.shots=1,o.shots-1
                bullets.emit(o,13,-8,o.angle,0,0,true)
            end
        end
        o.angle=(o.angle+o.turn)%256
        o.artClock=o.artClock-1
        if o.artClock<0 then o.artClock,o.frame=1,(o.frame+1)%8 end
        return true
    end

    function H.render(o)
        local assets=o.run.art
        if assets then art.draw(assets.sprites[data.images.drone[o.palette][o.frame+1]],o.h,o.l,-0x400,-0x300) end
    end

    return H
end
