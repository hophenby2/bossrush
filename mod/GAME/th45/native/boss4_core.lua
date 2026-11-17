-- 0x19ea9e 的八点炮组独占敌机槽，中心固定在后舱前方。
return function(program,bullets,art)
    local floor,s16=math.floor,program.s16
    local data=program.boss4
    local H={parts=9}

    function H.init(o)
        o.owner,o.h,o.l=o.row.owner,o.row.h,o.row.l
        o.flags=0x8000
        o.spin,o.pitch,o.yaw,o.clock,o.frame=0,0xa0,0x10,4,0
        o.extraParts={}
        for i=1,8 do o.extraParts[i]={flags=0x8000,h=0,l=0} end
        return true
    end

    local function shot(o,p,angle,speed)
        if angle>=0x30 and angle<0xd0 then
            bullets.emit(o,13,speed,angle,s16(p.h-o.h),s16(p.l-o.l),false)
        end
    end

    function H.step(o)
        local owner,run=o.owner,o.run
        if owner.phase>=3 or run.boss4~=owner then return false end
        o.h,o.l=s16(owner.rear.h+0x1800),owner.rear.l
        o.spin,o.pitch,o.yaw=(o.spin+1)%256,(o.pitch+1)%256,(o.yaw+1)%256
        o.clock=o.clock-1
        local fire=o.clock<0
        if fire then o.clock=4 end
        local spinSin,spinCos=unpack(data.rotation[o.spin+1])
        local pitchSin,pitchCos=unpack(data.rotation[o.pitch+1])
        local yawSin,yawCos=unpack(data.rotation[o.yaw+1])
        for i,p in ipairs(o.extraParts) do
            local angle=(i-1)*0x20
            local x,y=unpack(data.rotation[angle+1])
            x,y=x*0x18,y*0x18
            x,y=floor((spinCos*x-spinSin*y)/64),floor((spinSin*x+spinCos*y)/64)
            local z=floor(yawSin*y/64)
            y=floor(yawCos*y/64)
            x=floor((pitchCos*x+pitchSin*z)/64)
            p.h,p.l=s16(o.h+x),s16(o.l+y)
            if fire then
                local direction=(angle+o.spin)%256
                shot(o,p,direction,-2)
                shot(o,p,(0x80-direction)%256,-4)
            end
        end
        o.visible=true
        return true
    end

    function H.render(o)
        local assets=o.run.art
        if not assets or not o.visible then return end
        local image=assets.sprites[data.images.rearSpark[26][o.frame+1]]
        for _,p in ipairs(o.extraParts) do art.draw(image,p.h,p.l,-0x400,-0x200) end
    end

    return H
end
