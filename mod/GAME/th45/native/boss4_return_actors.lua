-- 回程的 0x72 翼侧子机分开等待放行信号，0x73 弹环在自身第一次运行时发射。
return function(program,bullets,effects,art)
    local band=require('bit').band
    local floor,min=math.floor,math.min
    local s16=program.s16
    local data=program.boss4
    local drone,ring={parts=1},{parts=17}

    function drone.init(o)
        o.owner,o.h,o.l=o.row.owner,o.row.h,o.row.l
        o.flags,o.front,o.back,o.right,o.left,o.hp=unpack(data.returnDroneBox)
        o.palette,o.frame,o.hold,o.frameClock=18,0,0x10,0
        o.speed,o.direction=0,0
        o.moveClock,o.movePeriod=4,4-band(program.random(o.run,program.randomByte),3)
        o.fireClock=0x50
        return true
    end

    function drone.step(o)
        local run,owner=o.run,o.owner
        if owner.phase>0 or run.boss4~=owner or o.hp<0 then
            effects.emit(o,0x86,o.speed,o.direction*4,0,false,12)
            return false
        end
        o.palette=o.impact and (o.palette==18 and 31 or 18) or 18
        o.impact=nil
        if run.stopPathClock then return true end
        if not run.freeze and owner.returnDroneDirection then
            o.moveClock=o.moveClock-1
            if o.moveClock<0 then
                o.moveClock=o.movePeriod
                if o.frame>=32 then
                    if o.speed==0 then
                        local angle=program.angle(o.h,o.l,run.player,0x20)
                        o.direction=angle<0x20 and 0x10 or 0x30
                    end
                    o.speed=min(0xd,o.speed+1)
                end
            end
        end
        local dh,dl=program.vector(o.speed,o.direction*4,run.slowVectors)
        o.h,o.l=s16(o.h+dh),s16(o.l+dl)
        if band(o.l+0x1000+run.cameraOffset,0xffff)<0x5800 then o.seen=true
        elseif o.seen then return false end
        if not run.freeze and owner.returnDroneDirection then
            o.fireClock=o.fireClock-1
            if o.fireClock<0 then
                o.fireClock=0x28
                local modifier=-min(0xc,8+floor(o.speed/2))
                for _,angle in ipairs({0x40,0xc0}) do bullets.emit(o,6,modifier,angle,0,0,true) end
            end
            if o.hold>0 then o.hold=o.hold-1
            else
                o.frame=o.frame+1
                if o.frame==32 then o.flags=0xa601 end
                if o.frame==40 then o.frame=32 end
            end
        end
        return true
    end

    function drone.render(o)
        local assets=o.run.art
        if assets then
            art.draw(assets.sprites[data.images.returnDrone[o.palette][o.frame+1]],o.h,o.l,-0x400,-0x300)
        end
    end

    local function project(o)
        local spinSin,spinCos=unpack(data.rotation[o.spin%256+1])
        local yawSin,yawCos=unpack(data.rotation[o.yaw%256+1])
        local pitchSin,pitchCos=unpack(data.rotation[0xa1])
        o.radius=min(0x30,o.radius+1)
        for i,p in ipairs(o.extraParts) do
            local x,y=unpack(data.rotation[(i-1)*0x10+1])
            x,y=x*o.radius,y*o.radius
            x,y=floor((spinCos*x-spinSin*y)/64),floor((spinSin*x+spinCos*y)/64)
            local z=floor(yawSin*y/64)
            y=floor(yawCos*y/64)
            x=floor((pitchCos*x+pitchSin*z)/64)
            p.h,p.l=s16(o.h+x),s16(o.l+y)
        end
    end

    function ring.init(o)
        local row=o.row
        o.h,o.l,o.speed,o.angle=row.h,row.l,row.speed,row.angle%256
        o.flags,o.front,o.back,o.right,o.left,o.hp=unpack(data.returnRingBox)
        o.spin,o.yaw,o.radius=0,0,0x20
        o.turn=2*data.droneWaveNoise[program.nextRandom(o.run)]
        o.extraParts={}
        for i=1,16 do o.extraParts[i]={flags=0x8000} end
        project(o)
        for _,p in ipairs(o.extraParts) do bullets.emit(o,0x1e,0,0,-o.h,-o.l,false,p) end
        return true
    end

    function ring.step(o)
        local run=o.run
        if not run.freeze and not o.fired then
            o.fired=true
            o.angle=program.angle8(o.h,o.l,run.player,o.angle)
            for i,p in ipairs(o.extraParts) do
                local angle=(i-1)*0x10+o.spin
                for delta=0,8,8 do bullets.emit(o,13,2,angle+delta,s16(p.h-o.h),s16(p.l-o.l),true) end
            end
        end
        local dh,dl=program.vector(o.speed,o.angle,run.slowVectors)
        o.h,o.l=s16(o.h+dh),s16(o.l+dl)
        if band(o.h+0x1400,0xffff)<0x9800 and band(o.l+0x1c00+run.cameraOffset,0xffff)<0x7000 then
            o.seen=true
        elseif o.seen then
            for _,p in ipairs(o.extraParts) do p.retired=true end
            return false
        end
        if not run.freeze then o.spin,o.yaw=o.spin+4,o.yaw+o.turn end
        project(o)
        return true
    end

    return drone,ring
end
