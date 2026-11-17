-- 0x1a7774 的脱离件走自己的速度表，到达释放点时登记两颗横向母弹。
return function(program,bullets,art)
    local s16=program.s16
    local H={parts=1}

    function H.init(o)
        local row=o.row
        o.h,o.l,o.speed,o.heading=row.h,row.l,row.speed,row.heading
        o.flags,o.clock,o.anim,o.emitterClock=0x8000,0,0,0
        return true
    end

    function H.step(o)
        local run,row=o.run,o.row
        if run.finalPortsPurge then return false end
        if not run.freeze then
            o.emitterClock=o.emitterClock-1
            if o.emitterClock<0 then
                o.emitterClock=2
                if not row.fixed then o.speed=o.speed-1 end
                if (row.fixed and o.h<=0x400) or o.speed==0 then
                    bullets.emit(o,row.bullet,0,0x40,0,0,true,row.period)
                    bullets.emit(o,row.bullet,0,0xc0,0,0,true,row.period)
                    return false
                end
            end
            o.anim=(o.anim+1)%30
        end
        if not run.stopPathClock then
            local dh,dl=program.vector(o.speed,o.heading,run.slowVectors)
            o.h,o.l=s16(o.h+dh),s16(o.l+dl)
        end
        return true
    end

    function H.render(o)
        if not o.run.art then return end
        local image=program.boss6.images.finalArmorJointWide[o.anim+1]
        art.draw(o.run.art.sprites[image],o.h,o.l,-0x600,-0x400)
    end

    return H
end
