-- 0x1a7ac0 的碎片先追向机身，再按原版距离表减速。全程没有受击判定。
return function(program,art)
    local band=require('bit').band
    local abs,floor=math.abs,math.floor
    local s16=program.s16
    local data=program.boss6
    local H={parts=1}

    function H.init(o)
        o.h,o.l,o.owner=o.row.h,o.row.l,o.row.owner
        o.flags,o.speed,o.heading=0x8000,0,0
        o.anim=band(program.random(o.run,program.randomByte),15)
        o.age,o.clock=0,0
        o.target={active=true,h=o.row.targetH,l=o.row.targetL}
        return true
    end

    function H.step(o)
        local run=o.run
        if not o.owner and run.finalShardsPurge then return false end
        if not run.freeze then
            o.clock=o.clock-1
            if o.clock<0 then
                o.clock,o.age,o.anim=1,o.age+1,(o.anim+1)%16
                if o.owner and o.age==16 then return false end
            end
            local p=o.owner
            local target=o.target
            if p then target.h,target.l=p.h,p.l end
            if o.stuck then return true end
            o.heading=program.angle8(o.h,o.l,target,o.heading)
            local h,l=abs(s16(o.h-target.h)),abs(s16(o.l-target.l))
            h=h-floor(h/4)
            local distance=math.max(h,l)+floor(math.min(h,l)/2)
            if distance<=0x80 then
                if p then return false end
                o.h,o.l,o.speed,o.stuck=target.h,target.l,0,true
                return true
            end
            local row=data.finalReassemblySpeed[math.ceil(distance/0x40)]
            o.speed=row and row[2] or 0x18
        end
        if not run.stopPathClock then
            local dh,dl=program.vector(o.speed,o.heading,run.slowVectors)
            o.h,o.l=s16(o.h+dh),s16(o.l+dl)
        end
        return true
    end

    function H.render(o)
        if not o.run.art then return end
        local frames=o.owner and data.images.finalReassembly or data.images.finalCoreShards
        local image=o.run.art.sprites[frames[o.anim+1]]
        art.draw(image,o.h,o.l,-0x400,-0x300)
    end

    return H
end
