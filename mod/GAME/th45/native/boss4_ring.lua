-- 0x19de96 先推进发射中心，再用 0x1a9394 的 6 位定点三轴旋转表布置十六个部件。
return function(program,bullets)
    local band=require('bit').band
    local floor=math.floor
    local s16=program.s16
    local data=program.boss4
    local H={parts=17}

    function H.init(o)
        local row=o.row
        o.h,o.l,o.angle,o.speed=row.h,row.l,band(row.angle,255),0x18
        o.flags,o.front,o.back,o.right,o.left,o.hp=unpack(data.ringBox)
        o.radius=5+band(program.random(o.run,program.randomByte),31)
        o.roll,o.pitch,o.yaw=0,0x500,o.angle*8
        o.extraParts={}
        for index=1,16 do
            local part={flags=0x8000,h=0,l=0}
            o.extraParts[index]=part
            bullets.emit(o,0x1e,0,0,-o.h,-o.l,false,part)
        end
        return true
    end

    local function rotation(angle)
        return unpack(data.rotation[floor(angle/8)+1])
    end

    local function retire(o)
        for _,part in ipairs(o.extraParts) do part.retired=true end
        return false
    end

    function H.step(o)
        local run=o.run
        local dh,dl=program.vector(o.speed,o.angle,run.slowVectors)
        o.h,o.l=s16(o.h+dh),s16(o.l+dl)
        if band(o.h+0x1c00,0xffff)<0xa800 and band(o.l+0x2400+run.cameraOffset,0xffff)<0x8000 then
            o.seen=true
        elseif o.seen then return retire(o) end
        if run.freeze then return true end
        o.pitch,o.radius=band(o.pitch+8,0x7f8),o.radius+1
        local rollSin,rollCos=rotation(o.roll)
        local yawSin,yawCos=rotation(o.yaw)
        local pitchSin,pitchCos=rotation(o.pitch)
        for index,part in ipairs(o.extraParts) do
            local x,y=rotation((index-1)*0x80)
            x,y=x*o.radius,y*o.radius
            x,y=floor((rollCos*x-rollSin*y)/64),floor((rollSin*x+rollCos*y)/64)
            local z=floor(yawSin*y/64)
            y=floor(yawCos*y/64)
            x=floor((pitchCos*x+pitchSin*z)/64)
            part.h,part.l=s16(o.h+x),s16(o.l+y)
        end
        return true
    end

    return H
end
