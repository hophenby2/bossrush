-- 0x1a74aa 的十二个发弹点使用 0x1188c6 的通常速度表确定环半径。
return function(program,bullets,effects,art)
    local band=require('bit').band
    local abs,floor=math.abs,math.floor
    local s16,s8=program.s16,program.s8
    local data=program.boss6
    local H={parts=13}

    local function place(o)
        for _,p in ipairs(o.extraParts) do
            local angle=band(p.angle+o.rotation,255)
            local h,l=program.vector(o.radius,angle,false)
            p.h,p.l=s16(o.h+8*h),s16(o.l+8*l)
        end
    end

    function H.init(o)
        o.h,o.l,o.owner=o.row.h,o.row.l,o.row.owner
        o.flags,o.front,o.back,o.right,o.left,o.hp=0x8001,0x200,0x200,0x180,0x180,0x7fff
        o.phase,o.radius,o.speed,o.heading=1,0x10,o.row.speed,0x20
        o.rotation=band(2*s8(program.random(o.run,program.randomNarrow)),255)
        o.turn=o.row.turn
        o.fireClock,o.aimed,o.spread=0x1c,1,false
        o.extraParts={}
        for i=1,12 do
            o.extraParts[i]={flags=0x8000,angle=(i-1)*0x15,run=o.run}
        end
        place(o)
        return true
    end

    local function aimSpeed(o)
        local target=o.owner
        o.target.h,o.target.l=s16(target.h+0x400),target.l
        o.heading=program.angle8(o.h,o.l,o.target,o.heading)
        local h,l=abs(s16(o.h-o.target.h)),abs(s16(o.l-o.target.l))
        h=h-floor(h/4)
        local distance=math.max(h,l)+floor(math.min(h,l)/2)
        local row=data.finalRingSpeed[math.max(1,math.ceil(distance/0x40))]
        o.speed=row and row[2] or 0xe
    end

    local function fire(o)
        if o.phase==1 then
            if o.aimed>0 then
                o.fireClock=o.fireClock-1
                if o.fireClock<0 then
                    o.aimed=0
                    for _,p in ipairs(o.extraParts) do
                        local angle=program.angle8(p.h,p.l,o.run.player,0x80)
                        bullets.emit(p,0x16,6,angle,0,0,true)
                    end
                end
            end
            o.radius=o.radius+1
            if o.radius<0x78 then return true end
            o.phase=2
        end
        if not o.spread then
            o.spread=true
            for _,p in ipairs(o.extraParts) do
                local angle=p.angle+o.rotation+0x40+(o.turn<0 and 0x80 or 0)
                bullets.emit(p,0xd,4,angle,0,0,true)
            end
        end
        o.radius=o.radius-4
        return o.radius>0
    end

    function H.step(o)
        local run=o.run
        if o.owner.phase>=2 then
            effects.emit(o,0x86,o.speed,o.heading,0,false,0)
            return false
        end
        if not run.freeze and not run.stopPathClock and not fire(o) then return false end
        o.target=o.target or {active=true}
        aimSpeed(o)
        if not run.stopPathClock then
            local h,l=program.vector(o.speed,o.heading,run.slowVectors)
            o.h,o.l=s16(o.h+h),s16(o.l+l)
        end
        place(o)
        if not run.freeze then o.rotation=band(o.rotation+o.turn,255) end
        return true
    end

    function H.render(o)
        if not o.run.art then return end
        local image=o.run.art.sprites[data.images.finalRing[1]]
        for _,p in ipairs(o.extraParts) do art.draw(image,p.h,p.l,-0x400,-0x200) end
    end

    return H
end
